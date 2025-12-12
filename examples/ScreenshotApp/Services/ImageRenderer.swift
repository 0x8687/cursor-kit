//
//  ImageRenderer.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import CoreGraphics
import CoreImage
import AppKit
import CoreText

class ImageRenderer {
    static func renderFinalImage(
        state: EditorState,
        annotations: [Annotation] = []
    ) async -> NSImage? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let screenshot = state.screenshot else {
                    continuation.resume(returning: nil)
                    return
                }
                
                // Calculate final canvas size
                let screenshotSize = CGSize(width: screenshot.width, height: screenshot.height)
                let padding = state.padding
                let canvasSize = CGSize(
                    width: screenshotSize.width + (padding * 2),
                    height: screenshotSize.height + (padding * 2)
                )
                
                // Create context
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                guard let context = CGContext(
                    data: nil,
                    width: Int(canvasSize.width),
                    height: Int(canvasSize.height),
                    bitsPerComponent: 8,
                    bytesPerRow: 0,
                    space: colorSpace,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                ) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                // Draw background
                if let background = state.background {
                    drawBackground(
                        context: context,
                        background: background,
                        size: canvasSize
                    )
                } else {
                    // Default white background
                    context.setFillColor(NSColor.white.cgColor)
                    context.fill(CGRect(origin: .zero, size: canvasSize))
                }
                
                // Draw screenshot with padding
                let screenshotRect = CGRect(
                    x: padding,
                    y: padding,
                    width: screenshotSize.width,
                    height: screenshotSize.height
                )
                
                // Apply corner radius mask
                if state.cornerRadius > 0 {
                    context.saveGState()
                    let path = CGPath(
                        roundedRect: screenshotRect,
                        cornerWidth: state.cornerRadius,
                        cornerHeight: state.cornerRadius,
                        transform: nil
                    )
                    context.addPath(path)
                    context.clip()
                }
                
                // Draw screenshot
                context.draw(screenshot, in: screenshotRect)
                
                if state.cornerRadius > 0 {
                    context.restoreGState()
                }
                
                // Apply drop shadow
                if state.shadowBlur > 0 {
                    context.saveGState()
                    context.setShadow(
                        offset: state.shadowOffset,
                        blur: state.shadowBlur,
                        color: state.shadowColor.cgColor
                    )
                    
                    // Redraw screenshot with shadow
                    if state.cornerRadius > 0 {
                        let path = CGPath(
                            roundedRect: screenshotRect,
                            cornerWidth: state.cornerRadius,
                            cornerHeight: state.cornerRadius,
                            transform: nil
                        )
                        context.addPath(path)
                        context.fillPath()
                    } else {
                        context.fill(screenshotRect)
                    }
                    
                    // Draw screenshot again on top
                    if state.cornerRadius > 0 {
                        let path = CGPath(
                            roundedRect: screenshotRect,
                            cornerWidth: state.cornerRadius,
                            cornerHeight: state.cornerRadius,
                            transform: nil
                        )
                        context.addPath(path)
                        context.clip()
                    }
                    context.draw(screenshot, in: screenshotRect)
                    context.restoreGState()
                }
                
                // Draw annotations (placeholder for now)
                for annotation in annotations {
                    drawAnnotation(context: context, annotation: annotation, canvasSize: canvasSize)
                }
                
                // Create final image
                guard let finalImage = context.makeImage() else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let nsImage = NSImage(cgImage: finalImage, size: canvasSize)
                continuation.resume(returning: nsImage)
            }
        }
    }
    
    private static func drawBackground(
        context: CGContext,
        background: Background,
        size: CGSize
    ) {
        let rect = CGRect(origin: .zero, size: size)
        
        switch background {
        case .gradient(let preset):
            // Create gradient
            let colors = preset.colors.map { $0.cgColor }
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: nil
            ) else {
                // Fallback to white
                context.setFillColor(NSColor.white.cgColor)
                context.fill(rect)
                return
            }
            
            let startPoint: CGPoint
            let endPoint: CGPoint
            
            switch preset.startPoint {
            case .topLeading:
                startPoint = CGPoint(x: 0, y: size.height)
            case .top:
                startPoint = CGPoint(x: size.width / 2, y: size.height)
            case .topTrailing:
                startPoint = CGPoint(x: size.width, y: size.height)
            case .leading:
                startPoint = CGPoint(x: 0, y: size.height / 2)
            case .center:
                startPoint = CGPoint(x: size.width / 2, y: size.height / 2)
            case .trailing:
                startPoint = CGPoint(x: size.width, y: size.height / 2)
            case .bottomLeading:
                startPoint = CGPoint(x: 0, y: 0)
            case .bottom:
                startPoint = CGPoint(x: size.width / 2, y: 0)
            case .bottomTrailing:
                startPoint = CGPoint(x: size.width, y: 0)
            default:
                startPoint = CGPoint(x: 0, y: size.height)
            }
            
            switch preset.endPoint {
            case .topLeading:
                endPoint = CGPoint(x: 0, y: size.height)
            case .top:
                endPoint = CGPoint(x: size.width / 2, y: size.height)
            case .topTrailing:
                endPoint = CGPoint(x: size.width, y: size.height)
            case .leading:
                endPoint = CGPoint(x: 0, y: size.height / 2)
            case .center:
                endPoint = CGPoint(x: size.width / 2, y: size.height / 2)
            case .trailing:
                endPoint = CGPoint(x: size.width, y: size.height / 2)
            case .bottomLeading:
                endPoint = CGPoint(x: 0, y: 0)
            case .bottom:
                endPoint = CGPoint(x: size.width / 2, y: 0)
            case .bottomTrailing:
                endPoint = CGPoint(x: size.width, y: 0)
            default:
                endPoint = CGPoint(x: size.width, y: 0)
            }
            
            if preset.type == .radial {
                context.drawRadialGradient(
                    gradient,
                    startCenter: startPoint,
                    startRadius: 0,
                    endCenter: endPoint,
                    endRadius: max(size.width, size.height),
                    options: []
                )
            } else {
                context.drawLinearGradient(
                    gradient,
                    start: startPoint,
                    end: endPoint,
                    options: []
                )
            }
            
        case .image(let nsImage):
            if let cgImage = nsImage.cgImage {
                context.draw(cgImage, in: rect)
            } else {
                // Fallback to white
                context.setFillColor(NSColor.white.cgColor)
                context.fill(rect)
            }
        }
    }
    
    private static func drawAnnotation(
        context: CGContext,
        annotation: Annotation,
        canvasSize: CGSize
    ) {
        context.saveGState()
        
        context.setStrokeColor(annotation.color.cgColor)
        context.setLineWidth(annotation.strokeWidth)
        context.setFillColor(annotation.color.cgColor)
        
        let path: CGPath
        
        switch annotation.type {
        case .arrow:
            if let start = annotation.startPoint, let end = annotation.endPoint {
                path = createArrowPath(start: start, end: end, frame: annotation.frame)
            } else {
                path = CGPath(rect: annotation.frame, transform: nil)
            }
            
        case .rectangle:
            path = CGPath(roundedRect: annotation.frame, cornerWidth: 4, cornerHeight: 4, transform: nil)
            
        case .ellipse:
            path = CGPath(ellipseIn: annotation.frame, transform: nil)
            
        case .line:
            if let start = annotation.startPoint, let end = annotation.endPoint {
                let mutablePath = CGMutablePath()
                mutablePath.move(to: start)
                mutablePath.addLine(to: end)
                path = mutablePath
            } else {
                path = CGPath(rect: annotation.frame, transform: nil)
            }
            
        case .text:
            // Text rendering handled separately
            path = CGPath(rect: annotation.frame, transform: nil)
        }
        
        context.addPath(path)
        context.strokePath()
        
        context.restoreGState()
    }
    
    private static func createArrowPath(start: CGPoint, end: CGPoint, frame: CGRect) -> CGPath {
        let mutablePath = CGMutablePath()
        
        let dx = end.x - start.x
        let dy = end.y - start.y
        let length = sqrt(dx * dx + dy * dy)
        
        guard length > 0 else {
            return mutablePath
        }
        
        let unitX = dx / length
        let unitY = dy / length
        let headSize: CGFloat = 10
        let arrowHeadLength = min(headSize, length / 2)
        let arrowHeadWidth = arrowHeadLength * 0.6
        
        // Draw line
        let lineEndX = end.x - unitX * arrowHeadLength
        let lineEndY = end.y - unitY * arrowHeadLength
        
        mutablePath.move(to: start)
        mutablePath.addLine(to: CGPoint(x: lineEndX, y: lineEndY))
        
        // Draw arrow head
        let perpendicularX = -unitY
        let perpendicularY = unitX
        
        let arrowTip1 = CGPoint(
            x: end.x - unitX * arrowHeadLength + perpendicularX * arrowHeadWidth,
            y: end.y - unitY * arrowHeadLength + perpendicularY * arrowHeadWidth
        )
        
        let arrowTip2 = CGPoint(
            x: end.x - unitX * arrowHeadLength - perpendicularX * arrowHeadWidth,
            y: end.y - unitY * arrowHeadLength - perpendicularY * arrowHeadWidth
        )
        
        mutablePath.addLine(to: arrowTip1)
        mutablePath.addLine(to: end)
        mutablePath.addLine(to: arrowTip2)
        mutablePath.addLine(to: CGPoint(x: lineEndX, y: lineEndY))
        
        return mutablePath
    }
    
    private static func drawTextAnnotation(
        context: CGContext,
        annotation: Annotation,
        canvasSize: CGSize
    ) {
        guard let text = annotation.text, !text.isEmpty else { return }
        
        context.saveGState()
        
        let fontSize = annotation.fontSize ?? 16
        let font = annotation.font ?? NSFont.systemFont(ofSize: fontSize)
        
        // Create attributed string
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: annotation.color.cgColor
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        // Create text frame
        let textFrame = annotation.frame
        let path = CGPath(rect: textFrame, transform: nil)
        
        // Create framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(), path, nil)
        
        // Draw text
        context.textMatrix = .identity
        context.translateBy(x: 0, y: canvasSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: textFrame.origin.x, y: canvasSize.height - textFrame.origin.y - textFrame.height)
        
        CTFrameDraw(frame, context)
        
        context.restoreGState()
        
        // Draw border if needed
        if annotation.hasBorder == true {
            context.saveGState()
            context.setStrokeColor((annotation.borderColor ?? .black).cgColor)
            context.setLineWidth(annotation.borderWidth ?? 1.0)
            context.stroke(textFrame)
            context.restoreGState()
        }
    }
}

