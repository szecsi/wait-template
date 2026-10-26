# WAIT 2027 – Typst template

Typst version of the LaTeX template in `../latex-template` (egpubl.cls + wait.sty).
It reproduces the same A4 page, type area, 9/11pt Times two-column layout,
title block, abstract box, headings, captions, running heads and reference style.

    typst compile wait2027Sample.typ

Files:

| file                  | purpose                                              |
|-----------------------|------------------------------------------------------|
| `wait.typ`            | the template (replaces `egpubl.cls` + `wait.sty`)    |
| `wait2027Sample.typ`  | the sample paper (same content as `wait2027Sample.tex`) |
| `wait.csl`            | reference style: superscript numbers, `1.` labels    |
| `refs.bib`            | the sample references (the `thebibliography` of the LaTeX sample) |
| `sample.svg`          | `sample.eps` converted to SVG (Typst cannot read EPS)|

## LaTeX → Typst

| LaTeX                              | Typst                                         |
|------------------------------------|-----------------------------------------------|
| `\ConferencePaper`                 | `paper-type: "paper"`                         |
| `\ConferenceSubmission`            | `paper-type: "submission"`                    |
| `\title[short]{long}`              | `title: [...]`, `short-title: [...]`          |
| `\author[short]{...}`              | `authors: [...]`, `short-authors: [...]`, `affiliations: (...)` |
| `\thanks{...}`                     | `#thanks[...]`                                |
| `\begin{abstract}`                 | `abstract: [...]`                             |
| `\CCScat{a}{b}{c}`                 | `ccs: (ccs-cat("a", "b", "c"),)`              |
| `\keyword{k}`                      | `keywords: (keyword("k"),)`                   |
| `\ConfYear`, `\ConfName`, ...      | `conference: (year: 2027, name: ..., location: ...)` (defaults in `conf-defaults`) |
| `\pStartPage{n}`                   | `start-page: n`                               |
| `\section`, `\subsection`          | `=`, `==`                                     |
| `\section*{...}`                   | `#heading(numbering: none)[...]`              |
| `\cite{a}` / `\cite{a,b}`          | `#cite(<a>)` / `@a @b`                        |
| `Section~\ref{x}`                  | `@x` (prints "Section 4", "Figure 1", "Table 1") |
| `\begin{quote}`                    | `#quote(block: true)[...]`                    |
| `\appendix`                        | `#show: appendix`                             |
| `\mbox{\rm ...}` in math           | `#textrm[...]`                                |
| `\textsc{...}`                     | `#textsc("...")`                              |

## Known differences from the LaTeX output

- References are numbered in order of first citation (as with BibTeX `unsrt`),
  not in the hand-written `thebibliography` order. Names are abbreviated to
  initials (`K. Ch.` becomes `K.C.`).
- Typst has no `\flushbottom`: columns end at their natural length instead of
  being stretched to the bottom of the page.
- Line and page breaks can differ slightly, because the font metrics and the
  line-breaking algorithm are not identical.
- The font is Times New Roman. On systems without it, change `serif` in `wait.typ`
  (e.g. to `("TeX Gyre Termes",)`).
- Floats go at the top or bottom of a column. There are no separate float pages.
