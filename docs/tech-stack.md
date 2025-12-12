# Tech Stack: macOS Screenshot App

**Date**: 2025-12-05  
**Project**: Native macOS Screenshot Application with Advanced Editing

## Core Technologies

### Language & Framework
- **Swift 6**: Modern, type-safe language with async/await, actors
- **SwiftUI**: Declarative UI framework (macOS 12+)
- **AppKit**: Window management, file operations (minimal use)

### Image Processing
- **Core Graphics (CGContext)**: Image manipulation, rendering, composition
- **Core Image (CIFilter)**: Advanced effects (shadows, blur, filters)
- **NSImage/CGImage**: Image representation and conversion

### Drawing & Annotations
- **SwiftUI Canvas**: Real-time drawing for annotations (arrows, shapes, lines)
- **Path API**: Shape creation and manipulation
- **Core Text**: Advanced text rendering for text tool

### System Integration
- **ScreenCaptureKit**: Modern screenshot capture API (macOS 12.3+)
  - `SCShareableContent`: Enumerate displays and windows
  - `SCContentFilter`: Define capture scope
  - `SCStream`: Capture stream management
  - `SCStreamOutput`: Frame handling
- **NSPasteboard**: Clipboard operations
- **FileManager**: File save operations

## Architecture Pattern

**MVVM (Model-View-ViewModel)**:
- **Models**: Screenshot data, annotations, editor state
- **Views**: SwiftUI views for UI components
- **ViewModels**: Business logic, state management

## Key Components

### 1. Screenshot Capture Service
- `ScreenshotCaptureService`: Handles all capture modes
- Async/await for non-blocking operations
- Permission management (screen recording, accessibility)

### 2. Image Editor
- `ImageEditorViewModel`: State management
- `ImageRenderer`: Core Graphics rendering pipeline
- `AnnotationCanvas`: SwiftUI Canvas for drawing
- `EffectProcessor`: Core Image filters

### 3. Annotation System
- `Annotation` model: Shape data structure
- `Tool` enum: Tool selection (arrow, rectangle, ellipse, line, text)
- Gesture handlers for manipulation

### 4. Background System
- `GradientPreset`: Predefined gradient collection
- `BackgroundManager`: Gradient/image management
- File importer for custom images

## Dependencies

**No External Dependencies Required**:
- All functionality available via native Apple frameworks
- Reduces bundle size, improves performance
- No third-party license concerns

## Minimum System Requirements

- **macOS**: 12.3 (Monterey) or later (for ScreenCaptureKit)
- **Xcode**: 14.0 or later
- **Swift**: 5.7+ (Swift 6 recommended)

**Note**: ScreenCaptureKit is available from macOS 12.3+. The app uses ScreenCaptureKit for all capture operations.

## Development Tools

- **Xcode**: Primary IDE
- **Swift Package Manager**: Dependency management (if needed later)
- **Instruments**: Performance profiling
- **Accessibility Inspector**: Testing accessibility features

## Performance Considerations

- Use background queues for image processing
- Cache rendered images for preview
- Lazy load gradient gallery
- Optimize Core Graphics rendering pipeline
- Support async operations throughout

## Security & Privacy

- Request permissions explicitly
- Handle permission denial gracefully
- Validate file inputs
- No network access required (offline-first)
- Privacy-focused (no telemetry, no data collection)

## Future Extensibility

- Swift Package Manager ready (if external libs needed)
- Modular architecture allows feature additions
- Core Image filters extensible
- Plugin architecture possible (advanced)

## Rationale

**Why Native Swift/SwiftUI?**
- Best performance for macOS
- Native look and feel
- Full access to system APIs
- No Electron overhead
- Smaller app size
- Better battery efficiency

**Why No External Libraries?**
- YAGNI principle: Native APIs sufficient
- Reduced complexity
- Better performance
- Easier maintenance
- No license management

## References

- Research reports in `plans/20251205-1045-macos-screenshot-app/research/`
- Apple Developer Documentation
- SwiftUI Best Practices

