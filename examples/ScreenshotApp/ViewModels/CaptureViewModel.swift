//
//  CaptureViewModel.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI
import CoreGraphics

@MainActor
class CaptureViewModel: ObservableObject {
    @Published var isCapturing = false
    @Published var capturedImage: CGImage?
    @Published var errorMessage: String?
    @Published var showingRegionOverlay = false
    @Published var showingWindowSelection = false
    @Published var availableWindows: [WindowInfo] = []
    
    private let captureService: ScreenshotCaptureService
    private let permissionManager: PermissionManager
    
    init(permissionManager: PermissionManager) {
        self.permissionManager = permissionManager
        self.captureService = ScreenshotCaptureService(permissionManager: permissionManager)
    }
    
    func startRegionCapture() {
        guard permissionManager.screenRecordingStatus == .granted else {
            errorMessage = "Screen recording permission is required"
            return
        }
        showingRegionOverlay = true
    }
    
    func captureRegion(bounds: CGRect) async {
        isCapturing = true
        errorMessage = nil
        
        do {
            let image = try await captureService.captureRegion(bounds: bounds)
            capturedImage = image
            showingRegionOverlay = false
        } catch {
            errorMessage = "Failed to capture region: \(error.localizedDescription)"
        }
        
        isCapturing = false
    }
    
    func captureFullscreen() async {
        guard permissionManager.screenRecordingStatus == .granted else {
            errorMessage = "Screen recording permission is required"
            return
        }
        
        isCapturing = true
        errorMessage = nil
        
        do {
            let image = try await captureService.captureFullscreen()
            capturedImage = image
        } catch {
            errorMessage = "Failed to capture fullscreen: \(error.localizedDescription)"
        }
        
        isCapturing = false
    }
    
    func startWindowCapture() async {
        guard permissionManager.screenRecordingStatus == .granted else {
            errorMessage = "Screen recording permission is required for window capture"
            return
        }
        
        availableWindows = await captureService.listWindows()
        showingWindowSelection = true
    }
    
    func captureWindow(windowID: CGWindowID) async {
        isCapturing = true
        errorMessage = nil
        
        do {
            let image = try await captureService.captureWindow(windowID: windowID)
            capturedImage = image
            showingWindowSelection = false
        } catch {
            errorMessage = "Failed to capture window: \(error.localizedDescription)"
        }
        
        isCapturing = false
    }
    
    func cancelCapture() {
        showingRegionOverlay = false
        showingWindowSelection = false
    }
}

