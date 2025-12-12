//
//  Extensions.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import AppKit

extension CGImage {
    var nsImage: NSImage {
        NSImage(cgImage: self, size: NSSize(width: width, height: height))
    }
}

extension NSImage {
    var cgImage: CGImage? {
        guard let tiffData = tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        return bitmapImage.cgImage
    }
}

extension Color {
    var cgColor: CGColor {
        NSColor(self).cgColor
    }
}

