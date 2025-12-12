//
//  TextEditorView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct TextEditorView: View {
    @Binding var text: String
    let frame: CGRect
    let onCommit: () -> Void
    let onCancel: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("Enter text", text: $text, axis: .vertical)
            .textFieldStyle(.plain)
            .padding(8)
            .background(Color.white.opacity(0.9))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.blue, lineWidth: 2)
            )
            .frame(width: max(200, frame.width), height: max(30, frame.height))
            .position(x: frame.midX, y: frame.midY)
            .focused($isFocused)
            .onSubmit {
                onCommit()
            }
            .onAppear {
                isFocused = true
            }
            .onKeyPress(.escape) {
                onCancel()
                return .handled
            }
    }
}

