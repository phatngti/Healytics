# Common Guide Prompt: Implement Any Feature Screenshot Section in the Report

Use this prompt when updating any feature section in the Healytics LaTeX report that includes UI screenshots, descriptions, flow explanations, and figure captions.

## Prompt

You are editing a LaTeX technical report in the Healytics project. Your task is to implement or refactor one feature section so the written explanation, screenshot grouping, captions, and figure layout all match the real UI assets provided for that feature.

### Inputs you must use

Before editing, identify:

1. the target `.tex` file,
2. the exact subsection or paragraph being updated,
3. the folder containing screenshots for the feature,
4. the number of screenshots in that feature,
5. whether the current text still matches the screenshots.

### Core objectives

1. Make the feature description consistent with the actual screenshots.
2. Group screenshots in a clear figure layout based on feature size.
3. Prevent caption collisions, float overflow, and broken page layout.
4. Keep the writing aligned with the actual user flow shown by the images.
5. Rebuild the PDF and verify the result.

### Required workflow

1. Read the current LaTeX section before editing.
2. Inspect the screenshot files in the target feature folder.
3. Determine the real user flow from the screenshots.
4. Rewrite the subsection text if the current description is outdated or incomplete.
5. Insert or refactor figure blocks so the screenshots are grouped by feature.
6. Rebuild the report PDF.
7. Visually verify the affected pages when possible.

### Layout rule for screenshot grouping

Apply this rule per feature:

1. If one feature has more than 6 screenshots, use a `3-column` grid.
2. If one feature has 6 screenshots or fewer, use a `2-column` grid.

If the screenshots are very tall and create an oversized float:

1. keep the same column rule,
2. split the feature into multiple figure blocks,
3. preserve logical reading order,
4. do not cram everything into one figure if it breaks the page.

### Figure implementation rules

For subfigure-based layouts:

1. Prefer:

```tex
\begin{figure}[H]
\centering
\captionsetup[subfigure]{font=small,justification=centering}
\captionsetup{skip=8pt}
...
\end{figure}
```

2. Use top-aligned subfigures:

```tex
\begin{subfigure}[t]{0.48\linewidth}
```

for 2-column layouts, and:

```tex
\begin{subfigure}[t]{0.31\linewidth}
```

or a nearby width for 3-column layouts.

3. Insert row separation with:

```tex
\par\medskip
```

4. Keep subcaptions short and action-focused.
5. Avoid long narrative captions under each subfigure.
6. Put the high-level description in the main figure caption, not in the subcaptions.

### Image sizing rules

For tall mobile screenshots:

1. Use `keepaspectratio`.
2. Cap height to avoid oversized floats, for example:

```tex
\includegraphics[width=\linewidth,height=0.21\textheight,keepaspectratio]{...}
```

3. Adjust the height only as much as needed for page fit.
4. Keep the images visually readable; do not shrink them excessively.

### Caption quality rules

1. Subcaptions should describe the action or state shown in that single screenshot.
2. Main figure captions should describe the feature stage or flow as a whole.
3. Avoid repeating the same words in every subcaption unless necessary.
4. Do not let subcaptions run so long that they wrap awkwardly into the main caption region.

Good pattern:

- subcaption: `Nhập email đăng ký`
- main caption: `Luồng Sign Up của người dùng trên ứng dụng di động`

### Writing rules for the feature description

When rewriting the surrounding paragraph or list:

1. describe the real sequence shown in the screenshots,
2. use the UI to infer the user flow conservatively,
3. mention validation, consent, OTP, status, filters, or payment steps only if they are actually visible or strongly implied,
4. keep implementation claims consistent with the backend architecture already documented elsewhere,
5. do not invent screens or interactions not present in the image set.

### When to split one feature into multiple figures

Split a feature into multiple figure blocks when:

1. the screenshots belong to distinct phases of the same feature,
2. the full set does not fit cleanly on one page,
3. caption spacing becomes unreadable,
4. the page produces oversized float warnings,
5. the feature has a natural breakdown such as:
   - entry,
   - verification,
   - completion,
   - confirmation.

### File naming guidance for screenshots

If screenshot filenames are too long, contain spaces, or are fragile in LaTeX:

1. create short aliases in the same image folder,
2. keep names predictable, such as:
   - `fig_user_auth_email.png`
   - `fig_feature_step_1.png`
   - `fig_feature_confirm.png`
3. update LaTeX to use the short aliases.

### Verification checklist

After editing:

1. run:

```sh
latexmk -pdf -interaction=nonstopmode main.tex
```

2. confirm:
   - the document compiles,
   - the new screenshots are included,
   - captions do not overlap,
   - the figure order matches the real flow,
   - no oversized float is introduced by the new figure block.

3. if possible, rasterize or preview the affected PDF pages to visually confirm layout.

### Expected output from the implementer

Return:

1. the file path edited,
2. the screenshot grouping used,
3. any text flow changes made,
4. whether the PDF rebuilt successfully,
5. any remaining unrelated warnings still present in the report.

### Reusable execution template

Use this execution pattern for any feature:

1. identify feature section and screenshot folder,
2. count screenshots,
3. choose `2-column` or `3-column`,
4. split into multiple figures if necessary,
5. shorten subcaptions,
6. cap screenshot heights,
7. rewrite the flow text to match the screenshots,
8. rebuild and verify visually.
