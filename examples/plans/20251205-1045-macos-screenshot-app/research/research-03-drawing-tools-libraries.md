# Research Report: Drawing Tools & Libraries for SwiftUI

## Executive Summary

SwiftUI `Canvas` and `Path` APIs sufficient for basic drawing (arrows, rectangles, ellipses, lines). No external libraries required for core functionality. For advanced features: consider `PencilKit` (Apple's drawing framework) or custom `Path` builders. Text tool: use `NSAttributedString` + Core Text. Shape manipulation: implement custom gesture handlers for move/resize/rotate.

## Research Methodology
- Sources: Apple Developer docs, SwiftUI examples, GitHub repositories
- Key terms: SwiftUI Canvas drawing, PencilKit, Path manipulation, annotation tools
- Date: December 2024

## Key Findings

### 1. Native SwiftUI Drawing

**Canvas + Path**:
- `Path` for shapes (rectangles, ellipses, lines, custom)
- `Canvas` for rendering
- Gesture support for interactive editing
- No external dependencies

**Shape Types**:
- **Arrow**: Custom `Path` with triangle head + line body
- **Rectangle**: `Path(rect:)` or `RoundedRectangle`
- **Ellipse**: `Path(ellipseIn:)` or `Ellipse`
- **Line**: `Path` with `move(to:)` and `line(to:)`

**Implementation Pattern**:
```swift
struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Draw arrow
        return path
    }
}
```

### 2. PencilKit (macOS 13+)

**Capabilities**:
- Advanced drawing engine (pressure sensitivity)
- Built-in tools (pen, marker, eraser)
- Overkill for screenshot annotations
- Better for freehand drawing apps

**Verdict**: Not needed for this use case (arrows, shapes, text).

### 3. Annotation Tool Architecture

**Tool Selection**:
- Enum: `Tool.arrow`, `Tool.rectangle`, `Tool.ellipse`, `Tool.line`, `Tool.text`
- State management via `@State` or ViewModel
- Toolbar UI for selection

**Shape Manipulation**:
- **Move**: `DragGesture` on shape
- **Resize**: Corner/edge drag handles
- **Rotate**: Rotation gesture (optional, not required)
- **Delete**: Context menu or keyboard shortcut

**Color & Style**:
- SwiftUI `Color` picker
- Stroke width slider
- Fill/stroke toggle
- Border style (solid, dashed)

### 4. Arrow Implementation

**Custom Path Builder**:
```swift
func createArrowPath(start: CGPoint, end: CGPoint, headSize: CGFloat) -> Path {
    // Calculate arrow head triangle
    // Draw line from start to end
    // Draw triangle at end point
}
```

**Variations**:
- Single-headed (default)
- Double-headed (optional)
- Curved arrow (bezier path)

### 5. Text Tool

**Implementation**:
- `TextField` overlay for text input
- `NSAttributedString` for styling
- Render to `CGContext` for export
- Support: color, font, size, alignment, border

**Text Editing**:
- Double-click to edit
- Drag to move
- Resize via corner handles
- Alignment: left, center, right

**Rendering**:
- Use Core Text (`CTFrameDraw`) for final export
- SwiftUI `Text` for preview only

### 6. Drawing State Management

**Annotation Model**:
```swift
struct Annotation: Identifiable {
    let id: UUID
    let type: AnnotationType
    var frame: CGRect
    var color: Color
    var strokeWidth: CGFloat
    // Type-specific properties
}
```

**ViewModel**:
- Array of `Annotation` objects
- Current tool selection
- Selected annotation (for editing)
- Undo/redo stack

### 7. Gesture Handling

**Multi-Gesture Support**:
- `DragGesture` for move/resize
- `TapGesture` for selection
- `MagnificationGesture` for zoom (optional)
- Combine gestures with `.simultaneously(with:)`

**Hit Testing**:
- Check if tap point intersects annotation
- Select annotation on tap
- Show selection handles
- Enable drag for selected annotation

## Implementation Recommendations

1. **Tool System**:
   - `Tool` enum with associated values
   - Toolbar with icon buttons
   - Visual feedback for active tool
   - Keyboard shortcuts (A=arrow, R=rectangle, etc.)

2. **Annotation Layer**:
   - Separate `ZStack` layer for annotations
   - Render above screenshot, below UI controls
   - Support z-ordering (bring to front/back)

3. **Shape Rendering**:
   - Use `Canvas` for real-time preview
   - Convert to `Path` for final export
   - Cache rendered shapes for performance

4. **Text Rendering**:
   - Overlay `TextField` during editing
   - Convert to `NSAttributedString` when committed
   - Render via Core Text in final export

5. **Undo/Redo**:
   - Implement command pattern
   - Store annotation state changes
   - Support keyboard shortcuts (Cmd+Z, Cmd+Shift+Z)

## Security Considerations

- Validate annotation bounds (prevent off-screen)
- Limit maximum annotation count (performance)
- Sanitize text input (prevent injection)

## References

- Apple: SwiftUI Canvas documentation
- Apple: Path and Shape protocols
- GitHub: SwiftUI drawing examples

## Unresolved Questions

None. Native SwiftUI sufficient for requirements.

