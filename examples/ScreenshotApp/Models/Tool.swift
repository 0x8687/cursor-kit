//
//  Tool.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

enum Tool: String, CaseIterable, Identifiable {
    case select
    case arrow
    case rectangle
    case ellipse
    case line
    case text
    case crop
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .select: return "Select"
        case .arrow: return "Arrow"
        case .rectangle: return "Rectangle"
        case .ellipse: return "Ellipse"
        case .line: return "Line"
        case .text: return "Text"
        case .crop: return "Crop"
        }
    }
    
    var systemImage: String {
        switch self {
        case .select: return "cursorarrow"
        case .arrow: return "arrow.right"
        case .rectangle: return "rectangle"
        case .ellipse: return "circle"
        case .line: return "line.diagonal"
        case .text: return "text"
        case .crop: return "crop"
        }
    }
    
    var keyboardShortcut: String? {
        switch self {
        case .select: return "1"
        case .arrow: return "2"
        case .rectangle: return "3"
        case .ellipse: return "4"
        case .line: return "5"
        case .text: return "6"
        case .crop: return "7"
        }
    }
}

