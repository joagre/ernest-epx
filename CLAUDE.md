# Epx — Claude Instructions

Epx is an Ernest library over epx, the pixel library for Erlang; `README.md` says what it does. This file is the way of working, cut from Ernest's own; it changes in the template, `ernest-template`, and is copied from there.

## Authority

- **The language is Ernest's report and guide**, which the installation holds under `share/doc/ernest/`, and this repository changes neither. What the toolchain does is the report's §11; what the standard library offers, its Appendix E; what a library of Ernest's offers, its Appendix G.
- **The design is the normative document of this program**: [`docs/design.md`](docs/design.md), with the plan item being built. Where the two differ, the design is corrected first.
- **Section 0 of the report, the five principles, is the tiebreaker** in every design discussion. Principles 2 to 5 construct; principle 1 audits the result. Every recommendation weighs the candidate against the five and names the principle that decided.

## Who owns each fact

Each fact has one owner. Every other document points at the owner and does not restate it.

| Owner | Owns |
|---|---|
| [`README.md`](README.md) | what the program is, how it is built, tested and run, and what each document is |
| [`docs/design.md`](docs/design.md) | how the program is arranged: its processes, its types, what each module owns, and the glossary of its names |
| [`docs/plan.md`](docs/plan.md) | the roadmap and where we are; a finished milestone is a row of its table, naming the log entries that argue it |
| [`docs/log.md`](docs/log.md) | the rationale: why the design and the plan say what they say. Never normative |
| [`docs/release.md`](docs/release.md) | what a release runs to be ready |
| [`docs/style.md`](docs/style.md) | the rules an Ernest program is written by, Ernest's own, copied and not edited here |
| the code and its tests | what is built |
| `language_feedback.md`, under `docs/` from its first line | what writing Ernest felt against the principles, a line each, in the shape of Ernest's file of that name, a queue: a line is carried there by copy, the log here cites Ernest's number, and the line then goes; the file goes when it is empty |
| `findings.md`, under `docs/` while a review's findings are open | the findings, each line until a plan item decides it; it goes when every line is done, dropped or planned |

**Proposals.** [`docs/proposals/`](docs/proposals/) holds what is designed, a directory for each: the proposal, its reasons, what other systems do, and its experiments or programs. Each directory's `README.md` says what its files are and which is current.

Until a proposal is decided all of it is tentative, and nothing flows from it into the design, the plan or the log.

A built proposal is kept as the record of its design, its status line saying so, until its milestone's row names the log entries that argue it and nothing else cites the directory; then it goes, after a reading decided with the user of what it holds that no owner has yet, an experiment's finding or a table of what other systems do, which goes first to `docs/design.md` or the log.

A `scratch/` directory inside a proposal's own directory, untracked, is the user's own thinking: no session edits it, commits it or builds on it.

**Where a sentence goes.** Decide the owner before you write. What will be built and when goes in the plan; why goes in the log; a paragraph that does both is split at that line. A decision the user must see goes in the plan, in one sentence, with the design section that states it and the log entry that argues it.

## The repository

- The program is Ernest, written for one floor of `ern`, which the Makefile names. `make` builds; `make test` tests; `make run` runs; [`README.md`](README.md)'s *Building* names the rest. Everything beyond the standard library that the program loads stands under `lib/`, which `make lib` fills: Ernest's own libraries, each dependency as its release archive unpacks, and each Erlang application the program stands on, a read-only git submodule under `erl/`, pinned and never copied, built by its own `make`.
- Work in the main checkout, on `main`. No worktree and no branch of a session's own: the user reads and edits this checkout.
- A coding job of many steps goes to an agent, so that the discussion with the user goes on while it runs. The agent follows this file, and its report comes back to the user. Where the work changes kind, between design or prose on one side and a build from a settled brief on the other, say in one line which model the next piece wants before starting it.
- A commit names its paths, `git commit -F message -- path...`, never a bare `git commit` after `git add`. Read `git status --short` first for entries that are not yours, and leave the index as the user left it. The message says what changed in one or two sentences and points to the log or the plan for why.

## Before code

- **The design changes first.** An anomaly found while building changes `docs/design.md`, then the log, then the code. Name the design's section a module implements before writing it.
- **A design is discussed in its proposal until the user says it is ready.** Until then bring nothing of it to the plan, the log or the design. At a pause offer another reading back or a harder question: the principles, a real program written against it, the operator's day.
- **State a change to the design or the plan and make it; do not ask.** Give the change and its argument, make it, report it under *Design conformance*. Stop and wait only where the answer decides what gets built and a guess would throw the work away: a design question, discussed one at a time, in prose, the argument before the verdict, with a recommendation. Smaller decisions come together, as one numbered list with a recommendation each.
- **Leave no decision pending.** A question a step raises is decided in the same turn and recorded in the plan and the log. One that needs the user stands in the plan meanwhile as a named decision in a named milestone, never as "open".

## Design

- **Prefer minimal, direct implementations** over speculative abstraction. A feature enters or stays out by the five principles, and the log names the principle that decided; how many uses ask for it decides nothing.
- **Bring options, not defenses.** When a simplification seems to conflict with a principle, first check whether the principle is being applied too dogmatically.
- **The tools are fast.** A test or a tool that costs more than its work is a defect: measure it, and fix it at its cause or plan it with a date. Every run is timed against its work, and one that costs more is named to the user in the same message.
- **The program is beautiful, inside and out.** Keep no code only to make it go faster; measure first, and where the plain form is fast enough it stays plain.
- **A measurement ends when its number stops deciding anything.** A number that confirms the plain form goes to the log once, and its item closes; following it further is an item of its own, planned with the decision it would change.
- **No fixed sleep, in the code or in a test.** A process waits on what it means: a message, a monitor, a port that answers, a process's end, or a deadline the design states.
- **The program is Ernest.** `foreign` is only what the host alone can do. A function the library lacks is not written in Erlang meanwhile: it goes to `language_feedback.md`, and the program waits or writes it in Ernest.

## Defects and gaps

- **No warts.** Never leave an approximation, a silent deviation from the design, or an unstated semantic choice in the code.
- **Fix a known defect when found.** A gap too large to fix now goes in the plan with a date, never in a comment.
- **Memory that no collection reclaims is a defect, fixed at its cause.** Never fix it by capping a list, a table or a cache.
- **Nothing routes around a defect or a gap of Ernest's.** A defect of the toolchain, a missing function or a feature the language lacks goes to `language_feedback.md` for the user to carry to Ernest, and what needed it says that it waits, in the plan. The program does not fork Ernest and does not work around it.
- **A published specification or a general-purpose engine is a library's work**: a pattern language, a data format, a protocol, dates and times. Where the program finds itself writing one, stop; whether it becomes a library of the program's own, a dependency, or an ask of Ernest is decided with the user first.
- **Writing Ernest tests the language.** Where it feels against a principle, a workaround, a second way, something invisible, a function the library lacks, say so at once, add the line to `language_feedback.md`, and discuss it with the user before any code goes around it.
- **Where the design is silent, add the sentence to the design or reject the input with an error.** Never accept it silently, and state the choice to the user.

## Tests

- **A test lives in the module it tests**, a `let` of type `Test.Case(m)` (Appendix E.24); `test/` holds only a program run end to end, as Ernest modules `ern test` runs. Every section of `docs/design.md` has a test whose comment names it, `// design §2: ...`, a comment and not a doc block, which would put the test on the module's page; and every exported function has one.
- **A test written after the code is a regression test.** Say so, and name what it does not cover.
- **`make test` runs before every commit**, and before the commit that closes a plan item the same from a fresh clone where the item touched the build. Edits to a proposal under discussion are committed at a pause, by their paths.
- **Readers run before a release**, as [`docs/release.md`](docs/release.md) says; a finding is fixed, planned or dropped, and the commit messages say which.

## Writing

- **`docs/design.md` is tight, in a Wirth language report's register.** State the rule; no rationale, no restating. Clear before short. The plan, the log, a proposal and a commit message are plain and short: one point to a sentence, in the order a reader needs it.
- **A paragraph is one turn of the text**, in every document and in a message to the user. A paragraph past about a hundred words, which `make test` lists, is read again for a turn it may hide, and left whole where it holds one thing.
- **The spelling is American English**, in every document, name and message.
- **No document or message names who proposed an idea**, or that person's role; it states the argument.

## Done

- **Read the result back before reporting it**, as a reader who knows Ernest would, against the principles and the design, and say what surprised. Decide every surprise: act on it in the same item or leave it with its reason, recorded where its owner keeps it.
- **Commit only after the checks pass**, never chained after them with `;`. Push only when the user says so, a proposal's pause excepted.
- **Every message that reports code work ends with a "Design conformance" section**: the sections of the design applied; every place the design was silent and what was done, or "none"; every deliberate omission, with the plan item that lifts it; and every line added to `language_feedback.md`, or "none".
- **Stop after each plan item.** Finish it whole, report it, and wait.

**Closing an item.** Each line names a rule above.

1. The design changed first, and every question decided, every gap and needed decision in the plan with its log entry.
2. What writing Ernest felt against a principle in `language_feedback.md`.
3. Every section the item built cited by a test, and a test written after the code called a regression test.
4. A new name in `docs/design.md`'s glossary, used as the glossary has it.
5. The result read back, and every surprise decided.
6. `make test` green; the conformance section written; the same commit removes every sentence elsewhere that says the item still waits; then a commit that names its paths.
7. The report to the user, ending with *Design conformance*, then a stop until the user's word.

## Style

[`docs/style.md`](docs/style.md), Ernest's rules for its programs, imported here. The glossary of this program's own names is `docs/design.md`'s and is living: a name that comes to recur across modules goes in it in the commit that writes it, and is used as it stands.

@docs/style.md
