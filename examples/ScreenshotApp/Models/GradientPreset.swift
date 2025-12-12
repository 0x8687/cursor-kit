//
//  GradientPreset.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

enum GradientType {
    case linear
    case radial
}

struct GradientPreset: Identifiable {
    let id: UUID
    let name: String
    let colors: [Color]
    let type: GradientType
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    init(
        id: UUID = UUID(),
        name: String,
        colors: [Color],
        type: GradientType = .linear,
        startPoint: UnitPoint = .topLeading,
        endPoint: UnitPoint = .bottomTrailing
    ) {
        self.id = id
        self.name = name
        self.colors = colors
        self.type = type
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

