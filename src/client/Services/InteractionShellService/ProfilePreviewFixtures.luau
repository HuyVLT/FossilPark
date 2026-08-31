--!strict

-- DEV PREVIEW ONLY. These immutable presentation examples are not PlayerData, ownership, or replication contracts.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeciesConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("SpeciesConfig"))

export type ShowcaseEntry = {
	speciesId: string,
	variant: "Normal" | "Gold",
}

export type PreviewProfile = {
	displayName: string,
	titleId: string?,
	discoveryCount: number,
	showcase: { ShowcaseEntry },
}

local profileNewPlayer: PreviewProfile = table.freeze({
	displayName = "New Explorer",
	titleId = nil,
	discoveryCount = 0,
	showcase = table.freeze({}),
})

local profileDiscoverer: PreviewProfile = table.freeze({
	displayName = "Fossil Finder",
	titleId = "field_researcher",
	discoveryCount = 1,
	showcase = table.freeze({
		table.freeze({ speciesId = SpeciesConfig.species_a.id, variant = "Normal" }),
	}),
})

local profileGoldShowcase: PreviewProfile = table.freeze({
	displayName = "Golden Explorer",
	titleId = "gold_discoverer",
	discoveryCount = 2,
	showcase = table.freeze({
		table.freeze({ speciesId = SpeciesConfig.species_b.id, variant = "Gold" }),
	}),
})

local profileStaffPreview: PreviewProfile = table.freeze({
	displayName = "Studio Tester",
	titleId = "tester",
	discoveryCount = 2,
	showcase = table.freeze({
		table.freeze({ speciesId = SpeciesConfig.species_a.id, variant = "Normal" }),
		table.freeze({ speciesId = SpeciesConfig.species_b.id, variant = "Gold" }),
	}),
})

local ProfilePreviewFixtures: { [string]: PreviewProfile } = table.freeze({
	profile_new_player = profileNewPlayer,
	profile_discoverer = profileDiscoverer,
	profile_gold_showcase = profileGoldShowcase,
	profile_staff_preview = profileStaffPreview,
})

return ProfilePreviewFixtures
