//
//  LineShape.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct LineShape: Shape {
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }
}

