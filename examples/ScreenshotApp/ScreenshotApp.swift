//
//  ScreenshotApp.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

@main
struct ScreenshotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)
        .commands {
            CommandGroup(replacing: .help) {
                Button("Keyboard Shortcuts...") {
                    NSApp.sendAction(Selector(("showHelp:")), to: nil, from: nil)
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }
    }
}

