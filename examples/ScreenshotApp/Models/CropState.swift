//
//  CropState.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import CoreGraphics

struct CropState {
    var isActive: Bool = false
    var cropRect: CGRect = .zero
    var aspectRatio: CGFloat? = nil // nil for freeform
    var padding: CGFloat = 0 // Percentage (0.0 to 1.0)
    
    mutating func reset() {
        isActive = false
        cropRect = .zero
        aspectRatio = nil
        padding = 0
    }
}

// Common aspect ratios
enum AspectRatioPreset: String, CaseIterable, Identifiable {
    case freeform
    case square // 1:1
    case landscape16_9 // 16:9
    case landscape4_3 // 4:3
    case landscape21_9 // 21:9
    case portrait9_16 // 9:16
    case portrait3_4 // 3:4
    case custom
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .freeform: return "Freeform"
        case .square: return "Square (1:1)"
        case .landscape16_9: return "Landscape (16:9)"
        case .landscape4_3: return "Landscape (4:3)"
        case .landscape21_9: return "Ultrawide (21:9)"
        case .portrait9_16: return "Portrait (9:16)"
        case .portrait3_4: return "Portrait (3:4)"
        case .custom: return "Custom"
        }
    }
    
    var ratio: CGFloat? {
        switch self {
        case .freeform: return nil
        case .square: return 1.0
        case .landscape16_9: return 16.0 / 9.0
        case .landscape4_3: return 4.0 / 3.0
        case .landscape21_9: return 21.0 / 9.0
        case .portrait9_16: return 9.0 / 16.0
        case .portrait3_4: return 3.0 / 4.0
        case .custom: return nil
        }
    }
}

