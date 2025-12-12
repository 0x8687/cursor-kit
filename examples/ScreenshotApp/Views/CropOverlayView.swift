//
//  CropOverlayView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct CropOverlayView: View {
    @Binding var cropRect: CGRect
    let aspectRatio: CGFloat?
    let onCrop: () -> Void
    let onCancel: () -> Void
    
    @State private var isDragging = false
    @State private var dragStart: CGPoint?
    @State private var dragHandle: CropHandle?
    
    enum CropHandle {
        case topLeft, topCenter, topRight
        case rightCenter
        case bottomRight, bottomCenter, bottomLeft
        case leftCenter
        case move
    }
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            // Clear crop area
            if cropRect.width > 0 && cropRect.height > 0 {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: cropRect.width, height: cropRect.height)
                    .position(x: cropRect.midX, y: cropRect.midY)
                    .blendMode(.destinationOut)
            }
            
            // Crop rectangle border
            if cropRect.width > 0 && cropRect.height > 0 {
                Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(.white)
                    .frame(width: cropRect.width, height: cropRect.height)
                    .position(x: cropRect.midX, y: cropRect.midY)
                
                // Crop handles
                ForEach(cropHandles, id: \.self) { handle in
                    cropHandleView(for: handle)
                }
                
                // Size display
                VStack {
                    Text("\(Int(cropRect.width)) × \(Int(cropRect.height))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(4)
                    Spacer()
                }
                .padding()
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !isDragging {
                        isDragging = true
                        dragStart = value.startLocation
                        dragHandle = getHandle(at: value.startLocation)
                    }
                    
                    if let handle = dragHandle, let start = dragStart {
                        updateCropRect(handle: handle, start: start, current: value.location)
                    }
                }
                .onEnded { _ in
                    isDragging = false
                    dragStart = nil
                    dragHandle = nil
                }
        )
        .onKeyPress(.escape) {
            onCancel()
            return .handled
        }
        .onKeyPress(.return) {
            onCrop()
            return .handled
        }
    }
    
    private var cropHandles: [CropHandle] {
        [.topLeft, .topCenter, .topRight,
         .rightCenter,
         .bottomRight, .bottomCenter, .bottomLeft,
         .leftCenter]
    }
    
    private func cropHandleView(for handle: CropHandle) -> some View {
        let position = positionForHandle(handle)
        return Circle()
            .fill(Color.white)
            .frame(width: 12, height: 12)
            .overlay(
                Circle()
                    .strokeBorder(Color.blue, lineWidth: 2)
            )
            .position(position)
    }
    
    private func positionForHandle(_ handle: CropHandle) -> CGPoint {
        switch handle {
        case .topLeft: return CGPoint(x: cropRect.minX, y: cropRect.minY)
        case .topCenter: return CGPoint(x: cropRect.midX, y: cropRect.minY)
        case .topRight: return CGPoint(x: cropRect.maxX, y: cropRect.minY)
        case .rightCenter: return CGPoint(x: cropRect.maxX, y: cropRect.midY)
        case .bottomRight: return CGPoint(x: cropRect.maxX, y: cropRect.maxY)
        case .bottomCenter: return CGPoint(x: cropRect.midX, y: cropRect.maxY)
        case .bottomLeft: return CGPoint(x: cropRect.minX, y: cropRect.maxY)
        case .leftCenter: return CGPoint(x: cropRect.minX, y: cropRect.midY)
        case .move: return CGPoint(x: cropRect.midX, y: cropRect.midY)
        }
    }
    
    private func getHandle(at point: CGPoint) -> CropHandle? {
        let handleSize: CGFloat = 20
        for handle in cropHandles {
            let handlePos = positionForHandle(handle)
            let distance = sqrt(pow(point.x - handlePos.x, 2) + pow(point.y - handlePos.y, 2))
            if distance < handleSize {
                return handle
            }
        }
        
        // Check if point is inside crop rect (for moving)
        if cropRect.contains(point) {
            return .move
        }
        
        return nil
    }
    
    private func updateCropRect(handle: CropHandle, start: CGPoint, current: CGPoint) {
        let deltaX = current.x - start.x
        let deltaY = current.y - start.y
        
        var newRect = cropRect
        
        switch handle {
        case .move:
            newRect.origin.x += deltaX
            newRect.origin.y += deltaY
            
        case .topLeft:
            newRect.origin.x += deltaX
            newRect.origin.y += deltaY
            newRect.size.width -= deltaX
            newRect.size.height -= deltaY
            
        case .topCenter:
            newRect.origin.y += deltaY
            newRect.size.height -= deltaY
            
        case .topRight:
            newRect.origin.y += deltaY
            newRect.size.width += deltaX
            newRect.size.height -= deltaY
            
        case .rightCenter:
            newRect.size.width += deltaX
            
        case .bottomRight:
            newRect.size.width += deltaX
            newRect.size.height += deltaY
            
        case .bottomCenter:
            newRect.size.height += deltaY
            
        case .bottomLeft:
            newRect.origin.x += deltaX
            newRect.size.width -= deltaX
            newRect.size.height += deltaY
            
        case .leftCenter:
            newRect.origin.x += deltaX
            newRect.size.width -= deltaX
        }
        
        // Ensure positive size
        if newRect.width < 0 {
            newRect.origin.x += newRect.width
            newRect.size.width = abs(newRect.width)
        }
        if newRect.height < 0 {
            newRect.origin.y += newRect.height
            newRect.size.height = abs(newRect.height)
        }
        
        // Apply aspect ratio constraint
        if let ratio = aspectRatio {
            newRect = constrainToAspectRatio(newRect, ratio: ratio, handle: handle)
        }
        
        cropRect = newRect
    }
    
    private func constrainToAspectRatio(_ rect: CGRect, ratio: CGFloat, handle: CropHandle) -> CGRect {
        var constrained = rect
        
        // Calculate new size maintaining aspect ratio
        let currentRatio = constrained.width / constrained.height
        
        if abs(currentRatio - ratio) > 0.01 { // Only adjust if significantly different
            // Adjust based on which dimension changed more
            if abs(constrained.width - cropRect.width) > abs(constrained.height - cropRect.height) {
                // Width changed more, adjust height
                constrained.size.height = constrained.width / ratio
            } else {
                // Height changed more, adjust width
                constrained.size.width = constrained.height * ratio
            }
            
            // Adjust origin to maintain handle position
            switch handle {
            case .topRight, .rightCenter, .bottomRight:
                // Keep right edge fixed
                constrained.origin.x = cropRect.maxX - constrained.width
            case .topLeft, .leftCenter, .bottomLeft:
                // Keep left edge fixed
                constrained.origin.x = cropRect.minX
            default:
                // Keep center fixed
                constrained.origin.x = cropRect.midX - constrained.width / 2
            }
            
            switch handle {
            case .bottomLeft, .bottomCenter, .bottomRight:
                // Keep bottom edge fixed
                constrained.origin.y = cropRect.maxY - constrained.height
            case .topLeft, .topCenter, .topRight:
                // Keep top edge fixed
                constrained.origin.y = cropRect.minY
            default:
                // Keep center fixed
                constrained.origin.y = cropRect.midY - constrained.height / 2
            }
        }
        
        return constrained
    }
}

