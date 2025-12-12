# Phase 5: Annotation Tools

## Context Links
- [Plan Overview](./plan.md)
- [Phase 3: Image Editor Core](./phase-03-image-editor-core.md)
- [Research: Drawing Tools](./research/research-03-drawing-tools-libraries.md)

## Overview
**Date**: 2025-12-05  
**Priority**: High  
**Status**: Pending  
**Description**: Arrows, rectangles, ellipses, lines with manipulation (move, resize, color, delete)

## Key Insights
- SwiftUI `Canvas` + `Path` sufficient, no external libs
- Custom `Path` builders for arrows
- Gesture handlers for move/resize
- Annotation layer renders above screenshot
- State management for annotation array

## Requirements

### Functional
- Arrow tool: Single/double-headed arrows
- Rectangle tool: Rectangles with rounded corners
- Ellipse tool: Circles and ellipses
- Line tool: Straight lines
- Move annotations: Drag to reposition
- Resize annotations: Corner/edge handles
- Change color: Color picker
- Change stroke width: Slider
- Delete annotations: Context menu or Delete key
- Undo/redo support

### Non-Functional
- Smooth drawing (60 FPS)
- Hit testing for selection
- Visual feedback (selection handles)
- Support 100+ annotations

## Architecture

**Annotation Model**:
- `id: UUID`
- `type: AnnotationType` (arrow, rectangle, ellipse, line)
- `frame: CGRect`
- `color: Color`
- `strokeWidth: CGFloat`
- Type-specific properties (start/end points, etc.)

**Tool Enum**:
- `arrow`, `rectangle`, `ellipse`, `line`, `text`, `crop`, `select`

**AnnotationCanvas**:
- SwiftUI `Canvas` view
- Render all annotations
- Handle drawing gestures
- Selection and manipulation

**AnnotationToolbar**:
- Tool selection buttons
- Color picker
- Stroke width slider
- Delete button

## Related Code Files

### Create
- `ScreenshotApp/Models/Annotation.swift` (update)
- `ScreenshotApp/Models/Tool.swift`
- `ScreenshotApp/Views/AnnotationCanvas.swift`
- `ScreenshotApp/Views/AnnotationToolbar.swift`
- `ScreenshotApp/Shapes/ArrowShape.swift`
- `ScreenshotApp/Shapes/LineShape.swift`

### Modify
- `ScreenshotApp/ViewModels/EditorViewModel.swift` (add annotations)
- `ScreenshotApp/Services/ImageRenderer.swift` (render annotations)
- `ScreenshotApp/Views/EditorView.swift` (add annotation UI)

## Implementation Steps

1. **Update Annotation Model**
   - Add all properties from architecture
   - Support different annotation types
   - Type-specific associated values

2. **Create Tool Enum**
   - `Tool.arrow`, `Tool.rectangle`, `Tool.ellipse`, `Tool.line`, etc.
   - Associated values for tool-specific state

3. **Create ArrowShape**
   - Custom `Shape` protocol implementation
   - Calculate arrow head triangle
   - Support single/double-headed
   - `path(in rect: CGRect) -> Path`

4. **Create LineShape**
   - Simple line path
   - Support start/end points
   - Optional arrow heads

5. **Create AnnotationCanvas**
   - SwiftUI `Canvas` view
   - Render annotations array
   - Handle `DragGesture` for drawing
   - Handle `TapGesture` for selection
   - Show selection handles for selected annotation
   - Handle resize gestures on handles

6. **Create AnnotationToolbar**
   - Tool selection buttons (icons)
   - Active tool highlight
   - Color picker (`ColorPicker`)
   - Stroke width slider
   - Delete button (enabled when annotation selected)

7. **Update EditorViewModel**
   - `@Published var annotations: [Annotation]`
   - `@Published var selectedTool: Tool`
   - `@Published var selectedAnnotation: Annotation?`
   - `@Published var annotationColor: Color`
   - `@Published var strokeWidth: CGFloat`
   - Methods: `addAnnotation()`, `deleteAnnotation()`, `updateAnnotation()`
   - Undo/redo for annotation operations

8. **Implement Drawing Logic**
   - Track drag start/end points
   - Create annotation based on tool type
   - Add to annotations array
   - Update preview in real-time

9. **Implement Selection & Manipulation**
   - Hit testing: check if tap intersects annotation
   - Select annotation on tap
   - Show selection handles (corners/edges)
   - Drag to move selected annotation
   - Drag handles to resize
   - Update annotation frame

10. **Integrate with ImageRenderer**
    - Render annotations in final export
    - Convert SwiftUI `Path` to `CGPath`
    - Draw annotations on `CGContext`
    - Respect annotation order (z-index)

11. **Add Keyboard Shortcuts**
    - Delete key: Delete selected annotation
    - Arrow keys: Move selected annotation (optional)
    - Cmd+Z/Cmd+Shift+Z: Undo/redo

12. **Update EditorView**
    - Add `AnnotationToolbar` to toolbar
    - Add `AnnotationCanvas` overlay on preview
    - Coordinate tool selection
    - Show annotation controls

## Todo List
- [ ] Update Annotation model
- [ ] Create Tool enum
- [ ] Create ArrowShape
- [ ] Create LineShape
- [ ] Create AnnotationCanvas
- [ ] Create AnnotationToolbar
- [ ] Update EditorViewModel with annotations
- [ ] Implement drawing logic
- [ ] Implement selection & manipulation
- [ ] Integrate with ImageRenderer
- [ ] Add keyboard shortcuts
- [ ] Update EditorView
- [ ] Test all annotation tools
- [ ] Test manipulation features

## Success Criteria
- All four tools (arrow, rectangle, ellipse, line) work
- Annotations draw correctly
- Move and resize work smoothly
- Color and stroke width changes apply
- Delete removes annotations
- Selection feedback is clear
- Annotations render in final export
- Undo/redo works for annotations
- Performance is smooth (60 FPS)

## Risk Assessment
- **Performance**: Many annotations may lag → Limit to reasonable count, optimize rendering
- **Hit testing**: Complex shapes may be inaccurate → Use bounding box for selection
- **Z-index**: Annotation order matters → Maintain array order

## Security Considerations
- Validate annotation bounds (prevent off-screen)
- Limit maximum annotation count (performance)
- Sanitize color values

## Next Steps
- Proceed to Phase 6: Text Tool

