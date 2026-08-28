# FOSSIL PARK — Contract Day

## 1. Contract Status

- **Contract version:** 0.1
- **Status:** DRAFT
- **Scope:** Vertical Slice v1
- **Change rule:** Any breaking contract change must be discussed by Dev 1, Dev 2, and Dev 3 before it is made.

## 2. PlayerData Schema

```luau
PlayerData = {
    Coins = 0,
    Collection = {}, -- TBD
    Fossils = {}, -- TBD
    ResearchProgress = 0,
    PulseUnlocked = false,
    OnboardingState = "FirstDig",
    FirstSessionProtectionActive = true,
}
```

`Collection` and `Fossils` structures are **TBD**. Persistent player data is server-owned.

## 3. Rock State Contract

Use these exact state names. Do not rename them.

```text
Idle
Damaged
WeakPointVisible
Broken
```

## 4. Onboarding State Contract

States are ordered as follows:

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

## 5. Species Contract

Vertical Slice v1 supports exactly **2 species**. The current temporary IDs are:

```text
species_a — TEMPORARY / REQUIRES TEAM CONFIRMATION
species_b — TEMPORARY / REQUIRES TEAM CONFIRMATION
```

See [src/shared/Config/SpeciesConfig.luau](src/shared/Config/SpeciesConfig.luau). Do not add additional species.

## 6. Variant Contract

Vertical Slice v1 supports exactly:

```text
Normal
Gold
```

## 7. Remote Contract

### Client → Server requests

```text
RequestStrike
RequestRevival
RequestResearchFeed
RequestPulseActivate
```

Payloads: **TBD**.

### Server → Client events

```text
RockStateChanged
RevivalResult
ResearchProgress
PulseReady
```

Payloads for `RockStateChanged`, `ResearchProgress`, and `PulseReady` are **TBD**.

`RevivalResult` payload:

```luau
{
    species = "...",
    variant = "Normal" | "Gold",
    isNewDiscovery = true | false,
    isDuplicate = true | false,
}
```

## 8. Domain Ownership Contract

| Domain | Owner |
| --- | --- |
| Player persistence | `PlayerDataService` |
| Rock state | Dig domain / `RockController` |
| Research progress | `ResearchService` |
| Pulse unlock | `ResearchService` |
| Pulse activation | `PulseService` |
| Onboarding state | `OnboardingService` |

> Only the owner of a domain may write its authoritative state.

## 9. Server Authority Contract

The client must never decide:

- RNG result
- Species reward
- Variant / Gold
- Research reward
- First Session Protection outcome
- Permanent progression

The client submits input; the server validates it and resolves authoritative results.

## 10. Open Decisions

- [ ] Final species IDs
- [ ] Final `Collection` structure
- [ ] Final `Fossils` structure
- [ ] Exact remote payloads
- [ ] Validation rules
- [ ] DataStore persistence format
