# FOSSIL PARK — Project Memory & AI Routing Guide

> Permanent Human + AI context hub for the repository. This document routes work; it does not replace `CONTRACTS.md`, `AGENTS.md`, current source, Dev logs, or integration testing.

## 0. Start Here

At the start of every development session:

1. Read this document.
2. Read `AGENTS.md`.
3. Read `CONTRACTS.md`.
4. Inspect the current Git branch, status, and recent relevant history.
5. Read the relevant Dev log and handoff.
6. Inspect the current source related to the task.
7. Identify ownership, authority, dependencies, and contract status before editing.

If a referenced file is absent, report `MISSING CONTEXT FILE`. Do not invent its contents.

## 1. Project Identity and Primary Goal

Fossil Park is a Roblox discovery, excavation, collection, revival, and progression game. The player fantasy is being an explorer who finds known Fossils, revives ancient creatures, discovers rare results, contributes duplicates to Research, and unlocks new ways to play.

The current goal is **Vertical Slice v1**, not the full game. The slice must prove that this loop makes players want to continue:

```text
DIG → FIND → REVIVE → DISCOVER → RESEARCH → BREAKTHROUGH
```

The initial Dig interaction is:

```text
BREAK → READ → STRIKE
```

The first Breakthrough unlocks Pulse as a new `BURST` verb, not merely a larger number.

## 2. Scope Lock

### In Scope

- One Dig Site: Site 1.
- Brittle / TARGET Rock only.
- Strike, Crack, Weak Point, Rock Break, and Fossil Reward.
- Revival Chamber.
- Exactly **2 Species**.
- `Normal` and `Gold` variants only.
- New Discovery and Duplicate.
- Duplicate to Research.
- First Breakthrough and Pulse Module.
- First Session Protection.
- Onboarding state machine and First 10 Minutes.
- Basic Collection integration.
- Locked Site 2 Gate as the endpoint/teaser; do not build Site 2 gameplay.
- Basic persistence, server authority, and anti-exploit validation.

### Optional Supporting Foundations

These may be prepared only when they do not delay or expand the core Vertical Slice:

- Player Profile presentation/integration foundation.
- Title metadata/config foundation.
- Staff/Tester development utilities.
- Integration diagnostics and playtest tooling.

Profile, Title, and Staff Tools are not Vertical Slice exit criteria. Production Title buffs are **OUT OF SCOPE**.

### Out of Scope

- more than 2 Species.
- Rainbow, Mythic, Secret, full Trait, or Mutation systems.
- Combine, Trading, Rebirth, Expedition, or multiple playable Dig Sites.
- Site 2 gameplay.
- Full Museum/Park economy, pet combat, complex shop, or full monetization.
- Full social network, leaderboard, Profile system, or production Title buffs.
- Advanced moderation suite or arbitrary admin command console.
- Final Auto Dig implementation.

If a feature does not prove the core loop, improve the First 10 Minutes, unblock integration, or materially improve testing, backlog it.

## 3. Source-of-Truth Priority

When sources conflict, use this priority:

1. `CONTRACTS.md`.
2. `AGENTS.md` and ownership rules.
3. Current production source code.
4. Explicit current team decision.
5. Current integration handoff and Dev logs.
6. This `PROJECT_MEMORY.md` router.
7. Current GDD/Game Concept.
8. Old notes and deprecated documents.

**AI IS NOT THE SOURCE OF TRUTH.**

**CHAT HISTORY IS NOT THE SOURCE OF TRUTH.**

**CONTRACTS + CURRENT SOURCE + PROJECT MEMORY ARE THE SOURCE OF TRUTH.**

Concept documents describe intent. They do not create production networking, payloads, schemas, enums, or service APIs.

## 4. Server Authority and Domain Ownership

The mandatory rule is:

```text
CLIENT REQUESTS.
SERVER DECIDES.
CLIENT PRESENTS.
```

The server owns authoritative Rock state, validation, rewards, Species/Variant results, New Discovery/Duplicate resolution, Research, Breakthrough, Pulse unlock/use, RNG, First Session Protection, PlayerData, and permanent progression.

The client owns input, UI, animation, VFX, camera, audio, presentation, and requests. It never reports a self-selected reward or permanent progression result.

Only the owner of a domain may write its authoritative state:

| Domain | Authoritative owner |
| --- | --- |
| Player persistence | `PlayerDataService` |
| Rock state | Dig domain / `RockController` |
| Research progress | `ResearchService` |
| Pulse unlock | `ResearchService` |
| Pulse activation | `PulseService` |
| Onboarding state | `OnboardingService` |

Do not create duplicate sources of truth.

## 5. Team Ownership

### Dev 1 — Server / Gameplay Systems

Owns PlayerData, Dig, RockController, Fossil rewards, Revival, Reward Resolution, Research, Breakthrough authority, Pulse, server RNG, persistence, First Session Protection, anti-exploit validation, and server Remote handlers.

If supporting systems become production systems, Dev 1 also owns authoritative Profile snapshots, Title ownership/equip/buffs, Staff roles, permissions, and privileged commands.

### Dev 2 — Client / Gameplay Presentation

Owns Strike input/feedback, camera, Rock/Crack/Weak Point visuals, break and Fossil presentation, Revival UI/animation, Normal/Gold reveal, discovery/duplicate feedback, Research UI, Breakthrough reveal, Pulse UI/VFX/audio, and final Profile/Title presentation.

### Dev 3 — World / Progression / Integration

Owns Site 1 world and blockout, Dig Area layout, spawn/machine/gate placement, `OnboardingService`, onboarding presentation, First 10 Minutes, Species/Collection config coordination, progression flow, world/target guidance, integration hooks, playtest tracking, balance/config, cross-system handoff, and final experience integration.

Supporting ownership includes Profile integration foundation, Title metadata/config foundation, Staff tooling integration, and stable teleport landmarks. Dev 3 does not take Dev 1 gameplay authority or Dev 2 final presentation ownership.

## 6. AI Routing Rules

Before implementation, answer:

```text
WHAT SYSTEM?
→ WHO OWNS IT?
→ CLIENT OR SERVER?
→ AUTHORITATIVE OR PRESENTATION?
→ DOES THE CONTRACT EXIST?
→ IS THE DEPENDENCY READY?
→ IMPLEMENT, PREVIEW, OR WAIT?
```

- Missing production contract: mark `TBD CONTRACT`; do not invent it.
- Missing dependency: build only a clearly labelled `DEV PREVIEW ONLY` fixture or local presentation boundary when useful.
- Another Dev's domain: stop at the integration boundary unless ownership is explicitly reassigned.
- Existing architecture: inspect it before proposing replacement or refactoring.

## 7. Cross-Dev Integration Maps

### Dig

```text
Dev 2 Strike Input
→ Dev 1 validates through DigService / RockController
→ authoritative Rock state and Fossil reward
→ Dev 2 presents Crack / Weak Point / Break / Fossil
→ Dev 3 advances the player journey from validated events
```

### Revival

```text
Dev 3 Revival Chamber journey
→ Dev 1 validates Fossil and resolves RevivalResult
→ Dev 2 presents Species / Variant / New or Duplicate
→ Dev 3 advances onboarding from the validated result
```

### Research

```text
Dev 3 guides Duplicate to Research Machine
→ Dev 1 ResearchService validates and changes Research
→ Dev 2 presents progress and completion
→ Dev 3 continues the journey from authoritative completion
```

### Breakthrough / Pulse

```text
Dev 1 resolves Breakthrough and authoritative Pulse unlock/use
→ Dev 2 presents Breakthrough and Pulse
→ Dev 3 transitions onboarding into FreePlay
```

No developer creates a private production payload to bypass a missing contract.

## 8. Locked Contracts

### Official Onboarding States

```text
FirstDig
FirstFossil
FirstRevival
NewDiscovery
FirstDuplicate
ResearchPrompt
ResearchComplete
Breakthrough
PulseUnlocked
FreePlay
GateSeen
```

These are the official 11 states. Experiential beats such as First Pulse or Gold Moment are not new production states unless `CONTRACTS.md` is formally changed.

### Official Rock States

```text
Idle
Damaged
WeakPointVisible
Broken
```

### Variant Contract

```text
Normal
Gold
```

Vertical Slice uses exactly two Species. Current `species_a` and `species_b` IDs are temporary until team confirmation.

## 9. Development Preview vs Production

### DEV PREVIEW ONLY

Allowed: static fixture, local placeholder data, presentation preview, Command Bar helper, timing debug, and visual simulation.

Forbidden: real reward, authoritative state mutation, permanent save, automatic unlock, client-authored progression, or accidental production dependency.

### Production

```text
Validated Request
→ Authoritative Domain Owner
→ Authoritative State/Result
→ Contracted Replication
→ Client Presentation
```

Preview shapes are not production payload contracts.

## 10. TBD Contract Rule

If implementation requires a missing RemoteEvent, RemoteFunction, payload, persistent field, enum, service API, or authoritative replication path:

```text
BLOCKED CONTRACT:
<missing boundary>

OWNER:
<Dev 1 / Dev 2 / Dev 3 / Team>

REQUIRED DECISION:
<what must be agreed>
```

Contract changes follow:

```text
PROPOSE → TEAM REVIEW → UPDATE CONTRACTS.md → IMPLEMENT → INTEGRATION TEST
```

Never implement first and rewrite the contract afterward to justify it.

## 11. Git Workflow

```text
dev1/* ───────────────┐
dev2/* ───────────────┼→ integration → main
dev3/world-progression┘
```

- `main`: stable/demo-ready, not daily development.
- `integration`: shared assembly and integration testing.
- Dev branches: role/feature work.

Before editing, inspect branch, status, recent history, and uncommitted work. Do not overwrite unknown changes. Do not run destructive reset, clean, shared-branch rebase, force-push, branch deletion, commit, push, or PR creation without explicit authorization.

## 12. Session Start Protocol

```text
SESSION BOOT

Project: Fossil Park
Goal: Vertical Slice v1
Role: <Dev / reviewer / integration assistant>
Read: PROJECT_MEMORY, AGENTS, CONTRACTS, relevant log/handoff/source
Git: <branch, status, HEAD, uncommitted work>
Current milestone: <evidence-based milestone>
Task: <current request>
Dependencies: <owners and systems>
Contract status: READY / TBD CONTRACT
```

Fetch only when appropriate and do not modify or discard existing work to make the tree clean.

## 13. Session End Protocol

Required when project files were modified:

```text
SESSION END

DONE:
FILES CREATED:
FILES MODIFIED:
TESTED:
NOT TESTED:
WAITING DEV1:
WAITING DEV2:
WAITING DEV3:
TBD CONTRACT:
ARCHITECTURE CONCERNS:
GIT STATUS:
NEXT RECOMMENDED STEP:
```

Use exact status tags: `DONE`, `IN PROGRESS`, `READY TO INTEGRATE`, `WAITING DEV1`, `WAITING DEV2`, `WAITING DEV3`, `BLOCKED CONTRACT`, `DEV PREVIEW ONLY`, `TBD`, `DEPRECATED`, and `OUT OF SCOPE`.

## 14. Handoff Format

```text
HANDOFF

SYSTEM:
OWNER:
STATUS:
WHAT WORKS:
WHAT IS MOCK:
AUTHORITATIVE SOURCE:
CLIENT ENTRY POINT:
SERVER ENTRY POINT:
CONTRACT:
TEST METHOD:
KNOWN ISSUES:
NEXT INTEGRATION:
```

Do not hand off with an unsupported claim such as “done, pull and test.”

## 15. Milestone Map

| Milestone | Goal |
| --- | --- |
| M1 | Foundation / World / Onboarding |
| M2 | Core Dig: Strike, Weak Point, Break, Fossil |
| M3 | Revival / Discovery / Duplicate |
| M4 | Duplicate / Research / Research Complete |
| M5 | Breakthrough / Pulse / FreePlay |
| M6 | Basic Collection / Site 2 Gate / GateSeen |
| M7 | Persistence / Rejoin |
| M8 | Full Vertical Slice Integration without mocks |
| M9 | First 10 Minutes playtest and polish |
| M10 | Release Candidate |

Milestones describe integration capability, not calendar days. Independent preview foundations do not prove production milestone completion.

## 16. Current Project State

**LAST UPDATED:** 2026-08-29

**CURRENT PRIMARY MILESTONE:** M5 — Dev 3 Breakthrough/Pulse/FreePlay presentation foundation is present as uncommitted work. Production milestones M2–M5 remain blocked on authoritative systems and contracts.

**LAST STABLE INTEGRATION:** `43a0dd9` — `feat: add Dev3 research progression foundation` (HEAD; also referenced by `integration`, `origin/integration`, and `origin/dev3/world-progression` at inspection time).

### Dev 1

**DONE:**

- Experimental RNG prototype remains isolated outside production loading.
- No repository evidence supports completion of production Dig, Revival, Research, Breakthrough, Pulse, persistence, or First Session Protection services.

**DOING:**

- UNKNOWN — requires Dev 1 update.

**BLOCKED:**

- UNKNOWN — requires Dev 1 update. Shared production integration is blocked by the TBD contracts listed below.

**READY TO INTEGRATE:**

- UNKNOWN — requires Dev 1 update.

### Dev 2

**DONE:**

- UNKNOWN — requires Dev 2 update. The repository contains Dev 3 placeholder presentation, not evidence of final Dev 2 gameplay/UI/VFX work.

**DOING:**

- UNKNOWN — requires Dev 2 update.

**BLOCKED:**

- UNKNOWN — requires Dev 2 update.

**READY TO INTEGRATE:**

- UNKNOWN — requires Dev 2 update.

### Dev 3

**DONE:**

- Site 1 runtime blockout with stable `PlayerSpawn`, `DigArea`, `RevivalChamber`, `ResearchMachine`, and `Site2Gate` landmarks.
- In-memory server onboarding skeleton containing all 11 contracted states and Studio mock transitions.
- Client-only placeholder interaction shell, onboarding presentation, target resolver, reusable Highlight, and distance guidance.
- Exactly-two-Species config, basic Collection presentation config, and Revival preview fixtures.
- First Session presentation/timing config and Studio-local record-once timing tracker.
- Research presentation config/fixtures and Research journey foundation through `ResearchComplete` at stable HEAD.
- Dev 1 integration handoff and shared team roadmap.

**DOING:**

- Uncommitted M5 documentation/presentation foundation for `ResearchComplete → Breakthrough → PulseUnlocked → FreePlay`, including static non-contract fixtures.
- Permanent repository memory/routing setup in this documentation task.

**BLOCKED:**

- Production onboarding integration waits for validated Dev 1 domain events, persistence, and an agreed authoritative server-to-client onboarding state path.
- Final interaction and reward presentation waits for Dev 2 production UI/VFX integration.

**READY TO INTEGRATE:**

- Site 1 landmark/config boundaries, world targeting, onboarding presentation preview, First 10 Minutes timing hooks, two-slot Collection presentation metadata, Revival/Research/Breakthrough dev fixtures, and Dev 3 handoff documentation.

### Team Blockers

- `CONTRACTS.md` is still DRAFT v0.1.
- No repository-supported production gameplay services implement the end-to-end loop.
- Dev 1 and Dev 2 current branch/work status is not represented by current repository logs.
- Rojo/Studio smoke-test evidence is incomplete for the current Dev 3 foundations.

### TBD Contracts

- Final Species IDs.
- Authoritative `Collection` and `Fossils` structures.
- Exact request/event payloads other than the currently documented `RevivalResult` fields.
- Validation rules and DataStore persistence format.
- Authoritative onboarding persistence and server-to-client replication path.
- Breakthrough result payload and Research-to-Breakthrough transition boundary.
- Pulse unlock/state payload and Pulse activation request/result contracts.
- Exact `GateSeen` / First Session Protection production integration and shutdown authority.
- Profile, Title, and Staff production schemas/APIs if those optional foundations are later productionized.

### Next Integration Target

Contract review with Dev 1 and Dev 2: confirm authoritative domain events, onboarding replication/persistence, final Species IDs, and the first production payload boundary. Then integrate the smallest end-to-end M2 slice: Strike validation → Rock states → Fossil reward → `FirstFossil` journey.

## 17. Memory Update Protocol

- `PROJECT_MEMORY.md`: update only milestone state, team blockers, major architectural decisions, current priority, and routing information.
- `DEV1_LOG.md`, `DEV2_LOG.md`, `DEV3_LOG.md`: detailed implementation memory for each owner.
- `INTEGRATION_HANDOFF.md`: current cross-owner interface and test handoff.
- `CONTRACTS.md`: update only after a real team contract decision.
- Source and Git history: implementation evidence.

Do not turn memory into a dump of every command, typo, discarded experiment, or temporary Output line. Update status only from repository or explicit team evidence; otherwise write `UNKNOWN`.

## 18. Anti-Drift and Anti-Scope-Creep

Do not replace architecture because another pattern seems cleaner. Refactor only when the task requires it, ownership allows it, contracts remain valid, a real issue is demonstrated, and migration cost is considered.

Before adding a feature, ask:

1. Does it prove the Vertical Slice core loop?
2. Does it unblock integration?
3. Does it improve the First 10 Minutes?
4. Does it materially improve testing?

If not, mark it `OUT OF SCOPE` or backlog it.

## 19. Testing Rule and Definition of Done

Use validation proportional to the work:

```text
Static/diff check
→ Rojo sync/build
→ Studio Play
→ Output check
→ cross-system integration test
→ multiplayer test when authority is involved
```

Code is not done merely because syntax appears correct. A feature is `DONE` only when:

- Ownership and server/client boundaries are correct.
- The contract is respected and no authoritative state is duplicated.
- Implementation is complete for the requested scope.
- Rojo sync/build and appropriate Studio tests pass.
- Output contains no relevant major errors.
- Adjacent integration works.
- The First 10 Minutes, No Punishment rule, and scope lock remain intact.

## 20. Profile / Title / Staff Routing

| Area | Dev 1 | Dev 2 | Dev 3 |
| --- | --- | --- | --- |
| Profile | Authoritative public snapshot | Final UI/presentation | Config/integration foundation |
| Title | Ownership, equip validation, future buff | Title/badge presentation | Metadata/config foundation |
| Staff Tools | Role, permission, privileged actions | Visual polish when assigned | Tool integration and landmark workflow |

Staff movement/teleport must use server-validated roles, allowlisted presets, and stable landmark IDs. Never accept arbitrary client speed or CFrame. Title gameplay buffs remain `OUT OF SCOPE` for Vertical Slice v1.

## 21. Final AI Decision Tree

```text
Is it in Vertical Slice or an explicitly allowed supporting foundation?
├─ NO → BACKLOG / OUT OF SCOPE
└─ YES
   ↓
Who owns it?
   ↓
Does the production contract exist?
├─ NO → TBD CONTRACT; preview/mock only when useful
└─ YES
   ↓
Is the dependency ready?
├─ NO → build only independent in-scope foundation or wait
└─ YES
   ↓
Inspect existing code
→ Implement the smallest compatible change
→ Validate
→ Log important state
→ Handoff
→ Integrate
```

The North Star remains: prove that `DIG → REVIVE → DISCOVER → RESEARCH → BREAKTHROUGH → PULSE` makes players voluntarily continue.
