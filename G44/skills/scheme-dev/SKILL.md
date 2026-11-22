---
name: scheme-dev
description: Write, review and test small Racket 8.x programs in #lang racket/base using a tiny core of built-ins and hand-written list helpers. Use for any request to write or fix Scheme or Racket code.
---

# scheme-dev

## 1. Language and version
- Target Racket 8.x. The first line of every file is exactly: #lang racket/base
- Files are plain UTF-8 text with the .rkt extension.
- Do not require any library, and do not use racket (full), racket/list or srfi.

## 2. Coding conventions
- Names: lowercase-with-hyphens (list-sum, not listSum). Predicates end in ?.
- Every function gets a ;; comment directly above it giving its recursive
  reading, e.g.:
      ;; my-length: the length of '() is 0; of (cons x rest) is 1 + length of rest.
- Write list helpers by hand: my-length, my-map, my-append, my-reverse.
  Define them in the file whenever they are needed, with the comment above.
- Define each function exactly once; define helpers before the functions that
  use them.
- One unit of work per prompt: answer one function or one fix at a time, and
  do not add unrequested extras.
- End the file with a newline.

## 3. How to run and test code
- Run the program: racket FILE.rkt
- The grader appends calls to the end of the file, then runs the command above.
  Your file must therefore contain definitions only, and end with a newline so
  the appended calls start on a fresh line.

## 4. Hard constraints
- Allowed built-ins only: define, lambda, let, let*, letrec, named let, if,
  cond with else, and, or, not, begin, quote, cons, car, cdr, list,
  car/cdr compositions up to four levels (caar ... cddddr), null?, pair?, eq?,
  assq, assoc, + - * < > <= >= =, max, display, newline (plus read for S2).
- Forbidden: set!, vectors, hash tables, strings, loops (for, do, while),
  length, append, reverse, map, filter, member, memq, list-ref, list-tail.
- No top-level calls: no (main), no test expressions, no bare expressions.
- Nothing printed at load time: loading the file must produce no output.
- Output only through display and newline, inside functions.

## 5. Self-review checklist (apply before answering)
- [ ] First line is #lang racket/base and the file ends with a newline.
- [ ] Every built-in used is on the allowed list in section 4.
- [ ] No forbidden name appears, including as a helper's body.
- [ ] Every function has a ;; recursive-reading comment above it.
- [ ] Each function is defined once; no pasted duplicates.
- [ ] Hand-written helpers (my-length, my-map, my-append, my-reverse) are
      defined if used, and the library versions are not.
- [ ] No top-level expression other than define forms.
- [ ] Loading the file prints nothing.
- [ ] Recursion over large inputs uses an accumulator (tail position).
- [ ] The file contains pure Racket, with no markdown fences or prose.
- [ ] The code was run with racket FILE.rkt and behaves as stated.

## 6. Known AI failure modes in Racket
- Reaching for map, length or append out of habit; use my-map, my-length,
  my-append instead.
- Adding a (main) call or a sample expression at the top level, which prints
  output at load time and collides with the grader's appended calls.
- Forgetting the final newline, so the grader's appended call fuses onto the
  last line of the file.
- Duplicate definitions from pasting a function twice.
- Non-tail recursion blowing the stack on large inputs; use a named let or an
  accumulator parameter.
- Markdown code fences pasted into the .rkt file, causing read errors.