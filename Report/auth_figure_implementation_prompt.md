# Deep Details Guide Prompt: Sign In / Sign Up Figure and Caption Implementation

Use this prompt when updating the LaTeX implementation section for authentication screenshots in the Healytics report.

## Prompt

You are editing a LaTeX technical report at `Contents/HienThuc.tex`. Your task is to refactor the `Đăng nhập và Đăng ký Tài khoản` subsection so the text, screenshot grouping, captions, and layout match the real mobile flow shown in `Images/Hiện thực/user_app/sign_in_sign_up`.

### Objectives

1. Update the narrative so the auth flow is accurate and complete.
2. Include all required screenshots from the folder, especially:
   - `fig_user_auth_entry.png`
   - `fig_user_auth_signin.png`
   - `fig_user_auth_email.png`
   - `fig_user_auth_otp.png`
   - `fig_user_auth_signup_profile.png`
   - `fig_user_auth_signup_address.png`
3. Fix figure caption layout so:
   - subcaptions do not collide with the figure caption,
   - long captions do not overlap neighboring items,
   - tall mobile screenshots do not create oversized floats.
4. Keep the presentation aligned with the rule:
   - if one feature has more than 6 screenshots, use a 3-column layout,
   - otherwise use a 2-column layout.
5. Rebuild the PDF and verify the figures render correctly.

### Implementation rules

1. Read the current subsection before editing. Do not assume the existing text is still correct.
2. Separate `Sign In` and `Sign Up` into distinct figure groups if combining them creates cramped captions or oversized figures.
3. For this auth flow, use:
   - one `Sign In` figure with 2 screenshots in 2 columns,
   - one `Sign Up` figure with 4 screenshots in a 2-column, 2-row grid.
4. Keep subcaptions short and action-oriented. Prefer:
   - `Chọn Sign In hoặc Create an account`
   - `Đăng nhập bằng email, mật khẩu hoặc social login`
   - `Nhập email đăng ký`
   - `Xác thực email bằng mã OTP`
   - `Điền thông tin cá nhân và ngày sinh`
   - `Địa chỉ, điều khoản và xác nhận đăng ký`
5. Add local caption controls inside the figure blocks:
   - `\captionsetup[subfigure]{font=small,justification=centering}`
   - `\captionsetup{skip=8pt}`
6. Use top-aligned subfigures:
   - `\begin{subfigure}[t]{0.48\linewidth}`
7. Insert `\par\medskip` between rows and before the main figure caption.
8. Cap tall screenshot height with `keepaspectratio`, for example:
   - `height=0.21\textheight` to `0.24\textheight`
   Adjust only enough to prevent overflow while keeping the images readable.
9. Update the numbered flow description to explicitly include the OTP verification step between email input and full profile completion.
10. Do not revert unrelated document content.

### Expected text changes

The auth narrative should explicitly describe:

1. entry screen selection,
2. returning-user sign-in,
3. email-first sign-up start,
4. OTP email verification,
5. profile completion,
6. final submission and account activation.

### Expected LaTeX structure

Use a structure equivalent to:

```tex
\begin{figure}[H]
\centering
\captionsetup[subfigure]{font=small,justification=centering}
\captionsetup{skip=8pt}
... two subfigures ...
\par\medskip
\caption{Luồng Sign In ...}
\label{fig:user_auth_signin_flow}
\end{figure}

\begin{figure}[H]
\centering
\captionsetup[subfigure]{font=small,justification=centering}
\captionsetup{skip=8pt}
... four subfigures in two rows ...
\par\medskip
\caption{Luồng Sign Up ...}
\label{fig:user_auth_signup_flow}
\end{figure}
```

### Verification steps

1. Run:

```sh
latexmk -pdf -interaction=nonstopmode main.tex
```

2. Confirm:
   - no new LaTeX errors were introduced,
   - auth screenshots are included in the expected order,
   - subcaptions do not overlap the main caption,
   - the figure does not produce an oversized float warning caused by this section.
3. If layout is still cramped:
   - shorten subcaptions further,
   - reduce screenshot height slightly,
   - keep the 2-column grouping for 6 or fewer images.

### Deliverable

Return:

1. the edited file path,
2. the new figure grouping used,
3. whether `main.pdf` rebuilt successfully,
4. any remaining pre-existing build warnings unrelated to this auth section.
