//
//  ToastView.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let isError: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .foregroundColor(isError ? .yellow : .green)
            Text(message)
                .foregroundColor(.primary)
                .font(.footnote)
                .lineLimit(2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.regularMaterial)
        .cornerRadius(10)
        .shadow(radius: 6)
        .accessibilityLabel(isError ? "Error: \(message)" : "Success: \(message)")
    }
}


