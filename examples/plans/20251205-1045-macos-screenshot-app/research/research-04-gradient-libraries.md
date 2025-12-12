# Research Report: Gradient Color Libraries & Background Management

## Executive Summary

SwiftUI `LinearGradient` and `AngularGradient` sufficient for gradient backgrounds. No external libraries needed. For trending gradients: curate predefined color sets (inspired by design trends 2024-2025). Custom image upload: use `NSImage` + `FileImporter`. Gradient gallery: grid of preview swatches. Store gradients as `Gradient` structs or JSON for persistence.

## Research Methodology
- Sources: Design trend articles, SwiftUI documentation, color palette resources
- Key terms: SwiftUI gradients, trending colors 2024, gradient gallery, color palettes
- Date: December 2024

## Key Findings

### 1. SwiftUI Gradient APIs

**LinearGradient**:
- Two or more colors with direction
- Supports stops for multi-color gradients
- High performance, native rendering

**AngularGradient** (Radial):
- Circular/radial gradients
- Center point and radius control
- Good for spotlight effects

**Usage**:
```swift
LinearGradient(
    colors: [.blue, .purple],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### 2. Trending Gradient Colors (2024-2025)

**Popular Palettes**:
- **Vibrant**: Purple-Pink, Blue-Cyan, Orange-Red
- **Soft**: Pastel Pink-Blue, Lavender-Mint, Peach-Cream
- **Dark**: Deep Blue-Purple, Charcoal-Teal, Navy-Gold
- **Neutral**: Beige-Brown, Gray-Blue, Warm White-Cream
- **Bold**: Electric Blue-Green, Magenta-Orange, Yellow-Pink

**Design Trends**:
- Glassmorphism (translucent gradients)
- Neo-brutalism (high contrast)
- Minimalism (subtle, monochromatic)
- Retro (80s/90s color schemes)

### 3. Gradient Gallery Implementation

**Data Structure**:
```swift
struct GradientPreset: Identifiable {
    let id: UUID
    let name: String
    let colors: [Color]
    let type: GradientType // linear, radial
    let startPoint: UnitPoint
    let endPoint: UnitPoint
}
```

**UI Design**:
- Grid layout (3-4 columns)
- Preview swatches (rounded rectangles)
- Name labels (optional)
- Search/filter (optional, for large sets)

**Storage**:
- Hardcode popular gradients in app
- Optional: JSON file for user customization
- User-created gradients in UserDefaults

### 4. Custom Image Upload

**FileImporter** (macOS 11+):
- Native file picker
- Supports common image formats (PNG, JPEG, HEIC)
- Returns `URL` for selected file

**Image Loading**:
```swift
.fileImporter(...) { result in
    if let url = try? result.get() {
        // Load image from URL
        let image = NSImage(contentsOf: url)
    }
}
```

**Image Processing**:
- Validate file size (prevent memory issues)
- Resize if too large (optional)
- Convert to `NSImage` for rendering
- Support transparency (PNG)

### 5. Background Rendering

**Composition**:
- Render gradient/image to `CGContext` as base layer
- Calculate screenshot position with padding
- Composite screenshot on top
- Apply effects (shadow, corner radius)

**Performance**:
- Cache gradient rendering
- Lazy load image thumbnails
- Pre-render popular gradients

### 6. Gradient Editor (Optional Enhancement)

**Features**:
- Color picker for gradient stops
- Add/remove color stops
- Adjust direction (angle/direction handles)
- Preview in real-time

**Implementation**:
- Custom SwiftUI view with color stops
- `ColorPicker` for each stop
- `Slider` for direction angle
- Live preview

## Implementation Recommendations

1. **Gradient Presets**:
   - Create 20-30 trending gradients
   - Organize by category (Vibrant, Soft, Dark, etc.)
   - Include popular combinations from design trends
   - Update periodically (optional)

2. **Gallery UI**:
   - `LazyVGrid` for grid layout
   - Tap to select, visual feedback
   - Search bar (optional, for 30+ gradients)
   - "Custom" option for image upload

3. **Storage**:
   - Hardcode presets in `GradientPreset` array
   - User-uploaded images: store in app's support directory
   - Recent selections: cache in UserDefaults

4. **Performance**:
   - Pre-render gradient swatches
   - Use `AsyncImage` for uploaded images
   - Cache rendered backgrounds

## Security Considerations

- Validate uploaded image formats
- Limit image file size (e.g., 10MB max)
- Sanitize file paths
- Handle corrupted image files gracefully

## References

- Apple: SwiftUI Gradient documentation
- Design trend articles (2024-2025 color palettes)
- Color palette resources (Coolors, Adobe Color)

## Unresolved Questions

None. SwiftUI gradients are sufficient, no external libraries needed.

