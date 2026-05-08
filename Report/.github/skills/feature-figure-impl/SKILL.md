---
name: feature-figure-impl
description: "Use when: implementing or refactoring feature sections with UI screenshots in LaTeX technical reports. Handles figure layout, captions, image sizing, and text consistency across the Healytics report."
---

# Feature Figure Implementation Skill

Implement or refactor one feature section in a LaTeX technical report so that written explanation, screenshot grouping, captions, and figure layout all match the real UI assets. This workflow ensures PDF output is clean, readable, and free of layout issues.

## Workflow

### 1. Identify the Target Section
- **Target `.tex` file**: Which content file needs updating (e.g., `Contents/HienThuc.tex`)
- **Subsection or paragraph**: The exact feature section being edited
- **Screenshot folder**: Path to the feature's images in `Images/`
- **Screenshot count**: Total number of screenshots for this feature
- **Current status**: Does the existing text still match the screenshots?

### 2. Read and Audit Current Content
- Open the current LaTeX section
- Inspect all screenshot files in the target folder
- Map the user flow from the image sequence
- Identify gaps or outdated text in the current subsection

### 3. Rewrite Feature Description (if needed)
- Describe the real sequence shown in screenshots
- Infer user flow conservatively from the UI
- Mention validation, OTP, filters, payment **only if visible or strongly implied**
- Keep claims consistent with backend architecture documented elsewhere
- Do not invent screens or interactions not in the image set

### 4. Apply Screenshot Grouping Rule
**Column layout per feature:**
- **>6 screenshots**: Use `3-column` grid
- **≤6 screenshots**: Use `2-column` grid
 - **Special-case — 5 screenshots**: Split into multiple logical figures (e.g., 2 images + 3 images) using a `2-column` grid. Do not force a 3-column layout. The odd image on the last row will naturally center.

**When to split into multiple figures:**
- Distinct phases (entry → verification → completion)
- Image set does not fit cleanly on one page
- Caption spacing becomes unreadable
- Page produces oversized float warnings
- Maintain logical reading order

### 5. Implement Figure Blocks

**Base structure (preferred):**
```tex
\begin{figure}[H]
\centering
\captionsetup[subfigure]{font=small,justification=centering}
\captionsetup{skip=8pt}
% Subfigures here
\caption{High-level feature description covering entire user flow}
\label{fig:feature_name}
\end{figure}
```

**Top-aligned subfigures:**
- 2-column: `\begin{subfigure}[t]{0.48\linewidth}`
- 3-column: `\begin{subfigure}[t]{0.31\linewidth}` or nearby value

**Row separation:** Insert `\par\medskip` between rows

### 6. Image Sizing Rules

**For tall mobile screenshots:**
```tex
\includegraphics[width=\linewidth,height=0.4\textheight,keepaspectratio]{path}
```
- Always use `keepaspectratio`.
- Cap height to avoid oversized floats; prefer `0.4\textheight` (acceptable range `0.26\textheight`–`0.4\textheight`) for 2-column layouts to ensure readability.
- When a row contains a single screenshot (e.g., the last image in an odd-numbered figure), **keep the subfigure width identical to the others** (e.g., `0.48\linewidth`). Do not use a wider subfigure like `0.60\linewidth` or `0.96\linewidth`. The `\centering` command at the `figure` level will automatically center it.
- Adjust heights conservatively to preserve readability while minimizing blank vertical space.

### 7. Caption Quality

**Subcaptions (short, action-focused):**
- Describe single screenshot action or state
- Avoid repetition unless necessary
- Examples: `Nhập email đăng ký`, `Chọn dịch vụ`

**Main figure caption:**
- Describe entire feature flow or stage
- Examples: `Luồng Sign Up của người dùng trên ứng dụng di động`
- Avoid duplicating subcaptions

### 8. Image Path & Naming

**If filenames are fragile or too long:**
- Create short aliases in the same image folder
- Use predictable naming (`fig_feature_step_1.png`, `fig_user_auth_email.png`)
- Update LaTeX to reference the aliases

### 9. Rebuild and Verify

- Rebuild the PDF (e.g., `latexmk -pdf main.tex`)
- Check affected pages visually
- Verify no float overflow, caption collisions, or broken page breaks
- Confirm images are readable at final size
- Ensure caption text does not wrap awkwardly

## Decision Tree

| Scenario | Action |
|----------|--------|
| Feature has 7+ screenshots | Use 3-column; evaluate if splitting needed |
| Feature has 3–6 screenshots | Use 2-column; should fit on one page |
| Page is oversized / text wraps badly | Split feature into 2–3 logical figures |
| Screenshots are very tall | Cap height carefully; test sizes |
| Text in subsection is outdated | Rewrite based on current screenshot flow; remove invented details |
| Filenames contain spaces/special chars | Create short aliases; update LaTeX paths |

## Assets

No additional assets. Refer to the report structure:
- LaTeX files: `Contents/`
- Screenshots: `Images/` (organized by feature subfolder)
- Build command: `latexmk -pdf main.tex` from report root

## Example Prompts

1. **Implement a new feature section:**
   > "Implement the Sign Up feature section in Contents/HienThuc.tex using the screenshots in Images/Hiện thực/user_app/sign_in_sign_up/. The feature has 5 UI images. Rewrite the subsection text to match the actual flow and create a 2-column figure layout with captions."

2. **Refactor an existing feature:**
   > "The AI chat feature section in Contents/HienThuc.tex is outdated. Audit the current text against Images/Hiện thực/user_app/chat_with_ai/ (8 screenshots). Refactor the subsection, use a 3-column grid split across two figures, and rebuild the PDF."

3. **Fix layout issues:**
   > "The appointment figure in Contents/HienThuc.tex is causing page overflow. Check Images/Hiện thực/user_app/appoinment/ and adjust image heights, captions, or split the figure to keep the page clean. Verify after rebuild."

## Related Customizations

- **Workspace instructions** (`.github/copilot-instructions.md`): Add report-wide style guide for all LaTeX editing
- **File instructions** (`.github/instructions/Contents/*.instructions.md`): Auto-load feature-specific tips when editing each content file
- **Hooks** (`.github/hooks/latexmk-rebuild.json`): Auto-rebuild PDF after LaTeX file saves in the report directory
