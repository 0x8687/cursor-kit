//
//  AnnotationCanvas.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct AnnotationCanvas: View {
    @ObservedObject var viewModel: EditorViewModel
    let canvasSize: CGSize
    
    @State private var isDrawing = false
    @State private var drawingStart: CGPoint?
    @State private var drawingEnd: CGPoint?
    
    var body: some View {
        Canvas { context, size in
            // Draw all annotations
            for annotation in viewModel.annotations {
                drawAnnotation(annotation, in: context, size: size)
            }
            
            // Draw selection handles if annotation is selected
            if let selected = viewModel.selectedAnnotation {
                drawSelectionHandles(selected, in: context, size: size)
            }
            
            // Draw preview of new annotation being drawn
            if isDrawing, let start = drawingStart, let end = drawingEnd {
                drawPreviewAnnotation(start: start, end: end, in: context, size: size)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !isDrawing {
                        isDrawing = true
                        drawingStart = value.startLocation
                    }
                    drawingEnd = value.location
                }
                .onEnded { value in
                    if let start = drawingStart, let end = drawingEnd {
                        handleDrawingComplete(start: start, end: end)
                    }
                    isDrawing = false
                    drawingStart = nil
                    drawingEnd = nil
                }
        )
        .onTapGesture { location in
            if viewModel.selectedTool == .select {
                viewModel.selectAnnotation(at: location)
                // Double-tap to edit text
                if let selected = viewModel.selectedAnnotation, selected.type == .text {
                    // Could add double-tap detection here if needed
                }
            } else {
                viewModel.clearSelection()
            }
        }
        .gesture(
            TapGesture(count: 2)
                .onEnded { _ in
                    if let selected = viewModel.selectedAnnotation, selected.type == .text {
                        viewModel.startEditingText(selected)
                    }
                }
        )
    }
    
    private func drawAnnotation(_ annotation: Annotation, in context: GraphicsContext, size: CGSize) {
        if annotation.type == .text {
            // Text annotations are rendered as overlay views, not in canvas
            // Just draw border if needed
            if annotation.hasBorder == true {
                context.stroke(
                    getPath(for: annotation),
                    with: .color(annotation.borderColor ?? .black),
                    lineWidth: annotation.borderWidth ?? 1.0
                )
            }
        } else {
            context.stroke(
                getPath(for: annotation),
                with: .color(annotation.color),
                lineWidth: annotation.strokeWidth
            )
        }
    }
    
    private func getPath(for annotation: Annotation) -> Path {
        switch annotation.type {
        case .arrow:
            if let start = annotation.startPoint, let end = annotation.endPoint {
                return ArrowShape(startPoint: start, endPoint: end).path(in: annotation.frame)
            }
            return Path(annotation.frame)
            
        case .rectangle:
            return Path(roundedRect: annotation.frame, cornerRadius: 4)
            
        case .ellipse:
            return Path(ellipseIn: annotation.frame)
            
        case .line:
            if let start = annotation.startPoint, let end = annotation.endPoint {
                return LineShape(startPoint: start, endPoint: end).path(in: annotation.frame)
            }
            return Path(annotation.frame)
            
        case .text:
            // Text frame rectangle
            return Path(annotation.frame)
        }
    }
    
    private func drawPreviewAnnotation(start: CGPoint, end: CGPoint, in context: GraphicsContext, size: CGSize) {
        let frame = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
        
        let previewAnnotation = viewModel.createAnnotation(
            type: annotationTypeForTool(viewModel.selectedTool),
            frame: frame
        )
        
        context.stroke(
            getPath(for: previewAnnotation),
            with: .color(viewModel.annotationColor),
            lineWidth: viewModel.strokeWidth
        )
    }
    
    private func annotationTypeForTool(_ tool: Tool) -> AnnotationType {
        switch tool {
        case .arrow: return .arrow
        case .rectangle: return .rectangle
        case .ellipse: return .ellipse
        case .line: return .line
        case .text: return .text
        default: return .rectangle
        }
    }
    
    private func drawSelectionHandles(_ annotation: Annotation, in context: GraphicsContext, size: CGSize) {
        let frame = annotation.frame
        let handleSize: CGFloat = 8
        let handles: [CGPoint] = [
            CGPoint(x: frame.minX, y: frame.minY), // Top-left
            CGPoint(x: frame.midX, y: frame.minY), // Top-center
            CGPoint(x: frame.maxX, y: frame.minY), // Top-right
            CGPoint(x: frame.maxX, y: frame.midY), // Right-center
            CGPoint(x: frame.maxX, y: frame.maxY), // Bottom-right
            CGPoint(x: frame.midX, y: frame.maxY), // Bottom-center
            CGPoint(x: frame.minX, y: frame.maxY), // Bottom-left
            CGPoint(x: frame.minX, y: frame.midY)  // Left-center
        ]
        
        for handle in handles {
            let handleRect = CGRect(
                x: handle.x - handleSize / 2,
                y: handle.y - handleSize / 2,
                width: handleSize,
                height: handleSize
            )
            context.fill(
                Path(ellipseIn: handleRect),
                with: .color(.blue)
            )
            context.stroke(
                Path(ellipseIn: handleRect),
                with: .color(.white),
                lineWidth: 1
            )
        }
    }
    
    private func handleDrawingComplete(start: CGPoint, end: CGPoint) {
        guard viewModel.selectedTool != .select && viewModel.selectedTool != .crop else {
            // If crop tool, start crop mode
            if viewModel.selectedTool == .crop {
                viewModel.startCrop()
            }
            return
        }
        
        let frame = CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
        
        // For text, use minimum size if too small
        let finalFrame: CGRect
        if viewModel.selectedTool == .text {
            finalFrame = CGRect(
                x: frame.origin.x,
                y: frame.origin.y,
                width: max(200, frame.width),
                height: max(30, frame.height)
            )
        } else {
            // Only create annotation if it has meaningful size
            guard frame.width > 5 && frame.height > 5 else { return }
            finalFrame = frame
        }
        
        let annotation = viewModel.createAnnotation(
            type: annotationTypeForTool(viewModel.selectedTool),
            frame: finalFrame
        )
        
        viewModel.addAnnotation(annotation)
        
        // If text tool, start editing immediately
        if viewModel.selectedTool == .text {
            viewModel.startEditingText(annotation)
        }
    }
}

