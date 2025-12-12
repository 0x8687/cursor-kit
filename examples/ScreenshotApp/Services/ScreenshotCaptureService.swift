//
//  ScreenshotCaptureService.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import AppKit
import CoreGraphics
import ApplicationServices

enum CaptureError: Error {
    case permissionDenied
    case captureFailed
    case invalidBounds
    case windowNotFound
    case unsupportedVersion
}

@MainActor
class ScreenshotCaptureService {
    private let permissionManager: PermissionManager
    
    init(permissionManager: PermissionManager) {
        self.permissionManager = permissionManager
    }
    
    func captureRegion(bounds: CGRect) async throws -> CGImage? {
        guard permissionManager.screenRecordingStatus == .granted else {
            throw CaptureError.permissionDenied
        }
        
        guard bounds.width > 0 && bounds.height > 0 else {
            throw CaptureError.invalidBounds
        }
        
        // Use ScreenCaptureKit on macOS 12.3+
        if #available(macOS 12.3, *) {
            return try await ScreenCaptureKitService.captureRegion(bounds: bounds)
        } else {
            // Fallback for older versions (though we target 12.0+, this is safety)
            throw CaptureError.unsupportedVersion
        }
    }
    
    func captureFullscreen() async throws -> CGImage? {
        guard permissionManager.screenRecordingStatus == .granted else {
            throw CaptureError.permissionDenied
        }
        
        // Use ScreenCaptureKit on macOS 12.3+
        if #available(macOS 12.3, *) {
            return try await ScreenCaptureKitService.captureFullscreen()
        } else {
            throw CaptureError.unsupportedVersion
        }
    }
    
    func captureWindow(windowID: CGWindowID) async throws -> CGImage? {
        guard permissionManager.screenRecordingStatus == .granted else {
            throw CaptureError.permissionDenied
        }
        
        // Use ScreenCaptureKit on macOS 12.3+
        if #available(macOS 12.3, *) {
            return try await ScreenCaptureKitService.captureWindow(windowID: windowID)
        } else {
            throw CaptureError.unsupportedVersion
        }
    }
    
    func listWindows() async -> [WindowInfo] {
        // ScreenCaptureKit doesn't require accessibility permission for window enumeration
        if #available(macOS 12.3, *) {
            do {
                return try await ScreenCaptureKitService.listWindows()
            } catch {
                return []
            }
        } else {
            // Fallback for older versions
            return await withCheckedContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async {
                    let windowList = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[String: Any]] ?? []
                    
                    let windows = windowList.compactMap { windowDict -> WindowInfo? in
                        guard let windowID = windowDict[kCGWindowNumber as String] as? CGWindowID,
                              let boundsDict = windowDict[kCGWindowBounds as String] as? [String: CGFloat],
                              let x = boundsDict["X"],
                              let y = boundsDict["Y"],
                              let width = boundsDict["Width"],
                              let height = boundsDict["Height"] else {
                            return nil
                        }
                        
                        let title = windowDict[kCGWindowName as String] as? String ?? "Untitled"
                        let ownerName = windowDict[kCGWindowOwnerName as String] as? String ?? "Unknown"
                        
                        let bounds = CGRect(x: x, y: y, width: width, height: height)
                        
                        return WindowInfo(
                            id: windowID,
                            title: title,
                            appName: ownerName,
                            bounds: bounds,
                            thumbnail: nil // No thumbnail for fallback
                        )
                    }
                    
                    continuation.resume(returning: windows)
                }
            }
        }
    }
}

