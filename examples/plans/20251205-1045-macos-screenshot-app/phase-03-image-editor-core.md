# Phase 3: Image Editor Core

## Context Links
- [Plan Overview](./plan.md)
- [Phase 2: Screenshot Capture](./phase-02-screenshot-capture.md)
- [Research: SwiftUI Image Editing](./research/research-02-swiftui-image-editing.md)

## Overview
**Date**: 2025-12-05  
**Priority**: Critical  
**Status**: Pending  
**Description**: Core editor view, rendering pipeline, state management, basic editing controls

## Key Insights
- Core Graphics for image manipulation
- Core Image for effects (shadows, filters)
- SwiftUI Canvas for annotations layer
- Layered rendering: background → screenshot → effects → annotations
- Async rendering for performance

## Requirements

### Functional
- Display captured screenshot in editor
- Adjust padding (spacing around screenshot)
- Adjust corner radius
- Adjust drop shadow (color, blur, offset)
- Real-time preview of changes
- Undo/redo support

### Non-Functional
- Smooth preview updates (60 FPS)
- Efficient memory usage
- Support large images (4K+)
- Background rendering for export

## Architecture

**EditorViewModel**:
- `@Published var screenshot: CGImage?`
- `@Published var padding: CGFloat`
- `@Published var cornerRadius: CGFloat`
- `@Published var shadowColor: Color`
- `@Published var shadowBlur: CGFloat`
- `@Published var shadowOffset: CGSize`
- Undo/redo stack

**ImageRenderer**:
- `renderFinalImage() async -> NSImage?`
- Layered composition: background → screenshot → effects → annotations
- Core Graphics rendering pipeline
- Core Image for effects

**EditorView**:
- Main editor interface
- Toolbar with controls
- Canvas preview area
- Control panels (padding, corners, shadow)

## Related Code Files

### Create
- `ScreenshotApp/Views/EditorView.swift`
- `ScreenshotApp/ViewModels/EditorViewModel.swift`
- `ScreenshotApp/Services/ImageRenderer.swift`
- `ScreenshotApp/Models/EditorState.swift` (update)

### Modify
- `ScreenshotApp/Views/ContentView.swift` (navigate to editor)

## Implementation Steps

1. **Update EditorState Model**
   - Add properties: padding, cornerRadius, shadowColor, shadowBlur, shadowOffset
   - Add undo/redo stack structure

2. **Create EditorViewModel**
   - Initialize with captured screenshot
   - Published properties for all editor state
   - Methods: `updatePadding()`, `updateCornerRadius()`, `updateShadow()`
   - Undo/redo implementation
   - State persistence (optional)

3. **Create ImageRenderer Service**
   - `renderFinalImage(state: EditorState, background: Background, annotations: [Annotation]) async -> NSImage?`
   - Create `CGContext` with final dimensions
   - Render background layer (gradient or image)
   - Calculate screenshot position with padding
   - Apply corner radius mask
   - Apply drop shadow (Core Image or CGContext)
   - Composite annotations (placeholder for now)
   - Export to `NSImage`

4. **Create EditorView**
   - Toolbar at top: tool selection, controls
   - Canvas area: preview of edited image
   - Control panels: padding slider, corner radius slider, shadow controls
   - Real-time preview updates
   - Background selection UI (placeholder)

5. **Implement Padding Control**
   - Slider: 0-100 pixels (or percentage)
   - Real-time preview update
   - Recalculate screenshot position

6. **Implement Corner Radius Control**
   - Slider: 0-50 pixels
   - Apply via `CGContext.clip(to:roundedRect:)`
   - Real-time preview

7. **Implement Drop Shadow**
   - Color picker for shadow color
   - Blur slider: 0-50 pixels
   - Offset controls: X and Y sliders
   - Use Core Image `CIShadowBlur` or CGContext shadow
   - Real-time preview

8. **Add Undo/Redo**
   - Command pattern for state changes
   - Stack-based undo/redo
   - Keyboard shortcuts: Cmd+Z, Cmd+Shift+Z
   - Limit stack size (e.g., 50 operations)

9. **Update ContentView Navigation**
   - After capture, navigate to EditorView
   - Pass captured image to editor
   - Back button to return to capture

10. **Performance Optimization**
    - Debounce preview updates (100ms)
    - Render on background queue
    - Cache intermediate results
    - Lazy load preview

## Todo List
- [ ] Update EditorState model
- [ ] Create EditorViewModel
- [ ] Create ImageRenderer service
- [ ] Create EditorView UI
- [ ] Implement padding control
- [ ] Implement corner radius control
- [ ] Implement drop shadow controls
- [ ] Add undo/redo functionality
- [ ] Update ContentView navigation
- [ ] Optimize preview performance
- [ ] Test all controls work correctly

## Success Criteria
- Editor displays captured screenshot
- Padding slider adjusts spacing correctly
- Corner radius slider rounds corners
- Shadow controls (color, blur, offset) work
- Real-time preview updates smoothly
- Undo/redo works for all operations
- Performance is smooth (60 FPS preview)
- Handles large images without lag

## Risk Assessment
- **Performance**: Complex rendering may lag → Use background queue, debounce
- **Memory**: Large images consume memory → Release promptly, use autoreleasepool
- **Preview quality**: High-res preview may be slow → Render at display resolution

## Security Considerations
- Validate all input values (prevent negative, extreme values)
- Handle memory pressure gracefully
- Don't leak image data

## Next Steps
- Proceed to Phase 4: Background System

