--!strict

-- Dev 3 presentation metadata only. ResearchService owns authoritative progress and completion.

local FirstSessionConfig = require(script.Parent:WaitForChild("FirstSessionConfig"))

local ResearchPresentationConfig = {
	landmarkId = FirstSessionConfig.landmarks.researchMachine,
	placeholder = {
		title = "RESEARCH — DEV PREVIEW",
		instruction = "Duplicates can contribute to Research.",
		waitingStatus = "Waiting for authoritative Research data",
	},
	onboarding = {
		ResearchPrompt = {
			title = "RESEARCH",
			instruction = "Take your duplicate to the Research Machine.",
		},
		ResearchComplete = {
			title = "RESEARCH COMPLETE",
			instruction = "Research is complete. A breakthrough comes next.",
		},
	},
	progressPresentation = {
		incompleteLabel = "Research in progress",
		completeLabel = "Research complete",
	},
}

return ResearchPresentationConfig
