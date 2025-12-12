//
//  PermissionManager.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import AppKit
import ApplicationServices

enum PermissionStatus {
    case notDetermined
    case granted
    case denied
}

@MainActor
class PermissionManager: ObservableObject {
    @Published var screenRecordingStatus: PermissionStatus = .notDetermined
    @Published var accessibilityStatus: PermissionStatus = .notDetermined
    
    init() {
        checkPermissions()
    }
    
    func checkPermissions() {
        screenRecordingStatus = checkScreenRecordingPermission()
        accessibilityStatus = checkAccessibilityPermission()
    }
    
    func requestScreenRecordingPermission() async -> Bool {
        let hasAccess = CGRequestScreenCaptureAccess()
        await MainActor.run {
            screenRecordingStatus = hasAccess ? .granted : .denied
        }
        return hasAccess
    }
    
    func requestAccessibilityPermission() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        accessibilityStatus = accessEnabled ? .granted : .denied
    }
    
    private func checkScreenRecordingPermission() -> PermissionStatus {
        // On macOS 10.15+, we need to check if we have screen recording permission
        if #available(macOS 10.15, *) {
            // CGPreflightScreenCaptureAccess() is available in macOS 12.0+
            if #available(macOS 12.0, *) {
                let hasAccess = CGPreflightScreenCaptureAccess()
                return hasAccess ? .granted : .notDetermined
            } else {
                // For macOS 10.15-11.x, we can't check without requesting
                return .notDetermined
            }
        } else {
            return .granted
        }
    }
    
    private func checkAccessibilityPermission() -> PermissionStatus {
        let accessEnabled = AXIsProcessTrusted()
        return accessEnabled ? .granted : .notDetermined
    }
}

