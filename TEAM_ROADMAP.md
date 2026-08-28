# FOSSIL PARK — Team Day-by-Day Roadmap

> Shared implementation plan for Vertical Slice v1. Last repository review: 2026-08-28.
>
> Status in this document describes repository evidence, not verbal completion claims. `CONTRACTS.md` remains DRAFT v0.1.

## Status Legend

- **DONE** — implementation or documentation exists in the repository.
- **IN PROGRESS** — implementation exists but still needs its stated validation or integration.
- **TODO** — no supporting implementation was found.
- **BLOCKED** — cannot proceed safely until a named dependency is resolved.
- **TBD CONTRACT** — the production interface, payload, or schema is not yet locked in `CONTRACTS.md`.

## Current Repository Baseline

- **DONE:** Rojo project mapping, server/client service loaders, shared config structure, ownership documentation, and the Contract Day draft exist.
- **IN PROGRESS:** Site 1 blockout, spawn, Dig Area, Revival Chamber, Research Machine, Site 2 Gate, interaction shell, onboarding presentation, target resolver, Highlight/distance guidance, and Command Bar previews exist but still require Studio/Rojo smoke-test confirmation.
- **DONE (skeleton only):** `OnboardingService` contains the 11 contracted states and in-memory ordered transitions. It is not production-integrated or persistent.
- **DONE (config only):** `SpeciesConfig` contains exactly two temporary IDs, `species_a` and `species_b`.
- **TODO:** production Dig, RockController, fossil reward, Revival, discovery/duplicate resolution, Research, Breakthrough, Pulse, Collection data integration, persistence, final Dev 2 presentation, and end-to-end gameplay.
- **TBD CONTRACT:** final species IDs, `Collection`/`Fossils` schemas, request/event payloads, validation rules, persistence format, and authoritative onboarding replication path.
- **BLOCKED:** production onboarding event integration waits for validated Dev 1 domain events and an agreed server-to-client state path.
- **Isolated:** the RNG prototype under `Experimental` is not loaded. `RNGResult` and its rarity outcomes conflict with the current contract and must not become a production dependency.

## Authoritative Ownership

- Dev 1 owns backend/server/game logic, RNG, validation, persistence, and server Remote handlers.
- Dev 2 owns client input, UI, gameplay feedback, VFX, sound, and presentation.
- Dev 3 owns onboarding state integration, world, progression flow, config, First 10 Minutes, and final experience integration.
- Only the owning service may write authoritative domain state. The client presents server results and never determines permanent progression.

## PARALLEL DEVELOPMENT RULE

Nobody needs to wait for another developer's entire feature to finish. Dev 1 can build authoritative logic, Dev 2 can build presentation against an agreed mock interface, and Dev 3 can build world/onboarding presentation through the existing preview boundary.

As soon as two compatible pieces are ready:

1. Inspect the other developer's changes.
2. Verify names and ownership against `CONTRACTS.md`.
3. Agree on the interface or networking contract.
4. Integrate only the compatible boundary.
5. Run a Studio smoke test together.
6. Commit the integration as an explicit checkpoint.
7. Continue independent work.

If the contract is not agreed, do not invent a production interface. Keep a clearly labeled preview/mock boundary and mark the work **TBD CONTRACT**.

## Daily Team Sync

Copy this into Discord:

```text
DONE:
DOING:
BLOCKED:
CHANGED CONTRACT:
READY TO INTEGRATE:
```

# Day 1 — Foundation / Contract / World

## Goal

Establish a shared repository structure, ownership boundary, and testable Site 1/onboarding foundation without claiming gameplay completion.

## Dev 1 — Backend / Server

- [x] **DONE:** Preserve the experimental RNG prototype outside production service loading.
- [ ] **TBD CONTRACT:** Review and confirm PlayerData, Remote payloads, validation rules, persistence format, and final species IDs.
- [ ] **TODO:** Confirm the domain-event hooks Dev 3 may consume without transferring state ownership.
- [ ] **TODO:** Confirm the authoritative onboarding replication approach.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Review the temporary interaction/onboarding shell and identify the replacement boundary for final UI.
- [ ] **TODO:** Confirm how mock presentation events will mirror future authoritative results.
- [ ] **TBD CONTRACT:** Agree with Dev 1 on client-facing payloads before production input or presentation wiring.

## Dev 3 — Integration / World / Progression

- [x] **DONE:** Create Site 1 static config and runtime blockout service.
- [x] **DONE:** Place one spawn, Dig Area, Revival Chamber, Research Machine, and locked Site 2 Gate.
- [x] **DONE:** Create the service-loader-compatible onboarding state machine skeleton.
- [x] **DONE:** Add presentation config for all 11 contracted onboarding states.
- [x] **DONE:** Add the temporary interaction shell and local preview panels.
- [x] **DONE:** Add target resolution, one reusable client Highlight, and distance guidance.
- [x] **DONE:** Add Command Bar preview support and Dev 1 integration handoff.
- [ ] **IN PROGRESS:** Complete the documented Rojo/Studio smoke test and record results.

## Integration Points

The world exposes stable prototype target names under `Workspace.Site1Blockout`. Dev 3 preview code may target these objects locally. Dev 1 and Dev 2 should inspect `DEV1_INTEGRATION_HANDOFF.md` before connecting production systems.

## Dependencies / Blockers

- **READY:** Repository structure, loaders, world config, and preview boundaries.
- **TBD CONTRACT:** Production payloads and onboarding replication.
- **BLOCKED:** Production onboarding integration until Dev 1 emits validated events.
- **WAITING DEV2:** Replacement plan for temporary interaction and onboarding presentation.

## Studio Test

1. Build/sync with Rojo and press Play.
2. Confirm `Workspace.Site1Blockout` contains the five expected journey landmarks.
3. Confirm the player spawns at `PlayerSpawn` facing the Dig Area.
4. Confirm all four proximity prompts and placeholder panels work without granting rewards.
5. Exercise server onboarding mock transitions and client preview states independently.
6. Confirm only one client Highlight exists and no Experimental RNG module loads.

## Exit Criteria

- [ ] Site 1 and both service loaders run without Output errors.
- [ ] All preview targets resolve and all 11 presentation states can be inspected.
- [ ] Team accepts the listed ownership and unresolved contract checklist.
- [ ] Experimental RNG remains isolated.

## Git / Handoff

Share the Day 1 checkpoint and `DEV1_INTEGRATION_HANDOFF.md` for review. Each developer inspects changes before integrating; do not blindly merge branches.

# Day 2 — Core Dig Loop

## Goal

Make `BREAK → READ → STRIKE` playable and award the first fossil through server-authoritative logic.

## Dev 1 — Backend / Server

- [ ] **TODO:** Implement `DigService` and the server `RockController`.
- [ ] **TODO:** Implement exact states `Idle`, `Damaged`, `WeakPointVisible`, and `Broken`.
- [ ] **TODO:** Validate strike origin, target, range/rate, rock eligibility, damage, Weak Point hits, and break transitions.
- [ ] **TODO:** Resolve fossil rewards and RNG exclusively on the server.
- [ ] **TODO:** Emit a validated fossil-found domain event for onboarding.
- [ ] **TBD CONTRACT:** Lock request/event payloads before production networking.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Implement strike input that requests action but never applies authoritative damage.
- [ ] **TODO:** Present immediate strike and camera feedback.
- [ ] **TODO:** Present damage/crack states from authoritative rock updates.
- [ ] **TODO:** Present a readable Weak Point and satisfying break/fossil reveal.
- [ ] **TODO:** Verify missing a Weak Point loses only the bonus.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Bind production rocks to the Dig Area without changing Dev 1 rock ownership.
- [ ] **TODO:** Validate world spacing, interaction range, target selection, and player approach angles.
- [ ] **TODO:** Connect validated first-dig/fossil events to `FirstDig → FirstFossil` through `OnboardingService`.
- [ ] **TODO:** Change the onboarding target from Dig Area to Revival Chamber after the authoritative fossil event.
- [ ] **TODO:** Record First 10 Minutes timing observations.
- [ ] **BLOCKED:** Use preview/mock presentation only until networking is contracted.

## Integration Points

```text
Dev 2 Strike Input
→ Dev 1 validated strike and Rock state
→ Dev 2 crack / Weak Point / break presentation

Dev 1 Fossil Reward
→ validated server domain event
→ Dev 3 OnboardingService advances to FirstFossil
→ Dev 3 target changes to Revival Chamber
```

Production Remote payloads remain **TBD CONTRACT**; the roadmap does not define them.

## Dependencies / Blockers

- **READY:** Dig Area blockout and onboarding preview presentation.
- **TBD CONTRACT:** Strike and rock-state payloads; fossil inventory schema.
- **WAITING DEV1:** Authoritative RockController, reward result, and domain events.
- **WAITING DEV2:** Final input and gameplay feedback.

## Studio Test

1. Strike only an eligible nearby rock and reject invalid/rate-limited requests.
2. Observe all four rock states in order.
3. Hit and intentionally miss Weak Points; both paths must still break the rock.
4. Confirm one server-authoritative fossil reward and no client-side RNG.
5. Confirm onboarding advances once and points to the Revival Chamber.

## Exit Criteria

- [ ] One Brittle/TARGET rock is playable through break and fossil reward.
- [ ] The server rejects invalid strikes and owns every state/reward transition.
- [ ] Dev 2 presentation follows authoritative results.
- [ ] Dev 3 onboarding changes target exactly once after the validated fossil event.

## Git / Handoff

Share separate backend, presentation, and world/onboarding checkpoints. Create an integration checkpoint only after contract review and the Studio smoke test.

# Day 3 — Revival + Discovery

## Goal

Complete `Fossil → Revival → Species → Normal/Gold → New Discovery/Duplicate`.

## Dev 1 — Backend / Server

- [ ] **TODO:** Implement `RevivalService` and `RewardResolutionService`.
- [ ] **TODO:** Validate fossil ownership and consume/resolve it authoritatively.
- [ ] **TODO:** Resolve exactly two species and only `Normal`/`Gold` variants server-side.
- [ ] **TODO:** Determine New Discovery versus Duplicate from authoritative data.
- [ ] **TODO:** Return the contracted `RevivalResult` fields.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Implement Revival interaction presentation and UI.
- [ ] **TODO:** Add anticipation animation without excessive passive wait.
- [ ] **TODO:** Present species, Normal/Gold, New Discovery, and Duplicate results distinctly.
- [ ] **TODO:** Ensure the client never chooses or alters the result.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Connect the Revival Chamber interaction to the agreed production boundary.
- [ ] **TODO:** Integrate `FirstFossil → FirstRevival → NewDiscovery` from validated events.
- [ ] **TODO:** Prepare basic Collection metadata against the final schema.
- [ ] **TODO:** Replace temporary species display names only after team confirmation.
- [ ] **TODO:** Validate target transitions and First 10 Minutes pacing.

## Integration Points

Dev 1 resolves `RevivalResult`; Dev 2 presents that immutable result; Dev 3 advances onboarding from validated server events and updates the world target. No client module determines species, variant, discovery, or duplicate status.

## Dependencies / Blockers

- **READY:** Revival Chamber blockout and contracted `RevivalResult` shape.
- **TBD CONTRACT:** Final species IDs and `Collection`/`Fossils` structures.
- **WAITING DEV1:** Revival authority and validated domain events.
- **WAITING DEV2:** Final reveal presentation.

## Studio Test

1. Reject revival without an owned fossil.
2. Exercise both species, both allowed variants, New Discovery, and Duplicate outcomes using server test controls.
3. Confirm no third species or unsupported variant appears.
4. Confirm onboarding and Collection presentation consume the same authoritative result.

## Exit Criteria

- [ ] A fossil can be revived into a server-selected contracted result.
- [ ] Normal and Gold are visually distinct.
- [ ] New Discovery and Duplicate are correctly classified and presented.
- [ ] Onboarding reaches `NewDiscovery` without client-authored progression.

## Git / Handoff

Share result fixtures/test controls with Dev 2 and Dev 3. Integrate only against the reviewed `RevivalResult` contract.

# Day 4 — Duplicate → Research

## Goal

Turn an authoritative Duplicate into Research progress and Research Complete.

## Dev 1 — Backend / Server

- [ ] **TODO:** Implement authoritative duplicate handling and `ResearchService`.
- [ ] **TODO:** Validate ownership, eligibility, single consumption, progress, and completion.
- [ ] **TODO:** Ensure only `ResearchService` writes research progress.
- [ ] **TBD CONTRACT:** Lock research request/event payloads and required Collection/Fossils fields.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Present Duplicate clearly after Revival.
- [ ] **TODO:** Implement the simple `RESEARCH THIS!` flow and progress presentation.
- [ ] **TODO:** Present Research Complete without a complex checklist.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Integrate `FirstDuplicate` and `ResearchPrompt` onboarding states.
- [ ] **TODO:** Target the Research Machine and validate the walking route.
- [ ] **TODO:** Advance to `ResearchComplete` only from Dev 1's validated completion event.
- [ ] **TODO:** Record elapsed time and navigation confusion.

## Integration Points

Dev 1 marks the reward as Duplicate and validates the feed; Dev 2 presents the action/result; Dev 3 guides the player to the Research Machine and advances onboarding from the authoritative completion event.

## Dependencies / Blockers

- **WAITING DEV1:** Duplicate inventory representation and ResearchService.
- **WAITING DEV2:** Research presentation.
- **TBD CONTRACT:** `RequestResearchFeed` and `ResearchProgress` payloads.
- **BLOCKED:** Production Research integration until Collection/Fossils ownership fields are agreed.

## Studio Test

1. Reject non-owned, non-duplicate, repeated, or malformed feeds.
2. Confirm accepted feeds change progress exactly once.
3. Confirm UI mirrors server progress and completion.
4. Confirm onboarding points to the machine and cannot skip required states.

## Exit Criteria

- [ ] A Duplicate contributes once to authoritative Research.
- [ ] Research progress and completion are visible and consistent.
- [ ] Onboarding reaches `ResearchComplete` in the contracted order.

## Git / Handoff

Document the accepted research boundary and test cases. Integrate after Dev 1/Dev 2/Dev 3 review; do not merge unreviewed branches.

# Day 5 — Breakthrough + Pulse

## Goal

Complete `Research Complete → Breakthrough → PulseUnlocked → FreePlay` and add the BURST gameplay verb.

## Dev 1 — Backend / Server

- [ ] **TODO:** Resolve the first Breakthrough in `ResearchService`.
- [ ] **TODO:** Write `PulseUnlocked` authoritatively through the owning service path.
- [ ] **TODO:** Implement `PulseService` charge and activation validation.
- [ ] **TODO:** Integrate First Session Protection pacing without client authority.
- [ ] **TBD CONTRACT:** Lock Pulse request/event payloads.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Present Breakthrough and Pulse unlock as distinct reward moments.
- [ ] **TODO:** Implement Pulse charge, ready, activation, burst VFX, and audio hooks.
- [ ] **TODO:** Make Pulse visibly add an action, not merely display a larger number.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Integrate `Breakthrough`, `PulseUnlocked`, and `FreePlay` onboarding transitions.
- [ ] **TODO:** Update guidance/world reactions without creating Pulse authority.
- [ ] **TODO:** Connect the First Session Protection handoff boundary conceptually to onboarding milestones.

## Integration Points

ResearchService owns unlock; PulseService validates use; Dev 2 presents charge/burst; OnboardingService observes validated events and changes only onboarding state. Pulse does not alter Gold odds.

## Dependencies / Blockers

- **WAITING DEV1:** Research completion, Pulse unlock, Pulse activation, protection logic.
- **WAITING DEV2:** Breakthrough/Pulse presentation.
- **TBD CONTRACT:** `PulseReady` and `RequestPulseActivate` payloads.

## Studio Test

1. Reject Pulse before unlock or before sufficient charge.
2. Unlock once from the first completed Research breakthrough.
3. Confirm charge, ready, and burst presentation follow server results.
4. Confirm Pulse changes interaction but not Gold RNG.
5. Confirm onboarding enters FreePlay once.

## Exit Criteria

- [ ] The first Breakthrough unlocks Pulse authoritatively.
- [ ] Pulse has a validated charge/activate/burst loop.
- [ ] Presentation clearly communicates the new gameplay verb.
- [ ] Onboarding reaches `FreePlay` without duplicate transitions.

## Git / Handoff

Share a focused Pulse integration checkpoint with authority tests. Preserve separate ownership of unlock state, activation, presentation, and onboarding.

# Day 6 — Collection + Site 2 Gate

## Goal

Complete the Vertical Slice ending presentation without making Site 2 playable.

## Dev 1 — Backend / Server

- [ ] **TODO:** Expose authoritative discovery/Collection data through the agreed architecture.
- [ ] **TODO:** Support the persistence fields required by basic Collection.
- [ ] **TODO:** Connect `GateSeen` to First Session Protection shutdown if required by the agreed server design.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Implement basic discovered/undiscovered Collection presentation if assigned to Dev 2.
- [ ] **TODO:** Polish Normal/Gold recognition for the two species.
- [ ] **TODO:** Present the locked Site 2 endpoint without implying playable content.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Integrate basic Collection config for exactly two species.
- [ ] **TODO:** Present authoritative `0/2 → 1/2 → 2/2` discovery progress.
- [ ] **TODO:** Integrate the existing locked Site 2 Gate and `GateSeen` state.
- [ ] **TODO:** Validate the First 10 Minutes endpoint and cliffhanger.
- [ ] **TODO:** Do not build Site 2.

## Integration Points

Dev 1 exposes authoritative discovery state; Dev 2 presents Collection and gate feedback; Dev 3 maps the two-species config, world target, and `GateSeen` onboarding endpoint.

## Dependencies / Blockers

- **READY:** Site 2 Gate blockout and two-entry temporary species config.
- **TBD CONTRACT:** Final Collection schema and species IDs.
- **WAITING DEV1:** Authoritative Collection state and protection exit hook.
- **WAITING DEV2:** Basic Collection/gate presentation.

## Studio Test

1. Verify 0/2, 1/2, and 2/2 derive from authoritative discoveries.
2. Verify Normal and Gold variants display correctly without adding species count.
3. Reach the gate, enter `GateSeen`, and confirm the gate stays locked.
4. Confirm First Session Protection disables through the agreed server-owned path.

## Exit Criteria

- [ ] Basic Collection reflects exactly two authoritative species.
- [ ] Site 2 Gate provides a clear locked endpoint and Site 2 is not playable.
- [ ] `GateSeen` is reached and the protection exit behavior is verified.

## Git / Handoff

Share Collection and gate checkpoints with screenshots/test notes. Do not add Site 2 content or merge unrelated feature work.

# Day 7 — Persistence + Rejoin

## Goal

Make contracted progression survive leave/rejoin while preserving domain ownership.

## Dev 1 — Backend / Server

- [ ] **TODO:** Implement `PlayerDataService`, persistence, validation, and safe defaults.
- [ ] **TODO:** Persist onboarding, discoveries, Research, Pulse unlock, and protection state.
- [ ] **TODO:** Handle load failure and malformed/old data safely.
- [ ] **TBD CONTRACT:** Finalize DataStore persistence format and nested schemas.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Initialize UI only from replicated authoritative state.
- [ ] **TODO:** Avoid replaying one-time reveal effects on ordinary rejoin unless explicitly intended.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Test new player initialization.
- [ ] **TODO:** Test leaving during `FirstDig`, after `FirstFossil`, and before Research.
- [ ] **TODO:** Test rejoin with Pulse already unlocked, FreePlay reached, and GateSeen reached.
- [ ] **TODO:** Resume appropriate presentation without creating another save system.

## Integration Points

PlayerDataService persists data owned by each domain through agreed APIs; OnboardingService remains the onboarding writer; Dev 2 and Dev 3 consume replicated authoritative state after load.

## Dependencies / Blockers

- **TBD CONTRACT:** Persistence format, Collection/Fossils schemas, and replication path.
- **WAITING DEV1:** PlayerDataService and load/save lifecycle.
- **WAITING DEV2:** State-driven UI initialization.

## Studio Test

Run isolated profiles for each listed leave/rejoin milestone. Confirm no duplicated rewards, skipped progression, repeated unlocks, or client-authored corrections. Inspect server Output for load/save failures.

## Exit Criteria

- [ ] Every contracted milestone resumes at the correct state.
- [ ] Research, discoveries, Pulse, and protection state persist consistently.
- [ ] Failed data operations use safe behavior and produce actionable diagnostics.

## Git / Handoff

Share persistence test evidence without exposing live keys or player data. Integrate only after schema review and migration/default checks.

# Day 8 — Full Vertical Slice Integration

## Goal

Run the entire experience without preview/mock dependencies in normal gameplay.

## Dev 1 — Backend / Server

- [ ] **TODO:** Connect all authoritative domain services and remove production reliance on stubs.
- [ ] **TODO:** Audit validation, duplicate processing, server RNG, and persistence boundaries.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Connect all input and presentation to authoritative results.
- [ ] **TODO:** Check duplicated UI, VFX, Highlights, and event subscriptions.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Connect the complete onboarding/world journey to real events.
- [ ] **TODO:** Remove normal-play dependence on the Dev 3 preview shell.
- [ ] **TODO:** Keep preview tools only if clearly development-only and isolated.
- [ ] **TODO:** Validate respawn, reconnect, targets, state order, and endpoint.

## Integration Points

```text
Spawn → FirstDig → Strike → Weak Point → Break → Fossil
→ Revival → New Discovery → Dig again → Duplicate
→ Research → Research Complete → Breakthrough → Pulse Unlock
→ FreePlay → Site 2 Gate
```

All three developers inspect the full chain at service boundaries and test together.

## Dependencies / Blockers

- **BLOCKED:** Requires Days 2–7 production systems and locked interfaces.
- **WAITING DEV1:** Complete authoritative loop.
- **WAITING DEV2:** Complete result-driven presentation.

## Studio Test

Run the full chain for a new player, respawn mid-flow, then reconnect. Check duplicate rewards/UI/Highlights, stuck onboarding, missing targets, wrong species/variants, bad Remote usage, and any Experimental RNG load.

## Exit Criteria

- [ ] The required flow is playable end-to-end without normal-play mocks.
- [ ] No duplicate listener, reward, UI, or Highlight behavior is observed.
- [ ] Server authority and ownership boundaries hold across the full loop.
- [ ] The Vertical Slice endpoint is the locked Site 2 Gate.

## Git / Handoff

Create one reviewed integration checkpoint after the full-team Studio test. Do not blindly merge feature branches.

# Day 9 — First 10 Minutes / Balance / Polish

## Goal

Make the first session understandable, active, and satisfying without expanding scope.

## Dev 1 — Backend / Server

- [ ] **TODO:** Tune server-owned pacing, RNG protection, Research, and Pulse config from playtest evidence.
- [ ] **TODO:** Preserve server authority and protection exit behavior during tuning.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Polish interaction feedback, UI clarity, VFX, sound, camera, Gold reveal, and Pulse payoff.
- [ ] **TODO:** Reduce passive waits and visual ambiguity found in testing.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Measure walking distances, machine placement, interaction ranges, copy, target visibility, navigation, and progression pacing.
- [ ] **TODO:** Maintain the playtest log and map issues to Design Pillars.
- [ ] **TODO:** Measure Voluntary Continue Rate after FreePlay using a team-agreed threshold/sample.

## Integration Points

Dev 3 records behavior and timing; the owning developer tunes each affected domain; the team reruns the same scenario before accepting a change.

## Dependencies / Blockers

- **READY:** Begin once Day 8 is playable end-to-end.
- **TBD CONTRACT:** Final Voluntary Continue Rate threshold and playtest sample size.
- **BLOCKED:** Meaningful timing targets require an end-to-end production loop.

## Studio Test

Record approximate timestamps, not hardcoded requirements:

```text
00:00 Spawn
??:?? First Dig
??:?? First Fossil
??:?? Revival
??:?? New Discovery
??:?? First Duplicate
??:?? Research
??:?? Breakthrough
??:?? Pulse
??:?? Site 2 Gate
```

Observe confusion, ignored targets, passive waits, weak reward moments, and whether players voluntarily dig again in FreePlay.

## Exit Criteria

- [ ] External playtesters can complete the loop without long tutorial text.
- [ ] Missed Weak Points never punish beyond the lost bonus.
- [ ] Gold and Pulse moments are visually unmistakable.
- [ ] Timing and continuation evidence is recorded for team review.

## Git / Handoff

Commit only reviewed tuning/polish changes with before/after playtest evidence. Do not add new systems to solve pacing problems.

# Day 10 — Release Candidate

## Goal

Produce a reviewable Vertical Slice release candidate without automatically merging it.

## Dev 1 — Backend / Server

- [ ] **TODO:** Audit server authority, validation, persistence, RNG, protection, and Output diagnostics.

## Dev 2 — Client / UI / VFX

- [ ] **TODO:** Audit initialization, feedback, UI/VFX duplication, supported variants, and client trust boundaries.

## Dev 3 — Integration / World / Progression

- [ ] **TODO:** Lead the complete journey, scope, onboarding, world, First 10 Minutes, and gate verification.
- [ ] **TODO:** Collect final test results and unresolved risks for release review.

## Integration Points

All developers run the same release checklist, compare Output and observed results, and assign every failure to its authoritative owner before creating a candidate checkpoint.

## Dependencies / Blockers

- **BLOCKED:** Requires all prior exit criteria or an explicitly documented release exception.
- **TBD CONTRACT:** No contract item may remain TBD if production code depends on it.

## Studio Test

Run fresh-player, returning-player, respawn, rejoin, invalid-request, Normal, Gold, Weak Point miss/hit, Duplicate, Research, Pulse, Collection, and GateSeen scenarios. Inspect client and server Output.

## Exit Criteria

- [ ] End-to-end smoke test passes.
- [ ] `CONTRACTS.md` matches production names, schemas, payloads, and ownership.
- [ ] Exactly two species and only Normal/Gold are reachable.
- [ ] No out-of-scope feature or production Experimental RNG dependency exists.
- [ ] Persistence, respawn, rejoin, onboarding, gate, and First 10 Minutes checks pass.

## Git / Handoff

Review clean Git status, final diff, and PR/merge plan. Do not automatically commit, push, merge, or create a PR.

## DAY 10 RELEASE CHECKLIST

- [ ] Complete full Vertical Slice flow from a fresh profile.
- [ ] Complete returning-player rejoin and respawn tests.
- [ ] Verify server authority and anti-exploit basics.
- [ ] Verify `CONTRACTS.md` against implementation.
- [ ] Verify exactly two species and Normal/Gold only.
- [ ] Verify no future/out-of-scope system is active.
- [ ] Verify no production dependency on Experimental RNG.
- [ ] Verify persistence and data validation.
- [ ] Verify onboarding cannot become stuck or skip states.
- [ ] Verify Site 2 remains locked and unplayable.
- [ ] Verify First Session Protection exits at the agreed `GateSeen` boundary.
- [ ] Verify the First 10 Minutes playtest record and agreed success threshold.
- [ ] Inspect client/server Output for errors and warnings.
- [ ] Review Git status and diff; agree on the PR/merge plan manually.

## Integration Board

| Feature | Dev1 | Dev2 | Dev3 | Integration | Test |
| --- | --- | --- | --- | --- | --- |
| Project Foundation | READY | READY | READY | READY | IN PROGRESS |
| Site 1 | NOT STARTED | NOT STARTED | READY | READY | IN PROGRESS |
| Dig | NOT STARTED | NOT STARTED | READY | NOT STARTED | NOT STARTED |
| Rock State | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED |
| Weak Point | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED |
| Fossil Reward | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED |
| Revival | NOT STARTED | NOT STARTED | READY | NOT STARTED | NOT STARTED |
| Species Resolution | NOT STARTED | NOT STARTED | READY | BLOCKED | NOT STARTED |
| Variant | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED | NOT STARTED |
| Discovery | NOT STARTED | NOT STARTED | NOT STARTED | BLOCKED | NOT STARTED |
| Duplicate | NOT STARTED | NOT STARTED | NOT STARTED | BLOCKED | NOT STARTED |
| Research | NOT STARTED | NOT STARTED | READY | BLOCKED | NOT STARTED |
| Breakthrough | NOT STARTED | NOT STARTED | READY | BLOCKED | NOT STARTED |
| Pulse | NOT STARTED | NOT STARTED | NOT STARTED | BLOCKED | NOT STARTED |
| Collection | NOT STARTED | NOT STARTED | IN PROGRESS | BLOCKED | NOT STARTED |
| Onboarding | NOT STARTED | NOT STARTED | READY | BLOCKED | IN PROGRESS |
| Persistence | NOT STARTED | NOT STARTED | NOT STARTED | BLOCKED | NOT STARTED |
| Site 2 Gate | NOT STARTED | NOT STARTED | READY | READY | IN PROGRESS |
| First 10 Minutes | NOT STARTED | NOT STARTED | IN PROGRESS | BLOCKED | NOT STARTED |
| Vertical Slice E2E | NOT STARTED | NOT STARTED | NOT STARTED | BLOCKED | NOT STARTED |

Board notes:

- `READY` for Dev 3 means the current blockout/config/skeleton or preview boundary exists; it does not mean production gameplay is integrated.
- Project Foundation and Site 1 testing remain `IN PROGRESS` because the repository records the latest state as awaiting Studio/Rojo verification.
- Species integration is blocked on final IDs/schema even though the temporary two-entry config is ready.
- Onboarding integration is blocked on Dev 1 validated events and a contract-approved replication path.
