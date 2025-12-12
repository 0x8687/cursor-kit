//
//  EditorViewModel.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import CoreGraphics

struct EditorCommand {
    let id: UUID
    let execute: () -> Void
    let undo: () -> Void
}

@MainActor
class EditorViewModel: ObservableObject {
    @Published var state: EditorState
    @Published var annotations: [Annotation] = []
    @Published var previewImage: NSImage?
    @Published var isRendering = false
    
    // Annotation tool state
    @Published var selectedTool: Tool = .select
    @Published var selectedAnnotation: Annotation?
    @Published var annotationColor: Color = .blue
    @Published var strokeWidth: CGFloat = 2.0
    
    // Text tool state
    @Published var textFont: NSFont = .systemFont(ofSize: 16)
    @Published var textFontSize: CGFloat = 16
    @Published var textAlignment: NSTextAlignment = .left
    @Published var textHasBorder: Bool = false
    @Published var textBorderColor: Color = .black
    @Published var textBorderWidth: CGFloat = 1.0
    @Published var editingTextAnnotation: Annotation?
    @Published var editingText: String = ""
    
    // Crop state
    @Published var cropState: CropState = CropState()
    @Published var selectedAspectRatio: AspectRatioPreset = .freeform
    @Published var customAspectRatio: CGFloat?
    
    // Export state
    @Published var exportOptions: ExportOptions = ExportOptions()
    @Published var isExporting = false
    @Published var exportError: String?
    @Published var exportSuccessMessage: String?
    
    private var undoStack: [EditorCommand] = []
    private var redoStack: [EditorCommand] = []
    private let maxUndoStackSize = 50
    
    init(screenshot: CGImage) {
        self.state = EditorState(screenshot: screenshot)
    }
    
    // MARK: - State Updates
    
    func updatePadding(_ value: CGFloat) {
        let oldValue = state.padding
        executeCommand(
            execute: { [weak self] in
                self?.state.padding = max(0, min(value, Constants.maxPadding))
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.state.padding = oldValue
                self?.updatePreview()
            }
        )
    }
    
    func updateCornerRadius(_ value: CGFloat) {
        let oldValue = state.cornerRadius
        executeCommand(
            execute: { [weak self] in
                self?.state.cornerRadius = max(0, min(value, Constants.maxCornerRadius))
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.state.cornerRadius = oldValue
                self?.updatePreview()
            }
        )
    }
    
    func updateShadowColor(_ color: Color) {
        let oldValue = state.shadowColor
        executeCommand(
            execute: { [weak self] in
                self?.state.shadowColor = color
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.state.shadowColor = oldValue
                self?.updatePreview()
            }
        )
    }
    
    func updateShadowBlur(_ value: CGFloat) {
        let oldValue = state.shadowBlur
        executeCommand(
            execute: { [weak self] in
                self?.state.shadowBlur = max(0, min(value, Constants.maxShadowBlur))
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.state.shadowBlur = oldValue
                self?.updatePreview()
            }
        )
    }
    
    func updateShadowOffset(_ offset: CGSize) {
        let oldValue = state.shadowOffset
        executeCommand(
            execute: { [weak self] in
                self?.state.shadowOffset = offset
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.state.shadowOffset = oldValue
                self?.updatePreview()
            }
        )
    }
    
    func setBackground(_ background: Background?) {
        let oldValue = state.background
        executeCommand(
            execute: { [weak self] in
                self?.state.background = background
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.state.background = oldValue
                self?.updatePreview()
            }
        )
    }
    
    // MARK: - Preview
    
    private func updatePreview() {
        Task {
            isRendering = true
            let image = await ImageRenderer.renderFinalImage(
                state: state,
                annotations: annotations
            )
            await MainActor.run {
                previewImage = image
                isRendering = false
            }
        }
    }
    
    func refreshPreview() {
        updatePreview()
    }
    
    // MARK: - Undo/Redo
    
    func undo() {
        guard let command = undoStack.popLast() else { return }
        command.undo()
        redoStack.append(command)
        if redoStack.count > maxUndoStackSize {
            redoStack.removeFirst()
        }
    }
    
    func redo() {
        guard let command = redoStack.popLast() else { return }
        command.execute()
        undoStack.append(command)
        if undoStack.count > maxUndoStackSize {
            undoStack.removeFirst()
        }
    }
    
    private func executeCommand(execute: @escaping () -> Void, undo: @escaping () -> Void) {
        execute()
        let command = EditorCommand(id: UUID(), execute: execute, undo: undo)
        undoStack.append(command)
        if undoStack.count > maxUndoStackSize {
            undoStack.removeFirst()
        }
        redoStack.removeAll()
    }
    
    // MARK: - Annotations
    
    func addAnnotation(_ annotation: Annotation) {
        let oldAnnotations = annotations
        executeCommand(
            execute: { [weak self] in
                self?.annotations.append(annotation)
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.annotations = oldAnnotations
                self?.updatePreview()
            }
        )
    }
    
    func deleteAnnotation(_ id: UUID) {
        guard let index = annotations.firstIndex(where: { $0.id == id }) else { return }
        let deletedAnnotation = annotations[index]
        let oldAnnotations = annotations
        
        executeCommand(
            execute: { [weak self] in
                self?.annotations.removeAll { $0.id == id }
                if self?.selectedAnnotation?.id == id {
                    self?.selectedAnnotation = nil
                }
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.annotations = oldAnnotations
                self?.updatePreview()
            }
        )
    }
    
    func updateAnnotation(_ annotation: Annotation) {
        guard let index = annotations.firstIndex(where: { $0.id == annotation.id }) else { return }
        let oldAnnotation = annotations[index]
        
        executeCommand(
            execute: { [weak self] in
                self?.annotations[index] = annotation
                if self?.selectedAnnotation?.id == annotation.id {
                    self?.selectedAnnotation = annotation
                }
                self?.updatePreview()
            },
            undo: { [weak self] in
                self?.annotations[index] = oldAnnotation
                if self?.selectedAnnotation?.id == annotation.id {
                    self?.selectedAnnotation = oldAnnotation
                }
                self?.updatePreview()
            }
        )
    }
    
    func selectAnnotation(at point: CGPoint) {
        // Find annotation at point (reverse order for top-most first)
        if let annotation = annotations.reversed().first(where: { $0.contains(point) }) {
            selectedAnnotation = annotation
            
            // Load text properties if text annotation
            if annotation.type == .text {
                textFont = annotation.font ?? .systemFont(ofSize: 16)
                textFontSize = annotation.fontSize ?? 16
                textAlignment = annotation.alignment ?? .left
                textHasBorder = annotation.hasBorder ?? false
                textBorderColor = annotation.borderColor ?? .black
                textBorderWidth = annotation.borderWidth ?? 1.0
                annotationColor = annotation.color
            }
        }
    }
    
    func clearSelection() {
        selectedAnnotation = nil
    }

    /// Selects a tool and handles any required setup/teardown.
    func selectTool(_ tool: Tool) {
        selectedTool = tool
        clearSelection()

        if tool == .crop {
            startCrop()
        } else {
            cancelCrop()
        }
    }
    
    func createAnnotation(type: AnnotationType, frame: CGRect) -> Annotation {
        var annotation = Annotation(
            type: type,
            frame: frame,
            color: annotationColor,
            strokeWidth: strokeWidth
        )
        
        // Set start/end points for arrow and line annotations
        annotation.startPoint = CGPoint(x: frame.minX, y: frame.minY)
        annotation.endPoint = CGPoint(x: frame.maxX, y: frame.maxY)
        
        // Set text-specific properties if text annotation
        if type == .text {
            annotation.text = ""
            annotation.font = textFont
            annotation.fontSize = textFontSize
            annotation.alignment = textAlignment
            annotation.hasBorder = textHasBorder
            annotation.borderColor = textBorderColor
            annotation.borderWidth = textBorderWidth
        }
        
        return annotation
    }
    
    // MARK: - Text Tool
    
    func startEditingText(_ annotation: Annotation) {
        editingTextAnnotation = annotation
        editingText = annotation.text ?? ""
    }
    
    func commitTextEdit() {
        guard var annotation = editingTextAnnotation else { return }
        annotation.text = editingText
        updateAnnotation(annotation)
        editingTextAnnotation = nil
        editingText = ""
    }
    
    func cancelTextEdit() {
        editingTextAnnotation = nil
        editingText = ""
    }
    
    func updateTextAnnotation(_ annotation: Annotation, text: String) {
        var updated = annotation
        updated.text = text
        updated.font = textFont
        updated.fontSize = textFontSize
        updated.alignment = textAlignment
        updated.hasBorder = textHasBorder
        updated.borderColor = textBorderColor
        updated.borderWidth = textBorderWidth
        updateAnnotation(updated)
    }
    
    // MARK: - Crop Tool
    
    func startCrop() {
        guard let screenshot = state.screenshot else { return }
        cropState.isActive = true
        cropState.cropRect = CGRect(
            x: state.padding,
            y: state.padding,
            width: CGFloat(screenshot.width),
            height: CGFloat(screenshot.height)
        )
        cropState.padding = state.padding / (CGFloat(screenshot.width) + state.padding * 2)
    }
    
    func updateCropRect(_ rect: CGRect) {
        cropState.cropRect = rect
    }
    
    func setAspectRatio(_ ratio: CGFloat?) {
        cropState.aspectRatio = ratio
        customAspectRatio = ratio
        
        // Recalculate crop rect to maintain aspect ratio
        if let ratio = ratio, cropState.cropRect.width > 0 && cropState.cropRect.height > 0 {
            let currentRatio = cropState.cropRect.width / cropState.cropRect.height
            if abs(currentRatio - ratio) > 0.01 {
                // Adjust to match aspect ratio
                var newRect = cropState.cropRect
                if currentRatio > ratio {
                    // Too wide, adjust height
                    newRect.size.height = newRect.width / ratio
                } else {
                    // Too tall, adjust width
                    newRect.size.width = newRect.height * ratio
                }
                cropState.cropRect = newRect
            }
        }
    }
    
    func applyCrop() {
        guard cropState.isActive,
              let screenshot = state.screenshot,
              cropState.cropRect.width > 0,
              cropState.cropRect.height > 0 else {
            return
        }
        
        // Calculate actual crop bounds relative to screenshot
        let screenshotSize = CGSize(width: screenshot.width, height: screenshot.height)
        let padding = state.padding
        
        // Crop rect is relative to canvas (with padding)
        // Need to convert to screenshot coordinates
        let cropX = max(0, cropState.cropRect.origin.x - padding)
        let cropY = max(0, cropState.cropRect.origin.y - padding)
        let cropWidth = min(cropState.cropRect.width, screenshotSize.width - cropX)
        let cropHeight = min(cropState.cropRect.height, screenshotSize.height - cropY)
        
        let cropBounds = CGRect(x: cropX, y: cropY, width: cropWidth, height: cropHeight)
        
        // Crop the screenshot
        if let croppedImage = screenshot.cropping(to: cropBounds) {
            let oldScreenshot = state.screenshot
            executeCommand(
                execute: { [weak self] in
                    self?.state.screenshot = croppedImage
                    self?.cropState.reset()
                    self?.updatePreview()
                },
                undo: { [weak self] in
                    self?.state.screenshot = oldScreenshot
                    self?.updatePreview()
                }
            )
        }
    }
    
    func cancelCrop() {
        cropState.reset()
    }
    
    func recalculatePaddingForAspectRatio(newRatio: CGFloat) {
        guard let screenshot = state.screenshot else { return }
        
        let screenshotSize = CGSize(width: screenshot.width, height: screenshot.height)
        let currentPadding = state.padding
        let currentCanvasSize = CGSize(
            width: screenshotSize.width + (currentPadding * 2),
            height: screenshotSize.height + (currentPadding * 2)
        )
        
        // Calculate new canvas size maintaining padding percentage
        let paddingPercent = currentPadding / currentCanvasSize.width // Use width as reference
        
        // Calculate new dimensions
        let newHeight: CGFloat
        let newWidth: CGFloat
        
        if screenshotSize.width / screenshotSize.height > newRatio {
            // Screenshot is wider than ratio, constrain by height
            newHeight = screenshotSize.height + (currentPadding * 2)
            newWidth = newHeight * newRatio
        } else {
            // Screenshot is taller than ratio, constrain by width
            newWidth = screenshotSize.width + (currentPadding * 2)
            newHeight = newWidth / newRatio
        }
        
        // Calculate new padding to maintain percentage
        let newPadding = newWidth * paddingPercent
        
        // Update state
        state.padding = newPadding
        updatePreview()
    }
    
    // MARK: - Export
    
    func exportAndSave() async {
        isExporting = true
        exportError = nil
        exportSuccessMessage = nil
        
        do {
            let image = try await ExportService.exportImage(
                state: state,
                annotations: annotations,
                options: exportOptions
            )
            
            // Show save panel
            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [.png, .jpeg]
            savePanel.nameFieldStringValue = exportOptions.generateFileName()
            savePanel.canCreateDirectories = true
            
            if savePanel.runModal() == .OK, let url = savePanel.url {
                try await ExportService.saveToFile(
                    image: image,
                    options: exportOptions,
                    url: url
                )
                exportSuccessMessage = "Saved to \(url.lastPathComponent)"
            }
        } catch {
            exportError = "Failed to save: \(error.localizedDescription)"
        }
        
        isExporting = false
    }
    
    func exportAndCopy() async {
        isExporting = true
        exportError = nil
        exportSuccessMessage = nil
        
        do {
            let image = try await ExportService.exportImage(
                state: state,
                annotations: annotations,
                options: exportOptions
            )
            
            try await ExportService.copyToClipboard(image: image)
            exportSuccessMessage = "Copied to clipboard"
        } catch {
            exportError = "Failed to copy: \(error.localizedDescription)"
        }
        
        isExporting = false
    }
}

