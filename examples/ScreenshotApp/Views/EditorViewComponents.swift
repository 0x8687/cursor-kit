//
//  EditorViewComponents.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

// MARK: - Preview Area View

struct PreviewAreaView: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if let preview = viewModel.previewImage {
                    Image(nsImage: preview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(NSColor.controlBackgroundColor))
                } else if viewModel.isRendering {
                    LoadingView(message: "Rendering preview...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("No preview available")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            // Annotation Canvas Overlay
            if let preview = viewModel.previewImage {
                GeometryReader { geometry in
                    ZStack {
                        AnnotationCanvas(
                            viewModel: viewModel,
                            canvasSize: geometry.size
                        )
                        
                        // Text annotations overlay (for display)
                        ForEach(viewModel.annotations.filter { $0.type == .text }) { annotation in
                            if viewModel.editingTextAnnotation?.id != annotation.id {
                                TextAnnotationView(annotation: annotation)
                            }
                        }
                        
                        // Text Editor Overlay (for editing)
                        if let editingAnnotation = viewModel.editingTextAnnotation {
                            TextEditorView(
                                text: $viewModel.editingText,
                                frame: editingAnnotation.frame,
                                onCommit: {
                                    viewModel.commitTextEdit()
                                },
                                onCancel: {
                                    viewModel.cancelTextEdit()
                                }
                            )
                        }
                        
                        // Crop Overlay
                        if viewModel.cropState.isActive {
                            CropOverlayView(
                                cropRect: $viewModel.cropState.cropRect,
                                aspectRatio: viewModel.cropState.aspectRatio,
                                onCrop: {
                                    viewModel.applyCrop()
                                },
                                onCancel: {
                                    viewModel.cancelCrop()
                                }
                            )
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Shadow Controls View

struct ShadowControlsView: View {
    @ObservedObject var viewModel: EditorViewModel
    let debounceUpdate: (@escaping () -> Void) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Drop Shadow")
                .font(.subheadline)
                .fontWeight(.medium)
            
            // Shadow Color
            ColorPicker("Shadow Color", selection: Binding(
                get: { viewModel.state.shadowColor },
                set: { color in
                    debounceUpdate { viewModel.updateShadowColor(color) }
                }
            ))
            .help("Select the color of the drop shadow")
            .accessibilityLabel("Shadow color picker")
            
            // Shadow Blur
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Blur")
                    Spacer()
                    Text("\(Int(viewModel.state.shadowBlur)) px")
                        .foregroundColor(.secondary)
                }
                        Slider(
                            value: Binding(
                                get: { viewModel.state.shadowBlur },
                                set: { value in
                                    debounceUpdate { viewModel.updateShadowBlur(value) }
                                }
                            ),
                            in: 0...Constants.maxShadowBlur
                        )
                        .help("Adjust the blur radius of the drop shadow (0-\(Int(Constants.maxShadowBlur)) pixels)")
                        .accessibilityLabel("Shadow blur")
                        .accessibilityValue("\(Int(viewModel.state.shadowBlur)) pixels")
            }
            
            // Shadow Offset
            VStack(alignment: .leading, spacing: 8) {
                Text("Offset")
                HStack {
                    Text("X:")
                    Slider(
                        value: Binding(
                            get: { viewModel.state.shadowOffset.width },
                            set: { value in
                                debounceUpdate {
                                    viewModel.updateShadowOffset(
                                        CGSize(width: value, height: viewModel.state.shadowOffset.height)
                                    )
                                }
                            }
                        ),
                        in: -20...20
                    )
                }
                HStack {
                    Text("Y:")
                    Slider(
                        value: Binding(
                            get: { viewModel.state.shadowOffset.height },
                            set: { value in
                                debounceUpdate {
                                    viewModel.updateShadowOffset(
                                        CGSize(width: viewModel.state.shadowOffset.width, height: value)
                                    )
                                }
                            }
                        ),
                        in: -20...20
                    )
                }
            }
        }
    }
}

// MARK: - Export Section View

struct ExportSectionView: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            // Format Selection
            Picker("Format", selection: Binding(
                get: {
                    switch viewModel.exportOptions.format {
                    case .png: return "PNG"
                    case .jpeg: return "JPEG"
                    }
                },
                set: { value in
                    if value == "PNG" {
                        viewModel.exportOptions.format = .png
                    } else {
                        viewModel.exportOptions.format = .jpeg(quality: 0.9)
                    }
                }
            )) {
                Text("PNG").tag("PNG")
                Text("JPEG").tag("JPEG")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // JPEG Quality (if JPEG selected)
            if case .jpeg = viewModel.exportOptions.format {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Quality")
                        Spacer()
                        if case .jpeg(let quality) = viewModel.exportOptions.format {
                            Text("\(Int(quality * 100))%")
                                .foregroundColor(.secondary)
                        }
                    }
                    Slider(
                        value: Binding(
                            get: {
                                if case .jpeg(let quality) = viewModel.exportOptions.format {
                                    return quality
                                }
                                return 0.9
                            },
                            set: { value in
                                viewModel.exportOptions.format = .jpeg(quality: value)
                            }
                        ),
                        in: 0.1...1.0
                    )
                }
                .padding(.horizontal)
            }
            
            // Export Buttons
            VStack(spacing: 8) {
                Button(action: {
                    Task {
                        await viewModel.exportAndSave()
                    }
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Save to File")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isExporting)
                .help("Save the edited screenshot to a file (⌘S)")
                .accessibilityLabel("Save to file")
                .accessibilityHint("Opens a file picker to save the screenshot")
                
                Button(action: {
                    Task {
                        await viewModel.exportAndCopy()
                    }
                }) {
                    HStack {
                        Image(systemName: "doc.on.clipboard")
                        Text("Copy to Clipboard")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isExporting)
                .help("Copy the edited screenshot to clipboard (⌘⇧C)")
                .accessibilityLabel("Copy to clipboard")
                .accessibilityHint("Copies the screenshot to the clipboard")
            }
            .padding(.horizontal)
            
            // Status Messages
            if let error = viewModel.exportError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            if let success = viewModel.exportSuccessMessage {
                Text(success)
                    .foregroundColor(.green)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
            if viewModel.isExporting {
                HStack {
                    ProgressView()
                        .scaleEffect(0.5)
                    Text("Exporting...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Controls Panel View

struct ControlsPanelView: View {
    @ObservedObject var viewModel: EditorViewModel
    @ObservedObject var backgroundManager: BackgroundManager
    @Binding var showingBackgroundGallery: Bool
    let debounceUpdate: (@escaping () -> Void) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Annotation Toolbar
                AnnotationToolbar(viewModel: viewModel)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.selectedTool)
                
                // Crop Toolbar (shown when crop tool selected)
                if viewModel.selectedTool == .crop {
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Crop Tool")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                        
                        AspectRatioPicker(
                            selectedPreset: $viewModel.selectedAspectRatio,
                            customRatio: $viewModel.customAspectRatio
                        )
                        .onChange(of: viewModel.selectedAspectRatio) { _, preset in
                            if preset == .custom {
                                // Keep current custom ratio
                            } else {
                                viewModel.setAspectRatio(preset.ratio)
                            }
                        }
                        .onChange(of: viewModel.customAspectRatio) { _, ratio in
                            if viewModel.selectedAspectRatio == .custom {
                                viewModel.setAspectRatio(ratio)
                            }
                        }
                        
                        HStack {
                            Button("Apply Crop") {
                                viewModel.applyCrop()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                            .accessibilityLabel("Apply crop")
                            .accessibilityHint("Applies the crop to the screenshot")
                            
                            Button("Cancel") {
                                viewModel.cancelCrop()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .accessibilityLabel("Cancel crop")
                            .accessibilityHint("Cancels the crop operation (or press ESC)")
                        }
                        .padding(.horizontal)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Text Toolbar (shown when text tool selected or text annotation selected)
                if viewModel.selectedTool == .text || (viewModel.selectedAnnotation?.type == .text) {
                    Divider()
                    TextToolbar(viewModel: viewModel)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                Divider()
                
                Text("Editor Controls")
                    .font(.headline)
                    .padding(.horizontal)
                
                // Padding Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Padding")
                        Spacer()
                        Text("\(Int(viewModel.state.padding)) px")
                            .foregroundColor(.secondary)
                    }
                    Slider(
                        value: Binding(
                            get: { viewModel.state.padding },
                            set: { value in
                                debounceUpdate { viewModel.updatePadding(value) }
                            }
                        ),
                        in: 0...Constants.maxPadding
                    )
                    .help("Adjust spacing around the screenshot (0-\(Int(Constants.maxPadding)) pixels)")
                    .accessibilityLabel("Padding")
                    .accessibilityValue("\(Int(viewModel.state.padding)) pixels")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Corner Radius Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Corner Radius")
                        Spacer()
                        Text("\(Int(viewModel.state.cornerRadius)) px")
                            .foregroundColor(.secondary)
                    }
                    Slider(
                        value: Binding(
                            get: { viewModel.state.cornerRadius },
                            set: { value in
                                debounceUpdate { viewModel.updateCornerRadius(value) }
                            }
                        ),
                        in: 0...Constants.maxCornerRadius
                    )
                    .help("Adjust the corner radius of the screenshot (0-\(Int(Constants.maxCornerRadius)) pixels)")
                    .accessibilityLabel("Corner radius")
                    .accessibilityValue("\(Int(viewModel.state.cornerRadius)) pixels")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Shadow Controls
                ShadowControlsView(
                    viewModel: viewModel,
                    debounceUpdate: debounceUpdate
                )
                .padding(.horizontal)
                
                Divider()
                
                // Background Selection
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Background")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        if viewModel.state.background != nil {
                            Button(action: {
                                viewModel.setBackground(nil)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Button(action: {
                        showingBackgroundGallery = true
                    }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text(viewModel.state.background != nil ? "Change Background" : "Select Background")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .help("Select a background gradient or upload a custom image")
                    .accessibilityLabel(viewModel.state.background != nil ? "Change background" : "Select background")
                    .accessibilityHint("Opens the background gallery to choose a gradient or image")
                }
                .padding(.horizontal)
                
                Divider()
                
                // Export Section
                ExportSectionView(viewModel: viewModel)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

