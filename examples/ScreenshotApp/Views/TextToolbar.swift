//
//  TextToolbar.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import AppKit

struct TextToolbar: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Text Properties")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            // Font Size
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Font Size")
                    Spacer()
                    Text("\(Int(viewModel.textFontSize)) pt")
                        .foregroundColor(.secondary)
                }
                Slider(
                    value: $viewModel.textFontSize,
                    in: 8...72
                )
                .onChange(of: viewModel.textFontSize) { _, newValue in
                    viewModel.textFont = NSFont.systemFont(ofSize: newValue)
                    if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                        viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                    }
                }
            }
            .padding(.horizontal)
            
            // Alignment
            VStack(alignment: .leading, spacing: 8) {
                Text("Alignment")
                HStack {
                    Button(action: { 
                        viewModel.textAlignment = .left
                        if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                            viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                        }
                    }) {
                        Image(systemName: "text.alignleft")
                    }
                    .buttonStyle(.bordered)
                    .background(viewModel.textAlignment == .left ? Color.accentColor.opacity(0.2) : Color.clear)
                    
                    Button(action: { 
                        viewModel.textAlignment = .center
                        if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                            viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                        }
                    }) {
                        Image(systemName: "text.aligncenter")
                    }
                    .buttonStyle(.bordered)
                    .background(viewModel.textAlignment == .center ? Color.accentColor.opacity(0.2) : Color.clear)
                    
                    Button(action: { 
                        viewModel.textAlignment = .right
                        if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                            viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                        }
                    }) {
                        Image(systemName: "text.alignright")
                    }
                    .buttonStyle(.bordered)
                    .background(viewModel.textAlignment == .right ? Color.accentColor.opacity(0.2) : Color.clear)
                }
            }
            .padding(.horizontal)
            
            // Color
            ColorPicker("Text Color", selection: $viewModel.annotationColor)
                .padding(.horizontal)
                .onChange(of: viewModel.annotationColor) { _, _ in
                    if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                        viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                    }
                }
            
            // Border
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Border", isOn: $viewModel.textHasBorder)
                    .onChange(of: viewModel.textHasBorder) { _, _ in
                        if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                            viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                        }
                    }
                
                if viewModel.textHasBorder {
                    ColorPicker("Border Color", selection: $viewModel.textBorderColor)
                        .onChange(of: viewModel.textBorderColor) { _, _ in
                            if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                                viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Border Width")
                            Spacer()
                            Text("\(Int(viewModel.textBorderWidth)) px")
                                .foregroundColor(.secondary)
                        }
                        Slider(
                            value: $viewModel.textBorderWidth,
                            in: 1...10
                        )
                        .onChange(of: viewModel.textBorderWidth) { _, _ in
                            if var annotation = viewModel.selectedAnnotation, annotation.type == .text {
                                viewModel.updateTextAnnotation(annotation, text: annotation.text ?? "")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

