# ScreenCaptureKit Migration Notes

## Overview

The app has been migrated from deprecated `CGWindowListCreateImage` to `ScreenCaptureKit` framework to ensure compatibility with macOS 15.0+.

## Changes Made

### 1. New Service: ScreenCaptureKitService

Created `ScreenshotApp/Services/ScreenCaptureKitService.swift`:
- Implements all capture operations using ScreenCaptureKit
- Handles region, fullscreen, and window capture
- Window enumeration using `SCShareableContent`
- Stream-based capture with proper lifecycle management

### 2. Updated ScreenshotCaptureService

Modified `ScreenshotApp/Services/ScreenshotCaptureService.swift`:
- Now delegates to `ScreenCaptureKitService` on macOS 12.3+
- Maintains same public API (no breaking changes)
- Includes fallback for older versions (though minimum is 12.3+)

### 3. Key Differences

**Old API (CGWindowListCreateImage)**:
- Synchronous, direct capture
- Simple API
- Deprecated in macOS 15.0

**New API (ScreenCaptureKit)**:
- Async, stream-based
- More complex but more powerful
- Hardware-accelerated
- Future-proof

## Implementation Details

### Capture Flow

1. **Get Shareable Content**: `SCShareableContent.excludingDesktopWindows()`
2. **Create Content Filter**: `SCContentFilter` for display/window
3. **Configure Stream**: `SCStreamConfiguration` with dimensions
4. **Create Stream**: `SCStream` with filter and config
5. **Add Output**: `CaptureOutput` handler for frames
6. **Start Capture**: `stream.startCapture()`
7. **Wait for Frame**: Async continuation receives `CGImage`
8. **Stop Capture**: `stream.stopCapture()`

### CaptureOutput Handler

- Implements `SCStreamOutput` protocol
- Receives `CMSampleBuffer` frames
- Converts to `CGImage` using Core Image
- Resumes async continuation with result
- Handles single frame capture (stops after first frame)

## Testing Checklist

- [ ] Region capture works correctly
- [ ] Fullscreen capture works correctly
- [ ] Window capture works correctly
- [ ] Window enumeration lists all windows
- [ ] Window thumbnails generate correctly
- [ ] Permissions are handled correctly
- [ ] Performance is acceptable
- [ ] Memory usage is reasonable
- [ ] Stream cleanup works properly

## Known Issues / Limitations

1. **Region Capture**: Currently captures from first display only. Multi-display support may need enhancement.

2. **Window Thumbnails**: Generated sequentially in parallel tasks. Could be optimized with better batching.

3. **Stream Lifecycle**: Ensure streams are properly stopped even on errors. Current implementation should handle this, but needs testing.

4. **Performance**: First capture may be slower due to stream setup. Subsequent captures should be faster.

## Future Improvements

1. **Multi-Display Support**: Handle region capture across multiple displays
2. **Thumbnail Caching**: Cache window thumbnails to improve enumeration performance
3. **Stream Reuse**: Reuse streams for multiple captures (if beneficial)
4. **Error Recovery**: Better error handling and recovery for stream failures

## References

- [Apple ScreenCaptureKit Documentation](https://developer.apple.com/documentation/screencapturekit)
- [WWDC22: ScreenCaptureKit Session](https://developer.apple.com/videos/play/wwdc2022/10156/)

