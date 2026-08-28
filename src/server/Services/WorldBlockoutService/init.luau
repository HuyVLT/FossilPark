--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = Shared:WaitForChild("Config")
local WorldBlockoutConfig = require(Config:WaitForChild("WorldBlockoutConfig"))

type BlockoutEntry = {
	id: string,
	position: Vector3,
	size: Vector3,
	label: string?,
	type: string,
}

type BorderEntry = {
	name: string,
	size: Vector3,
	position: Vector3,
}

local BLOCKOUT_FOLDER_NAME = "Site1Blockout"
local Palette = WorldBlockoutConfig.palette

local function createPart(name: string, size: Vector3, position: Vector3, color: Color3, material: Enum.Material, canCollide: boolean, rotation: Vector3?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = canCollide
	part.Size = size
	part.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(rotation and rotation.X or 0), math.rad(rotation and rotation.Y or 0), math.rad(rotation and rotation.Z or 0))
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

local function setBlockoutAttributes(instance: Instance, id: string, label: string?, blockoutType: string)
	instance:SetAttribute("BlockoutId", id)
	instance:SetAttribute("BlockoutType", blockoutType)
	if label then
		instance:SetAttribute("Label", label)
	end
end

local function buildGround(parent: Instance)
	local ground = WorldBlockoutConfig.ground
	local part = createPart(ground.id, ground.size, ground.position, Palette.earth, Enum.Material.Ground, true, nil)
	setBlockoutAttributes(part, ground.id, "Site 1 Ground", "Ground")
	part.Parent = parent
end

local function buildPaths(parent: Instance)
	local paths = Instance.new("Folder")
	paths.Name = "Paths"
	paths.Parent = parent

	for _, entry in ipairs(WorldBlockoutConfig.paths) do
		local path = createPart(entry.id, entry.size, entry.position, Palette.path, Enum.Material.Ground, true, nil)
		setBlockoutAttributes(path, entry.id, "Guidance Path", "Path")
		path.Parent = paths
	end
end

local function buildSpawn(entry: BlockoutEntry, parent: Instance)
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = entry.id
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Enabled = true
	spawn.AllowTeamChangeOnTouch = false
	spawn.Size = entry.size
	-- Identity rotation is level and faces negative Z, directly toward the Dig Area.
	spawn.CFrame = CFrame.new(entry.position)
	spawn.Color = Color3.fromRGB(71, 103, 105)
	spawn.Material = Enum.Material.Slate
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.BottomSurface = Enum.SurfaceType.Smooth
	setBlockoutAttributes(spawn, entry.id, entry.label, entry.type)

	local accent = createPart("SpawnAccent", Vector3.new(5.5, 0.08, 5.5), entry.position + Vector3.new(0, entry.size.Y / 2 + 0.05, 0), Palette.cyan, Enum.Material.SmoothPlastic, false, nil)
	accent.Parent = spawn
	spawn.Parent = parent
end

local function disableDefaultRootSpawn()
	-- Only the known root-level Baseplate spawn is disabled for this prototype session.
	-- Do not modify SpawnLocations inside unrelated Workspace models.
	local defaultSpawn = Workspace:FindFirstChild("SpawnLocation")
	if defaultSpawn and defaultSpawn:IsA("SpawnLocation") then
		defaultSpawn.Enabled = false
		defaultSpawn:SetAttribute("Dev3PrototypeDisabled", true)
	end
end

local function buildDigArea(entry: BlockoutEntry, parent: Instance)
	local model = Instance.new("Model")
	model.Name = entry.id
	setBlockoutAttributes(model, entry.id, entry.label, entry.type)

	local surface = createPart("Surface", entry.size, entry.position, Palette.earth, Enum.Material.Ground, true, nil)
	surface.Parent = model

	local border = Instance.new("Folder")
	border.Name = "ExcavationBorder"
	border.Parent = model
	local halfX = entry.size.X / 2
	local halfZ = entry.size.Z / 2
	local borderHeight = 0.7
	local borderY = entry.position.Y + entry.size.Y / 2 + borderHeight / 2
	local borderParts: { BorderEntry } = {
		{ name = "North", size = Vector3.new(entry.size.X, borderHeight, 3), position = entry.position + Vector3.new(0, borderY - entry.position.Y, -halfZ) },
		{ name = "South", size = Vector3.new(entry.size.X, borderHeight, 3), position = entry.position + Vector3.new(0, borderY - entry.position.Y, halfZ) },
		{ name = "West", size = Vector3.new(3, borderHeight, entry.size.Z), position = entry.position + Vector3.new(-halfX, borderY - entry.position.Y, 0) },
		{ name = "East", size = Vector3.new(3, borderHeight, entry.size.Z), position = entry.position + Vector3.new(halfX, borderY - entry.position.Y, 0) },
	}
	for _, borderEntry in ipairs(borderParts) do
		local borderPart = createPart(borderEntry.name, borderEntry.size, borderEntry.position, Palette.stone, Enum.Material.Slate, false, nil)
		borderPart.Parent = border
	end

	local rocks = Instance.new("Folder")
	rocks.Name = "DigRocks"
	rocks.Parent = model

	for _, rockEntry in ipairs(WorldBlockoutConfig.digRocks) do
		local rock = createPart(rockEntry.id, rockEntry.size, rockEntry.position, Palette.stone, Enum.Material.Slate, false, rockEntry.rotation)
		if rockEntry.shape == "Ball" then
			rock.Shape = Enum.PartType.Ball
		elseif rockEntry.shape == "Cylinder" then
			rock.Shape = Enum.PartType.Cylinder
		end
		setBlockoutAttributes(rock, rockEntry.id, "Visual Dig Rock", "DigRock")
		rock.Parent = rocks
	end

	local fragments = Instance.new("Folder")
	fragments.Name = "RockFragments"
	fragments.Parent = model
	for _, fragmentEntry in ipairs(WorldBlockoutConfig.digFragments) do
		local fragment = createPart(fragmentEntry.id, fragmentEntry.size, fragmentEntry.position, Palette.stone, Enum.Material.Slate, false, fragmentEntry.rotation)
		if fragmentEntry.shape == "Ball" then
			fragment.Shape = Enum.PartType.Ball
		end
		fragment.Parent = fragments
	end

	model.Parent = parent
end

local function buildRevivalChamber(entry: BlockoutEntry, parent: Instance)
	local model = Instance.new("Model")
	model.Name = entry.id
	setBlockoutAttributes(model, entry.id, entry.label, entry.type)

	local base = createPart("Platform", Vector3.new(entry.size.X, 1.5, entry.size.Z), entry.position + Vector3.new(0, 0.75, 0), Palette.stone, Enum.Material.Slate, true, nil)
	base.Parent = model

	local supportSize = Vector3.new(6, entry.size.Y, 8)
	local leftSupport = createPart("LeftSupport", supportSize, entry.position + Vector3.new(-13, entry.size.Y / 2, 0), Palette.metal, Enum.Material.Metal, false, nil)
	leftSupport.Parent = model

	local rightSupport = createPart("RightSupport", supportSize, entry.position + Vector3.new(13, entry.size.Y / 2, 0), Palette.metal, Enum.Material.Metal, false, nil)
	rightSupport.Parent = model

	local chamber = createPart("Chamber", Vector3.new(14, entry.size.Y - 4, 14), entry.position + Vector3.new(0, (entry.size.Y - 4) / 2 + 1.5, 0), Palette.metal, Enum.Material.Glass, false, nil)
	chamber.Shape = Enum.PartType.Cylinder
	chamber.Transparency = 0.2
	chamber.Parent = model

	local energyCore = createPart("EnergyCore", Vector3.new(3, entry.size.Y - 8, 3), entry.position + Vector3.new(0, entry.size.Y / 2 + 1.5, 0), Palette.cyan, Enum.Material.Neon, false, nil)
	energyCore.Shape = Enum.PartType.Cylinder
	energyCore.Parent = model

	local top = createPart("TopStructure", Vector3.new(32, 4, 22), entry.position + Vector3.new(0, entry.size.Y + 2, 0), Palette.metal, Enum.Material.Metal, false, nil)
	top.Parent = model

	model.Parent = parent
end

local function buildResearchMachine(entry: BlockoutEntry, parent: Instance)
	local model = Instance.new("Model")
	model.Name = entry.id
	setBlockoutAttributes(model, entry.id, entry.label, entry.type)

	local base = createPart("Platform", Vector3.new(entry.size.X, 1.5, entry.size.Z), entry.position + Vector3.new(0, 0.75, 0), Palette.stone, Enum.Material.Slate, true, nil)
	base.Parent = model

	local leftSupport = createPart("LeftSupport", Vector3.new(4, entry.size.Y - 4, 6), entry.position + Vector3.new(-7, (entry.size.Y - 4) / 2 + 1.5, 0), Palette.metal, Enum.Material.Metal, false, nil)
	leftSupport.Parent = model

	local rightSupport = createPart("RightSupport", Vector3.new(4, entry.size.Y - 4, 6), entry.position + Vector3.new(7, (entry.size.Y - 4) / 2 + 1.5, 0), Palette.metal, Enum.Material.Metal, false, nil)
	rightSupport.Parent = model

	local machine = createPart("MachineBody", Vector3.new(12, 8, 12), entry.position + Vector3.new(0, 5.5, 0), Palette.metal, Enum.Material.Metal, false, nil)
	machine.Parent = model

	local core = createPart("ResearchCore", Vector3.new(5, 5, 5), entry.position + Vector3.new(0, 12, 0), Palette.amber, Enum.Material.Neon, false, nil)
	core.Shape = Enum.PartType.Ball
	core.Parent = model

	model.Parent = parent
end

local function buildGate(entry: BlockoutEntry, parent: Instance)
	local model = Instance.new("Model")
	model.Name = entry.id
	setBlockoutAttributes(model, entry.id, entry.label, entry.type)

	local base = createPart("GateGround", Vector3.new(entry.size.X + 20, 1.5, 32), entry.position + Vector3.new(0, 0.75, 0), Palette.earth, Enum.Material.Ground, true, nil)
	base.Parent = model

	local postSize = Vector3.new(12, entry.size.Y, entry.size.Z)
	local postOffset = (entry.size.X - postSize.X) / 2
	local leftPost = createPart("LeftPost", postSize, entry.position + Vector3.new(-postOffset, entry.size.Y / 2, 0), Palette.stone, Enum.Material.Slate, false, nil)
	leftPost.Parent = model

	local rightPost = createPart("RightPost", postSize, entry.position + Vector3.new(postOffset, entry.size.Y / 2, 0), Palette.stone, Enum.Material.Slate, false, nil)
	rightPost.Parent = model

	local lintel = createPart("Lintel", Vector3.new(entry.size.X, 8, entry.size.Z), entry.position + Vector3.new(0, entry.size.Y - 4, 0), Palette.stone, Enum.Material.Slate, false, nil)
	lintel.Parent = model

	local indicator = createPart("GateIndicator", Vector3.new(26, 1.5, 1.5), entry.position + Vector3.new(0, entry.size.Y - 11, -entry.size.Z / 2), Palette.cyan, Enum.Material.Neon, false, nil)
	indicator.Parent = model

	model.Parent = parent
end

local WorldBlockoutService = {}

function WorldBlockoutService.init()
	local existingBlockout = Workspace:FindFirstChild(BLOCKOUT_FOLDER_NAME)
	if existingBlockout then
		existingBlockout:Destroy()
	end

	local blockoutFolder = Instance.new("Folder")
	blockoutFolder.Name = BLOCKOUT_FOLDER_NAME
	blockoutFolder.Parent = Workspace

	disableDefaultRootSpawn()
	buildGround(blockoutFolder)
	buildPaths(blockoutFolder)

	for _, entry in ipairs(WorldBlockoutConfig.areas) do
		if entry.type == "Spawn" then
			buildSpawn(entry, blockoutFolder)
		elseif entry.type == "DigArea" then
			buildDigArea(entry, blockoutFolder)
		elseif entry.type == "RevivalChamber" then
			buildRevivalChamber(entry, blockoutFolder)
		elseif entry.type == "ResearchMachine" then
			buildResearchMachine(entry, blockoutFolder)
		elseif entry.type == "Gate" then
			buildGate(entry, blockoutFolder)
		end
	end
end

return WorldBlockoutService
