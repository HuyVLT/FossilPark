-- CONTRACT CONFLICT: preserved remote RNG prototype. It is deliberately outside Server.Services
-- and must not run until its remote name, payload, and reward outcomes are approved by all developers.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Remotes = require(ReplicatedStorage.Shared.Experimental.Networking.Remotes).init()
local Config = require(script.Config)

local RNGService = {}
RNGService.__index = RNGService

local cooldowns: { [number]: number } = {}

local function weightedPick(rng: Random)
	local total = 0
	for _, outcome in Config.Outcomes do
		total += outcome.Weight
	end
	if total <= 0 then
		return nil
	end

	local roll = rng:NextNumber() * total
	for _, outcome in Config.Outcomes do
		roll -= outcome.Weight
		if roll <= 0 then
			return outcome
		end
	end
	return Config.Outcomes[#Config.Outcomes]
end

local function onTriggered(player: Player, prompt: ProximityPrompt)
	local now = os.clock()
	if cooldowns[player.UserId] and now < cooldowns[player.UserId] then
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local part = prompt:FindFirstAncestorWhichIsA("BasePart")
	if not root or not part then
		return
	end

	if (root.Position - part.Position).Magnitude > Config.Range then
		return
	end

	cooldowns[player.UserId] = now + Config.Cooldown

	local rng = if Config.Seed then Random.new(Config.Seed) else Random.new()
	local result = weightedPick(rng)
	if not result then
		return
	end

	Remotes.RNGResult:FireClient(player, result.Name)
end

local function bind(prompt: ProximityPrompt)
	prompt.Triggered:Connect(function(player)
		onTriggered(player, prompt)
	end)
end

function RNGService.init()
	for _, prompt in CollectionService:GetTagged(Config.TriggerTag) do
		bind(prompt)
	end
	CollectionService:GetInstanceAddedSignal(Config.TriggerTag):Connect(bind)
end

return RNGService
