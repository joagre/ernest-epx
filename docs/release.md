# The release

What a release runs to be ready, and nothing else. Between releases a change runs `make test` before every commit (CLAUDE.md, *Tests*).

1. **A fresh clone builds and passes:** `git clone`, then `make test`, in a directory of its own.
2. **Two readers**, each a session of its own, given its brief and the files it reads, and nothing that argues for them: a cold reader, who reads `README.md` and runs the program as a user would; and a code reader, who reads `src/` against `design.md`, the report's §0 and Appendix E.0's shape rules. Each hands in a numbered list, most serious first: a finding gives its place, a short quote, what is wrong, and a one-line fix.
3. **The findings:** a defect is fixed or planned in a milestone; clarity is fixed where it is cheap, and otherwise dropped. The lines stand in `findings.md` until each is done, and the commit messages say which.
4. **The release:** `VERSION` set, the tag, and the archive `make release` writes, `build/<name>-<version>.tar.gz`, published beside the tag so that another repository's `make lib` can name it.
5. **The notes** say what the release is and what a program or an operator of the previous release changes, and list none of the changes.
6. **`language_feedback.md`'s lines carried to Ernest**, so that a release leaves nothing the language has not heard.
