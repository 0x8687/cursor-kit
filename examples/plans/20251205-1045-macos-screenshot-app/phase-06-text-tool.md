# Phase 6: Text Tool

## Context Links
- [Plan Overview](./plan.md)
- [Phase 5: Annotation Tools](./phase-05-annotation-tools.md)
- [Research: Drawing Tools](./research/research-03-drawing-tools-libraries.md)

## Overview
**Date**: 2025-12-05  
**Priority**: High  
**Status**: Pending  
**Description**: Text annotation with styling, alignment, borders, editing

## Key Insights
- `NSAttributedString` for rich text
- Core Text for final export rendering
- TextField overlay during editing
- Support: color, font, size, alignment, border
- Double-click to edit existing text

## Requirements

### Functional
- Add text annotations
- Edit text (double-click or select + edit)
- Move text annotations
- Change text color
- Change font and size
- Change alignment (left, center, right)
- Add/remove text border
- Resize text box
- Delete text annotations

### Non-Functional
- Smooth text rendering
- Support long text (multi-line)
- Font selection (system fonts)
- Real-time preview

## Architecture

**TextAnnotation Model** (extends Annotation):
- `text: String`
- `font: NSFont`
- `fontSize: CGFloat`
- `alignment: NSTextAlignment`
- `hasBorder: Bool`
- `borderColor: Color`
- `borderWidth: CGFloat`

**TextEditorView**:
- `TextField` overlay for editing
- Positioned at annotation location
- Auto-focus on creation
- Commit on Enter, cancel on ESC

**TextToolbar**:
- Font picker
- Font size slider
- Alignment buttons
- Color picker
- Border toggle

## Related Code Files

### Create
- `ScreenshotApp/Models/TextAnnotation.swift`
- `ScreenshotApp/Views/TextEditorView.swift`
- `ScreenshotApp/Views/TextToolbar.swift`

### Modify
- `ScreenshotApp/Models/Annotation.swift` (add text type)
- `ScreenshotApp/Views/AnnotationCanvas.swift` (render text)
- `ScreenshotApp/ViewModels/EditorViewModel.swift` (text state)
- `ScreenshotApp/Services/ImageRenderer.swift` (render text via Core Text)

## Implementation Steps

1. **Create TextAnnotation Model**
   - Extend `Annotation` or create separate model
   - Add all text-specific properties
   - Support multi-line text

2. **Update Annotation Model**
   - Add `.text` case to `AnnotationType`
   - Support text annotations in array

3. **Create TextEditorView**
   - `TextField` or `TextEditor` for multi-line
   - Position at annotation frame
   - Auto-focus on show
   - Enter to commit, ESC to cancel
   - Update annotation text in real-time

4. **Create TextToolbar**
   - Font picker (system fonts)
   - Font size slider (8-72pt)
   - Alignment buttons (left, center, right)
   - Color picker
   - Border toggle and border color picker

5. **Update EditorViewModel**
   - `@Published var selectedTextAnnotation: TextAnnotation?`
   - `@Published var textFont: NSFont`
   - `@Published var textFontSize: CGFloat`
   - `@Published var textAlignment: NSTextAlignment`
   - `@Published var textHasBorder: Bool`
   - Methods: `addTextAnnotation()`, `updateTextAnnotation()`, `deleteTextAnnotation()`

6. **Implement Text Drawing in AnnotationCanvas**
   - Render text annotations using `Text` view or `NSAttributedString`
   - Apply font, size, color, alignment
   - Draw border if enabled
   - Handle text wrapping

7. **Implement Text Selection**
   - Double-click text to edit
   - Tap to select
   - Show selection handles
   - Drag to move
   - Resize text box

8. **Integrate with ImageRenderer**
   - Use Core Text (`CTFrame`, `CTLine`) for export
   - Create `NSAttributedString` from text annotation
   - Draw text on `CGContext`
   - Apply border if enabled
   - Handle text alignment

9. **Update AnnotationToolbar**
   - Add text tool button
   - Show text-specific controls when text selected
   - Integrate TextToolbar

10. **Add Keyboard Shortcuts**
    - Enter: Commit text edit
    - ESC: Cancel text edit
    - Cmd+B: Toggle border (optional)
    - Cmd+L/C/R: Alignment shortcuts (optional)

11. **Update EditorView**
    - Show TextEditorView overlay when editing text
    - Show TextToolbar when text tool selected
    - Handle text creation flow

12. **Handle Multi-line Text**
    - Support text wrapping
    - Auto-resize text box
    - Manual resize via handles

## Todo List
- [ ] Create TextAnnotation model
- [ ] Update Annotation model
- [ ] Create TextEditorView
- [ ] Create TextToolbar
- [ ] Update EditorViewModel
- [ ] Implement text drawing
- [ ] Implement text selection
- [ ] Integrate with ImageRenderer
- [ ] Update AnnotationToolbar
- [ ] Add keyboard shortcuts
- [ ] Update EditorView
- [ ] Handle multi-line text
- [ ] Test all text features

## Success Criteria
- Text annotations can be added
- Text can be edited (double-click)
- Text can be moved and resized
- Font, size, color, alignment work
- Border can be added/removed
- Text renders correctly in preview
- Text exports correctly in final image
- Multi-line text works
- Performance is smooth

## Risk Assessment
- **Font rendering**: System fonts may vary → Use standard fonts, test on different systems
- **Text wrapping**: Long text may overflow → Implement proper wrapping
- **Core Text**: Complex API → Use helper functions, test thoroughly

## Security Considerations
- Validate text input (prevent injection)
- Limit text length (performance)
- Sanitize font names

## Next Steps
- Proceed to Phase 7: Crop & Aspect Ratio

