--!strict

-- Dev 3 presentation and playtest configuration only.
-- This module owns no progression, rewards, RNG, persistence, or gameplay authority.

export type MilestoneName =
	"Spawn"
	| "FirstDig"
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

local FirstSessionConfig = {
	landmarks = {
		blockoutFolder = "Site1Blockout",
		spawn = "PlayerSpawn",
		digArea = "DigArea",
		revivalChamber = "RevivalChamber",
		researchMachine = "ResearchMachine",
		site2Gate = "Site2Gate",
	},

	interactionRanges = {
		Dig = 48,
		Revival = 34,
		Research = 28,
		Gate = 48,
	},

	guidance = {
		distanceUpdateInterval = 0.25,
	},

	timingMilestones = {
		"Spawn",
		"FirstDig",
		"FirstFossil",
		"FirstRevival",
		"NewDiscovery",
		"FirstDuplicate",
		"ResearchPrompt",
		"ResearchComplete",
		"Breakthrough",
		"PulseUnlocked",
		"FreePlay",
		"GateSeen",
	} :: { MilestoneName },

	playtest = {
		timingTrackerEnabledInStudio = true,
	},
}

return FirstSessionConfig
