//
//  ArrowShape.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct ArrowShape: Shape {
    var startPoint: CGPoint
    var endPoint: CGPoint
    var headSize: CGFloat = 10
    var doubleHeaded: Bool = false
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Calculate direction vector
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let length = sqrt(dx * dx + dy * dy)
        
        guard length > 0 else {
            return path
        }
        
        // Normalize direction
        let unitX = dx / length
        let unitY = dy / length
        
        // Arrow head size
        let arrowHeadLength = min(headSize, length / 2)
        let arrowHeadWidth = arrowHeadLength * 0.6
        
        // Draw line from start to end (with offset for arrow head)
        let lineEndX = endPoint.x - unitX * arrowHeadLength
        let lineEndY = endPoint.y - unitY * arrowHeadLength
        
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: lineEndX, y: lineEndY))
        
        // Draw arrow head at end
        let perpendicularX = -unitY
        let perpendicularY = unitX
        
        let arrowTip1 = CGPoint(
            x: endPoint.x - unitX * arrowHeadLength + perpendicularX * arrowHeadWidth,
            y: endPoint.y - unitY * arrowHeadLength + perpendicularY * arrowHeadWidth
        )
        
        let arrowTip2 = CGPoint(
            x: endPoint.x - unitX * arrowHeadLength - perpendicularX * arrowHeadWidth,
            y: endPoint.y - unitY * arrowHeadLength - perpendicularY * arrowHeadWidth
        )
        
        path.addLine(to: arrowTip1)
        path.addLine(to: endPoint)
        path.addLine(to: arrowTip2)
        path.addLine(to: CGPoint(x: lineEndX, y: lineEndY))
        
        // Draw arrow head at start if double-headed
        if doubleHeaded {
            let lineStartX = startPoint.x + unitX * arrowHeadLength
            let lineStartY = startPoint.y + unitY * arrowHeadLength
            
            let startArrowTip1 = CGPoint(
                x: startPoint.x + unitX * arrowHeadLength + perpendicularX * arrowHeadWidth,
                y: startPoint.y + unitY * arrowHeadLength + perpendicularY * arrowHeadWidth
            )
            
            let startArrowTip2 = CGPoint(
                x: startPoint.x + unitX * arrowHeadLength - perpendicularX * arrowHeadWidth,
                y: startPoint.y + unitY * arrowHeadLength - perpendicularY * arrowHeadWidth
            )
            
            path.move(to: startPoint)
            path.addLine(to: startArrowTip1)
            path.addLine(to: CGPoint(x: lineStartX, y: lineStartY))
            path.addLine(to: startArrowTip2)
            path.addLine(to: startPoint)
        }
        
        return path
    }
}

