# Phase 10: Testing

## Context Links
- [Plan Overview](./plan.md)
- All implementation phases

## Overview
**Date**: 2025-12-05  
**Priority**: Critical  
**Status**: Pending  
**Description**: Unit tests, integration tests, UI tests, edge case coverage

## Key Insights
- XCTest framework for all tests
- Test services independently
- Integration tests for workflows
- UI tests for user interactions
- Mock permissions for testing
- Test on multiple macOS versions

## Requirements

### Functional
- Unit tests for all services
- Integration tests for workflows
- UI tests for major features
- Edge case coverage
- Error scenario testing
- Performance testing

### Non-Functional
- > 80% code coverage
- Tests run in < 5 minutes
- Tests are maintainable
- Clear test names and organization

## Architecture

**Test Structure**:
```
ScreenshotAppTests/
├── Services/
│   ├── ScreenshotCaptureServiceTests.swift
│   ├── ImageRendererTests.swift
│   └── ExportServiceTests.swift
├── ViewModels/
│   └── EditorViewModelTests.swift
├── Models/
│   └── AnnotationTests.swift
└── Integration/
    └── CaptureToExportTests.swift

ScreenshotAppUITests/
├── CaptureFlowTests.swift
├── EditorFlowTests.swift
└── ExportFlowTests.swift
```

## Related Code Files

### Create
- All test files in `ScreenshotAppTests/`
- All UI test files in `ScreenshotAppUITests/`
- Test utilities and mocks

## Implementation Steps

1. **Set Up Test Targets**
   - Create unit test target
   - Create UI test target
   - Configure test schemes
   - Add test dependencies

2. **Create Test Utilities**
   - Mock permission manager
   - Test image generators
   - Test data fixtures
   - Helper assertions

3. **Test ScreenshotCaptureService**
   - Test region capture (mock)
   - Test fullscreen capture (mock)
   - Test window capture (mock)
   - Test permission handling
   - Test error cases

4. **Test ImageRenderer**
   - Test background rendering
   - Test screenshot composition
   - Test effect application
   - Test annotation rendering
   - Test final export

5. **Test EditorViewModel**
   - Test state management
   - Test padding updates
   - Test corner radius updates
   - Test shadow updates
   - Test annotation operations
   - Test undo/redo

6. **Test Annotation Models**
   - Test annotation creation
   - Test annotation manipulation
   - Test serialization (if needed)

7. **Test ExportService**
   - Test save to file (mock)
   - Test copy to clipboard (mock)
   - Test export formats
   - Test error handling

8. **Integration Tests**
   - Test capture → edit → export flow
   - Test annotation workflow
   - Test background selection workflow
   - Test crop workflow

9. **UI Tests**
   - Test capture flow
   - Test editor interactions
   - Test tool selection
   - Test export actions
   - Test keyboard shortcuts

10. **Edge Case Tests**
    - Very large images
    - Very small images
    - Invalid inputs
    - Permission denial
    - File system errors
    - Memory pressure

11. **Performance Tests**
    - Capture performance
    - Rendering performance
    - Export performance
    - Memory usage

12. **Accessibility Tests**
    - VoiceOver navigation
    - Keyboard navigation
    - High contrast mode

## Todo List
- [ ] Set up test targets
- [ ] Create test utilities
- [ ] Test ScreenshotCaptureService
- [ ] Test ImageRenderer
- [ ] Test EditorViewModel
- [ ] Test annotation models
- [ ] Test ExportService
- [ ] Write integration tests
- [ ] Write UI tests
- [ ] Write edge case tests
- [ ] Write performance tests
- [ ] Write accessibility tests
- [ ] Achieve > 80% coverage
- [ ] All tests pass

## Success Criteria
- > 80% code coverage
- All unit tests pass
- All integration tests pass
- All UI tests pass
- Edge cases covered
- Performance tests pass
- Accessibility tests pass
- Tests run in < 5 minutes
- Tests are maintainable

## Risk Assessment
- **Test maintenance**: Tests may break with changes → Keep tests simple, update with code
- **UI test flakiness**: May be unreliable → Use stable selectors, retry logic
- **Coverage gaps**: May miss edge cases → Review coverage reports, add missing tests

## Security Considerations
- Test permission handling
- Test input validation
- Test file path sanitization
- Test error handling doesn't leak info

## Next Steps
- Proceed to Phase 11: Code Review

