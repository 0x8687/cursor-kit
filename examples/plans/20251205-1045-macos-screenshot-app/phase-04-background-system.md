# Phase 4: Background System

## Context Links
- [Plan Overview](./plan.md)
- [Phase 3: Image Editor Core](./phase-03-image-editor-core.md)
- [Research: Gradient Libraries](./research/research-04-gradient-libraries.md)

## Overview
**Date**: 2025-12-05  
**Priority**: High  
**Status**: Pending  
**Description**: Gradient gallery, custom image upload, background rendering integration

## Key Insights
- SwiftUI `LinearGradient` sufficient, no external libs
- Curate 20-30 trending gradients
- FileImporter for custom image upload
- Background renders as base layer in composition
- Padding calculation must account for background

## Requirements

### Functional
- Gallery of 20-30 trending gradient presets
- Custom image upload via file picker
- Preview swatches in grid layout
- Background renders behind screenshot
- Padding reveals background around screenshot

### Non-Functional
- Fast gradient rendering
- Support common image formats (PNG, JPEG, HEIC)
- Validate uploaded images (size, format)
- Cache gradient swatches

## Architecture

**GradientPreset Model**:
- `id: UUID`
- `name: String`
- `colors: [Color]`
- `type: GradientType` (linear, radial)
- `startPoint: UnitPoint`
- `endPoint: UnitPoint`

**BackgroundManager**:
- `gradientPresets: [GradientPreset]`
- `selectedBackground: Background`
- `uploadCustomImage(url: URL) -> Bool`

**BackgroundGalleryView**:
- Grid of gradient swatches
- "Custom" option for upload
- Selection feedback
- Search/filter (optional)

## Related Code Files

### Create
- `ScreenshotApp/Models/GradientPreset.swift` (update)
- `ScreenshotApp/Models/Background.swift`
- `ScreenshotApp/Services/BackgroundManager.swift`
- `ScreenshotApp/Views/BackgroundGalleryView.swift`

### Modify
- `ScreenshotApp/Services/ImageRenderer.swift` (add background rendering)
- `ScreenshotApp/Views/EditorView.swift` (add background selection UI)

## Implementation Steps

1. **Create Background Model**
   - `Background.swift`: Enum (gradient, image)
   - Associated values for gradient/image data

2. **Update GradientPreset Model**
   - Add all properties from architecture
   - Create 20-30 preset gradients (trending colors)
   - Organize by category (Vibrant, Soft, Dark, Neutral, Bold)

3. **Create BackgroundManager Service**
   - Initialize with gradient presets
   - `selectGradient(_ preset: GradientPreset)`
   - `uploadCustomImage(url: URL) async throws -> Bool`
   - Validate image (size, format)
   - Store uploaded images in app support directory
   - `selectedBackground: Background` property

4. **Create BackgroundGalleryView**
   - `LazyVGrid` with 3-4 columns
   - Display gradient swatches (rounded rectangles)
   - Show gradient name (optional)
   - "Custom" button for image upload
   - Selection highlight
   - Tap to select

5. **Integrate with ImageRenderer**
   - Update `renderFinalImage()` to render background first
   - Render gradient via `LinearGradient` or `AngularGradient`
   - Render uploaded image if selected
   - Calculate final canvas size (screenshot + padding)

6. **Add Background Selection to EditorView**
   - Button to open background gallery
   - Sheet/popover with `BackgroundGalleryView`
   - Display selected background preview
   - Update `EditorViewModel` with background selection

7. **Implement Custom Image Upload**
   - Use `.fileImporter()` modifier
   - Filter: images only
   - Validate file size (max 10MB)
   - Validate format (PNG, JPEG, HEIC)
   - Load and store image
   - Update background selection

8. **Update Padding Calculation**
   - Padding reveals background around screenshot
   - Recalculate when background changes
   - Maintain aspect ratio considerations

9. **Add Gradient Categories** (Optional)
   - Organize presets by category
   - Filter by category in gallery
   - Search functionality (optional)

10. **Performance Optimization**
    - Pre-render gradient swatches
    - Cache uploaded images
    - Lazy load gallery thumbnails

## Todo List
- [ ] Create Background model
- [ ] Update GradientPreset with presets
- [ ] Create BackgroundManager service
- [ ] Create BackgroundGalleryView
- [ ] Integrate background rendering
- [ ] Add background selection UI to EditorView
- [ ] Implement custom image upload
- [ ] Update padding calculation
- [ ] Add gradient categories (optional)
- [ ] Optimize performance
- [ ] Test all background options

## Success Criteria
- Gallery displays 20-30 gradient presets
- Gradients render correctly as backgrounds
- Custom image upload works
- Background appears behind screenshot with padding
- Selection updates preview in real-time
- Handles invalid image files gracefully
- Performance is smooth

## Risk Assessment
- **Large images**: May cause memory issues → Validate size, resize if needed
- **Invalid formats**: User may upload unsupported format → Validate, show error
- **File permissions**: May not access selected file → Handle gracefully

## Security Considerations
- Validate uploaded image formats
- Limit file size (10MB max)
- Sanitize file paths
- Handle corrupted images gracefully
- Don't store images without user consent

## Next Steps
- Proceed to Phase 5: Annotation Tools

