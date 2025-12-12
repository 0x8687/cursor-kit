# Debug Report: Region Capture Error

**Date**: 2025-12-05  
**Issue**: Failed to capture region: the operation couldn't be completed ScreenshotApp.CaptureError error 1  
**Severity**: Runtime Error  
**Status**: Root Cause Identified

## Executive Summary

Region capture fails with `CaptureError.captureFailed` (error code 1) due to coordinate system mismatch and incorrect `SCStreamConfiguration` setup for region capture.

**Root Cause**: 
1. `sourceRect` in `SCStreamConfiguration` expects display-relative coordinates, but bounds from overlay are in screen coordinates
2. Width/height configuration conflicts with `sourceRect` - should use one or the other
3. Missing coordinate system conversion from screen space to display space

**Impact**: Region capture doesn't work, users can't capture selected areas.

**Solution**: Fix coordinate conversion and correct `SCStreamConfiguration` setup for region capture.

## Technical Analysis

### Problem Location

**File**: `ScreenshotApp/Services/ScreenCaptureKitService.swift`  
**Function**: `captureRegion(bounds: CGRect)`  
**Line**: 19-54

### Problematic Code

```swift
static func captureRegion(bounds: CGRect) async throws -> CGImage? {
    // ...
    let config = SCStreamConfiguration()
    config.width = Int(bounds.width)
    config.height = Int(bounds.height)
    config.sourceRect = bounds  // ❌ Wrong coordinate system
    // ...
}
```

### Root Cause

1. **Coordinate System Mismatch**:
   - `bounds` from `CaptureOverlayView` are in screen coordinates (origin at top-left of screen)
   - `sourceRect` in `SCStreamConfiguration` expects display-relative coordinates (origin at top-left of display)
   - On multi-display setups, screen coordinates ≠ display coordinates

2. **Configuration Conflict**:
   - Setting both `width/height` and `sourceRect` can cause conflicts
   - For region capture, should use `sourceRect` to define area, then crop the result
   - Or capture full display and crop in post-processing

3. **Missing Display Selection**:
   - Code uses `content.displays.first` which might not be the display containing the region
   - Should find the display that contains the bounds

### Error Flow

1. User selects region in `CaptureOverlayView` → bounds in screen coordinates
2. `captureRegion(bounds:)` called with screen coordinates
3. `SCStreamConfiguration.sourceRect` set with wrong coordinates
4. ScreenCaptureKit fails to create stream → `CaptureError.captureFailed`
5. Error message shows "error 1" (second enum case, 0-indexed)

## Solution

### Option 1: Capture Full Display, Crop After (Recommended)

Capture the entire display, then crop to the requested region:

```swift
static func captureRegion(bounds: CGRect) async throws -> CGImage? {
    let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
    
    // Find display containing the bounds
    guard let display = findDisplayContaining(bounds, in: content.displays) else {
        throw CaptureError.captureFailed
    }
    
    let filter = SCContentFilter(display: display, excludingWindows: [])
    
    let config = SCStreamConfiguration()
    config.width = Int(display.width)
    config.height = Int(display.height)
    config.showsCursor = false
    config.queueDepth = 5
    
    let output = CaptureOutput()
    let stream = SCStream(filter: filter, configuration: config, delegate: nil)
    try await stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: .global(qos: .userInitiated))
    
    try await stream.startCapture()
    let fullImage = try await output.waitForFrame()
    try await stream.stopCapture()
    
    // Convert bounds from screen to display coordinates
    let displayBounds = convertToDisplayCoordinates(bounds, display: display)
    
    // Crop to region
    guard let croppedImage = fullImage.cropping(to: displayBounds) else {
        throw CaptureError.captureFailed
    }
    
    return croppedImage
}
```

### Option 2: Use Correct sourceRect (Alternative)

Convert coordinates properly and use `sourceRect`:

```swift
// Convert screen coordinates to display coordinates
let displayBounds = convertToDisplayCoordinates(bounds, display: display)

let config = SCStreamConfiguration()
config.width = Int(displayBounds.width)
config.height = Int(displayBounds.height)
config.sourceRect = displayBounds  // Now in correct coordinate system
```

### Helper Functions Needed

```swift
private static func findDisplayContaining(_ rect: CGRect, in displays: [SCDisplay]) -> SCDisplay? {
    // Find display that contains the center of the rect
    let center = CGPoint(x: rect.midX, y: rect.midY)
    return displays.first { display in
        let displayFrame = display.frame
        return displayFrame.contains(center)
    }
}

private static func convertToDisplayCoordinates(_ screenRect: CGRect, display: SCDisplay) -> CGRect {
    let displayFrame = display.frame
    return CGRect(
        x: screenRect.origin.x - displayFrame.origin.x,
        y: screenRect.origin.y - displayFrame.origin.y,
        width: screenRect.width,
        height: screenRect.height
    )
}
```

## Implementation

**Recommended Approach**: Option 1 (capture full, crop after) is more reliable because:
- Avoids coordinate system issues
- Works consistently across multi-display setups
- Easier to debug
- Performance impact is minimal for typical regions

## Testing

After fix:
- [ ] Region capture works on single display
- [ ] Region capture works on multi-display setups
- [ ] Region capture works with different screen resolutions
- [ ] Error messages are clear if capture fails
- [ ] Performance is acceptable

## Additional Notes

- ScreenCaptureKit coordinate system: origin at top-left of each display
- Screen coordinate system: origin at top-left of primary display
- On multi-display: secondary displays have negative or offset coordinates
- Always validate bounds before capture
- Consider adding bounds validation (min size, within display bounds)

---

**Report Generated By**: Debugger Agent  
**Date**: 2025-12-05

