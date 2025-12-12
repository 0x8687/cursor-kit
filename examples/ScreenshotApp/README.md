# Screenshot App

A native macOS screenshot application with advanced editing capabilities.

## Features

- **Capture Modes**:
  - Region selection (drag & drop)
  - Fullscreen capture
  - Window selection

- **Editing Tools**:
  - Background selection (gradient gallery or custom images)
  - Padding adjustment
  - Corner radius adjustment
  - Drop shadow customization
  - Annotation tools (arrows, rectangles, ellipses, lines)
  - Text tool with styling
  - Crop tool
  - Aspect ratio selection

- **Export**:
  - Save to directory
  - Copy to clipboard

## Requirements

- macOS 12.0 (Monterey) or later
- Xcode 14.0 or later
- Swift 6.0

## Setup

1. Open the project in Xcode
2. Build and run (Cmd+R)
3. Grant screen recording permission when prompted
4. Grant accessibility permission if using window capture

## Project Structure

```
ScreenshotApp/
├── App/              # App entry point
├── Models/           # Data models
├── Views/            # SwiftUI views
├── ViewModels/       # View models (MVVM)
├── Services/         # Business logic services
├── Utils/            # Utilities and extensions
└── Shapes/           # Custom shapes
```

## Development

Built with:
- Swift 6
- SwiftUI
- Core Graphics
- Core Image

## License

MIT

