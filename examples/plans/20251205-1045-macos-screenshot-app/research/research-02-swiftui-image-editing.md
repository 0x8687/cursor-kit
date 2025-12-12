# Research Report: SwiftUI Image Editing & Canvas Capabilities

## Executive Summary

SwiftUI provides `Canvas` view for drawing operations, but complex image editing requires Core Graphics (`CGContext`). For screenshot editor: use `Canvas` for annotations (arrows, shapes, text), `CGContext` for image manipulation (crop, resize, effects). Combine both: render screenshot to `NSImage`, apply Core Graphics filters, then overlay annotations via Canvas. Core Image (`CIFilter`) for advanced effects (shadows, blur).

## Research Methodology
- Sources: Apple SwiftUI docs, Core Graphics reference, GitHub examples
- Key terms: SwiftUI Canvas, Core Graphics image editing, NSImage manipulation
- Date: December 2024

## Key Findings

### 1. SwiftUI Canvas (iOS 15+, macOS 12+)

**Capabilities**:
- 2D drawing with `Path` and `CGContext`
- Real-time rendering
- Gesture support for interactive drawing
- Good for annotations (arrows, shapes, lines)

**Limitations**:
- Not ideal for complex image manipulation
- No direct image filtering
- Performance issues with large images
- Limited text rendering control

**Usage Pattern**:
```swift
Canvas { context, size in
    // Draw paths, shapes, text
    context.stroke(path, with: .color(.red))
}
```

### 2. Core Graphics (CGContext)

**Image Manipulation**:
- Crop, resize, rotate via `CGContext.draw()`
- Apply transforms and clipping
- Create new images from existing
- Essential for screenshot editing pipeline

**Rendering Pipeline**:
1. Create `CGContext` with desired size
2. Draw background (gradient/image)
3. Draw screenshot with padding/transform
4. Apply effects (shadow, corner radius)
5. Export to `NSImage` or `CGImage`

### 3. Core Image (CIFilter)

**Advanced Effects**:
- Drop shadows: `CIShadowBlur`, `CIColorMatrix`
- Corner radius: `CIRoundedRectangleGenerator` + compositing
- Blur, color adjustments
- High performance (GPU-accelerated)

**Integration**:
- Convert `CGImage` → `CIImage` → apply filters → `CGImage`
- Use `CIContext` for rendering

### 4. Image Composition Strategy

**Layered Approach**:
1. **Background Layer**: Gradient or uploaded image
2. **Screenshot Layer**: Original capture with padding
3. **Annotation Layer**: Canvas-drawn elements (arrows, shapes, text)
4. **Effect Layer**: Shadows, corner radius (via Core Image)

**Rendering Order**:
- Render background to `CGContext`
- Apply padding calculation
- Draw screenshot with corner radius mask
- Apply drop shadow (Core Image or CGContext)
- Composite annotations on top
- Export final image

### 5. Text Rendering

**Options**:
- SwiftUI `Text` view (limited styling)
- Core Text (`CTFrame`, `CTLine`) for advanced control
- `NSAttributedString` for rich text
- Canvas text rendering (basic)

**For Editor**:
- Use `NSAttributedString` for text tool
- Render to `CGContext` for final export
- Support color, font, alignment, border

### 6. Crop Implementation

**Approaches**:
1. **UI Selection**: `GeometryReader` + `DragGesture` for crop rectangle
2. **Image Processing**: `CGImage.cropping(to:)` for actual crop
3. **Aspect Ratio**: Calculate crop bounds respecting ratio + padding

**Padding Consideration**:
- Crop must account for background padding
- Maintain aspect ratio while preserving padding
- Recalculate screenshot position after crop

### 7. Aspect Ratio & Padding

**Challenge**: Maintain padding in both directions when changing aspect ratio.

**Solution**:
- Calculate padding as percentage of dimensions
- When ratio changes, recalculate screenshot size
- Maintain padding percentage, not absolute pixels
- Center screenshot in new canvas size

**Formula**:
```
newWidth = targetRatio * newHeight
screenshotWidth = newWidth - (paddingPercent * 2 * newWidth)
screenshotHeight = newHeight - (paddingPercent * 2 * newHeight)
```

## Implementation Recommendations

1. **Architecture**:
   - `ImageEditorViewModel`: State management
   - `ImageRenderer`: Core Graphics rendering
   - `AnnotationCanvas`: SwiftUI Canvas for drawing
   - `EffectProcessor`: Core Image filters

2. **Rendering Pipeline**:
   - Separate background, screenshot, annotations
   - Use `CGContext` for final composition
   - Cache intermediate results
   - Async rendering for large images

3. **Performance**:
   - Render at display resolution, export at full quality
   - Use background queue for heavy operations
   - Debounce real-time preview updates
   - Lazy load gradient gallery

## Security Considerations

- Validate uploaded background images (size, format)
- Sanitize file paths for save operations
- Handle memory efficiently (large images)

## References

- Apple: SwiftUI Canvas documentation
- Apple: Core Graphics Programming Guide
- GitHub: AppScreenshotKit (reference implementation)
- Andrew Hanshaw: "Rendering Images with SwiftUI"

## Unresolved Questions

None. Core Graphics + SwiftUI Canvas combination is well-established pattern.

