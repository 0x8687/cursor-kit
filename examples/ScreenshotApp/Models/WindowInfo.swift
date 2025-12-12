//
//  WindowInfo.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import AppKit
import CoreGraphics

struct WindowInfo: Identifiable {
    let id: CGWindowID
    let title: String
    let appName: String
    let bounds: CGRect
    let thumbnail: CGImage?
    
    init(
        id: CGWindowID,
        title: String,
        appName: String,
        bounds: CGRect,
        thumbnail: CGImage? = nil
    ) {
        self.id = id
        self.title = title
        self.appName = appName
        self.bounds = bounds
        self.thumbnail = thumbnail
    }
}

