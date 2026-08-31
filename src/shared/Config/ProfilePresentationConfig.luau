--!strict

-- Dev 3 presentation metadata only. This is not an authoritative public Profile schema or replication contract.

export type ProfileFieldKey = "DisplayName" | "EquippedTitle" | "DiscoveryCount" | "CollectionShowcase"

export type ProfileFieldPresentation = {
	key: ProfileFieldKey,
	label: string,
	presentationOrder: number,
}

local fields: { ProfileFieldPresentation } = table.freeze({
	table.freeze({ key = "DisplayName", label = "Explorer", presentationOrder = 1 }),
	table.freeze({ key = "EquippedTitle", label = "Title", presentationOrder = 2 }),
	table.freeze({ key = "DiscoveryCount", label = "Discoveries", presentationOrder = 3 }),
	table.freeze({ key = "CollectionShowcase", label = "Showcase", presentationOrder = 4 }),
})

local ProfilePresentationConfig = table.freeze({
	previewTitle = "PLAYER PROFILE — DEV PREVIEW",
	emptyTitleLabel = "No title selected",
	emptyShowcaseLabel = "No discoveries showcased",
	fields = fields,
})

return ProfilePresentationConfig
