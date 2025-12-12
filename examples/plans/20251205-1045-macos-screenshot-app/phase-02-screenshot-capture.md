# Phase 2: Screenshot Capture Service

## Context Links
- [Plan Overview](./plan.md)
- [Phase 1: Project Setup](./phase-01-project-setup.md)
- [Research: macOS Screenshot APIs](./research/research-01-macos-screenshot-apis.md)

## Overview
**Date**: 2025-12-05  
**Priority**: Critical  
**Status**: Pending  
**Description**: Implement three capture modes: region selection, fullscreen, window selection

## Key Insights
- `CGWindowListCreateImage` for region/window capture
- `CGDisplayCreateImage` for fullscreen (fastest)
- Custom overlay window needed for region selection
- Window enumeration requires accessibility permission
- Async/await for non-blocking capture

## Requirements

### Functional
- Region capture: Drag & drop selection
- Fullscreen capture: Entire screen
- Window capture: Select specific window
- Visual feedback during selection
- Cancel operation (ESC key)

### Non-Functional
- Capture operations < 1 second
- Handle multiple displays
- Support Retina displays
- Memory efficient (release images promptly)

## Architecture

**ScreenshotCaptureService**:
- `captureRegion(bounds: CGRect) async throws -> CGImage?`
- `captureFullscreen() async throws -> CGImage?`
- `captureWindow(windowID: CGWindowID) async throws -> CGImage?`
- `listWindows() async -> [WindowInfo]`

**CaptureOverlayView**:
- Transparent fullscreen window
- Selection rectangle tracking
- Visual feedback (marching ants, coordinates)
- Keyboard shortcuts (ESC, Enter)

**WindowSelectionView**:
- List windows with thumbnails
- Click to select
- Show window title and app name

## Related Code Files

### Create
- `ScreenshotApp/Services/ScreenshotCaptureService.swift`
- `ScreenshotApp/Views/CaptureOverlayView.swift`
- `ScreenshotApp/Views/WindowSelectionView.swift`
- `ScreenshotApp/Models/WindowInfo.swift`

### Modify
- `ScreenshotApp/ViewModels/CaptureViewModel.swift` (new)
- `ScreenshotApp/Views/ContentView.swift` (add capture UI)

## Implementation Steps

1. **Create WindowInfo Model**
   - `WindowInfo.swift`: windowID, title, appName, bounds, thumbnail

2. **Implement ScreenshotCaptureService**
   - Check permissions before capture
   - `captureRegion(bounds:)`: Use `CGWindowListCreateImage` with bounds
   - `captureFullscreen()`: Use `CGDisplayCreateImage` for main display
   - `captureWindow(windowID:)`: Use `CGWindowListCreateImage` with window ID
   - `listWindows()`: Enumerate windows with `CGWindowListCopyWindowInfo`
   - Error handling for permission failures
   - Async/await implementation

3. **Create CaptureOverlayView**
   - Transparent `NSWindow` overlay
   - Track mouse drag for selection rectangle
   - Visual feedback: selection rectangle, coordinates
   - ESC to cancel, Enter to confirm
   - Return selected bounds

4. **Create WindowSelectionView**
   - List windows in grid or list
   - Show window thumbnails (small preview)
   - Display window title and app name
   - Click to select window
   - Return selected window ID

5. **Create CaptureViewModel**
   - State management for capture flow
   - Handle capture mode selection
   - Coordinate between views and service
   - Store captured image

6. **Update ContentView**
   - Add capture mode buttons (Region, Fullscreen, Window)
   - Show capture overlay when region mode selected
   - Show window selection when window mode selected
   - Display captured image preview

7. **Handle Multiple Displays**
   - Detect all screens with `NSScreen.screens`
   - Calculate correct bounds for each display
   - Support region selection across displays

8. **Add Keyboard Shortcuts**
   - Global hotkeys (optional, future enhancement)
   - ESC to cancel, Enter to confirm in overlay

## Todo List
- [ ] Create WindowInfo model
- [ ] Implement ScreenshotCaptureService
- [ ] Create CaptureOverlayView
- [ ] Create WindowSelectionView
- [ ] Create CaptureViewModel
- [ ] Update ContentView with capture UI
- [ ] Handle multiple displays
- [ ] Add keyboard shortcuts
- [ ] Test all three capture modes
- [ ] Test permission handling

## Success Criteria
- Region capture works with drag & drop
- Fullscreen capture captures entire screen
- Window selection lists and captures windows
- Visual feedback appears during selection
- ESC cancels, Enter confirms
- Handles permission denial gracefully
- Works on Retina displays
- Supports multiple displays

## Risk Assessment
- **Performance**: Large screenshots may be slow → Use background queue
- **Permission denial**: User may deny → Show clear error message
- **Window enumeration**: May miss some windows → Test with various apps

## Security Considerations
- Never capture without explicit user action
- Request permissions before capture
- Don't store captured images without user consent
- Clear clipboard after copy (optional)

## Next Steps
- Proceed to Phase 3: Image Editor Core

