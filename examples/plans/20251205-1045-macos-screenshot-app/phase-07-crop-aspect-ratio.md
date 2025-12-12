# Phase 7: Crop & Aspect Ratio

## Context Links
- [Plan Overview](./plan.md)
- [Phase 3: Image Editor Core](./phase-03-image-editor-core.md)
- [Research: SwiftUI Image Editing](./research/research-02-swiftui-image-editing.md)

## Overview
**Date**: 2025-12-05  
**Priority**: Medium  
**Status**: Pending  
**Description**: Crop tool, aspect ratio selection, padding respect in both directions

## Key Insights
- Crop must respect background padding
- Aspect ratio changes require recalculation
- Padding percentage maintained, not absolute pixels
- Crop rectangle UI with drag handles
- `CGImage.cropping(to:)` for actual crop

## Requirements

### Functional
- Crop tool: Select area to keep
- Aspect ratio presets (1:1, 16:9, 4:3, etc.)
- Custom aspect ratio input
- Maintain padding when aspect ratio changes
- Padding respected in both vertical and horizontal
- Visual crop rectangle with handles
- Preview crop area

### Non-Functional
- Smooth crop rectangle manipulation
- Accurate crop bounds
- Handle edge cases (crop larger than image)

## Architecture

**CropState**:
- `isActive: Bool`
- `cropRect: CGRect`
- `aspectRatio: CGFloat?` (nil for freeform)
- `padding: CGFloat` (percentage)

**CropOverlayView**:
- Crop rectangle visualization
- Drag handles (corners, edges)
- Constrain to aspect ratio if set
- Visual feedback

**AspectRatioPicker**:
- Preset ratios (1:1, 16:9, 4:3, 21:9, 9:16, custom)
- Display ratio labels
- Custom ratio input

## Related Code Files

### Create
- `ScreenshotApp/Models/CropState.swift`
- `ScreenshotApp/Views/CropOverlayView.swift`
- `ScreenshotApp/Views/AspectRatioPicker.swift`

### Modify
- `ScreenshotApp/ViewModels/EditorViewModel.swift` (add crop state)
- `ScreenshotApp/Services/ImageRenderer.swift` (apply crop)
- `ScreenshotApp/Views/EditorView.swift` (add crop UI)

## Implementation Steps

1. **Create CropState Model**
   - Properties from architecture
   - Methods: `applyCrop()`, `resetCrop()`

2. **Create CropOverlayView**
   - Overlay on preview canvas
   - Draw crop rectangle
   - Corner and edge drag handles
   - Constrain to aspect ratio if set
   - Visual feedback (marching ants, dimmed area)

3. **Create AspectRatioPicker**
   - Grid of preset ratios
   - Custom ratio input field
   - Display ratio labels (e.g., "16:9")
   - Selection highlight

4. **Update EditorViewModel**
   - `@Published var cropState: CropState`
   - `@Published var selectedAspectRatio: CGFloat?`
   - Methods: `startCrop()`, `updateCropRect()`, `applyCrop()`, `cancelCrop()`
   - Recalculate padding when aspect ratio changes

5. **Implement Crop Rectangle Manipulation**
   - Track drag start point
   - Calculate crop rectangle from drag
   - Constrain to aspect ratio if set
   - Update crop state
   - Show preview

6. **Implement Aspect Ratio Constraint**
   - When ratio selected, constrain crop rectangle
   - Maintain ratio while dragging
   - Update crop rectangle when ratio changes

7. **Implement Padding Respect**
   - Calculate padding as percentage of dimensions
   - When aspect ratio changes:
     - Calculate new canvas size
     - Maintain padding percentage
     - Recalculate screenshot position
     - Update crop bounds

8. **Apply Crop to Image**
   - Use `CGImage.cropping(to:)` for actual crop
   - Update screenshot image
   - Reset crop state
   - Update preview

9. **Integrate with ImageRenderer**
   - Apply crop before rendering
   - Recalculate final canvas size
   - Maintain padding in both directions

10. **Update EditorView**
    - Add crop tool button
    - Show CropOverlayView when crop active
    - Show AspectRatioPicker
    - Handle crop flow

11. **Handle Edge Cases**
    - Crop larger than image → Clamp to image bounds
    - Crop outside image → Show error
    - Invalid aspect ratio → Validate input

12. **Add Keyboard Shortcuts**
    - C: Toggle crop tool
    - Enter: Apply crop
    - ESC: Cancel crop

## Todo List
- [ ] Create CropState model
- [ ] Create CropOverlayView
- [ ] Create AspectRatioPicker
- [ ] Update EditorViewModel
- [ ] Implement crop rectangle manipulation
- [ ] Implement aspect ratio constraint
- [ ] Implement padding respect
- [ ] Apply crop to image
- [ ] Integrate with ImageRenderer
- [ ] Update EditorView
- [ ] Handle edge cases
- [ ] Add keyboard shortcuts
- [ ] Test crop functionality
- [ ] Test aspect ratio changes
- [ ] Test padding respect

## Success Criteria
- Crop tool selects area correctly
- Crop rectangle can be moved and resized
- Aspect ratio presets work
- Custom aspect ratio works
- Padding maintained when ratio changes
- Padding respected in both directions
- Crop applies correctly to image
- Visual feedback is clear
- Edge cases handled gracefully

## Risk Assessment
- **Padding calculation**: Complex math → Test thoroughly, use helper functions
- **Aspect ratio constraint**: May feel restrictive → Provide freeform option
- **Crop bounds**: May go outside image → Validate and clamp

## Security Considerations
- Validate crop bounds
- Validate aspect ratio input
- Prevent division by zero in calculations

## Next Steps
- Proceed to Phase 8: Export & Save

