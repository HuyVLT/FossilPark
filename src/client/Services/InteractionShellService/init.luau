--!strict

-- Temporary Dev 3 integration shell. Final interaction UX belongs to Dev 2.
-- Server gameplay systems must replace these mock client-only actions; no authoritative state is changed here.

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local InteractionUiShell = require(script.Parent:WaitForChild("InteractionUiShell"))

type InteractionKind = "Dig" | "Revival" | "Research" | "Gate"

type InteractionTarget = {
	kind: InteractionKind,
	instance: Instance,
	promptTitle: string,
	promptDetail: string?,
	range: number,
}

local InteractionShellService = {}

function InteractionShellService.init()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local ui = InteractionUiShell.new(playerGui)

	local blockout = Workspace:WaitForChild("Site1Blockout")
	local targets: { InteractionTarget } = {
	{
		kind = "Dig",
		instance = blockout:WaitForChild("DigArea"),
		promptTitle = "[E] Dig",
		range = 48,
	},
	{
		kind = "Revival",
		instance = blockout:WaitForChild("RevivalChamber"),
		promptTitle = "[E] Use Revival Chamber",
		range = 34,
	},
	{
		kind = "Research",
		instance = blockout:WaitForChild("ResearchMachine"),
		promptTitle = "[E] Open Research",
		range = 28,
	},
	{
		kind = "Gate",
		instance = blockout:WaitForChild("Site2Gate"),
		promptTitle = "[E] Inspect Site 2 Gate",
		range = 48,
	},
	}

	local activeTarget: InteractionTarget? = nil

	local function getWorldPosition(instance: Instance): Vector3?
		if instance:IsA("BasePart") then
			return instance.Position
		end

		if instance:IsA("Model") then
			local boundingBox = instance:GetBoundingBox()
			return boundingBox.Position
		end

		return nil
	end

	local function updatePrompt()
	if ui.isPanelOpen() then
		activeTarget = nil
		ui.clearPrompt()
		return
	end

	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not rootPart or not rootPart:IsA("BasePart") then
		activeTarget = nil
		ui.clearPrompt()
		return
	end

	local nearestTarget: InteractionTarget? = nil
	local nearestDistance = math.huge
	for _, target in ipairs(targets) do
		local targetPosition = getWorldPosition(target.instance)
		if targetPosition then
			local distance = (rootPart.Position - targetPosition).Magnitude
			if distance <= target.range and distance < nearestDistance then
				nearestTarget = target
				nearestDistance = distance
			end
		end
	end

	activeTarget = nearestTarget
	if activeTarget then
		ui.setPrompt(activeTarget.promptTitle, activeTarget.promptDetail)
	else
		ui.clearPrompt()
	end
	end

	local function activateInteraction(_actionName: string, inputState: Enum.UserInputState, _inputObject: InputObject)
	if inputState ~= Enum.UserInputState.Begin or ui.isPanelOpen() or not activeTarget then
		return Enum.ContextActionResult.Pass
	end

	print("[InteractionShell] " .. activeTarget.instance.Name .. " activated")

	if activeTarget.kind == "Dig" then
		ui.showDigPanel()
	elseif activeTarget.kind == "Revival" then
		ui.showRevivalPanel()
	elseif activeTarget.kind == "Research" then
		ui.showResearchPanel()
	elseif activeTarget.kind == "Gate" then
		ui.showGatePanel()
	end

	-- TODO: Dev 1 server validation and Dev 2 final input/presentation replace this prototype.
	-- Intentionally no client reward, RNG, or permanent-state mutation.
	return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindAction("Dev3PlaceholderInteract", activateInteraction, false, Enum.KeyCode.E)

	RunService.RenderStepped:Connect(updatePrompt)
end

return InteractionShellService
