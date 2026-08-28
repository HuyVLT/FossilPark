--!strict

export type BlockoutType = "Spawn" | "DigArea" | "RevivalChamber" | "ResearchMachine" | "Gate"

export type BlockoutEntry = {
	id: string,
	position: Vector3,
	size: Vector3,
	label: string?,
	type: BlockoutType,
}

export type PathEntry = {
	id: string,
	position: Vector3,
	size: Vector3,
}

export type RockEntry = {
	id: string,
	position: Vector3,
	size: Vector3,
	rotation: Vector3,
	shape: "Ball" | "Block" | "Cylinder",
}

local WorldBlockoutConfig = {
	palette = {
		stone = Color3.fromRGB(69, 71, 75),
		metal = Color3.fromRGB(47, 56, 62),
		earth = Color3.fromRGB(93, 74, 54),
		path = Color3.fromRGB(112, 94, 68),
		cyan = Color3.fromRGB(67, 174, 178),
		amber = Color3.fromRGB(198, 137, 66),
	},

	ground = {
		id = "Ground",
		position = Vector3.new(0, -0.3, -146),
		size = Vector3.new(150, 1, 340),
	},

	paths = {
		{ id = "SpawnToDigPath", position = Vector3.new(0, 0.3, -28), size = Vector3.new(14, 0.16, 40) },
		{ id = "DigToRevivalPath", position = Vector3.new(0, 0.3, -108), size = Vector3.new(14, 0.16, 82) },
		{ id = "RevivalToResearchPath", position = Vector3.new(21, 0.3, -152), size = Vector3.new(42, 0.16, 14) },
		{ id = "MainToGatePath", position = Vector3.new(0, 0.3, -225), size = Vector3.new(16, 0.16, 134) },
	} :: { PathEntry },

	areas = {
		{
			id = "PlayerSpawn",
			position = Vector3.new(0, 0.5, 0),
			size = Vector3.new(8, 0.6, 8),
			label = "Player Spawn",
			type = "Spawn",
		},
		{
			id = "DigArea",
			position = Vector3.new(0, 0.4, -48),
			size = Vector3.new(84, 0.4, 76),
			label = "Dig Area",
			type = "DigArea",
		},
		{
			id = "RevivalChamber",
			position = Vector3.new(0, 0.2, -152),
			size = Vector3.new(40, 32, 40),
			label = "Revival Chamber",
			type = "RevivalChamber",
		},
		{
			id = "ResearchMachine",
			position = Vector3.new(42, 0.2, -152),
			size = Vector3.new(24, 20, 24),
			label = "Research Machine",
			type = "ResearchMachine",
		},
		{
			id = "Site2Gate",
			position = Vector3.new(0, 0.2, -292),
			size = Vector3.new(78, 42, 10),
			label = "Site 2 Gate",
			type = "Gate",
		},
	} :: { BlockoutEntry },

	digRocks = {
		{ id = "DigRock_01", position = Vector3.new(-25, 4.1, -28), size = Vector3.new(8, 7, 7), rotation = Vector3.new(8, 20, -12), shape = "Block" },
		{ id = "DigRock_02", position = Vector3.new(-8, 3.4, -24), size = Vector3.new(6, 5.6, 6), rotation = Vector3.new(-10, 35, 9), shape = "Ball" },
		{ id = "DigRock_03", position = Vector3.new(15, 4.6, -30), size = Vector3.new(9, 8, 7), rotation = Vector3.new(14, -20, 8), shape = "Block" },
		{ id = "DigRock_04", position = Vector3.new(30, 3.6, -45), size = Vector3.new(6, 6, 8), rotation = Vector3.new(20, 18, -15), shape = "Ball" },
		{ id = "DigRock_05", position = Vector3.new(-28, 3.6, -49), size = Vector3.new(7, 6, 6), rotation = Vector3.new(-8, -32, 18), shape = "Block" },
		{ id = "DigRock_06", position = Vector3.new(-12, 4.6, -58), size = Vector3.new(8, 8, 7), rotation = Vector3.new(12, 12, -20), shape = "Block" },
		{ id = "DigRock_07", position = Vector3.new(9, 3.1, -53), size = Vector3.new(5, 5, 5), rotation = Vector3.new(0, 44, 0), shape = "Ball" },
		{ id = "DigRock_08", position = Vector3.new(25, 5.1, -63), size = Vector3.new(9, 9, 8), rotation = Vector3.new(-14, 28, 12), shape = "Block" },
		{ id = "DigRock_09", position = Vector3.new(-30, 3.1, -68), size = Vector3.new(6, 5, 7), rotation = Vector3.new(18, -18, -10), shape = "Cylinder" },
		{ id = "DigRock_10", position = Vector3.new(3, 4.1, -72), size = Vector3.new(8, 7, 6), rotation = Vector3.new(-9, 50, 14), shape = "Block" },
	} :: { RockEntry },

	digFragments = {
		{ id = "DigFragment_01", position = Vector3.new(-18, 1.2, -35), size = Vector3.new(3, 1.2, 2), rotation = Vector3.new(8, 26, -14), shape = "Block" },
		{ id = "DigFragment_02", position = Vector3.new(2, 1.2, -34), size = Vector3.new(2, 1.2, 3), rotation = Vector3.new(-6, 42, 12), shape = "Block" },
		{ id = "DigFragment_03", position = Vector3.new(22, 1.1, -39), size = Vector3.new(2, 1, 2), rotation = Vector3.new(10, -18, 20), shape = "Ball" },
		{ id = "DigFragment_04", position = Vector3.new(-21, 1.3, -60), size = Vector3.new(3, 1.4, 2), rotation = Vector3.new(-8, 30, -16), shape = "Block" },
		{ id = "DigFragment_05", position = Vector3.new(16, 1.15, -58), size = Vector3.new(2, 1.1, 2), rotation = Vector3.new(12, 14, 24), shape = "Ball" },
		{ id = "DigFragment_06", position = Vector3.new(-2, 1.2, -68), size = Vector3.new(3, 1.2, 2), rotation = Vector3.new(4, -36, 10), shape = "Block" },
	} :: { RockEntry },
}

return WorldBlockoutConfig
