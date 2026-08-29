--!strict

-- DEV PREVIEW ONLY. These local presentation examples are not production payloads or contracts.

export type PreviewBreakthroughState = {
	presentationKey: "breakthrough_pending" | "breakthrough_complete" | "pulse_unlocked",
	detail: string,
}

local breakthroughPending: PreviewBreakthroughState = table.freeze({
	presentationKey = "breakthrough_pending",
	detail = "Awaiting an authoritative result (DEV EXAMPLE)",
})

local breakthroughComplete: PreviewBreakthroughState = table.freeze({
	presentationKey = "breakthrough_complete",
	detail = "A new excavation action was discovered (DEV EXAMPLE)",
})

local pulseUnlocked: PreviewBreakthroughState = table.freeze({
	presentationKey = "pulse_unlocked",
	detail = "Pulse is available for presentation testing (DEV EXAMPLE)",
})

local BreakthroughPreviewFixtures: { [string]: PreviewBreakthroughState } = table.freeze({
	breakthrough_pending = breakthroughPending,
	breakthrough_complete = breakthroughComplete,
	pulse_unlocked = pulseUnlocked,
})

return BreakthroughPreviewFixtures
