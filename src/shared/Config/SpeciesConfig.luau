--!strict

export type SpeciesEntry = {
	id: string,
	displayName: string,
	fossilName: string,
}

export type SpeciesConfigType = {
	[string]: SpeciesEntry,
}

local SpeciesConfig: { [string]: SpeciesEntry } = {
	species_a = {
		id = "species_a",
		displayName = "Creature A",
		fossilName = "Ancient Claw Fossil",
	},

	species_b = {
		id = "species_b",
		displayName = "Creature B",
		fossilName = "Stone Egg Fossil",
	},
}

return SpeciesConfig
