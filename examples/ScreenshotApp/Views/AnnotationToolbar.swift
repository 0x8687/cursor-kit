//
//  AnnotationToolbar.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct AnnotationToolbar: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Tools")
                .font(.headline)
                .padding(.horizontal)
            
            // Tool Selection
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach([Tool.select, .arrow, .rectangle, .ellipse, .line, .text, .crop]) { tool in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.selectTool(tool)
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tool.systemImage)
                                .font(.title2)
                                .symbolVariant(viewModel.selectedTool == tool ? .fill : .none)
                            Text(tool.name)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            Group {
                                if viewModel.selectedTool == tool {
                                    Color.accentColor.opacity(0.2)
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    viewModel.selectedTool == tool ? Color.accentColor : Color.clear,
                                    lineWidth: 2
                                )
                        )
                        .cornerRadius(8)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .help("Select \(tool.name) tool (Press \(tool.keyboardShortcut ?? ""))")
                    .accessibilityLabel("\(tool.name) tool")
                    .accessibilityHint(viewModel.selectedTool == tool ? "Selected" : "Tap to select")
                    .accessibilityAddTraits(viewModel.selectedTool == tool ? .isSelected : [])
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // Annotation Properties (shown when tool selected)
            if viewModel.selectedTool != .select && viewModel.selectedTool != .crop {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Properties")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    
                    // Color Picker
                    ColorPicker("Color", selection: $viewModel.annotationColor)
                        .padding(.horizontal)
                        .help("Select the color for annotations")
                        .accessibilityLabel("Annotation color picker")
                    
                    // Stroke Width
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Width")
                            Spacer()
                            Text("\(Int(viewModel.strokeWidth)) px")
                                .foregroundColor(.secondary)
                        }
                        Slider(
                            value: $viewModel.strokeWidth,
                            in: 1...20
                        )
                        .help("Adjust the stroke width of annotations (1-20 pixels)")
                        .accessibilityLabel("Stroke width")
                        .accessibilityValue("\(Int(viewModel.strokeWidth)) pixels")
                    }
                    .padding(.horizontal)
                }
            }
            
            // Selected Annotation Controls
            if viewModel.selectedAnnotation != nil {
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Annotation")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    
                    // Delete Button
                    Button(action: {
                        if let id = viewModel.selectedAnnotation?.id {
                            viewModel.deleteAnnotation(id)
                        }
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .padding(.horizontal)
                    .help("Delete selected annotation (or press Delete key)")
                    .accessibilityLabel("Delete annotation")
                    .accessibilityHint("Removes the selected annotation from the canvas")
                }
            }
        }
        .padding(.vertical)
    }
}

