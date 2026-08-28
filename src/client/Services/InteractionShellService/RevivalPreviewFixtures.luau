--!strict

-- DEV PREVIEW ONLY. These immutable examples are never authoritative Revival results.

export type PreviewResult = {
	species: string,
	variant: "Normal" | "Gold",
	isNewDiscovery: boolean,
	isDuplicate: boolean,
}

local speciesANormalNew: PreviewResult = table.freeze({
	species = "species_a",
	variant = "Normal",
	isNewDiscovery = true,
	isDuplicate = false,
})

local speciesAGoldNew: PreviewResult = table.freeze({
	species = "species_a",
	variant = "Gold",
	isNewDiscovery = true,
	isDuplicate = false,
})

local speciesBNormalDuplicate: PreviewResult = table.freeze({
	species = "species_b",
	variant = "Normal",
	isNewDiscovery = false,
	isDuplicate = true,
})

local RevivalPreviewFixtures: { [string]: PreviewResult } = table.freeze({
	species_a_normal_new = speciesANormalNew,
	species_a_gold_new = speciesAGoldNew,
	species_b_normal_duplicate = speciesBNormalDuplicate,
})

return RevivalPreviewFixtures
