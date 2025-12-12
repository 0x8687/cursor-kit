//
//  EditorView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct EditorView: View {
    let screenshot: CGImage
    @StateObject private var viewModel: EditorViewModel
    @StateObject private var backgroundManager = BackgroundManager()
    @State private var debounceTask: Task<Void, Never>?
    @State private var showingBackgroundGallery = false
    @State private var showingHelp = false
    @State private var toastMessage: String?
    @State private var toastIsError = false
    @State private var toastTask: Task<Void, Never>?
    
    init(screenshot: CGImage) {
        self.screenshot = screenshot
        _viewModel = StateObject(wrappedValue: EditorViewModel(screenshot: screenshot))
    }
    
    var body: some View {
        HSplitView {
            PreviewAreaView(viewModel: viewModel)
                .frame(minWidth: 400)
            
            ControlsPanelView(
                viewModel: viewModel,
                backgroundManager: backgroundManager,
                showingBackgroundGallery: $showingBackgroundGallery,
                debounceUpdate: debounceUpdate
            )
            .frame(width: 300)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { viewModel.undo() }) {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                }
                .keyboardShortcut("z", modifiers: .command)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: { viewModel.redo() }) {
                    Label("Redo", systemImage: "arrow.uturn.forward")
                }
                .keyboardShortcut("z", modifiers: [.command, .shift])
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    Task {
                        await viewModel.exportAndSave()
                    }
                }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                }
                .keyboardShortcut("s", modifiers: .command)
                .disabled(viewModel.isExporting)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    Task {
                        await viewModel.exportAndCopy()
                    }
                }) {
                    Label("Copy", systemImage: "doc.on.clipboard")
                }
                .keyboardShortcut("c", modifiers: [.command, .shift])
                .disabled(viewModel.isExporting)
                .accessibilityLabel("Copy to clipboard")
            }
            
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showingHelp = true
                }) {
                    Label("Help", systemImage: "questionmark.circle")
                }
                .keyboardShortcut("?", modifiers: .command)
                .accessibilityLabel("Show keyboard shortcuts help")
            }
        }
        .onAppear {
            viewModel.refreshPreview()
        }
        .sheet(isPresented: $showingBackgroundGallery) {
            BackgroundGalleryView(
                backgroundManager: backgroundManager,
                onSelect: { background in
                    viewModel.setBackground(background)
                },
                onCancel: {
                    showingBackgroundGallery = false
                }
            )
        }
        .onKeyPress(.delete) {
            if let id = viewModel.selectedAnnotation?.id {
                viewModel.deleteAnnotation(id)
            }
            return .handled
        }
        // Tool selection shortcuts: 1-7
        .onKeyPress(.init("1")) { _ in
            viewModel.selectTool(.select)
            return .handled
        }
        .onKeyPress(.init("2")) { _ in
            viewModel.selectTool(.arrow)
            return .handled
        }
        .onKeyPress(.init("3")) { _ in
            viewModel.selectTool(.rectangle)
            return .handled
        }
        .onKeyPress(.init("4")) { _ in
            viewModel.selectTool(.ellipse)
            return .handled
        }
        .onKeyPress(.init("5")) { _ in
            viewModel.selectTool(.line)
            return .handled
        }
        .onKeyPress(.init("6")) { _ in
            viewModel.selectTool(.text)
            return .handled
        }
        .onKeyPress(.init("7")) { _ in
            viewModel.selectTool(.crop)
            return .handled
        }
        // ESC to cancel crop
        .onKeyPress(.escape) { _ in
            viewModel.cancelCrop()
            return .handled
        }
        // Toast notifications for export
        .onChange(of: viewModel.exportSuccessMessage) { _, message in
            if let message = message {
                showToast(message, isError: false)
            }
        }
        .onChange(of: viewModel.exportError) { _, message in
            if let message = message {
                showToast(message, isError: true)
            }
        }
        .overlay(alignment: .bottom) {
            if let message = toastMessage {
                ToastView(message: message, isError: toastIsError)
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: toastMessage)
            }
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
    }
    
    private func debounceUpdate(_ update: @escaping () -> Void) {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
            if !Task.isCancelled {
                update()
            }
        }
    }

    private func showToast(_ message: String, isError: Bool) {
        toastTask?.cancel()
        toastMessage = message
        toastIsError = isError

        toastTask = Task {
            try? await Task.sleep(nanoseconds: 2_500_000_000) // 2.5s
            if !Task.isCancelled {
                await MainActor.run {
                    toastMessage = nil
                }
            }
        }
    }
}

#Preview {
    EditorView(screenshot: createSampleImage())
}

func createSampleImage() -> CGImage {
    let size = CGSize(width: 400, height: 300)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(
        data: nil,
        width: Int(size.width),
        height: Int(size.height),
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    
    context.setFillColor(NSColor.systemBlue.cgColor)
    context.fill(CGRect(origin: .zero, size: size))
    
    return context.makeImage()!
}

