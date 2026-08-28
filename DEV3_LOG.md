# DEV 3 WORK LOG --- FOSSIL PARK

> **Mục đích:** Nhật ký tiến độ công việc của **DEV 3 (Integration / World / Progression Owner)**.
> Giúp Dev 1, Dev 2 và Tech Lead theo dõi trực tiếp các đầu việc, thay đổi kỹ thuật, trạng thái và yêu cầu phối hợp.

---

## 📌 THÔNG TIN DEV 3
- **Vai trò:** Integration / World / Progression Owner
- **Nhiệm vụ chính:**
  - `OnboardingService` & Onboarding State Machine
  - World layout / Site 1 blockout / Machine placements
  - Species config & Collection metadata
  - Integration nối các gameplay event (Server/Client) vào flow trải nghiệm
  - Pacing & First 10 Minutes Experience

---

## 🕒 NHẬT KÝ TIẾN ĐỘ (LOG ENTRIES)

### [2026-08-27] - Clarify Site 1 Spawn Pad Visual
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Reduced the PlayerSpawn footprint and set its transform to a level identity rotation facing the Dig Area.
  - Replaced the reflective dark-metal finish with slate and added a non-colliding teal inset marker for visual clarity.
- **Files ảnh hưởng:**
  - `src/shared/WorldBlockoutConfig.luau`
  - `src/server/WorldBlockoutBuilder.server.luau`
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - The SpawnLocation remains the only active prototype spawn. `SpawnAccent` is visual-only and is parented under `PlayerSpawn`; it is not an additional SpawnLocation or gameplay object.
  - The spawn base now sits flush on the Site 1 ground: bottom Y = 0.2 and top Y = 0.8.
- **Trạng thái:** Completed; ready for Studio visual verification.
- **Bước tiếp theo:**
  - Confirm the spawn reads as a compact, level start pad rather than a dark floating slab.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None.

### [2026-08-27] - Ensure a Single Active Site 1 Spawn
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Set the generated `Site1Blockout.PlayerSpawn` explicitly enabled, anchored, neutral, and oriented toward the Dig Area.
  - Added runtime-only handling that disables only a root-level `Workspace.SpawnLocation` default Baseplate spawn when it exists.
  - Moved the start of the Spawn-to-Dig path away from the SpawnLocation footprint to prevent platform overlap.
- **Files ảnh hưởng:**
  - `src/server/WorldBlockoutBuilder.server.luau`
  - `src/shared/WorldBlockoutConfig.luau`
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - The root default spawn is disabled, not deleted; unrelated SpawnLocations inside models are untouched. The operation repeats safely on every Play session.
  - `PlayerSpawn` remains at `(0, 0.7, 0)`, flush with the Site 1 ground top at Y = 0.2 and facing negative Z toward `DigArea`.
- **Trạng thái:** Completed; ready for spawn consistency testing.
- **Bước tiếp theo:**
  - Confirm the player consistently spawns on `Site1Blockout.PlayerSpawn` after stopping and replaying Studio sessions.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None.

### [2026-08-27] - Fix Site 1 Ground Layer Overlap
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Corrected overlapping ground elevations that caused the Site 1 ground and Baseplate to render at the same height.
  - Lifted paths, the dig surface, station foundations, rocks, and fragments onto distinct, non-overlapping vertical layers.
- **Files ảnh hưởng:**
  - `src/shared/WorldBlockoutConfig.luau`
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - `Ground` now has a visible top surface at Y = 0.2, above the Baseplate top at Y = 0. Paths begin at Y = 0.22 and the Dig Area begins at Y = 0.2, avoiding coplanar render surfaces.
  - All adjustment is static blockout placement only; no gameplay or contract behavior changed.
- **Trạng thái:** Completed; ready for Studio visual verification.
- **Bước tiếp theo:**
  - Confirm the Site 1 ground no longer flickers or blends with the Baseplate in Play mode.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None.

### [2026-08-27] - Make Site 1 Interaction Prototype Fully Visible
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Added visible placeholder panels for Dig Area and Site 2 Gate; expanded Revival and Research panels with their requested static status text.
  - Replaced the temporary raw keyboard listener with a single-fire `ContextActionService` binding for `E` and added activation-only Output logging.
- **Files ảnh hưởng:**
  - `src/client/InteractionUiShell.luau`
  - `src/client/InteractionShellController.client.luau`
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - The prior Dig branch was intentionally a no-op TODO, which caused the lack of visible response.
  - The action accepts only `Begin`, requires one nearest active target, and rejects activation while a panel is open. All panel data remains static and non-authoritative.
  - Final UI remains Dev 2 ownership; authoritative gameplay remains Dev 1 ownership.
- **Trạng thái:** Completed; ready for all-four-interaction playtest.
- **Bước tiếp theo:**
  - Replace mock panel activation only after server-authoritative gameplay and Dev 2 final UI are available.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None during prototype testing.

### [2026-08-27] - Add Temporary Site 1 Interaction UI Shell
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Added a client-only, proximity-driven playtest shell for Dig Area, Revival Chamber, Research Machine, and Site 2 Gate.
  - Added static HUD labels and non-authoritative Revival/Research placeholder panels for First 10 Minutes flow testing.
- **Files ảnh hưởng:**
  - `src/client/InteractionUiShell.luau` (new)
  - `src/client/InteractionShellController.client.luau` (new)
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - The shell mounts a `ScreenGui` to `PlayerGui`, reads only local distance to existing blockout instance names, and makes no gameplay or persistent-state changes.
  - `E` opens only the two mock panels; Dig intentionally has no action and the gate stays locked as display-only text.
  - Final UI/UX remains Dev 2 ownership; future server-authoritative actions must use the locked remote contract rather than this mock shell.
- **Trạng thái:** Completed; ready for interaction-flow playtesting.
- **Bước tiếp theo:**
  - Replace static UI values and mock panel actions only after Dev 1 exposes server-authoritative results and Dev 2 owns the final presentation.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - Dev 1: connect validated gameplay through existing contract remotes when ready. Dev 2: replace this temporary UI presentation and input shell.

### [2026-08-27] - Unify Site 1 Visual Blockout Language
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Added a shared static palette for dark stone, muted metal, excavated earth, cyan energy, and amber research accents.
  - Updated the existing blockout primitives so the dig site, machines, gate, ground, and paths use one stylized fossil-excavation / ancient-tech visual language.
  - Added shallow excavation borders and small visual fragments to improve the dig-area composition.
- **Files ảnh hưởng:**
  - `src/shared/WorldBlockoutConfig.luau`
  - `src/server/WorldBlockoutBuilder.server.luau`
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - Cyan neon is limited to the chamber core and gate indicator; amber neon is limited to the research core. Paths, ground, and structures are non-neon.
  - All changes are static presentation-only geometry and colors; no gameplay, remotes, VFX systems, UI, animation, sounds, RNG, or persistent state were added.
- **Trạng thái:** Completed; ready for Studio visual consistency playtest.
- **Bước tiếp theo:**
  - Tune only config values or primitive proportions if Studio testing identifies readability issues.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None.

### [2026-08-27] - Improve Site 1 Blockout Readability
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Expanded the Site 1 blockout with a bounded ground area, physical guidance paths, and a ten-rock visual excavation cluster.
  - Rebuilt the placeholder chamber, research machine, and gate at clearer landmark scale while preserving their original root instance names.
- **Files ảnh hưởng:**
  - `src/shared/WorldBlockoutConfig.luau`
  - `src/server/WorldBlockoutBuilder.server.luau`
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - All placements remain static shared data; the builder remains presentation-only and server-run.
  - Dig rocks are non-colliding visual placeholders only; no interaction, reward, RNG, VFX, or gameplay state was added.
  - Paths and landmark scale provide world-based navigation from spawn through the gate without tutorial UI.
- **Trạng thái:** Completed; ready for Studio readability playtest.
- **Bước tiếp theo:**
  - Adjust positions and proportions in `WorldBlockoutConfig.luau` only if playtest feedback identifies a flow or readability issue.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None.

### [2026-08-27] - Fix Site 1 Blockout Builder Parse Error
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Replaced the unsupported Luau type-index expression in `WorldBlockoutBuilder.server.luau` with a simple local structural type.
  - Replaced generalized table iteration with `ipairs` for broad Roblox Studio compatibility.
- **Files ảnh hưởng:**
  - `src/server/WorldBlockoutBuilder.server.luau`
  - `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - The fix is syntax-only; world layout, blockout configuration, instance names, and scope are unchanged.
- **Trạng thái:** Completed; ready for Studio verification.
- **Bước tiếp theo:**
  - Press Play and confirm `Workspace.Site1Blockout` contains all five named blockout instances.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None.

### [2026-08-27] - Build Site 1 World Blockout
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Added a shared, static placement config for the Site 1 player journey: spawn, dig area, revival chamber, research machine, and Site 2 gate.
  - Added a server-side world builder that creates anchored placeholder geometry in `Workspace.Site1Blockout` when the experience runs.
- **Files ảnh hưởng:**
  - `src/shared/WorldBlockoutConfig.luau` (new)
  - `src/server/WorldBlockoutBuilder.server.luau` (new)
  - `DEV3_LOG.md` (updated)
- **Quyết định kỹ thuật / Ghi chú:**
  - Static placement data stays in shared config; the builder only creates presentation-only placeholder geometry.
  - No gameplay logic, remotes, persistent state, RNG, UI, VFX, or contract changes were added.
  - Layout targets are approximately 3 seconds from spawn to dig area, 6.5 seconds from dig area to revival chamber, 2.6 seconds from revival chamber to research machine, and 8.75 seconds from the main machines to the gate at a 16-stud-per-second walk speed.
- **Trạng thái:** Completed; ready for Studio flow testing.
- **Bước tiếp theo:**
  - Playtest and adjust `WorldBlockoutConfig.luau` positions only if the intended walking flow needs tuning.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - None for the blockout. Future gameplay and presentation systems may use these named workspace instances as integration reference points.

### [2026-08-27] - Create Contract Day Skeleton
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Reviewed `AGENTS.md`, the repository scaffold, the existing Dev 3 log, and `src/shared/SpeciesConfig.luau`.
  - Created the root-level Contract Day skeleton for Vertical Slice v1.
- **Files ảnh hưởng:**
  - `CONTRACTS.md` (new)
  - `DEV3_LOG.md` (updated)
- **Quyết định kỹ thuật / Ghi chú:**
  - Locked only names and rules already directed by `AGENTS.md`; unspecified schemas and payloads remain `TBD`.
  - `species_a` and `species_b` are documented as temporary IDs requiring team confirmation.
- **Trạng thái:** Completed; awaiting Contract Day confirmation from Dev 1 and Dev 2.
- **Bước tiếp theo:**
  - Resolve the open checklist in `CONTRACTS.md` before parallel implementation relies on the contracts.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - Confirm species IDs, nested player-data structures, remote payloads, validation rules, and persistence format.

### [2026-08-27] - Khởi tạo Quy trình Ghi Log Dev 3 & Cập nhật AGENTS.md
- **Người thực hiện:** Dev 3 (với sự hỗ trợ của Antigravity)
- **Công việc:**
  - Cập nhật quy tắc bắt buộc ghi log vào [AGENTS.md](file:///c:/Project%20Web/FossilPark/AGENTS.md) (Mục 19 & Mục 25).
  - Tạo file [DEV3_LOG.md](file:///c:/Project%20Web/FossilPark/DEV3_LOG.md) làm template theo dõi công việc chuẩn cho Dev 3.
- **Files thay đổi:**
  - `AGENTS.md`
  - `DEV3_LOG.md`
- **Trạng thái:** Hoàn thành thiết lập log.

### [2026-08-27] - Triển khai Shared Species Config cho Vertical Slice v1
- **Người thực hiện:** Dev 3 (với sự hỗ trợ của Antigravity)
- **Công việc:**
  - Kiểm tra `CONTRACTS.md` (chưa tồn tại) và `default.project.json`.
  - Tạo module shared `SpeciesConfig.luau` chứa data-driven configuration cho đúng 2 species (`species_a` và `species_b`).
  - Định nghĩa kiểu dữ liệu Luau (`SpeciesEntry`, `SpeciesConfigType`) phục vụ Type Safety cho toàn dự án.
- **Files thay đổi:**
  - [src/shared/SpeciesConfig.luau](file:///c:/Project%20Web/FossilPark/src/shared/SpeciesConfig.luau) (Mới)
  - [DEV3_LOG.md](file:///c:/Project%20Web/FossilPark/DEV3_LOG.md) (Cập nhật log)
- **Quyết định kỹ thuật / Ghi chú:**
  - Cấu hình chỉ chứa thuần data (ID, Display Name, Fossil Name). Không chứa logic RNG, Revival, Traits hay gameplay.
  - Sử dụng schema tối giản theo yêu cầu vì chưa có `CONTRACTS.md`.
- **Trạng thái:** Hoàn thành (Chờ team xác nhận tại Contract Day).
- **Bước tiếp theo:**
  - Thống nhất schema chính thức trên `CONTRACTS.md` cùng Dev 1 và Dev 2.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - Dev 1 (`RevivalService`, `PlayerDataService`) và Dev 2 (Revival UI, Collection UI) tham chiếu `ReplicatedStorage.Shared.SpeciesConfig` khi cần lấy thông tin species.

---

### [2026-08-28] - Migrate Dev 3 Work to Remote Service Structure
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Migrated the Site 1 world builder into `Server.Services.WorldBlockoutService` and the temporary interaction shell into `Client.Services.InteractionShellService`.
  - Moved shared Dev 3 static data into `Shared.Config` and adopted the remote server/client service bootstrap loaders.
  - Added the remote toolchain metadata and preserved the remote RNG prototype under `Experimental` so it is not loaded.
- **Files ảnh hưởng:**
  - `src/server/Services/WorldBlockoutService/init.luau`
  - `src/client/Services/InteractionShellService/init.luau`
  - `src/client/Services/InteractionShellService/InteractionUiShell.luau`
  - `src/shared/Config/WorldBlockoutConfig.luau`
  - `src/shared/Config/SpeciesConfig.luau`
  - `src/server/init.server.luau`
  - `src/client/init.client.luau`
  - `src/server/Experimental/RNGService/*`
  - `src/client/Experimental/RNGClientService/init.luau`
  - `src/shared/Experimental/Networking/Remotes.luau`
  - `.gitattributes`, `rokit.toml`, `selene.toml`, `wally.toml`, `DEV3_LOG.md`
- **Quyết định kỹ thuật / Ghi chú:**
  - The remote loader runs only direct children of `Services`; Dev 3 runtime modules now return a table exposing `init()`.
  - The preserved RNG prototype is deliberately excluded from both loaders. Its `RNGResult` remote and Common/Rare/Legendary outcomes are not part of `CONTRACTS.md` and conflict with Vertical Slice v1's species/variant direction.
  - `default.project.json` is unchanged because its existing mappings already match the remote root structure and the remote's additional `StarterPlayerScripts` path is not present locally.
- **Trạng thái:** Completed pending Studio/Rojo validation.
- **Bước tiếp theo:**
  - Run the Rojo sync and Studio playtest after the team resolves the Git baseline and reviews the isolated RNG prototype.
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - Team: review or replace the isolated remote RNG prototype through Contract Day before it is registered as a runtime service.

### [Template cho Entry Mới]
```markdown
### [YYYY-MM-DD HH:mm] - [Tên Task / Đầu việc]
- **Người thực hiện:** Dev 3
- **Công việc thực hiện:**
  - Mô tả chi tiết các việc đã làm...
- **Files ảnh hưởng:**
  - `path/to/file1`
  - `path/to/file2`
- **Quyết định kỹ thuật / Ghi chú:**
  - ...
- **Trạng thái:** In Progress / Completed / Blocked
- **Bước tiếp theo:**
  - ...
- **Yêu cầu phối hợp với Dev 1 & Dev 2:**
  - ...
```
