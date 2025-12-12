# Phase 8: Export & Save

## Context Links
- [Plan Overview](./plan.md)
- [Phase 3: Image Editor Core](./phase-03-image-editor-core.md)
- [Phase 7: Crop & Aspect Ratio](./phase-07-crop-aspect-ratio.md)

## Overview
**Date**: 2025-12-05  
**Priority**: Critical  
**Status**: Pending  
**Description**: Save to directory, copy to clipboard, file operations

## Key Insights
- `NSPasteboard` for clipboard operations
- `FileManager` and `NSSavePanel` for file save
- Export at full quality (not preview resolution)
- Support common formats (PNG, JPEG)
- Async operations for large images

## Requirements

### Functional
- Save to directory: File picker, choose location
- Copy to clipboard: One-click copy
- Export formats: PNG (default), JPEG (optional)
- Export quality: Full resolution
- File naming: Timestamp or custom
- Success/error feedback

### Non-Functional
- Fast export (< 2 seconds for typical images)
- Handle large images (4K+)
- Progress indicator for long operations
- Error handling for file system issues

## Architecture

**ExportService**:
- `saveToFile(image: NSImage, url: URL) async throws`
- `copyToClipboard(image: NSImage) async throws`
- `exportImage(state: EditorState) async -> NSImage?`

**ExportOptions**:
- `format: ExportFormat` (PNG, JPEG)
- `quality: CGFloat` (for JPEG, 0.0-1.0)
- `fileName: String?` (nil for auto-generated)

## Related Code Files

### Create
- `ScreenshotApp/Services/ExportService.swift`
- `ScreenshotApp/Models/ExportOptions.swift`
- `ScreenshotApp/Views/ExportOptionsView.swift`

### Modify
- `ScreenshotApp/ViewModels/EditorViewModel.swift` (add export methods)
- `ScreenshotApp/Views/EditorView.swift` (add export UI)

## Implementation Steps

1. **Create ExportOptions Model**
   - Format enum (PNG, JPEG)
   - Quality property (JPEG only)
   - File name option

2. **Create ExportService**
   - `exportImage(state:)`: Render final image at full quality
   - Use `ImageRenderer.renderFinalImage()` with high-res settings
   - Return `NSImage`

3. **Implement Save to File**
   - Use `NSSavePanel` for file picker
   - Set allowed file types (PNG, JPEG)
   - Generate default filename: "Screenshot YYYY-MM-DD HH-MM-SS.png"
   - Save image to selected URL
   - Handle file system errors
   - Show success/error alert

4. **Implement Copy to Clipboard**
   - Use `NSPasteboard.general`
   - Clear existing clipboard content
   - Set image data
   - Support PNG format (best quality)
   - Show success feedback (toast or alert)

5. **Create ExportOptionsView**
   - Format picker (PNG/JPEG)
   - Quality slider (JPEG only)
   - File name input (optional)
   - Export button

6. **Update EditorViewModel**
   - `exportAndSave() async throws`
   - `exportAndCopy() async throws`
   - `exportOptions: ExportOptions`
   - Progress state for UI feedback

7. **Add Export UI to EditorView**
   - "Save" button in toolbar
   - "Copy" button in toolbar
   - Show export options sheet (optional)
   - Progress indicator during export

8. **Implement Async Export**
   - Render on background queue
   - Update UI on main queue
   - Show progress indicator
   - Handle cancellation (optional)

9. **Handle Export Errors**
   - File permission errors
   - Disk full errors
   - Invalid file path errors
   - Show user-friendly error messages

10. **Add Export Shortcuts**
    - Cmd+S: Save to file
    - Cmd+Shift+C: Copy to clipboard
    - Cmd+E: Export options (optional)

11. **Optimize Export Quality**
    - Render at full resolution (not preview)
    - Use high-quality settings
    - PNG for lossless, JPEG for smaller files
    - Maintain aspect ratio

12. **Add Export History** (Optional)
    - Remember last save location
    - Quick save to last location
    - Export history list

## Todo List
- [ ] Create ExportOptions model
- [ ] Create ExportService
- [ ] Implement save to file
- [ ] Implement copy to clipboard
- [ ] Create ExportOptionsView
- [ ] Update EditorViewModel
- [ ] Add export UI to EditorView
- [ ] Implement async export
- [ ] Handle export errors
- [ ] Add export shortcuts
- [ ] Optimize export quality
- [ ] Test save functionality
- [ ] Test clipboard copy
- [ ] Test error handling

## Success Criteria
- Save to file works with file picker
- Copy to clipboard works
- Export formats (PNG, JPEG) work
- Full quality export (not preview)
- File naming works (auto or custom)
- Success/error feedback appears
- Progress indicator shows during export
- Keyboard shortcuts work
- Handles errors gracefully
- Performance is acceptable (< 2s for typical images)

## Risk Assessment
- **Large images**: Export may be slow → Show progress, use background queue
- **File permissions**: User may not have write access → Handle gracefully
- **Clipboard**: May fail on some systems → Fallback, show error

## Security Considerations
- Validate file paths
- Sanitize file names
- Don't overwrite files without confirmation (optional)
- Handle file system errors securely

## Next Steps
- Proceed to Phase 9: UI/UX Polish

