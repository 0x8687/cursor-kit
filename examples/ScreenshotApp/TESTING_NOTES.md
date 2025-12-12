# Testing Notes - Screenshot App

## Current Implementation Status

### ✅ Completed Phases

**Phase 1: Project Setup**
- Xcode project structure
- Folder organization (Models, Views, ViewModels, Services, Utils)
- Permission management (screen recording, accessibility)
- Basic app entry point

**Phase 2: Screenshot Capture**
- Region capture (drag & drop selection)
- Fullscreen capture
- Window selection and capture
- Permission handling

**Phase 3: Image Editor Core**
- Editor view with split layout (preview + controls)
- Padding adjustment (0-200px)
- Corner radius adjustment (0-50px)
- Drop shadow controls (color, blur, X/Y offset)
- Undo/redo functionality
- Real-time preview with debouncing

**Phase 4: Background System**
- 30 gradient presets (Vibrant, Soft, Dark, Neutral, Bold, Radial)
- Custom image upload
- Background gallery UI
- Background rendering in final image

### ⏳ Pending Phases

- Phase 5: Annotation Tools (arrows, rectangles, ellipses, lines)
- Phase 6: Text Tool
- Phase 7: Crop & Aspect Ratio
- Phase 8: Export & Save
- Phase 9: UI/UX Polish
- Phase 10: Testing
- Phase 11: Code Review
- Phase 12: Documentation

## Setup Instructions

### 1. Create Xcode Project

Since we've created the file structure, you'll need to:

1. Open Xcode
2. Create a new macOS App project
3. Choose SwiftUI interface
4. Set deployment target to macOS 12.0+
5. Copy all files from `ScreenshotApp/` into your Xcode project
6. Ensure folder structure matches:
   ```
   ScreenshotApp/
   ├── App/
   ├── Models/
   ├── Views/
   ├── ViewModels/
   ├── Services/
   ├── Utils/
   └── Shapes/
   ```

### 2. Configure Info.plist

Add these keys to your `Info.plist`:
- `NSScreenCaptureUsageDescription`: "This app needs screen recording permission to capture screenshots."
- `NSAccessibilityUsageDescription`: "This app needs accessibility permission to select windows for capture."

### 3. Build Settings

- Swift Language Version: Swift 6 (or Swift 5.7+)
- Deployment Target: macOS 12.0 or later

## Testing Checklist

### Capture Functionality

- [ ] **Region Capture**
  - Click "Capture Region" button
  - Drag to select area
  - Verify selection rectangle appears
  - Verify coordinates display
  - Verify capture completes and opens editor

- [ ] **Fullscreen Capture**
  - Click "Capture Fullscreen" button
  - Verify entire screen is captured
  - Verify editor opens with captured image

- [ ] **Window Capture**
  - Click "Capture Window" button
  - Verify window selection sheet appears
  - Verify windows are listed with thumbnails
  - Select a window
  - Verify capture completes and opens editor

- [ ] **Permissions**
  - Verify screen recording permission dialog appears
  - Grant permission and verify capture works
  - Deny permission and verify error message appears
  - Verify accessibility permission request for window capture

### Editor Functionality

- [ ] **Padding Control**
  - Adjust padding slider
  - Verify spacing around screenshot changes
  - Verify preview updates smoothly
  - Test min (0px) and max (200px) values

- [ ] **Corner Radius**
  - Adjust corner radius slider
  - Verify corners become rounded
  - Verify preview updates
  - Test min (0px) and max (50px) values

- [ ] **Drop Shadow**
  - Change shadow color
  - Adjust blur slider
  - Adjust X and Y offset sliders
  - Verify shadow appears correctly
  - Verify preview updates

- [ ] **Background Selection**
  - Click "Select Background" button
  - Verify background gallery opens
  - Select a gradient preset
  - Verify background appears behind screenshot
  - Upload a custom image
  - Verify custom image appears as background
  - Clear background and verify it's removed

- [ ] **Undo/Redo**
  - Make several changes
  - Press Cmd+Z to undo
  - Press Cmd+Shift+Z to redo
  - Verify changes are reverted/applied correctly

### Known Issues / Limitations

1. **CaptureOverlayView**: Currently implemented as SwiftUI overlay. For production, should use NSWindow for true fullscreen overlay across all displays.

2. **Annotation Tools**: Not yet implemented (Phase 5)

3. **Text Tool**: Not yet implemented (Phase 6)

4. **Crop Tool**: Not yet implemented (Phase 7)

5. **Export/Save**: Not yet implemented (Phase 8)

6. **Shadow Rendering**: Current implementation draws screenshot twice for shadow effect. Could be optimized.

7. **Preview Performance**: Large images (4K+) may have slower preview updates. Consider rendering at display resolution for preview.

## Next Steps After Testing

Once testing is complete, we'll continue with:
- Phase 5: Annotation Tools
- Phase 6: Text Tool
- Phase 7: Crop & Aspect Ratio
- Phase 8: Export & Save
- Phase 9: UI/UX Polish
- Phase 10: Comprehensive Testing
- Phase 11: Code Review
- Phase 12: Documentation

## Reporting Issues

If you encounter any issues during testing, note:
1. What you were trying to do
2. What happened vs. what you expected
3. Any error messages
4. macOS version
5. Xcode version

This will help us fix issues before continuing with remaining phases.

