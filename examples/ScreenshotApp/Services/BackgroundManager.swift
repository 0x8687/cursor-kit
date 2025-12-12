//
//  BackgroundManager.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import AppKit

@MainActor
class BackgroundManager: ObservableObject {
    @Published var gradientPresets: [GradientPreset] = []
    @Published var selectedBackground: Background?
    @Published var uploadedImages: [NSImage] = []
    
    init() {
        loadGradientPresets()
    }
    
    private func loadGradientPresets() {
        gradientPresets = [
            // Vibrant Gradients
            GradientPreset(
                name: "Purple Pink",
                colors: [Color(red: 0.6, green: 0.2, blue: 0.8), Color(red: 1.0, green: 0.4, blue: 0.6)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Blue Cyan",
                colors: [Color(red: 0.2, green: 0.4, blue: 0.9), Color(red: 0.2, green: 0.9, blue: 1.0)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Orange Red",
                colors: [Color(red: 1.0, green: 0.6, blue: 0.2), Color(red: 1.0, green: 0.2, blue: 0.2)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Electric Blue Green",
                colors: [Color(red: 0.0, green: 0.5, blue: 1.0), Color(red: 0.0, green: 1.0, blue: 0.5)],
                type: .linear,
                startPoint: .leading,
                endPoint: .trailing
            ),
            GradientPreset(
                name: "Magenta Orange",
                colors: [Color(red: 1.0, green: 0.0, blue: 0.8), Color(red: 1.0, green: 0.5, blue: 0.0)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            
            // Soft Gradients
            GradientPreset(
                name: "Pastel Pink Blue",
                colors: [Color(red: 1.0, green: 0.8, blue: 0.9), Color(red: 0.8, green: 0.9, blue: 1.0)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Lavender Mint",
                colors: [Color(red: 0.9, green: 0.8, blue: 1.0), Color(red: 0.8, green: 1.0, blue: 0.9)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Peach Cream",
                colors: [Color(red: 1.0, green: 0.9, blue: 0.8), Color(red: 1.0, green: 0.95, blue: 0.9)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Sky Blue",
                colors: [Color(red: 0.7, green: 0.9, blue: 1.0), Color(red: 0.9, green: 0.95, blue: 1.0)],
                type: .linear,
                startPoint: .top,
                endPoint: .bottom
            ),
            GradientPreset(
                name: "Rose Gold",
                colors: [Color(red: 1.0, green: 0.85, blue: 0.8), Color(red: 1.0, green: 0.9, blue: 0.85)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            
            // Dark Gradients
            GradientPreset(
                name: "Deep Blue Purple",
                colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.3, green: 0.1, blue: 0.4)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Charcoal Teal",
                colors: [Color(red: 0.2, green: 0.2, blue: 0.25), Color(red: 0.1, green: 0.3, blue: 0.3)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Navy Gold",
                colors: [Color(red: 0.0, green: 0.1, blue: 0.3), Color(red: 0.4, green: 0.3, blue: 0.1)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Midnight Blue",
                colors: [Color(red: 0.05, green: 0.05, blue: 0.2), Color(red: 0.1, green: 0.1, blue: 0.3)],
                type: .linear,
                startPoint: .top,
                endPoint: .bottom
            ),
            GradientPreset(
                name: "Dark Purple",
                colors: [Color(red: 0.15, green: 0.05, blue: 0.25), Color(red: 0.25, green: 0.1, blue: 0.35)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            
            // Neutral Gradients
            GradientPreset(
                name: "Beige Brown",
                colors: [Color(red: 0.95, green: 0.9, blue: 0.85), Color(red: 0.7, green: 0.6, blue: 0.5)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Gray Blue",
                colors: [Color(red: 0.7, green: 0.75, blue: 0.8), Color(red: 0.5, green: 0.6, blue: 0.7)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Warm White Cream",
                colors: [Color(red: 1.0, green: 0.98, blue: 0.95), Color(red: 0.95, green: 0.92, blue: 0.88)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Stone Gray",
                colors: [Color(red: 0.8, green: 0.8, blue: 0.75), Color(red: 0.6, green: 0.6, blue: 0.55)],
                type: .linear,
                startPoint: .top,
                endPoint: .bottom
            ),
            GradientPreset(
                name: "Sand Beige",
                colors: [Color(red: 0.95, green: 0.92, blue: 0.88), Color(red: 0.85, green: 0.8, blue: 0.75)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            
            // Bold Gradients
            GradientPreset(
                name: "Yellow Pink",
                colors: [Color(red: 1.0, green: 0.9, blue: 0.0), Color(red: 1.0, green: 0.4, blue: 0.6)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Green Blue",
                colors: [Color(red: 0.0, green: 0.8, blue: 0.4), Color(red: 0.0, green: 0.5, blue: 1.0)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Red Orange",
                colors: [Color(red: 1.0, green: 0.2, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.0)],
                type: .linear,
                startPoint: .leading,
                endPoint: .trailing
            ),
            GradientPreset(
                name: "Violet Indigo",
                colors: [Color(red: 0.5, green: 0.2, blue: 0.9), Color(red: 0.3, green: 0.1, blue: 0.6)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            GradientPreset(
                name: "Coral Peach",
                colors: [Color(red: 1.0, green: 0.5, blue: 0.4), Color(red: 1.0, green: 0.7, blue: 0.6)],
                type: .linear,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            
            // Radial Gradients
            GradientPreset(
                name: "Sunset Radial",
                colors: [Color(red: 1.0, green: 0.6, blue: 0.4), Color(red: 0.8, green: 0.3, blue: 0.6)],
                type: .radial,
                startPoint: .center,
                endPoint: .center
            ),
            GradientPreset(
                name: "Ocean Radial",
                colors: [Color(red: 0.2, green: 0.6, blue: 0.9), Color(red: 0.1, green: 0.3, blue: 0.5)],
                type: .radial,
                startPoint: .center,
                endPoint: .center
            ),
            GradientPreset(
                name: "Forest Radial",
                colors: [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.1, green: 0.4, blue: 0.2)],
                type: .radial,
                startPoint: .center,
                endPoint: .center
            )
        ]
    }
    
    func selectGradient(_ preset: GradientPreset) {
        selectedBackground = .gradient(preset)
    }
    
    func uploadCustomImage(url: URL) async throws -> Bool {
        guard url.startAccessingSecurityScopedResource() else {
            throw BackgroundError.fileAccessDenied
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        guard let image = NSImage(contentsOf: url) else {
            throw BackgroundError.invalidImage
        }
        
        // Validate image size
        if let imageData = try? Data(contentsOf: url),
           imageData.count > Constants.maxImageSize {
            throw BackgroundError.imageTooLarge
        }
        
        await MainActor.run {
            uploadedImages.append(image)
            selectedBackground = .image(image)
        }
        
        return true
    }
    
    func selectUploadedImage(_ image: NSImage) {
        selectedBackground = .image(image)
    }
    
    func clearBackground() {
        selectedBackground = nil
    }
}

enum BackgroundError: LocalizedError {
    case fileAccessDenied
    case invalidImage
    case imageTooLarge
    
    var errorDescription: String? {
        switch self {
        case .fileAccessDenied:
            return "Unable to access the selected file"
        case .invalidImage:
            return "Invalid image format"
        case .imageTooLarge:
            return "Image is too large (max 10MB)"
        }
    }
}

