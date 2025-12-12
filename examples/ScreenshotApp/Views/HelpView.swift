//
//  HelpView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Tools Section
                    SectionView(title: "Tools") {
                        ShortcutRow(key: "1", description: "Select Tool")
                        ShortcutRow(key: "2", description: "Arrow Tool")
                        ShortcutRow(key: "3", description: "Rectangle Tool")
                        ShortcutRow(key: "4", description: "Ellipse Tool")
                        ShortcutRow(key: "5", description: "Line Tool")
                        ShortcutRow(key: "6", description: "Text Tool")
                        ShortcutRow(key: "7", description: "Crop Tool")
                    }
                    
                    // Actions Section
                    SectionView(title: "Actions") {
                        ShortcutRow(key: "⌘Z", description: "Undo")
                        ShortcutRow(key: "⌘⇧Z", description: "Redo")
                        ShortcutRow(key: "⌘S", description: "Save to File")
                        ShortcutRow(key: "⌘⇧C", description: "Copy to Clipboard")
                        ShortcutRow(key: "Delete", description: "Delete Selected Annotation")
                        ShortcutRow(key: "ESC", description: "Cancel Crop")
                    }
                    
                    // Editing Section
                    SectionView(title: "Editing") {
                        Text("• Drag on canvas to create annotations")
                        Text("• Click to select annotations")
                        Text("• Drag handles to resize annotations")
                        Text("• Double-click text annotations to edit")
                    }
                }
                .padding()
            }
            .navigationTitle("Keyboard Shortcuts")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 500, height: 600)
    }
}

private struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding(.leading, 16)
        }
    }
}

private struct ShortcutRow: View {
    let key: String
    let description: String
    
    var body: some View {
        HStack {
            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(key)
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(4)
        }
    }
}

#Preview {
    HelpView()
}

