//
//  ExportService.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import AppKit
import CoreGraphics

enum ExportError: Error {
    case renderFailed
    case saveFailed
    case clipboardFailed
    case invalidFormat
}

@MainActor
class ExportService {
    static func exportImage(
        state: EditorState,
        annotations: [Annotation],
        options: ExportOptions = ExportOptions()
    ) async throws -> NSImage {
        // Render final image at full quality
        guard let image = await ImageRenderer.renderFinalImage(
            state: state,
            annotations: annotations
        ) else {
            throw ExportError.renderFailed
        }
        
        return image
    }
    
    static func saveToFile(
        image: NSImage,
        options: ExportOptions,
        url: URL
    ) async throws {
        guard let imageData = imageData(from: image, format: options.format) else {
            throw ExportError.invalidFormat
        }
        
        try imageData.write(to: url)
    }
    
    static func copyToClipboard(image: NSImage) async throws {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        
        guard pasteboard.writeObjects([image]) else {
            throw ExportError.clipboardFailed
        }
    }
    
    private static func imageData(from image: NSImage, format: ExportFormat) -> Data? {
        guard let cgImage = image.cgImage else { return nil }
        
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = image.size
        
        switch format {
        case .png:
            return bitmapRep.representation(using: .png, properties: [:])
            
        case .jpeg(let quality):
            return bitmapRep.representation(
                using: .jpeg,
                properties: [.compressionFactor: quality]
            )
        }
    }
}

