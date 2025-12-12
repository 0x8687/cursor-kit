//
//  Constants.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import Foundation

enum Constants {
    static let appName = "Screenshot App"
    static let appVersion = "1.0.0"
    
    // Default editor values
    static let defaultPadding: CGFloat = 20
    static let defaultCornerRadius: CGFloat = 8
    static let defaultShadowBlur: CGFloat = 10
    static let defaultShadowOffset = CGSize(width: 0, height: 4)
    
    // Limits
    static let maxPadding: CGFloat = 200
    static let maxCornerRadius: CGFloat = 50
    static let maxShadowBlur: CGFloat = 50
    static let maxImageSize: Int = 10 * 1024 * 1024 // 10MB
}

