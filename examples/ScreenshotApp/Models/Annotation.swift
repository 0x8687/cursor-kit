//
//  Annotation.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import CoreGraphics
import AppKit

enum AnnotationType {
    case arrow
    case rectangle
    case ellipse
    case line
    case text
}

struct Annotation: Identifiable {
    let id: UUID
    let type: AnnotationType
    var frame: CGRect
    var color: Color
    var strokeWidth: CGFloat
    
    // Type-specific properties
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    var text: String?
    var font: NSFont?
    var fontSize: CGFloat?
    var alignment: NSTextAlignment?
    var hasBorder: Bool?
    var borderColor: Color?
    var borderWidth: CGFloat?
    
    init(
        id: UUID = UUID(),
        type: AnnotationType,
        frame: CGRect,
        color: Color = .blue,
        strokeWidth: CGFloat = 2.0
    ) {
        self.id = id
        self.type = type
        self.frame = frame
        self.color = color
        self.strokeWidth = strokeWidth
    }
    
    // Helper to get bounding box for hit testing
    var boundingBox: CGRect {
        frame
    }
    
    // Check if point is inside annotation
    func contains(_ point: CGPoint) -> Bool {
        boundingBox.contains(point)
    }
}

