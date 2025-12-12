# Research Report: macOS Screenshot Capture APIs

## Executive Summary

macOS provides robust native APIs for screenshot capture via Core Graphics framework. Three capture modes required: region selection (drag & drop), fullscreen, and specific window. Primary APIs: `CGWindowListCreateImage`, `CGDisplayCreateImage`, and `CGWindowListCopyWindowInfo`. Region selection requires custom overlay window with mouse tracking. Window capture needs accessibility permissions.

## Research Methodology
- Sources: Apple Developer Documentation, GitHub repositories, technical articles
- Key search terms: CGWindowListCreateImage, macOS screenshot Swift, window capture API
- Date: December 2024

## Key Findings

### 1. Core Graphics APIs

**CGWindowListCreateImage** (Window/Region Capture):
- Captures specific windows or screen regions
- Parameters: window ID, screen bounds, image options
- Returns `CGImage?` for further processing
- Requires screen recording permission (macOS 10.15+)

**CGDisplayCreateImage** (Fullscreen):
- Captures entire display content
- Direct access to display buffer
- Fastest method for fullscreen capture
- Returns `CGImage?`

**CGWindowListCopyWindowInfo** (Window Enumeration):
- Lists all available windows
- Provides window metadata (bounds, owner, layer)
- Required for window selection UI
- Needs accessibility permissions

### 2. Region Selection Implementation

**Custom Overlay Approach**:
- Create transparent fullscreen window
- Track mouse drag events to define selection rectangle
- Use `NSWindow` with `.borderless` style
- Capture selected region using `CGWindowListCreateImage` with calculated bounds

**Alternative: screencapture CLI**:
- Can invoke system tool programmatically
- Less control, requires Process/Shell execution
- Not recommended for native app experience

### 3. Permission Requirements

**Screen Recording Permission** (macOS 10.15+):
- Required for `CGWindowListCreateImage`
- Request via `CGRequestScreenCaptureAccess()`
- User must grant in System Preferences > Security & Privacy

**Accessibility Permission**:
- Required for window enumeration
- Request via `AXIsProcessTrusted()`
- Needed for window selection feature

### 4. Best Practices

- Request permissions early in app lifecycle
- Provide clear permission request dialogs
- Handle permission denial gracefully
- Use async/await for capture operations (avoid blocking UI)
- Cache window list to reduce enumeration overhead
- Support multiple displays (use `NSScreen` for bounds)

### 5. Performance Considerations

- `CGDisplayCreateImage` is fastest (direct buffer access)
- Window capture slower (requires compositing)
- Region capture performance depends on selection size
- Consider background queue for capture operations
- Cache captured images for editor preview

## Implementation Recommendations

1. **Capture Service Architecture**:
   - Separate `ScreenshotCaptureService` class
   - Async methods returning `CGImage?`
   - Error handling for permission failures
   - Support cancellation for long operations

2. **Region Selection UI**:
   - Transparent overlay window with selection rectangle
   - Visual feedback (marching ants, coordinates)
   - Keyboard shortcuts (ESC to cancel, Enter to confirm)
   - Support for multiple displays

3. **Window Selection**:
   - List windows with thumbnails
   - Highlight on hover
   - Click to select
   - Show window title and app name

## Security Considerations

- Screen recording permission is sensitive (privacy)
- Never capture without explicit user action
- Don't store captured images without user consent
- Clear clipboard after copy operation (optional)
- Handle permission revocation gracefully

## References

- Apple Developer: Core Graphics Window Services
- GitHub: ScreenshotSwiftUI package (reference implementation)
- Medium: "How to take a screenshot from a macOS app using Swift"

## Unresolved Questions

None identified. APIs are well-documented and stable.

