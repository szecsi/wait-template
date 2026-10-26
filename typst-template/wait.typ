// =====================================================================
//  wait.typ -- Typst template for WAIT: Workshop on the Advances in
//  Information Technology.
//
//  A reproduction of the LaTeX template (egpubl.cls v3.10 + wait.sty):
//  A4 paper, 9/11pt Times, two columns, the same type area, headings,
//  captions, abstract block, running heads and reference style.
//
//  Usage:
//    #import "wait.typ": *
//    #show: wait.with(title: [...], authors: [...], ...)
// =====================================================================

// ------ the event (wait.sty) -----------------------------------------
#let conf-defaults = (
  name: "WAIT: Workshop on the Advances in Information Technology",
  location: "Budapest",
  year: 2027,
  editors: "Bálint Kiss and László Szirmay-Kalos",
)

// ------ fonts --------------------------------------------------------
// The LaTeX template uses Times (dfadobe.sty, NimbusRomNo9L in pdfTeX).
// Without Times New Roman, use e.g. ("TeX Gyre Termes",) or ("Nimbus Roman",).
#let serif = ("Times New Roman",)
#let math-font = "New Computer Modern Math"

// Font sizes of egpubl.cls as (size, baselineskip).
#let sizes = (
  tiny: (6pt, 8pt),
  scriptsize: (6pt, 7pt),
  small: (8pt, 10pt),
  footnotesize: (8pt, 10pt),
  normalsize: (9pt, 11pt),
  large: (10pt, 11pt),
  Large: (12pt, 14pt),
  LARGE: (14.4pt, 17pt),
  huge: (17.28pt, 20pt),
  Huge: (20.74pt, 25pt),
)

// Lines are measured from 0.7em above the baseline to the baseline,
// so leading = baselineskip - 0.7em reproduces TeX's \baselineskip.
#let top-edge = 0.7em
#let leading-for(size, skip) = skip - 0.7 * size

// A paragraph-level size change, like {\small ... \par}.
#let fontsize(name, body) = {
  let (size, skip) = sizes.at(name)
  set text(size: size)
  set par(leading: leading-for(size, skip))
  body
}

// An inline size change, like {\small ...}.
#let size(name, body) = text(size: sizes.at(name).first(), body)

// Text font inside math, like \mbox{\rm ...}.
#let textrm(body) = text(font: serif, body)

// ------ page geometry (egpubl.cls) -----------------------------------
//  \textwidth 38pc, \textheight 55\baselineskip + \topskip, \columnsep 2pc,
//  \oddsidemargin 0 (1in), \topmargin -1pc, \headheight 11pt,
//  \headsep 11pt, \footskip 22pt
#let text-width = 38 * 12pt
#let text-height = 55 * 11pt + 9pt
#let margin-left = 72pt
#let margin-top = 72pt - 12pt + 11pt + 11pt
#let column-sep = 2 * 12pt

// Normal paragraph metrics: \parskip 5.5pt, \parindent 1em
#let normal-leading = leading-for(9pt, 11pt)
#let par-skip = 5.5pt

// Fake small caps, like \textsc (Times usually has no smcp feature).
#let textsc(s) = {
  for word in s.split(" ").intersperse(" ") {
    if word == " " { word } else {
      upper(word.first())
      text(size: 0.8em, upper(word.slice(word.first().len())))
    }
  }
}

// Symbols used for \thanks and footnotes (\@fnsymbol of egpubl.cls).
#let fnsymbols = ("†", "‡", "§", "¶", "‖", "**", "††", "‡‡", "§§", "¶¶", "‖‖")
#let fnsymbol(n) = fnsymbols.at(n - 1, default: "***")

// \thanks{...} for the author list: prints the mark, and the text is set
// as a footnote at the bottom of the first column.
#let thanks-notes = state("wait-thanks", ())
#let thanks(body) = context {
  let n = thanks-notes.get().len() + 1
  thanks-notes.update(notes => notes + (body,))
  super(fnsymbol(n))
}

// ACM CCS category, like \CCScat{I.3.3}{Computer Graphics}{Line and Curve Generation}
#let ccs-cat(code, area, desc) = [#code [#area]: #desc]

// Keyword, like \keyword{...}
#let keyword(k) = [[#k]]

// Appendix: like \appendix -- sections become "Appendix A: Title".
#let appendix(body) = {
  counter(heading).update(0)
  set heading(numbering: "A")
  show heading: it => {
    if it.level > 1 or it.numbering == none { return it }
    set text(size: 9pt, weight: "bold")
    set par(justify: false, first-line-indent: 0pt)
    block(above: 11pt + par-skip + normal-leading, below: par-skip + normal-leading, sticky: true)[
      Appendix #counter(heading).display("A"):#h(0.5em)#text(weight: "regular", it.body)
    ]
  }
  body
}

// ------ the document -------------------------------------------------
#let wait(
  // \title[short]{long}
  title: none,
  short-title: none,
  // \author[short]{long}; use #super[1] for affiliation marks
  // and #thanks[...] for \thanks
  authors: none,
  short-authors: none,
  // the affiliation lines below the authors
  affiliations: (),
  abstract: none,
  // array of ccs-cat(...) entries (Categories and Subject Descriptors)
  ccs: (),
  // array of keyword(...) entries, or none
  keywords: none,
  // "paper" = \ConferencePaper (final version, no page numbers)
  // "submission" = \ConferenceSubmission (page numbers, year in footer)
  paper-type: "paper",
  // overrides of conf-defaults, e.g. (year: 2028)
  conference: (:),
  // \pStartPage
  start-page: 1,
  body,
) = {
  let conf = conf-defaults + conference
  let submission = paper-type == "submission"
  if short-title == none { short-title = title }
  if short-authors == none { short-authors = authors }

  set document(title: short-title, description: [#conf.name #conf.year])

  // ------ fonts and paragraphs ------
  set text(
    font: serif,
    size: 9pt,
    lang: "en",
    top-edge: top-edge,
    bottom-edge: "baseline",
  )
  set par(
    justify: true,
    leading: normal-leading,
    spacing: par-skip + normal-leading,
    first-line-indent: 1em,
  )
  show math.equation: set text(font: math-font)

  // ------ page layout ------
  let header = context {
    let page-no = counter(page).get().first()
    set par(justify: false, first-line-indent: 0pt)
    if here().page() == 1 {
      fontsize("small", block(width: 70%)[#conf.name, #conf.location, #conf.year])
    } else {
      set text(size: sizes.small.first())
      let number = if submission { counter(page).display() }
      let running = emph[#short-authors / #short-title]
      if calc.odd(page-no) [#h(1fr)#running#h(1fr)#number] else [#number#h(1fr)#running#h(1fr)]
    }
  }
  let footer = context {
    if submission {
      set text(size: sizes.tiny.first())
      let page-no = counter(page).get().first()
      if here().page() == 1 or calc.odd(page-no) [#conf.year.] else [#h(1fr)#conf.year.]
    }
  }
  set page(
    paper: "a4",
    margin: (
      left: margin-left,
      right: 595.28pt - margin-left - text-width,
      top: margin-top,
      bottom: 841.89pt - margin-top - text-height,
    ),
    columns: 2,
    header: header,
    header-ascent: 11pt,
    footer: footer,
    footer-descent: 22pt - 0.7 * 6pt,
  )
  set columns(gutter: column-sep)
  counter(page).update(start-page)

  // ------ sections ------
  // \section, \subsection, \subsubsection: normalsize bold, "1.2.  Title",
  // 11pt + \parskip above, \parskip below
  set heading(numbering: "1.1")
  show heading: it => {
    set text(size: 9pt, weight: "bold")
    set par(justify: false, first-line-indent: 0pt, leading: normal-leading)
    let above = if it.level >= 3 { 5.5pt } else { 11pt }
    block(above: above + par-skip + normal-leading, below: par-skip + normal-leading, sticky: true, {
      if it.numbering != none {
        counter(heading).display(it.numbering) + "." + h(0.5em)
      }
      it.body
    })
  }
  set ref(supplement: it => {
    if it.func() == heading { "Section" } else { it.supplement }
  })

  // ------ lists (\leftmargini 1em, \labelsep 0.5em, \itemsep 0) ------
  set list(indent: 0pt, body-indent: 0.65em, marker: ([•], [--], [∘], [⋄]), spacing: normal-leading)
  set enum(indent: 0pt, body-indent: 0.5em, numbering: "1.a.i.A.", spacing: normal-leading)
  show terms.item: it => block(par(hanging-indent: 1em, first-line-indent: 0pt)[*#it.term*#h(0.5em)#it.description])

  // ------ quote / quotation: 1.5pc on both sides, no italics ------
  show quote.where(block: true): it => block(
    above: par-skip + normal-leading,
    below: par-skip + normal-leading,
    pad(x: 1.5 * 12pt, it.body),
  )

  // ------ displayed math (\abovedisplayskip 5.5pt) ------
  show math.equation.where(block: true): set block(above: 5.5pt + normal-leading, below: 5.5pt + normal-leading)

  // ------ footnotes ------
  // marks are symbols; \footnoterule is .4\columnwidth; \footnotesize text
  set footnote(numbering: fnsymbol)
  set footnote.entry(
    separator: line(length: 40%, stroke: 0.4pt),
    clearance: 19.5pt - 3pt,
    gap: 4pt,
    indent: 0pt,
  )
  show footnote.entry: it => {
    let loc = it.note.location()
    let mark = numbering(it.note.numbering, ..counter(footnote).at(loc))
    fontsize("footnotesize", par(first-line-indent: 0pt, justify: true)[
      #h(1em)#super(mark)#h(4pt)#it.note.body
    ])
  }

  // ------ floats and captions ------
  // "Figure 1: Italic caption", centred if it fits on one line
  set place(clearance: 22pt)
  set figure(gap: 6pt)
  show figure.where(kind: table): set figure.caption(position: bottom)
  show figure.caption: it => layout(region => {
    let number = numbering(it.numbering, ..it.counter.at(it.location()))
    let caption = [*#it.supplement #number:* #emph(it.body)]
    set par(first-line-indent: 0pt, justify: true)
    if measure(caption).width > region.width { caption } else { align(center, caption) }
  })
  show figure: it => block(width: 100%, below: 6pt, it)

  // ------ tables (\tabcolsep 6pt, \arrayrulewidth .5pt) ------
  set table(stroke: none, inset: (x: 6pt, y: 2.2pt), align: left)

  // ------ bibliography: "References" as \subsection*, entries 5.5pt apart ------
  set bibliography(title: [References], style: "wait.csl")
  show bibliography: set par(spacing: 5.5pt + normal-leading, justify: true)
  show bibliography: set block(spacing: 5.5pt + normal-leading)

  // ------ title block, abstract (spans both columns) ------
  let title-block = {
    set par(first-line-indent: 0pt, justify: false)
    set block(spacing: 0pt)
    v(27pt + 10pt)
    align(center, {
      fontsize("huge", text(weight: "bold", title))
      v(31pt)
      fontsize("normalsize", authors)
      if affiliations.len() > 0 {
        v(11pt - 4.4pt)
        fontsize("small", affiliations.join(linebreak()))
      }
    })
    v(38pt)
    line(length: 100%, stroke: 0.25pt)
    v(12.9pt - 6.3pt)
    pad(x: 2 * 12pt, {
      set par(justify: true, spacing: normal-leading)
      [*Abstract*]
      linebreak()
      emph(abstract)
      if ccs.len() > 0 {
        parbreak()
        v(5.5pt)
        [Categories and Subject Descriptors #size("small")[(according to ACM CCS)]: ]
        ccs.join(" ")
      }
      if keywords != none {
        parbreak()
        v(5.5pt)
        [*Keywords:* ]
        keywords.join(" ")
      }
    })
    v(10.8pt)
    line(length: 100%, stroke: 0.25pt)
  }
  place(top, float: true, scope: "parent", clearance: 27.8pt, title-block)

  // the \thanks texts become footnotes of the first column;
  // afterwards the footnote counter restarts (as after \maketitle)
  place(context for (i, note) in thanks-notes.final().enumerate() {
    hide(footnote(numbering: _ => fnsymbol(i + 1), note))
  })
  counter(footnote).update(0)

  body
}
