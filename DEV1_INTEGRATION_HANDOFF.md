# Dev 1 Integration Handoff — Vertical Slice v1

## Current Dev 3 Systems

- `WorldBlockoutService` builds the runtime `Workspace.Site1Blockout` placeholder world.
- `OnboardingService` owns the current server-side, in-memory onboarding state machine.
- `InteractionShellService` provides temporary client interaction panels and onboarding presentation preview.
- `OnboardingPresentationConfig` contains editable copy and optional Site 1 target IDs for all contracted onboarding states.
- `OnboardingTargetResolver` and `OnboardingTargetGuidance` provide client-only target Highlight and distance presentation.

## What Is Temporary

- Onboarding state is in memory only; it is not persisted.
- `OnboardingService.handleMockDomainEvent(...)` uses internal mock event names for Studio testing.
- `InteractionShellService.setPreviewState(...)` is a local client preview hook.
- Interaction panels and HUD counters are placeholder presentation only.
- `species_a` / `species_b` and their display names remain temporary pending team confirmation.

## Dev 1 Integration Needed

Dev 1 needs to provide authoritative integration for:

1. PlayerDataService onboarding persistence.
2. Validated events from the real Dig flow.
3. FossilFound progression.
4. Revival result progression.
5. New Discovery and Duplicate progression.
6. Research completion.
7. Breakthrough.
8. Pulse unlock.
9. GateSeen and First Session Protection handoff.
10. Authoritative server-to-client onboarding state replication.

TBD — networking contract must be agreed before implementation.

Do not invent Remote names or payloads for this integration.

## Authority Rules

- The client never advances onboarding.
- The client only presents replicated state.
- `OnboardingService` is the onboarding state owner.
- `PlayerDataService` will become the persistence owner.
- Dev 1 domain services emit validated events.
- Dev 3 UI consumes authoritative replicated state.

## Proposed Integration Shape

```text
Dev 1 Domain Service
    ↓ validated server event
OnboardingService
    ↓ authoritative state update
PlayerDataService persistence
    ↓ TBD replicated state path
Dev 3 Client Presentation
```

This is a conceptual flow only, not an implementation contract.

## Existing Dev Preview Hooks

- `OnboardingService.handleMockDomainEvent(player, eventName)` — development-only server test hook; replace after real domain-event integration.
- `InteractionShellService.setPreviewState(stateName)` — development-only client presentation hook; replace after authoritative replication.

## Studio Smoke Test

1. Sync Rojo and press Play.
2. Confirm `Workspace.Site1Blockout` contains `PlayerSpawn`, `DigArea`, `RevivalChamber`, `ResearchMachine`, and `Site2Gate`.
3. Confirm the player spawns at `PlayerSpawn` and `[E] Dig` appears near the Dig Area.
4. Verify all four placeholder interaction panels open with `E`.
5. In Server Command Bar, call `OnboardingService.handleMockDomainEvent(...)` in sequence and confirm transition logs.
6. In Client Command Bar, call `InteractionShellService.setPreviewState(...)` and verify objective text, target Highlight, and distance presentation only.
7. Confirm no preview action changes player progression or calls the server.
