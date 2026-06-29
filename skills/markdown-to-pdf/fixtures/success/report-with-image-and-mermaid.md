---
title: "Image and Mermaid Rendering Test"
author: "AI Skills"
subject: "Markdown fixture for image and Mermaid validation"
date: "2026-06-30"
keywords:
  - markdown
  - image
  - mermaid
---

# Image and Mermaid Rendering Test

This document is a focused fixture for validating local image rendering and Mermaid diagram rendering in Markdown-to-PDF conversion.

## Local Image

The image below uses a relative path to a fixture asset.

![Sample local SVG asset](assets/sample.svg)

## Mermaid Flowchart

```mermaid
flowchart TD
  Source[Markdown source] --> Parse[Pandoc conversion]
  Parse --> Render[HTML render]
  Render --> Pdf[PDF output]
  Render --> Validate[Visual validation]
```

## Mermaid Sequence Diagram

```mermaid
sequenceDiagram
  participant User
  participant Skill
  participant Renderer
  participant Output

  User->>Skill: Request PDF conversion
  Skill->>Renderer: Render Markdown and diagrams
  Renderer->>Output: Write PDF file
  Output-->>User: Return generated PDF path
```

## Verification Notes

Expected output:

| Check | Expected Result |
|-------|-----------------|
| Local image | The sample SVG is visible in the generated PDF. |
| Flowchart | The Mermaid flowchart renders as a diagram, not as raw code. |
| Sequence diagram | The Mermaid sequence diagram renders as a diagram, not as raw code. |

