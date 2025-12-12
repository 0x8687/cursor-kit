# Phase 1: Project Setup & Foundation

## Context Links
- [Plan Overview](./plan.md)
- [Tech Stack](../../docs/tech-stack.md)
- [Research: macOS Screenshot APIs](./research/research-01-macos-screenshot-apis.md)

## Overview
**Date**: 2025-12-05  
**Priority**: Critical  
**Status**: Pending  
**Description**: Set up Xcode project, folder structure, permissions, basic app architecture

## Key Insights
- macOS 12.0+ required for SwiftUI Canvas
- Screen recording permission mandatory for capture
- Accessibility permission needed for window enumeration
- MVVM pattern for clean architecture

## Requirements

### Functional
- Create Xcode project with SwiftUI App lifecycle
- Configure Info.plist for permissions
- Set up folder structure (Models, Views, ViewModels, Services, Utils)
- Basic window management

### Non-Functional
- macOS 12.0+ deployment target
- Swift 6 compatibility
- Clean project structure (<200 lines per file)

## Architecture

```
ScreenshotApp/
├── App/
│   └── ScreenshotApp.swift
├── Models/
│   ├── Annotation.swift
│   ├── GradientPreset.swift
│   └── EditorState.swift
├── Views/
│   ├── ContentView.swift
│   ├── EditorView.swift
│   └── CaptureOverlayView.swift
├── ViewModels/
│   ├── EditorViewModel.swift
│   └── CaptureViewModel.swift
├── Services/
│   ├── ScreenshotCaptureService.swift
│   ├── ImageRenderer.swift
│   └── PermissionManager.swift
└── Utils/
    ├── Extensions.swift
    └── Constants.swift
```

## Related Code Files

### Create
- `ScreenshotApp/App/ScreenshotApp.swift`
- `ScreenshotApp/Models/Annotation.swift`
- `ScreenshotApp/Models/GradientPreset.swift`
- `ScreenshotApp/Models/EditorState.swift`
- `ScreenshotApp/Views/ContentView.swift`
- `ScreenshotApp/Services/PermissionManager.swift`
- `ScreenshotApp/Utils/Extensions.swift`
- `ScreenshotApp/Utils/Constants.swift`
- `Info.plist` (permissions)
- `README.md`

## Implementation Steps

1. **Create Xcode Project**
   - New macOS App project
   - SwiftUI interface
   - Swift 6 language version
   - macOS 12.0 deployment target

2. **Configure Info.plist**
   - Add `NSScreenCaptureUsageDescription`: "This app needs screen recording permission to capture screenshots"
   - Add `NSAccessibilityUsageDescription`: "This app needs accessibility permission to select windows"

3. **Create Folder Structure**
   - App, Models, Views, ViewModels, Services, Utils folders
   - Organize files by responsibility

4. **Implement App Entry Point**
   - `ScreenshotApp.swift`: Basic App struct
   - Window configuration
   - Initial view setup

5. **Create Permission Manager**
   - `PermissionManager.swift`: Request screen recording access
   - Request accessibility access
   - Check permission status
   - Handle denial gracefully

6. **Create Basic Models**
   - `Annotation.swift`: Empty struct (placeholder)
   - `GradientPreset.swift`: Empty struct (placeholder)
   - `EditorState.swift`: Empty struct (placeholder)

7. **Create Content View**
   - `ContentView.swift`: Basic UI with capture button
   - Permission request UI if needed
   - Navigation structure

8. **Add Constants**
   - `Constants.swift`: App name, version, default values

9. **Add Extensions**
   - `Extensions.swift`: Common Swift extensions (empty for now)

10. **Create README**
    - Project description
    - Setup instructions
    - Requirements

## Todo List
- [ ] Create Xcode project
- [ ] Configure Info.plist permissions
- [ ] Create folder structure
- [ ] Implement app entry point
- [ ] Create PermissionManager service
- [ ] Create basic model structs
- [ ] Create ContentView
- [ ] Add constants and extensions
- [ ] Create README
- [ ] Test app launches and permissions

## Success Criteria
- App launches without errors
- Permission dialogs appear correctly
- Folder structure follows architecture
- All files compile without errors
- README documents setup process

## Risk Assessment
- **Permission denial**: User may deny permissions → Handle gracefully with clear UI
- **Xcode version**: Older versions may not support Swift 6 → Document minimum Xcode version

## Security Considerations
- Request permissions explicitly with clear descriptions
- Never capture without user action
- Handle permission revocation

## Next Steps
- Proceed to Phase 2: Screenshot Capture Service

