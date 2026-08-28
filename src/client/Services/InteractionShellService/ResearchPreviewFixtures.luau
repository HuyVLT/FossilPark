--!strict

-- DEV PREVIEW ONLY. This local shape is not a production ResearchProgress contract.

export type PreviewResearchState = {
	displayProgress: string,
	isComplete: boolean,
	statusLabel: string,
}

local prompt: PreviewResearchState = table.freeze({
	displayProgress = "No progress submitted",
	isComplete = false,
	statusLabel = "RESEARCH THIS!",
})

local incomplete: PreviewResearchState = table.freeze({
	displayProgress = "1 / 2 (DEV EXAMPLE)",
	isComplete = false,
	statusLabel = "Research in progress",
})

local complete: PreviewResearchState = table.freeze({
	displayProgress = "2 / 2 (DEV EXAMPLE)",
	isComplete = true,
	statusLabel = "Research complete",
})

local ResearchPreviewFixtures: { [string]: PreviewResearchState } = table.freeze({
	prompt = prompt,
	incomplete = incomplete,
	complete = complete,
})

return ResearchPreviewFixtures
