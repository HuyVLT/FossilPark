--!strict

-- Dev 3 presentation/integration metadata only.
-- Breakthrough resolution and Pulse unlock/availability remain authoritative Dev 1 domains.

local BreakthroughPresentationConfig = {
	placeholder = {
		title = "BREAKTHROUGH — DEV PREVIEW",
		instruction = "Research is complete. A new excavation action is being revealed.",
		waitingStatus = "Waiting for authoritative Breakthrough result",
	},
	onboarding = {
		ResearchComplete = {
			title = "RESEARCH COMPLETE",
			instruction = "Research is complete. A breakthrough comes next.",
		},
		Breakthrough = {
			title = "BREAKTHROUGH",
			instruction = "A new excavation action has been discovered.",
		},
		PulseUnlocked = {
			title = "PULSE MODULE UNLOCKED",
			instruction = "Pulse is now available for future excavations.",
		},
		FreePlay = {
			title = "EXPLORE",
			instruction = "Tutorial complete. Explore and keep discovering fossils.",
		},
	},
	previewLabels = {
		breakthrough_pending = "Breakthrough pending",
		breakthrough_complete = "Breakthrough complete",
		pulse_unlocked = "Pulse Module unlocked",
	},
}

return BreakthroughPresentationConfig
