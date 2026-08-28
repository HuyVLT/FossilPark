--!strict

-- Dev 3 presentation metadata only. Authoritative discoveries belong to server-owned player data.

local SpeciesConfig = require(script.Parent:WaitForChild("SpeciesConfig"))

export type DiscoveryPresentationState = "Undiscovered" | "Discovered"
export type SupportedVariant = "Normal" | "Gold"

export type CollectionSlot = {
	order: number,
	speciesId: string,
	temporarySpeciesId: boolean,
}

local slots: { CollectionSlot } = {
	{
		order = 1,
		speciesId = SpeciesConfig.species_a.id,
		temporarySpeciesId = true,
	},
	{
		order = 2,
		speciesId = SpeciesConfig.species_b.id,
		temporarySpeciesId = true,
	},
}

local CollectionConfig = {
	totalSpecies = 2,
	slots = slots,
	discoveryPresentation = {
		Undiscovered = {
			label = "Undiscovered",
			showIdentity = false,
		},
		Discovered = {
			label = "Discovered",
			showIdentity = true,
		},
	},
	variantPresentation = {
		Normal = {
			label = "Normal",
			accentColor = Color3.fromRGB(191, 201, 203),
		},
		Gold = {
			label = "Gold",
			accentColor = Color3.fromRGB(235, 190, 75),
		},
	},
}

return CollectionConfig
