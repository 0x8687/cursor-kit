//
//  CaptureOverlayView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct CaptureOverlayView: View {
    @Binding var isPresented: Bool
    let onCapture: (CGRect) -> Void
    let onCancel: () -> Void
    
    @State private var startPoint: CGPoint?
    @State private var currentPoint: CGPoint?
    @State private var selectionRect: CGRect?
    @State private var activeMode: CaptureTarget = .selectedPortion
    
    var body: some View {
        ZStack {
            // Make the hosting window transparent and above other app windows
            TransparentOverlayWindow()
                .allowsHitTesting(false)
            
            // Subtle dark veil to hint focus mode while keeping the desktop visible
            Color.black.opacity(0.22)
                .ignoresSafeArea()
            
            // Selection overlay + handles + size label
            if let rect = currentSelectionRect {
                selectionOverlay(rect: rect)
            }
            
            // Floating toolbar
            VStack {
                Spacer()
                CaptureToolbar(
                    activeMode: $activeMode,
                    hasSelection: currentSelectionRect != nil,
                    onCancel: handleCancel,
                    onCapture: {
                        if let rect = currentSelectionRect {
                            onCapture(rect)
                        }
                    }
                )
            }
            .padding(.bottom, 32)
        }
        .background(Color.clear)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if startPoint == nil {
                        startPoint = value.startLocation
                    }
                    currentPoint = value.location
                }
                .onEnded { value in
                    if let start = startPoint, let end = currentPoint {
                        let rect = buildRect(start: start, end: end)
                        selectionRect = rect
                        // Auto-capture for speed; toolbar button also available
                        guard rect.width > 10 && rect.height > 10 else {
                            onCancel()
                            reset()
                            return
                        }
                        onCapture(rect)
                    }
                    reset()
                }
        )
        .onAppear {
            reset()
        }
        .onKeyPress(.escape) {
            onCancel()
            reset()
            return .handled
        }
    }
    
    private func reset() {
        startPoint = nil
        currentPoint = nil
        selectionRect = nil
    }
    
    private var currentSelectionRect: CGRect? {
        if let start = startPoint, let current = currentPoint {
            return buildRect(start: start, end: current)
        }
        return selectionRect
    }
    
    private func buildRect(start: CGPoint, end: CGPoint) -> CGRect {
        CGRect(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )
    }
    
    private func handleCancel() {
        onCancel()
        reset()
    }
    
    // MARK: - UI Elements
    
    @ViewBuilder
    private func selectionOverlay(rect: CGRect) -> some View {
        // Darken outside selection for focus
        FocusCutoutOverlay(selection: rect)
            .ignoresSafeArea()
        
        // Dashed outline
        Rectangle()
            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            .foregroundColor(.white)
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
        
        // Handles
        ForEach(handlePoints(for: rect), id: \.self) { point in
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
                .position(point)
        }
        
        // Size label
        VStack {
            Text("\(Int(rect.width)) × \(Int(rect.height))")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.55))
                .cornerRadius(6)
            Spacer()
        }
        .padding(.top, max(12, rect.minY > 28 ? rect.minY - 28 : 12))
    }
    
    private func handlePoints(for rect: CGRect) -> [CGPoint] {
        let midX = rect.midX
        let midY = rect.midY
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        
        return [
            CGPoint(x: minX, y: minY),
            CGPoint(x: midX, y: minY),
            CGPoint(x: maxX, y: minY),
            CGPoint(x: minX, y: midY),
            CGPoint(x: maxX, y: midY),
            CGPoint(x: minX, y: maxY),
            CGPoint(x: midX, y: maxY),
            CGPoint(x: maxX, y: maxY)
        ]
    }
}
 
// MARK: - Supporting Views

private enum CaptureTarget: String {
    case entireScreen
    case window
    case selectedPortion
    case recordScreen
    case recordPortion
}

private struct CaptureToolbar: View {
    @Binding var activeMode: CaptureTarget
    let hasSelection: Bool
    let onCancel: () -> Void
    let onCapture: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ToolbarIconButton(
                systemName: "xmark",
                label: "Cancel",
                isActive: false,
                action: onCancel
            )
            
            ToolbarIconButton(
                systemName: "macwindow.on.rectangle",
                label: "Full Screen",
                isActive: activeMode == .entireScreen,
                action: { activeMode = .entireScreen }
            )
            
            ToolbarIconButton(
                systemName: "macwindow",
                label: "Window",
                isActive: activeMode == .window,
                action: { activeMode = .window }
            )
            
            ToolbarIconButton(
                systemName: "rectangle.dashed",
                label: "Portion",
                isActive: activeMode == .selectedPortion,
                action: { activeMode = .selectedPortion }
            )
            
            Divider()
                .frame(height: 28)
                .overlay(Color.white.opacity(0.25))
                .padding(.horizontal, 6)
            
            ToolbarIconButton(
                systemName: "record.circle",
                label: "Record Screen",
                isActive: activeMode == .recordScreen,
                action: { activeMode = .recordScreen }
            )
            
            ToolbarIconButton(
                systemName: "record.circle.dashed",
                label: "Record Portion",
                isActive: activeMode == .recordPortion,
                action: { activeMode = .recordPortion }
            )
            
            Spacer().frame(width: 4)
            
            Button {
                // Placeholder for options tap
            } label: {
                HStack(spacing: 4) {
                    Text("Options")
                    Image(systemName: "chevron.down")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.08))
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
            
            Button(action: onCapture) {
                Text("Capture")
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(hasSelection ? Color.white.opacity(0.22) : Color.white.opacity(0.12))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            .opacity(hasSelection ? 1 : 0.5)
            .disabled(!hasSelection)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.18), radius: 12, y: 6)
        .padding(.horizontal, 24)
        .frame(maxWidth: 720)
    }
}

private struct ToolbarIconButton: View {
    let systemName: String
    let label: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.system(size: 16, weight: .semibold))
                    .symbolVariant(.none)
                Text(label)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isActive ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct FocusCutoutOverlay: View {
    let selection: CGRect
    
    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                var path = Path(CGRect(origin: .zero, size: size))
                path.addPath(Path(selection))
                context.fill(path, with: .color(Color.black.opacity(0.45)), style: FillStyle(eoFill: true))
            }
            .compositingGroup()
        }
    }
}

