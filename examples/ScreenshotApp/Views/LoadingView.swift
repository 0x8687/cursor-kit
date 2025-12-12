//
//  LoadingView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct LoadingView: View {
    let message: String?
    let progress: Double?
    
    init(message: String? = nil, progress: Double? = nil) {
        self.message = message
        self.progress = progress
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if let progress = progress {
                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .frame(width: 200)
            } else {
                ProgressView()
                    .scaleEffect(1.2)
            }
            
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 8)
        .accessibilityLabel(message ?? "Loading")
        .accessibilityValue(progress != nil ? "\(Int(progress! * 100)) percent" : "")
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
        LoadingView(message: "Capturing screenshot...")
    }
}

