//
//  ContentView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var permissionManager = PermissionManager()
    @StateObject private var captureViewModel: CaptureViewModel
    @State private var showingEditor = false
    
    init() {
        let pm = PermissionManager()
        _permissionManager = StateObject(wrappedValue: pm)
        _captureViewModel = StateObject(wrappedValue: CaptureViewModel(permissionManager: pm))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("ScreenshotApp")
                    .font(.largeTitle)
                    .padding()
                
                if permissionManager.screenRecordingStatus != .granted {
                    VStack(spacing: 15) {
                        Text("Screen Recording Permission Required")
                            .font(.headline)
                        Text("This app needs screen recording permission to capture screenshots.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Request Permission") {
                            Task {
                                await permissionManager.requestScreenRecordingPermission()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    ZStack {
                        VStack(spacing: 20) {
                            Button("Capture Region") {
                                captureViewModel.startRegionCapture()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .disabled(captureViewModel.isCapturing)
                            .accessibilityLabel("Capture Region")
                            .accessibilityHint("Drag to select an area of the screen to capture")
                            
                            Button("Capture Fullscreen") {
                                Task {
                                    await captureViewModel.captureFullscreen()
                                    if captureViewModel.capturedImage != nil {
                                        showingEditor = true
                                    }
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .disabled(captureViewModel.isCapturing)
                            .accessibilityLabel("Capture Fullscreen")
                            .accessibilityHint("Capture the entire screen")
                            
                            Button("Capture Window") {
                                Task {
                                    await captureViewModel.startWindowCapture()
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .disabled(captureViewModel.isCapturing)
                            .accessibilityLabel("Capture Window")
                            .accessibilityHint("Select a window to capture")
                        }
                        .padding()
                        .opacity(captureViewModel.isCapturing ? 0.3 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: captureViewModel.isCapturing)
                        
                        if captureViewModel.isCapturing {
                            LoadingView(message: "Capturing screenshot...")
                        }
                    }
                }
                
                if let error = captureViewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: captureViewModel.errorMessage)
                    .accessibilityLabel("Error: \(error)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(isPresented: $showingEditor) {
                if let image = captureViewModel.capturedImage {
                    EditorView(screenshot: image)
                }
            }
            .overlay {
                if captureViewModel.showingRegionOverlay {
                    CaptureOverlayView(
                        isPresented: $captureViewModel.showingRegionOverlay,
                        onCapture: { bounds in
                            Task {
                                await captureViewModel.captureRegion(bounds: bounds)
                                if captureViewModel.capturedImage != nil {
                                    showingEditor = true
                                }
                            }
                        },
                        onCancel: {
                            captureViewModel.cancelCapture()
                        }
                    )
                    .background(Color.clear)
                    .ignoresSafeArea()
                }
            }
            .sheet(isPresented: $captureViewModel.showingWindowSelection) {
                WindowSelectionView(
                    windows: captureViewModel.availableWindows,
                    onSelect: { windowID in
                        Task {
                            await captureViewModel.captureWindow(windowID: windowID)
                            if captureViewModel.capturedImage != nil {
                                showingEditor = true
                            }
                        }
                    },
                    onCancel: {
                        captureViewModel.cancelCapture()
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}

