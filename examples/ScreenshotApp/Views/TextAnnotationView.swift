//
//  TextAnnotationView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import AppKit

struct TextAnnotationView: View {
    let annotation: Annotation
    
    var body: some View {
        if let text = annotation.text, !text.isEmpty {
            Text(text)
                .font(.init(annotation.font ?? NSFont.systemFont(ofSize: annotation.fontSize ?? 16)))
                .foregroundColor(annotation.color)
                .frame(width: annotation.frame.width, height: annotation.frame.height, alignment: textAlignment)
                .overlay(
                    Group {
                        if annotation.hasBorder == true {
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(
                                    annotation.borderColor ?? .black,
                                    lineWidth: annotation.borderWidth ?? 1.0
                                )
                        }
                    }
                )
                .position(x: annotation.frame.midX, y: annotation.frame.midY)
        }
    }
    
    private var textAlignment: Alignment {
        switch annotation.alignment {
        case .left:
            return .leading
        case .center:
            return .center
        case .right:
            return .trailing
        default:
            return .leading
        }
    }
}

