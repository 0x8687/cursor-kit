//
//  ScreenCaptureKitService.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import ScreenCaptureKit
import CoreGraphics
import AppKit
import CoreVideo
import CoreImage
import Foundation

@available(macOS 12.3, *)
class ScreenCaptureKitService {
    
    // MARK: - Region Capture
    
    static func captureRegion(bounds: CGRect) async throws -> CGImage? {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        let excludedWindows = appWindows(from: content)
        
        // Find the display that contains the bounds
        guard let display = findDisplayContaining(bounds, in: content.displays) else {
            throw CaptureError.captureFailed
        }
        
        // Create content filter for the display
        let filter = SCContentFilter(display: display, excludingWindows: excludedWindows)
        
        // Capture the full display first
        let config = SCStreamConfiguration()
        config.width = Int(display.width)
        config.height = Int(display.height)
        config.showsCursor = false
        config.queueDepth = 5
        
        // Create stream output
        let output = CaptureOutput()
        
        // Create and configure stream
        let stream = SCStream(filter: filter, configuration: config, delegate: nil)
        try await stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: .global(qos: .userInitiated))
        
        // Start capture
        try await stream.startCapture()
        
        // Wait for frame
        let fullImage = try await output.waitForFrame()
        
        // Stop capture
        try await stream.stopCapture()
        
        // Convert bounds from screen coordinates to display coordinates
        let displayBounds = convertToDisplayCoordinates(bounds, display: display)
        
        // Validate bounds are within display
        let displayFrame = CGRect(x: 0, y: 0, width: display.width, height: display.height)
        guard displayFrame.intersects(displayBounds) else {
            throw CaptureError.invalidBounds
        }
        
        // Crop to the requested region
        let croppedRect = displayBounds.intersection(displayFrame)
        guard let croppedImage = fullImage.cropping(to: croppedRect) else {
            throw CaptureError.captureFailed
        }
        
        return croppedImage
    }
    
    // MARK: - Fullscreen Capture
    
    static func captureFullscreen() async throws -> CGImage? {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        let excludedWindows = appWindows(from: content)
        
        guard let display = content.displays.first else {
            throw CaptureError.captureFailed
        }
        
        let filter = SCContentFilter(display: display, excludingWindows: excludedWindows)
        
        let config = SCStreamConfiguration()
        config.width = Int(display.width)
        config.height = Int(display.height)
        config.showsCursor = false
        config.queueDepth = 5
        
        let output = CaptureOutput()
        let stream = SCStream(filter: filter, configuration: config, delegate: nil)
        try await stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: .global(qos: .userInitiated))
        
        try await stream.startCapture()
        let image = try await output.waitForFrame()
        try await stream.stopCapture()
        
        return image
    }
    
    // MARK: - Window Capture
    
    static func captureWindow(windowID: CGWindowID) async throws -> CGImage? {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        
        // Find the window by ID
        guard let window = content.windows.first(where: { $0.windowID == windowID }) else {
            throw CaptureError.windowNotFound
        }
        
        let filter = SCContentFilter(desktopIndependentWindow: window)
        
        let config = SCStreamConfiguration()
        config.width = Int(window.frame.width)
        config.height = Int(window.frame.height)
        config.showsCursor = false
        config.queueDepth = 5
        
        let output = CaptureOutput()
        let stream = SCStream(filter: filter, configuration: config, delegate: nil)
        try await stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: .global(qos: .userInitiated))
        
        try await stream.startCapture()
        let image = try await output.waitForFrame()
        try await stream.stopCapture()
        
        return image
    }
    
    // MARK: - Window Enumeration
    
    static func listWindows() async throws -> [WindowInfo] {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        
        // Use TaskGroup to capture thumbnails in parallel (with limit)
        return await withTaskGroup(of: WindowInfo.self) { group in
            var windows: [WindowInfo] = []
            
            for window in content.windows {
                group.addTask {
                    // Generate thumbnail
                    let thumbnail = try? await captureWindowThumbnail(window: window)
                    
                    return WindowInfo(
                        id: window.windowID,
                        title: window.title ?? "Untitled",
                        appName: window.owningApplication?.applicationName ?? "Unknown",
                        bounds: window.frame,
                        thumbnail: thumbnail
                    )
                }
            }
            
            for await windowInfo in group {
                windows.append(windowInfo)
            }
            
            return windows
        }
    }
    
    // MARK: - Helper Methods
    
    /// Find the display that contains the given bounds (in screen coordinates)
    private static func findDisplayContaining(_ rect: CGRect, in displays: [SCDisplay]) -> SCDisplay? {
        // Find display that contains the center of the rect
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return displays.first { display in
            let displayFrame = display.frame
            return displayFrame.contains(center)
        }
    }
    
    /// Convert screen coordinates to display-relative coordinates
    private static func convertToDisplayCoordinates(_ screenRect: CGRect, display: SCDisplay) -> CGRect {
        let displayFrame = display.frame
        return CGRect(
            x: screenRect.origin.x - displayFrame.origin.x,
            y: screenRect.origin.y - displayFrame.origin.y,
            width: screenRect.width,
            height: screenRect.height
        )
    }
    
    /// Windows owned by this process, to exclude the app UI from captures
    private static func appWindows(from content: SCShareableContent) -> [SCWindow] {
        let pid = Int32(ProcessInfo.processInfo.processIdentifier)
        return content.windows.filter { window in
            window.owningApplication?.processID == pid
        }
    }
    
    private static func captureWindowThumbnail(window: SCWindow) async throws -> CGImage? {
        let filter = SCContentFilter(desktopIndependentWindow: window)
        
        let config = SCStreamConfiguration()
        config.width = min(Int(window.frame.width), 200)
        config.height = min(Int(window.frame.height), 200)
        config.showsCursor = false
        config.queueDepth = 1
        
        let output = CaptureOutput()
        let stream = SCStream(filter: filter, configuration: config, delegate: nil)
        try await stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: .global(qos: .utility))
        
        try await stream.startCapture()
        let image = try await output.waitForFrame()
        try await stream.stopCapture()
        
        return image
    }
}

// MARK: - Capture Output Handler

@available(macOS 12.3, *)
private class CaptureOutput: NSObject, SCStreamOutput {
    private var captureContinuation: CheckedContinuation<CGImage, Error>?
    
    func waitForFrame() async throws -> CGImage {
        return try await withCheckedThrowingContinuation { continuation in
            self.captureContinuation = continuation
        }
    }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .screen else { return }
        guard let continuation = captureContinuation else { return }
        
        // Extract image from sample buffer
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            continuation.resume(throwing: CaptureError.captureFailed)
            captureContinuation = nil
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            continuation.resume(throwing: CaptureError.captureFailed)
            captureContinuation = nil
            return
        }
        
        // Resume with captured image (only once)
        continuation.resume(returning: cgImage)
        captureContinuation = nil
    }
}

