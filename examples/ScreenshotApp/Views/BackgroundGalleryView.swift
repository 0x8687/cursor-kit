//
//  BackgroundGalleryView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct BackgroundGalleryView: View {
    @ObservedObject var backgroundManager: BackgroundManager
    let onSelect: (Background?) -> Void
    let onCancel: () -> Void
    
    @State private var showingImagePicker = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Select Background")
                    .font(.headline)
                Spacer()
                Button("Cancel") {
                    onCancel()
                }
            }
            .padding()
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Gradient Presets
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gradients")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                            ForEach(backgroundManager.gradientPresets) { preset in
                                GradientSwatchView(preset: preset) {
                                    backgroundManager.selectGradient(preset)
                                    onSelect(backgroundManager.selectedBackground)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Custom Image Upload
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Custom Images")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                        
                        // Upload Button
                        Button(action: { showingImagePicker = true }) {
                            HStack {
                                Image(systemName: "photo.badge.plus")
                                Text("Upload Image")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                        
                        // Uploaded Images
                        if !backgroundManager.uploadedImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(Array(backgroundManager.uploadedImages.enumerated()), id: \.offset) { index, image in
                                        ImageThumbnailView(image: image) {
                                            backgroundManager.selectUploadedImage(image)
                                            onSelect(backgroundManager.selectedBackground)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Clear Background Option
                    Divider()
                        .padding(.vertical, 8)
                    
                    Button(action: {
                        backgroundManager.clearBackground()
                        onSelect(nil)
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Clear Background")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .frame(width: 500, height: 600)
        .fileImporter(
            isPresented: $showingImagePicker,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            handleImageSelection(result: result)
        }
    }
    
    private func handleImageSelection(result: Result<[URL], Error>) {
        Task {
            do {
                let urls = try result.get()
                if let url = urls.first {
                    try await backgroundManager.uploadCustomImage(url: url)
                    await MainActor.run {
                        onSelect(backgroundManager.selectedBackground)
                        errorMessage = nil
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct GradientSwatchView: View {
    let preset: GradientPreset
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    preset.type == .radial
                        ? AnyShapeStyle(AngularGradient(
                            colors: preset.colors,
                            center: .center,
                            startAngle: .zero,
                            endAngle: .degrees(360)
                        ))
                        : AnyShapeStyle(LinearGradient(
                            colors: preset.colors,
                            startPoint: preset.startPoint,
                            endPoint: preset.endPoint
                        ))
                )
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1)
                )
            
            Text(preset.name)
                .font(.system(size: 10))
                .lineLimit(1)
                .foregroundColor(.secondary)
        }
        .onTapGesture {
            onSelect()
        }
    }
}

struct ImageThumbnailView: View {
    let image: NSImage
    let onSelect: () -> Void
    
    var body: some View {
        VStack {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1)
                )
        }
        .onTapGesture {
            onSelect()
        }
    }
}

