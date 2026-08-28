# AGENTS.md --- FOSSIL PARK

> **Mục đích của file này:** Cung cấp context cho AI coding agent
> (Antigravity) để hiểu chính xác game đang được xây dựng, các quyết
> định thiết kế đã chốt, kiến trúc dự kiến và những điều **không được tự
> ý thay đổi**.

------------------------------------------------------------------------

# 1. PROJECT IDENTITY

## Tên dự án

**FOSSIL PARK** *(working title, có thể đổi sau)*

## Thể loại

Roblox game kết hợp:

-   Fossil excavation / digging
-   Collection
-   RNG reveal
-   Creature revival
-   Progression
-   Light gambling excitement
-   Visual spectacle / satisfying animations

Game ưu tiên trải nghiệm cho:

1.  Trẻ em và người chơi Roblox phổ thông: dễ hiểu, ít chữ, thao tác đơn
    giản.
2.  Người thích RNG/gambling loop: anticipation, reveal, rarity,
    variant, trait, collection.
3.  Người thích animation/VFX đẹp: mỗi discovery hiếm phải tạo cảm giác
    đặc biệt.

## Fantasy cốt lõi

Người chơi là một nhà thám hiểm khảo cổ.

Họ:

``` text
DIG ROCK
   ↓
FIND FOSSIL
   ↓
REVIVE CREATURE
   ↓
DISCOVER NEW SPECIES / VARIANT
   ↓
COLLECT DUPLICATES
   ↓
RESEARCH
   ↓
BREAKTHROUGH
   ↓
UNLOCK NEW WAY TO PLAY
   ↓
EXPLORE MORE DIG SITES
```

Đây là vòng lặp cốt lõi của game.

**Không được tự biến game thành Mining Simulator, Pet Simulator clone
hoặc idle simulator.**

------------------------------------------------------------------------

# 2. DESIGN PILLARS --- QUY TẮC CAO NHẤT

Mọi feature mới phải được kiểm tra với các nguyên tắc sau.

## Pillar 1 --- Discovery comes first

Người chơi phải cảm thấy mình đang **khám phá**, không chỉ đang farm
currency.

``` text
Discovery → Progression → Power
```

Không phải:

``` text
Grind money → Buy bigger number → Grind faster
```

## Pillar 2 --- Discovery unlocks power, Coin supports its use

Khám phá và Research là nguồn mở khóa progression chính.

Coin vẫn tồn tại và được dùng cho các mục đích hỗ trợ, nhưng:

> **Coin must never be the primary gate for meaningful discovery or new
> gameplay verbs.**

Không được thiết kế progression chỉ đơn giản:

``` text
Need stronger tool
→ Farm money
→ Buy stronger tool
→ Repeat
```

## Pillar 3 --- Breakthrough adds a verb, not just a stat

Một Breakthrough tốt phải thay đổi cách người chơi tương tác.

Ưu tiên:

``` text
Unlock a new action
Unlock a new interaction
Unlock a new decision
```

Tránh:

``` text
+10% damage
+20% mining speed
x2 power
bigger number only
```

Ví dụ:

-   Pulse Module = thêm hành động `BURST`
-   Không chỉ là "+25% damage".

## Pillar 4 --- World tells the story, not UI

Ưu tiên feedback bằng:

-   Crack trên đá
-   Weak Point phát sáng
-   Particle
-   Sound
-   Animation
-   Machine thay đổi hình dạng
-   Visual state transition

Tránh phụ thuộc vào:

-   HP bar lớn
-   Popup chữ liên tục
-   Checklist dài
-   Tutorial textbox che màn hình

## Pillar 5 --- Simple first, depth later

10 phút đầu phải cực kỳ dễ hiểu.

Hệ thống có thể phức tạp ở backend, nhưng UI ban đầu phải là phiên bản
đơn giản nhất.

Không nhồi nhiều lựa chọn cho người chơi mới.

Ví dụ:

-   Duplicate đầu tiên: ưu tiên gợi ý `RESEARCH THIS!`
-   Không ngay lập tức bắt người chơi hiểu toàn bộ Keep / Research /
    Combine / Trait / Mutation.

Độ sâu được mở dần qua nhiều session.

## Pillar 6 --- No punishment, only bonus

Nếu người chơi bỏ lỡ cơ hội bonus:

> **Missing a bonus opportunity never punishes the player beyond the
> bonus itself.**

Ví dụ:

-   Miss Weak Point → vẫn phá được đá bình thường.
-   Không bị giảm reward.
-   Không tăng độ cứng đá.
-   Không phá hủy Fossil.
-   Miss Resonance → chỉ không nhận bonus.

Game cần tạo cảm giác:

``` text
"Oh nice, I got a bonus!"
```

Không phải:

``` text
"Damn, I failed again."
```

## Pillar 7 --- Anticipation is part of the reward

Khoảnh khắc chờ reveal phải hấp dẫn.

Các điểm quan trọng:

-   Fossil xuất hiện.
-   Revival.
-   Gold Variant.
-   Trait.
-   Mutation.
-   Secret discovery.

RNG không chỉ là kết quả; **anticipation và presentation là một phần
reward**.

------------------------------------------------------------------------

# 3. CORE DIG GAMEPLAY

## Core loop của một Rock encounter

``` text
BREAK → READ → STRIKE
```

Người chơi không chỉ click vô hồn.

Họ:

1.  Strike Rock.
2.  Quan sát Rock phản hồi.
3.  Nhận biết cơ hội.
4.  Strike tiếp tục hoặc đánh vào Weak Point.
5.  Break Rock.
6.  Nhận Fossil.

## Không sử dụng HP bar làm feedback chính

Không hiển thị một thanh:

``` text
Rock HP: 73 / 100
```

Feedback chính là visual:

``` text
Rock intact
→ small cracks
→ cracks spread
→ Weak Point appears
→ final fracture
→ Rock breaks
```

## Pattern duy nhất cho Vertical Slice

### BRITTLE / TARGET

Đây là pattern duy nhất được implement trong Vertical Slice v1.

Flow:

``` text
Player clicks Rock
→ Crack appears
→ Weak Point becomes visible
→ Player may strike Weak Point
→ Bonus progress / satisfying feedback
→ Rock breaks
→ Fossil obtained
```

Nếu không đánh Weak Point:

``` text
Player continues clicking
→ Rock still breaks normally
```

Weak Point là bonus, không phải điều kiện bắt buộc.

### Rock States

Tên state dùng thống nhất:

``` text
Idle
Damaged
WeakPointVisible
Broken
```

Không tự đổi tên enum nếu chưa cập nhật contract.

------------------------------------------------------------------------

# 4. FUTURE ROCK PATTERNS

Đây là direction đã được chốt về mặt design, nhưng **KHÔNG cần implement
trong Vertical Slice v1**.

Bốn interaction identity chính:

  Pattern   Verb                         Ý nghĩa
  --------- ---------------------------- ---------------------------------
  TARGET    Strike đúng điểm             Tìm Weak Point
  EXPOSE    Reveal state mới             Phá lớp ngoài để lộ core
  FLOW      Duy trì tương tác tự nhiên   Resonance / ambient interaction
  BURST     Charge rồi giải phóng        Pulse Module

Mỗi Rock Pattern mới phải vượt qua **Identity Test**:

1.  Người chơi thực sự làm gì khác so với pattern cũ?
2.  Mắt họ đang tìm kiếm loại tín hiệu nào?
3.  Hành động chính là gì: Target / Expose / Flow / Burst?
4.  Nếu chỉ đổi VFX mà gameplay không đổi, pattern đó chưa đủ khác biệt.

Không tạo pattern mới chỉ vì "đổi texture đá".

------------------------------------------------------------------------

# 5. FOSSIL SYSTEM

## Fossil có identity

Khi đào được Fossil, Fossil không phải chỉ là một "loot box" hoàn toàn
vô danh.

Ví dụ:

``` text
T-Rex Skull Fossil
Ancient Raptor Fossil
Mammoth Fossil
```

Người chơi biết mình đã tìm được loại Fossil nào.

## Fossil Quality

Direction hiện tại:

``` text
Normal
Fine
Pristine
Perfect
```

Quality có thể ảnh hưởng:

-   Sell / support value
-   Presentation
-   Research-related value
-   Các bonus nhỏ

Quality **không được trực tiếp tăng Variant rarity ở Revival**.

Không tạo cảm giác:

``` text
Fossil quality xấu
→ gần như mất cơ hội ra Gold
```

------------------------------------------------------------------------

# 6. REVIVAL SYSTEM

## Revival Chamber

Flow:

``` text
Fossil
→ Revival Chamber
→ Revival animation
→ Creature reveal
→ Variant result
→ New Discovery / Duplicate result
```

Vertical Slice chỉ cần:

``` text
Normal
Gold
```

Không implement Rainbow/Mythic/Secret trong v1.

## Important RNG Rule

Dig gameplay bonus không được thay đổi RNG rarity lớn của Revival.

Ví dụ:

``` text
Weak Point bonus
Pulse bonus
Rock micro bonus
```

Có thể tác động:

-   Dig progress
-   Quality-related reward
-   Fragments
-   Visual fun reward

Nhưng **không được âm thầm tăng Gold chance**.

Pulse và Gold trong onboarding có quan hệ **narrative/pacing**, không
phải:

``` text
Pulse gives better Gold RNG
```

------------------------------------------------------------------------

# 7. CREATURE SYSTEM

Vertical Slice chỉ dùng **2 Species**.

Mục tiêu:

-   Có đủ New Discovery.
-   Có đủ Duplicate.
-   Có thể test Collection.
-   Không cần nhiều content.

Creature không phải combat pet.

Tránh xây hệ thống:

``` text
Pet Damage
DPS
Fight enemies
Best pet team
```

Direction dài hạn:

-   Collection value
-   Park / Museum display
-   Visual rarity
-   Cosmetic/status value
-   Completion goals

Không nên để Creature hiếm đơn giản đồng nghĩa:

``` text
Produces more money per second
```

Creature cần giá trị ngoài economy.

------------------------------------------------------------------------

# 8. RESEARCH SYSTEM

## Triết lý

Duplicate không chỉ là đồ rác để Sell.

Core concept:

``` text
Duplicate
→ Feed / contribute to Research
→ Research progress
→ Breakthrough
→ New gameplay capability
```

Tên experience có thể dùng:

``` text
RESEARCH THIS!
```

Trong onboarding, UI phải đơn giản.

Không đưa checklist phức tạp như:

``` text
Collect 3 Common
Collect 2 Rare
Find 1 Pristine
Get 1 Gold
```

ngay từ đầu.

Tutorial chỉ hiển thị progress bằng:

-   Icon
-   Visual slot
-   Progress bar

Không bắt trẻ em đọc quá nhiều.

## First Breakthrough

Research đầu tiên mở:

# PULSE MODULE

Pulse phải là ví dụ cho:

> Breakthrough adds a verb, not just a stat.

------------------------------------------------------------------------

# 9. PULSE MODULE

Pulse là gameplay verb:

``` text
BURST
```

Nó phải có:

``` text
Charge
→ Visual feedback
→ Activate
→ Burst
→ Strong visual payoff
```

Không chỉ là nút "+damage".

Trong Vertical Slice:

-   Pulse được unlock qua Research.
-   `PulseUnlocked` lưu trong `PlayerDataService`.
-   `ResearchService` là service được phép ghi trạng thái unlock.
-   `PulseService` đọc trạng thái và xử lý charge/activate.
-   Không để hai service cùng sở hữu source of truth.

------------------------------------------------------------------------

# 10. VARIANT

Vertical Slice:

``` text
Normal
Gold
```

Gold phải là khoảnh khắc visual đáng nhớ.

Cần có:

-   Distinct reveal.
-   Distinct VFX.
-   Distinct sound.
-   Visual recognition ngay lập tức.

Người chơi phải hiểu bằng mắt:

``` text
Normal = normal discovery
Gold = SOMETHING SPECIAL
```

Không cần giải thích dài.

------------------------------------------------------------------------

# 11. FIRST SESSION PROTECTION SYSTEM

## Mục tiêu

10 phút đầu không được hoàn toàn phụ thuộc vào RNG thật.

Onboarding cần đảm bảo nhịp trải nghiệm.

Tên chính thức:

# First Session Protection System

Đây **không phải client scripting**.

Toàn bộ logic protection phải nằm ở **Server Authority**.

## Protection có thể đảm bảo

Tùy config:

-   Weak Point xuất hiện đúng nhịp.
-   Fossil đầu tiên không xuất hiện quá muộn.
-   New Discovery đầu tiên xảy ra.
-   Duplicate không xuất hiện quá sớm hoặc quá muộn.
-   Research đủ progress đúng pacing.
-   First Gold moment được bảo vệ/heavily weighted/guaranteed theo
    config.

Không hard-script từng click.

Mục tiêu là kiểm soát:

``` text
Outcome pacing
```

không phải giả vờ mọi thứ hoàn toàn random.

## Exit condition

Protection phải có điều kiện tắt rõ ràng.

Direction hiện tại:

``` text
GateSeen
→ First Session Protection disabled
```

Tức là sau khi người chơi hoàn thành onboarding và thấy/unlock Site 2
Gate, hệ thống protection kết thúc.

Không để protection chạy mãi.

------------------------------------------------------------------------

# 12. FIRST 10 MINUTES --- DESIGN INTENT

First 10 Minutes là onboarding quan trọng nhất.

Nguyên tắc:

## Mỗi beat phải có hành động

Ở mọi thời điểm, phải trả lời được:

1.  Người chơi đang bấm/kéo/thao tác gì?
2.  Người chơi có phải chỉ đứng chờ animation quá lâu không?

Tránh thời gian bị động.

Animation quan trọng có thể tồn tại, ví dụ Revival khoảng 3 giây, nhưng
không được liên tục bắt người chơi chờ.

## Chỉ dùng BRITTLE/TARGET

Trong 10 phút đầu:

-   Không Layered/EXPOSE.
-   Không Resonance/FLOW.
-   Không Fractured/BURST Rock.
-   Không teaser mechanic phức tạp.

Người chơi chỉ học:

``` text
Strike
→ Observe cracks
→ Find Weak Point
→ Strike
→ Break
```

Sau khi họ hiểu core interaction mới mở thêm depth.

## Concept pacing

Không dồn quá nhiều khái niệm cùng lúc.

Người chơi cần các khoảng:

``` text
Learn
→ Do
→ Reward
→ Free play
→ Learn next thing
```

Không:

``` text
Tutorial
→ Tutorial
→ Tutorial
→ Tutorial
→ 5 systems popup
```

------------------------------------------------------------------------

# 13. ONBOARDING STATE MACHINE

Onboarding phải được implement như **state machine**, không phải một
đống tutorial UI if/else.

Các state chính cần được giữ trong một thứ tự rõ ràng.

Direction:

``` text
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

Tên cuối cùng có thể được team chuẩn hóa trong `CONTRACTS.md`, nhưng sau
khi khóa contract thì không tự đổi.

## Ownership

`OnboardingService` sở hữu onboarding state.

Các gameplay service chỉ emit domain event.

Ví dụ:

``` text
DigService
→ emits FossilFound

RevivalService
→ emits RevivalCompleted

ResearchService
→ emits ResearchCompleted

OnboardingService
→ reacts to event
→ changes onboarding state
```

Không để `DigService` tự sửa `OnboardingState` trực tiếp.

------------------------------------------------------------------------

# 14. TECHNICAL ARCHITECTURE RULES

## Server is the source of truth

Client không được quyết định:

-   RNG result.
-   Species reward.
-   Variant.
-   Gold result.
-   Research reward.
-   Protection result.
-   Permanent progression.

Client chỉ gửi request/input.

Ví dụ:

``` text
Client:
"I want to strike this Rock."

Server:
Validates request
Calculates progression
Updates Rock state
Determines Fossil outcome
Sends visual result to Client
```

Không:

``` text
Client rolls Gold
→ Client tells Server "I got Gold"
```

## Domain Ownership Rule

Nguyên tắc bắt buộc:

> **Only the service that owns a domain event may write the state
> belonging to that domain.**

Ví dụ:

  State                     Owner
  ------------------------- -----------------------------
  Player data persistence   PlayerDataService
  Rock state                RockController / Dig domain
  Research progress         ResearchService
  Pulse unlock event        ResearchService
  Pulse activation logic    PulseService
  Onboarding state          OnboardingService

Các service khác giao tiếp qua:

-   Event
-   Public API contract
-   PlayerDataService

Không tạo duplicate source of truth.

------------------------------------------------------------------------

# 15. PLAYER DATA SCHEMA

Schema chính xác sẽ được khóa trong `CONTRACTS.md`.

Direction tối thiểu:

``` lua
PlayerData = {
    Coins = 0,

    Collection = {},

    Fossils = {},

    ResearchProgress = 0,

    PulseUnlocked = false,

    OnboardingState = "FirstDig",

    FirstSessionProtectionActive = true,
}
```

Không tự lưu permanent data phía Client.

Mọi thay đổi persistent phải qua Server.

------------------------------------------------------------------------

# 16. REMOTE CONTRACT DIRECTION

Tên cuối cùng phải được khóa trong `CONTRACTS.md`.

Direction hiện tại:

``` text
RequestStrike
RockStateChanged

RequestRevival
RevivalResult

RequestResearchFeed
ResearchProgress

PulseReady
RequestPulseActivate
```

Ví dụ payload Revival:

``` lua
{
    species = "SpeciesA",
    variant = "Normal",
    isNewDiscovery = true,
    isDuplicate = false,
}
```

Hoặc:

``` lua
{
    species = "SpeciesA",
    variant = "Gold",
    isNewDiscovery = false,
    isDuplicate = true,
}
```

Sau Contract Day, không tự đổi:

-   Remote name.
-   Payload field.
-   Enum name.

Nếu cần đổi, cập nhật `CONTRACTS.md` và báo toàn team.

------------------------------------------------------------------------

# 17. VERTICAL SLICE v1 SCOPE

## MUST IMPLEMENT

### Gameplay

-   [ ] One Dig Site.
-   [ ] BRITTLE/TARGET Rock only.
-   [ ] Strike input.
-   [ ] Crack feedback.
-   [ ] Weak Point.
-   [ ] Rock breaks.
-   [ ] Fossil reward.

### Revival

-   [ ] Revival Chamber.
-   [ ] 2 Species.
-   [ ] Normal Variant.
-   [ ] Gold Variant.
-   [ ] New Discovery.
-   [ ] Duplicate.

### Progression

-   [ ] Research from duplicate.
-   [ ] First Breakthrough.
-   [ ] Pulse Module unlock.
-   [ ] Pulse charge.
-   [ ] Pulse activation.
-   [ ] First Session Protection.
-   [ ] Onboarding state machine.

### World/UI

-   [ ] Site 1 blockout.
-   [ ] Revival Chamber location.
-   [ ] Research Machine location.
-   [ ] Basic Collection UI.
-   [ ] Site 2 visual Gate.
-   [ ] First 10 Minutes experience.

### Technical

-   [ ] Server-authoritative RNG.
-   [ ] PlayerDataService.
-   [ ] Domain ownership rules.
-   [ ] Remote contracts.
-   [ ] Basic persistence.

------------------------------------------------------------------------

# 18. OUT OF SCOPE --- DO NOT BUILD YET

Không tự thêm các hệ thống sau vào Vertical Slice:

-   [ ] More than 2 Species.
-   [ ] Rainbow Variant.
-   [ ] Mythic.
-   [ ] Secret.
-   [ ] Trait reroll.
-   [ ] Mutation.
-   [ ] Combine system.
-   [ ] Trading.
-   [ ] Multiple Dig Sites.
-   [ ] Layered Rock.
-   [ ] Resonance Rock.
-   [ ] Fractured Rock.
-   [ ] Expedition.
-   [ ] Rebirth.
-   [ ] Full Museum system.
-   [ ] Park income.
-   [ ] Pet combat.
-   [ ] Complex shop.
-   [ ] Full monetization.
-   [ ] Auto Dig final implementation.

Nếu một feature không nằm trong MUST IMPLEMENT, mặc định xem là **OUT OF
SCOPE** cho Vertical Slice.

Không thêm chỉ vì "làm tiện luôn".

------------------------------------------------------------------------

# 19. TEAM RESPONSIBILITIES

## DEV 1 --- SERVER / BACKEND / GAME LOGIC OWNER

### Ownership

Dev 1 chịu trách nhiệm Server Authority.

### Phase 1

-   [ ] `PlayerDataService`
-   [ ] Player schema
-   [ ] Persistence
-   [ ] `DigService`
-   [ ] Server validation cho Strike
-   [ ] `RockController` logic/state machine
-   [ ] Fossil reward generation
-   [ ] `RevivalService`
-   [ ] Server RNG
-   [ ] Variant resolution
-   [ ] `RewardResolutionService`
-   [ ] First Session Protection System
-   [ ] `ResearchService`
-   [ ] Research progress
-   [ ] Breakthrough result
-   [ ] `PulseService`
-   [ ] Charge/activation validation
-   [ ] Remote server handlers

### Quy tắc

Dev 1 **không chịu trách nhiệm final VFX/UI**.

Dev 1 có thể dùng:

-   Debug output.
-   Placeholder Remote calls.
-   Test command.
-   Stub data.

Mục tiêu tuần đầu:

> Toàn bộ game logic chạy được dù chưa có UI đẹp.

------------------------------------------------------------------------

## DEV 2 --- CLIENT GAMEPLAY / UI / VFX OWNER

### Ownership

Dev 2 chịu trách nhiệm:

> "Game feels satisfying when the player interacts."

### Phase 1

-   [ ] Strike input.
-   [ ] Click feedback.
-   [ ] Camera feel.
-   [ ] Rock visual states.
-   [ ] Crack visuals.
-   [ ] Weak Point visuals.
-   [ ] Rock break VFX.
-   [ ] Fossil reveal presentation.
-   [ ] Revival UI.
-   [ ] Revival animation.
-   [ ] Normal reveal.
-   [ ] Gold reveal.
-   [ ] Research UI.
-   [ ] Research progress visual.
-   [ ] Breakthrough presentation.
-   [ ] Pulse VFX.
-   [ ] Pulse charge feedback.
-   [ ] Pulse burst feedback.
-   [ ] Sound hooks.

### Quy tắc

Dev 2 không tự quyết định:

-   Gold RNG.
-   Fossil reward.
-   Research outcome.
-   Permanent player data.

Dev 2 nhận authoritative result từ Server và trình bày nó.

Có thể mock:

``` text
RockStateChanged
RevivalResult
ResearchProgress
PulseReady
```

để làm song song khi backend chưa hoàn thành.

------------------------------------------------------------------------

## DEV 3 --- INTEGRATION / WORLD / PROGRESSION OWNER

### Ownership

Dev 3 chịu trách nhiệm:

> "Người chơi từ lúc spawn đến phút thứ 10 trải nghiệm có liền mạch hay
> không."

### Phase 1

-   [ ] `OnboardingService` state machine skeleton.
-   [ ] Site 1 blockout.
-   [ ] Dig area layout.
-   [ ] Machine placement.
-   [ ] Player spawn.
-   [ ] Species A/B config.
-   [ ] Collection data/config.
-   [ ] Site 2 Gate visual.
-   [ ] First 10 Minutes flow config.
-   [ ] Onboarding prompts.
-   [ ] Integration hooks.

### Phase 2+

-   [ ] Nối onboarding với gameplay events thật.
-   [ ] Kiểm tra pacing.
-   [ ] Kiểm tra UI Complexity Rule.
-   [ ] Kiểm tra No Punishment Rule.
-   [ ] Final integration.
-   [ ] Playtest logging.
-   [ ] Balance config.
-   [ ] Scope control.

### Quy tắc

Dev 3 không được tự nhét feature mới vào onboarding.

Nếu flow không ổn:

``` text
Record problem
→ Identify violated Design Pillar
→ Discuss solution
```

Không tự thêm 3 popup/tutorial mới.

### Quy định Ghi Log Tiến Độ (Bắt buộc)

- **File log:** `DEV3_LOG.md`
- **Mục đích:** Để toàn bộ team (Dev 1, Dev 2, Tech Lead) luôn nắm rõ Dev 3 đang làm gì, vừa hoàn thành gì, thay đổi file nào và bước tiếp theo là gì.
- **Quy tắc:** Bất cứ khi nào làm việc, tạo file, sửa code, tích hợp module hay cập nhật logic thuộc scope Dev 3, agent/Dev 3 **phải cập nhật log vào `DEV3_LOG.md`**.
- **Cấu trúc một entry log gồm:**
  - Thời gian (Timestamp / Ngày giờ)
  - Công việc đang thực hiện / Đã hoàn thành (Task / Action)
  - Các file bị ảnh hưởng (Affected Files)
  - Chi tiết thay đổi / Quyết định kỹ thuật (Details / Decisions)
  - Trạng thái & Bước tiếp theo (Status & Next Steps)
  - Vấn đề / Yêu cầu phối hợp với Dev 1 & Dev 2 (Blockers / Coordination)

------------------------------------------------------------------------

# 20. CONTRACT DAY

Trước khi code logic lớn, cả 3 Dev phải thống nhất:

-   [ ] PlayerData schema.
-   [ ] RemoteEvent/RemoteFunction list.
-   [ ] Remote direction.
-   [ ] Payload format.
-   [ ] Rock state enum.
-   [ ] Onboarding states.
-   [ ] Species IDs.
-   [ ] Variant IDs.
-   [ ] Domain ownership.

Tạo file:

# `CONTRACTS.md`

Đây là nguồn tham chiếu chung.

Sau Contract Day:

> Không ai được tự đoán tên field của người khác.

Nếu Dev 1 cần field:

``` text
PulseUnlocked
```

Dev 2 và Dev 3 dùng đúng field đó.

Không tạo:

``` text
HasPulse
IsPulseUnlocked
PulseOwned
```

cho cùng một ý nghĩa.

------------------------------------------------------------------------

# 21. PRODUCTION TIMELINE

## Phase 0 --- Contract Day

Thời gian: khoảng nửa ngày.

Cả team:

``` text
Lock contracts
→ Lock ownership
→ Lock scope
```

Không build feature lớn trước khi contract cơ bản thống nhất.

------------------------------------------------------------------------

## Phase 1 --- Parallel Development

Thời gian: Tuần 1.

### Dev 1

Build Server Logic bằng test/stub.

### Dev 2

Build Client Feel bằng fake events.

### Dev 3

Build Onboarding + World + Config bằng mock gameplay events.

Mục tiêu:

> Không ai chờ ai để bắt đầu.

------------------------------------------------------------------------

## Phase 2 --- Integration

Thời gian: đầu Tuần 2.

Thứ tự ưu tiên:

``` text
1. Dig → Fossil
2. Fossil → Revival
3. Revival → New/Duplicate
4. Duplicate → Research
5. Research → Breakthrough
6. Breakthrough → Pulse
7. Pulse → Dig experience
8. Onboarding connects everything
9. Collection + Site 2 Gate
```

------------------------------------------------------------------------

## Phase 3 --- Polish

Tuần 2 cuối đến Tuần 3.

Tập trung:

-   Animation timing.
-   Sound.
-   VFX.
-   Gold reveal.
-   Pulse satisfaction.
-   Camera.
-   UI clarity.
-   First 10 Minutes pacing.

Không thêm feature lớn trong phase này.

------------------------------------------------------------------------

## Phase 4 --- External Playtest

Tuần 3 đến Tuần 4.

Test bằng người ngoài team.

Ưu tiên người chơi Roblox thật, càng gần target audience càng tốt.

Đo:

### Voluntary Continue Rate

Sau khi bước vào Free Play:

> Bao nhiêu người tự nguyện đào thêm ít nhất 1 Fossil mà không có ai
> nhắc?

Cần đặt threshold cụ thể trước khi playtest.

Ví dụ placeholder:

``` text
Target ≥ 70%
```

Con số cuối cùng có thể thay đổi sau khi team quyết định sample size.

Quan sát:

-   Chỗ nào họ không biết làm gì?
-   Chỗ nào họ bỏ qua?
-   Chỗ nào họ reaction mạnh?
-   Chỗ nào họ thấy chán?
-   Họ có tự tiếp tục đào không?

Không sửa game ngay giữa từng lượt test.

Thu thập đủ feedback rồi mới thay đổi.

------------------------------------------------------------------------

# 22. DEFINITION OF DONE --- VERTICAL SLICE

Vertical Slice chỉ được coi là hoàn thành khi:

-   [ ] Người chơi có thể spawn và hiểu phải đào mà không cần đọc hướng
    dẫn dài.
-   [ ] Strike Rock có feedback ngay lập tức.
-   [ ] Crack tạo cảm giác tiến triển.
-   [ ] Weak Point dễ hiểu bằng visual.
-   [ ] Miss Weak Point không gây punishment.
-   [ ] Người chơi nhận được Fossil.
-   [ ] Revival tạo anticipation.
-   [ ] New Discovery dễ hiểu.
-   [ ] Duplicate xuất hiện đúng pacing.
-   [ ] Research không yêu cầu đọc checklist phức tạp.
-   [ ] Research dẫn tới Breakthrough.
-   [ ] Pulse thay đổi interaction, không chỉ tăng số.
-   [ ] Gold moment nhìn vào là biết đặc biệt.
-   [ ] First Session Protection chạy server-side.
-   [ ] Protection có exit condition.
-   [ ] Site 2 Gate tạo được cliffhanger.
-   [ ] Không có feature out-of-scope làm phình dự án.
-   [ ] Playtester ngoài team hiểu core loop.
-   [ ] Đạt threshold Voluntary Continue Rate đã chốt.

------------------------------------------------------------------------

# 23. ANTI-PATTERNS --- NHỮNG ĐIỀU CẦN TRÁNH

Không tự biến FOSSIL PARK thành:

## Mining Simulator clone

Tránh core loop:

``` text
Click
→ Sell
→ Buy stronger tool
→ Click faster
→ Sell
→ Buy bigger tool
```

## Pet damage simulator

Tránh:

``` text
Creature = DPS
Best pet = highest multiplier
Need bigger multiplier
```

## Pure RNG button simulator

Tránh gameplay:

``` text
Stand still
→ Press Roll
→ Wait
→ Repeat
```

RNG phải được gắn với Discovery và gameplay context.

## Idle-first game

Không thiết kế hệ thống khiến người chơi tốt nhất là:

``` text
AFK
→ Wait
→ Return
→ Collect everything
```

## UI overload

Không:

-   Checklist dài.
-   Popup liên tục.
-   Nhiều button choice trong onboarding.
-   Tutorial text che gameplay.

------------------------------------------------------------------------

# 24. WHEN ADDING A NEW FEATURE

Trước khi code feature mới, AI agent hoặc developer phải trả lời:

1.  Feature này hỗ trợ Pillar nào?
2.  Nó thêm gameplay verb hay chỉ thêm number?
3.  Nó có làm người chơi mới phải đọc thêm nhiều không?
4.  Nó có punishment không?
5.  Nó có trùng cảm giác với feature hiện tại không?
6.  Nó có nằm trong Vertical Slice scope không?
7.  Nó có tạo thêm dependency lớn không?

Nếu không trả lời rõ được:

> **Do not implement it yet.**

------------------------------------------------------------------------

# 25. AI AGENT INSTRUCTIONS

Khi hỗ trợ code cho dự án này:

## DO

-   Đọc file này trước khi đề xuất architecture lớn.
-   Tôn trọng Server Authority.
-   Tôn trọng Domain Ownership.
-   Giữ naming thống nhất với `CONTRACTS.md`.
-   Ưu tiên scope nhỏ.
-   Dùng config/data-driven design khi phù hợp.
-   Cho phép Dev 1/2/3 làm song song bằng mock/stub.
-   Tách gameplay logic khỏi presentation.
-   Báo rõ nếu đề xuất mới mâu thuẫn với Design Pillars.
-   **Luôn cập nhật `DEV3_LOG.md`:** Mỗi khi thực hiện công việc, viết code, sửa lỗi, cập nhật tài liệu hoặc chuyển trạng thái task của Dev 3, phải ghi log chi tiết vào [DEV3_LOG.md](file:///c:/Project%20Web/FossilPark/DEV3_LOG.md) để các thành viên khác trong team nắm bắt.

## DO NOT

-   Không tự thêm hệ thống ngoài Vertical Slice scope.
-   Không tự biến Coin thành progression gate chính.
-   Không tự thêm pet combat.
-   Không thêm mining power upgrade kiểu simulator cũ nếu chưa có quyết
    định mới.
-   Không để Client quyết định RNG.
-   Không để Client quyết định permanent rewards.
-   Không tự đổi Remote contract.
-   Không tạo duplicate source of truth.
-   Không thay onboarding state machine bằng tutorial popup chain.
-   Không biến bonus thành punishment.
-   Không tăng Gold RNG từ Weak Point/Pulse.
-   Không giả định feature future đã tồn tại.

## Nếu yêu cầu của developer mâu thuẫn với file này

Không tự im lặng sửa design.

Phải:

1.  Nêu điểm mâu thuẫn.
2.  Chỉ ra Pillar/rule liên quan.
3.  Đề xuất phương án tương thích.
4.  Chỉ thay đổi design khi developer xác nhận.

------------------------------------------------------------------------

# 26. CURRENT DEVELOPMENT PRIORITY

Hiện tại dự án đang ở giai đoạn:

# VERTICAL SLICE v1

Ưu tiên tuyệt đối:

``` text
MAKE THE FIRST 10 MINUTES FUN
```

Không ưu tiên:

``` text
Lots of content
Lots of species
Lots of maps
Lots of systems
```

Câu hỏi quan trọng nhất trước khi mở rộng game là:

> **"Core loop DIG → REVIVE → RESEARCH → PULSE → DISCOVER có thực sự
> khiến người chơi muốn tiếp tục chơi không?"**

Nếu chưa trả lời được câu hỏi này bằng playtest thật:

> **Do not scale the project yet.**
