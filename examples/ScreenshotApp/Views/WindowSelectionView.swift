//
//  WindowSelectionView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct WindowSelectionView: View {
    let windows: [WindowInfo]
    let onSelect: (CGWindowID) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Window")
                    .font(.headline)
                Spacer()
                Button("Cancel") {
                    onCancel()
                }
            }
            .padding()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 16) {
                    ForEach(windows) { window in
                        WindowThumbnailView(window: window) {
                            onSelect(window.id)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 600, height: 500)
    }
}

struct WindowThumbnailView: View {
    let window: WindowInfo
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let thumbnail = window.thumbnail {
                Image(decorative: thumbnail, scale: 1.0)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .cornerRadius(4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 120)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(window.title)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                Text(window.appName)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .onTapGesture {
            onSelect()
        }
    }
}

