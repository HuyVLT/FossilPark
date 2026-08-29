--!strict

-- Temporary presentation copy only. OnboardingService remains the authoritative state owner.

local BreakthroughPresentationConfig = require(script.Parent:WaitForChild("BreakthroughPresentationConfig"))

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

export type TargetIdentifier = "DigArea" | "RevivalChamber" | "ResearchMachine" | "Site2Gate"

export type PresentationEntry = {
	title: string,
	instruction: string,
	target: TargetIdentifier?,
}

type PresentationEntries = {
	FirstDig: PresentationEntry,
	FirstFossil: PresentationEntry,
	FirstRevival: PresentationEntry,
	NewDiscovery: PresentationEntry,
	FirstDuplicate: PresentationEntry,
	ResearchPrompt: PresentationEntry,
	ResearchComplete: PresentationEntry,
	Breakthrough: PresentationEntry,
	PulseUnlocked: PresentationEntry,
	FreePlay: PresentationEntry,
	GateSeen: PresentationEntry,
}

local states: PresentationEntries = {
	FirstDig = {
		title = "FIRST DIG",
		instruction = "Break your first brittle rock.",
		target = "DigArea",
	},
	FirstFossil = {
		title = "FOSSIL FOUND",
		instruction = "Take your fossil to the Revival Chamber.",
		target = "RevivalChamber",
	},
	FirstRevival = {
		title = "REVIVAL",
		instruction = "Revive your first creature.",
		target = "RevivalChamber",
	},
	NewDiscovery = {
		title = "NEW DISCOVERY",
		instruction = "Check your new species discovery.",
	},
	FirstDuplicate = {
		title = "DUPLICATE",
		instruction = "Duplicates can be used for Research.",
		target = "ResearchMachine",
	},
	ResearchPrompt = {
		title = "RESEARCH",
		instruction = "Take your duplicate to the Research Machine.",
		target = "ResearchMachine",
	},
	ResearchComplete = {
		title = BreakthroughPresentationConfig.onboarding.ResearchComplete.title,
		instruction = BreakthroughPresentationConfig.onboarding.ResearchComplete.instruction,
		target = "ResearchMachine",
	},
	Breakthrough = {
		title = BreakthroughPresentationConfig.onboarding.Breakthrough.title,
		instruction = BreakthroughPresentationConfig.onboarding.Breakthrough.instruction,
	},
	PulseUnlocked = {
		title = BreakthroughPresentationConfig.onboarding.PulseUnlocked.title,
		instruction = BreakthroughPresentationConfig.onboarding.PulseUnlocked.instruction,
	},
	FreePlay = {
		title = BreakthroughPresentationConfig.onboarding.FreePlay.title,
		instruction = BreakthroughPresentationConfig.onboarding.FreePlay.instruction,
	},
	GateSeen = {
		title = "SITE 2",
		instruction = "Site 2 remains locked in this Vertical Slice.",
		target = "Site2Gate",
	},
}

local OnboardingPresentationConfig = {
	states = states,
}

function OnboardingPresentationConfig.getPresentation(stateName: string): PresentationEntry?
	return (states :: { [string]: PresentationEntry })[stateName]
end

return OnboardingPresentationConfig
