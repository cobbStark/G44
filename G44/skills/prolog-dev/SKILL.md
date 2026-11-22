---
name: prolog-dev
description: Write, review and test small SWI-Prolog 9.x programs under strict conventions (pure style, restricted libraries, no side effects at load time). Use for any request to write or fix Prolog code.
---

# prolog-dev

## 1. Language and version
- Target SWI-Prolog 9.x only. Not ISO-only, not GNU, not Scryer.
- Source files are plain UTF-8 text with the .pl extension.
- Default double_quotes flag applies: "text" is a string, 'text' is an atom.

## 2. Coding conventions
- Predicates and atoms: snake_case, starting lowercase (path_cost, not pathCost).
- Variables: CamelCase or _Name; use _ for singletons.
- Quote any atom that is not a plain lowercase identifier: 'c++', 'AI',
  'Hello World', '[]' only when meant as an atom.
- Every predicate gets a comment directly above its first clause giving its
  declarative reading, e.g.:
      % path_cost(+Path, -Cost): Cost is the sum of edge weights in Path.
- Keep all clauses of a predicate together (contiguous).
- Prefer pure relations; use accumulators and first-argument indexing.
- One unit of work per prompt: answer one predicate or one fix at a time, and
  do not add unrequested extras.

## 3. How to run and test code
- Run the program: swipl -q -f FILE.pl -g main -t halt
- Test one goal: swipl -q -f FILE.pl -g "<goal>" -t halt
- main/0 is an ordinary predicate defined in the file; the command line, not
  the file, starts it and ends the process.

## 4. Hard constraints
- Libraries allowed: lists, apply, yall, aggregate. Nothing else.
- No assert, asserta, assertz, retract, retractall.
- No global variables (b_setval, nb_setval, b_getval, nb_getval).
- No halt/0 anywhere in the file.
- No initialization directive of any kind.
- Nothing printed at load time: no directive may write output.
- Output only through format/2 with ~w (and ~n), inside predicates.

## 5. Self-review checklist (apply before answering)
- [ ] Only the four allowed libraries are loaded.
- [ ] No assert/retract, no global variables, no halt/0, no initialization.
- [ ] Loading the file prints nothing.
- [ ] Every predicate has a declarative-reading comment above it.
- [ ] Clauses of each predicate are contiguous.
- [ ] Special atoms are quoted ('c++', 'AI'); atoms vs strings are intentional.
- [ ] Arithmetic operands are bound before is/2 or comparison.
- [ ] once/1 wraps goals where exactly one answer is wanted.
- [ ] Output uses format with ~w, never print/1 or writeq/1.
- [ ] The file contains pure Prolog, with no markdown fences or prose.
- [ ] The code was run with the commands in section 3 and behaves as stated.

## 6. Known AI failure modes in Prolog
- Confusing atoms and strings: 'abc' vs "abc"; compare with the same type.
- Unquoted special atoms: c++ or AI (AI is a variable!) instead of 'c++', 'AI'.
- Infinite loops from unbound arithmetic: X is Y+1 with Y unbound raises an
  error; recursion without a base case or a bound loops forever.
- Missing once/1 when one answer is wanted, leaving choice points that
  backtrack into duplicate output.
- Discontiguous clauses: helper clauses scattered through the file.
- Markdown code fences pasted into the .pl file, causing syntax errors.
- Using forbidden libraries (clpfd, dcg/basics, readutil, assoc, etc.).
- Printing with print/1 or writeq/1 instead of format("~w~n", [X]).