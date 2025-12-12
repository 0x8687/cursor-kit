//
//  EditorState.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import CoreGraphics

enum Background {
    case gradient(GradientPreset)
    case image(NSImage)
}

struct EditorState {
    var screenshot: CGImage?
    var padding: CGFloat
    var cornerRadius: CGFloat
    var shadowColor: Color
    var shadowBlur: CGFloat
    var shadowOffset: CGSize
    var background: Background?
    
    init(
        screenshot: CGImage? = nil,
        padding: CGFloat = Constants.defaultPadding,
        cornerRadius: CGFloat = Constants.defaultCornerRadius,
        shadowColor: Color = .black.opacity(0.3),
        shadowBlur: CGFloat = Constants.defaultShadowBlur,
        shadowOffset: CGSize = Constants.defaultShadowOffset,
        background: Background? = nil
    ) {
        self.screenshot = screenshot
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowBlur = shadowBlur
        self.shadowOffset = shadowOffset
        self.background = background
    }
}

