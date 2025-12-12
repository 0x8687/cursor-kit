//
//  TransparentOverlayWindow.swift
//  ScreenshotApp
//
//  Ensures the overlay window stays transparent and above the main app UI
//

import SwiftUI
import AppKit

struct TransparentOverlayWindow: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        configure(window: view.window)
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        configure(window: nsView.window)
    }
    
    private func configure(window: NSWindow?) {
        guard let window else { return }
        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .screenSaver
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
}

