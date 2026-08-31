--!strict

-- Dev 3 presentation metadata only.
-- Title ownership, equip validation, staff roles, permissions, and gameplay effects remain server-authoritative Dev 1 domains.

export type TitleCategory = "Progression" | "Discovery" | "Staff"

export type TitleEntry = {
	id: string,
	displayName: string,
	description: string,
	category: TitleCategory,
	presentationOrder: number,
}

local fieldResearcher: TitleEntry = table.freeze({
	id = "field_researcher",
	displayName = "Field Researcher",
	description = "Contributes discoveries to fossil research.",
	category = "Progression",
	presentationOrder = 1,
})

local goldDiscoverer: TitleEntry = table.freeze({
	id = "gold_discoverer",
	displayName = "Gold Discoverer",
	description = "A presentation title for a remarkable Gold discovery.",
	category = "Discovery",
	presentationOrder = 2,
})

local tester: TitleEntry = table.freeze({
	id = "tester",
	displayName = "Tester",
	description = "Staff title presentation preview only. Grants no permissions.",
	category = "Staff",
	presentationOrder = 3,
})

local TitleConfig: { [string]: TitleEntry } = table.freeze({
	field_researcher = fieldResearcher,
	gold_discoverer = goldDiscoverer,
	tester = tester,
})

return TitleConfig
