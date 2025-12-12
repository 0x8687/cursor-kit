//
//  AspectRatioPicker.swift
//  ScreenshotApp
//
//  Created on 2025-12-05.
//

import SwiftUI

struct AspectRatioPicker: View {
    @Binding var selectedPreset: AspectRatioPreset
    @Binding var customRatio: CGFloat?
    @State private var customRatioString: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Aspect Ratio")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(AspectRatioPreset.allCases.filter { $0 != .custom }) { preset in
                    Button(action: {
                        selectedPreset = preset
                        customRatio = preset.ratio
                    }) {
                        VStack(spacing: 4) {
                            Text(preset.name)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            selectedPreset == preset
                                ? Color.accentColor.opacity(0.2)
                                : Color.clear
                        )
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            
            // Custom ratio input
            if selectedPreset == .custom {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom Ratio (width:height)")
                        .font(.caption)
                    TextField("e.g., 16:9", text: $customRatioString)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            parseCustomRatio()
                        }
                        .onAppear {
                            if let ratio = customRatio {
                                customRatioString = String(format: "%.2f:1", ratio)
                            }
                        }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func parseCustomRatio() {
        let parts = customRatioString.split(separator: ":")
        guard parts.count == 2,
              let width = Double(parts[0]),
              let height = Double(parts[1]),
              width > 0, height > 0 else {
            return
        }
        
        customRatio = CGFloat(width / height)
        selectedPreset = .custom
    }
}

