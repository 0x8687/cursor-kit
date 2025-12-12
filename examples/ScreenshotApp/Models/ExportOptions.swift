//
//  ExportOptions.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import Foundation

enum ExportFormat {
    case png
    case jpeg(quality: CGFloat)
}

struct ExportOptions {
    var format: ExportFormat = .png
    var fileName: String?
    
    var fileExtension: String {
        switch format {
        case .png: return "png"
        case .jpeg: return "jpg"
        }
    }
    
    func generateFileName() -> String {
        if let fileName = fileName, !fileName.isEmpty {
            return fileName
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        return "Screenshot \(formatter.string(from: Date()))"
    }
}

