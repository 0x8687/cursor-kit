
# Screenshot App Bootstrap Example

This project includes an example macOS Screenshot App with a rich image editor. Below are the supported features and how to try the example using the Cursor Kit bootstrap workflow.

## Features

**Screenshot capabilities:**
- Capture a specific region on the screen with drag & drop
- Capture fullscreen
- Capture a specific window

**Post-screenshot editor:**
- Select a background from a trending gradient gallery or upload an image
- Adjust padding (spacing between screenshot & edges, revealing background)
- Control corner radius (rounded corners)
- Adjust drop-shadow
- Draw/edit/move/change color for: arrows, rectangles, ellipses, lines
- Text tool: add, modify, move, color, border, alignment
- Crop tool
- Choose output aspect ratio (vertical & horizontal padding respected)
- Save to directory or copy to clipboard

## How to Run the Example

Clone the repository and open the project in Cursor IDE:

```bash
git clone https://github.com/0x8687/cursor-kit.git
cd cursor-kit
```

Use the bootstrap workflow from the root of the project:

```bash
/bootstrap A screenshot app on MacOS with these following features:

- Capture a specific region on the screen by drag & drop
- Capture fullscreen
- Capture a specific window

After taking screenshot, open an editor:

- Select a background in the gallery of a bunch of trending gradient colors, or upload some specific images.
- Adjust padding of the final result (spacing between the edges to the screenschot and reveal a background behind)
- Adjust rounded of the corners of the screenshot.
- Adjust drop-shadow of the screenshot
- Add/modify/move/change color: arrows, rectangles, ellipses, lines,...
- Text tool: Add, modify, move, change color, change border, alignment
- Crop tool
- Select ratio of the final result (must respect the padding in both directions: vertical & horizontal)
- Save to a directory or copy to clipboard
```

This command tells Cursor Kit's AI bootstrap workflow to scaffold a macOS screenshot app project with all of the above features.

> **Note:** If you want to explore a full working example, check [`examples/ScreenshotApp/`](./ScreenshotApp/).

### More Information
- The Cursor Kit bootstrap prompt will guide you through scaffolding, implementation, and AI-powered task planning.
- For advanced usage or customizing the workflow, see `.cursor/workflows/` and `CURSOR.md`.

---


