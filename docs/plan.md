# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Begun from `ernest-template` on 2026-10-20; nothing is built yet. The first milestone is the library's design, discussed in a proposal before a function is declared.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|

## Milestone 1: the design

1. **What the library offers**, discussed in a proposal under `docs/proposals/`: which of epx's operations, pixmaps and pixels first, and in what Ernest shape, each a shim where epx's function does exactly its work and Ernest around it where not; then stated in `design.md`.
2. **How epx is found**, a decision of the proposal: epx is Erlang with a NIF, built by rebar3, which `make lib` does not fetch and `lib/*/build` does not describe, and a `foreign fn` finds its module as a `.beam` on the load path (report §8.4, §11.2) while the NIF's library is found from the application's `priv/` by the host. Recommended: decided by trying it, a built epx under `lib/epx/` with its `ebin/` on the load path, before the shape of the Makefile's rule is chosen; what is learned goes back to `ernest-template`.
3. **The first module**, `Epx` with pixmaps, their tests and `make test` green.
