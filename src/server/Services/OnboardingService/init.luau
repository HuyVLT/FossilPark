--!strict

-- Dev 3 owns onboarding state. This skeleton is server-only and uses temporary in-memory state.
-- TODO: Replace mock events with validated Dev 1 domain events during integration.

local Players = game:GetService("Players")

export type OnboardingState =
	"FirstDig"
	| "FirstFossil"
	| "FirstRevival"
	| "NewDiscovery"
	| "FirstDuplicate"
	| "ResearchPrompt"
	| "ResearchComplete"
	| "Breakthrough"
	| "PulseUnlocked"
	| "FreePlay"
	| "GateSeen"

type Transition = {
	from: OnboardingState,
	to: OnboardingState,
}

local INITIAL_STATE: OnboardingState = "FirstDig"

-- Temporary Studio-only mapping. These event names are internal and are not RemoteEvent or contract names.
local mockDomainEvents: { [string]: Transition } = {
	FossilFound = { from = "FirstDig", to = "FirstFossil" },
	RevivalStarted = { from = "FirstFossil", to = "FirstRevival" },
	NewDiscoveryResolved = { from = "FirstRevival", to = "NewDiscovery" },
	DuplicateResolved = { from = "NewDiscovery", to = "FirstDuplicate" },
	ResearchPromptRequested = { from = "FirstDuplicate", to = "ResearchPrompt" },
	ResearchCompleted = { from = "ResearchPrompt", to = "ResearchComplete" },
	BreakthroughReached = { from = "ResearchComplete", to = "Breakthrough" },
	PulseUnlocked = { from = "Breakthrough", to = "PulseUnlocked" },
	FreePlayStarted = { from = "PulseUnlocked", to = "FreePlay" },
	GateSeen = { from = "FreePlay", to = "GateSeen" },
}

local playerStates: { [Player]: OnboardingState } = {}

local OnboardingService = {}

local function initializePlayer(player: Player)
	playerStates[player] = INITIAL_STATE
end

local function transition(player: Player, expectedState: OnboardingState, nextState: OnboardingState): boolean
	local currentState = playerStates[player]
	if currentState ~= expectedState then
		warn(string.format("[Onboarding] %s: rejected %s -> %s (current: %s)", player.Name, expectedState, nextState, currentState or "uninitialized"))
		return false
	end

	playerStates[player] = nextState
	print(string.format("[Onboarding] %s: %s -> %s", player.Name, currentState, nextState))

	if nextState == "GateSeen" then
		-- TODO: Dev 1 integration should use GateSeen to shut down First Session Protection.
	end

	return true
end

function OnboardingService.getState(player: Player): OnboardingState?
	return playerStates[player]
end

function OnboardingService.handleMockDomainEvent(player: Player, eventName: string): boolean
	local mapping = mockDomainEvents[eventName]
	if not mapping then
		warn(string.format("[Onboarding] %s: unknown mock event %q", player.Name, eventName))
		return false
	end

	return transition(player, mapping.from, mapping.to)
end

function OnboardingService.init()
	for _, player in Players:GetPlayers() do
		initializePlayer(player)
	end

	Players.PlayerAdded:Connect(initializePlayer)
	Players.PlayerRemoving:Connect(function(player)
		playerStates[player] = nil
	end)
end

return OnboardingService
