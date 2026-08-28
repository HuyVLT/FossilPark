--!strict

-- Temporary Dev 3 integration shell. Final interaction UX belongs to Dev 2.
-- Server gameplay systems must replace these mock client-only actions; no authoritative state is changed here.

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local InteractionUiShell = require(script:WaitForChild("InteractionUiShell"))
local OnboardingTargetGuidance = require(script:WaitForChild("OnboardingTargetGuidance"))
local sharedConfig = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local OnboardingPresentationConfig = require(sharedConfig:WaitForChild("OnboardingPresentationConfig"))

type InteractionKind = "Dig" | "Revival" | "Research" | "Gate"

type InteractionTarget = {
	kind: InteractionKind,
	instance: Instance,
	promptTitle: string,
	promptDetail: string?,
	range: number,
}

local InteractionShellService = {}
local previewUi: any = nil
local targetGuidance: any = nil
local promptConnection: RBXScriptConnection? = nil
local previewRequestConnection: RBXScriptConnection? = nil

local PREVIEW_STATE_ATTRIBUTE = "Dev3PreviewState"
local PREVIEW_REQUEST_ID_ATTRIBUTE = "Dev3PreviewRequestId"

local function cleanup()
	if promptConnection then
		promptConnection:Disconnect()
		promptConnection = nil
	end

	if previewRequestConnection then
		previewRequestConnection:Disconnect()
		previewRequestConnection = nil
	end

	if targetGuidance then
		targetGuidance:destroy()
		targetGuidance = nil
	end

	ContextActionService:UnbindAction("Dev3PlaceholderInteract")
	previewUi = nil
end

local function applyPreviewState(stateName: string): boolean
	local presentation = OnboardingPresentationConfig.getPresentation(stateName)
	if not presentation then
		warn(string.format("[OnboardingPreview] Unknown preview state %q", stateName))
		return false
	end

	if not previewUi then
		return false
	end

	previewUi.setOnboardingObjective(presentation.title, presentation.instruction, presentation.target)
	if targetGuidance then
		targetGuidance:setTarget(presentation.target)
	end
	print(string.format("[OnboardingPreview] %s", stateName))
	return true
end

-- DEV PREVIEW ONLY
-- Replace with server-authoritative onboarding state replication after networking contract is finalized.
function InteractionShellService.setPreviewState(stateName: string): boolean
	local presentation = OnboardingPresentationConfig.getPresentation(stateName)
	if not presentation then
		warn(string.format("[OnboardingPreview] Unknown preview state %q", stateName))
		return false
	end

	if previewUi then
		return applyPreviewState(stateName)
	end

	local player = Players.LocalPlayer
	local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
	local screenGui = playerGui and playerGui:FindFirstChild("Dev3InteractionShell")
	if not screenGui or not screenGui:IsA("ScreenGui") then
		warn("[OnboardingPreview] UI shell is not initialized")
		return false
	end

	-- Client Command Bar can have separate ModuleScript state. Signal the already initialized service through its UI instance.
	screenGui:SetAttribute(PREVIEW_STATE_ATTRIBUTE, stateName)
	local requestId = screenGui:GetAttribute(PREVIEW_REQUEST_ID_ATTRIBUTE)
	screenGui:SetAttribute(PREVIEW_REQUEST_ID_ATTRIBUTE, if type(requestId) == "number" then requestId + 1 else 1)
	return true
end

function InteractionShellService.init()
	cleanup()
	print("[InteractionShell] Initializing")

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local ui = InteractionUiShell.new(playerGui)
	previewUi = ui
	print("[InteractionShell] UI ready")
	targetGuidance = OnboardingTargetGuidance.new(player, ui)
	local screenGui = playerGui:WaitForChild("Dev3InteractionShell")
	previewRequestConnection = screenGui:GetAttributeChangedSignal(PREVIEW_REQUEST_ID_ATTRIBUTE):Connect(function()
		local requestedState = screenGui:GetAttribute(PREVIEW_STATE_ATTRIBUTE)
		if type(requestedState) == "string" then
			applyPreviewState(requestedState)
		end
	end)
	InteractionShellService.setPreviewState("FirstDig")

	local blockout = Workspace:WaitForChild("Site1Blockout")
	print("[InteractionShell] Found Site1Blockout")
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

	for _, target in ipairs(targets) do
		if getWorldPosition(target.instance) then
			print(string.format("[InteractionShell] Target %s resolved", target.instance.Name))
		else
			warn(string.format("[InteractionShell] Target %s has no usable world position", target.instance.Name))
		end
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

	promptConnection = RunService.RenderStepped:Connect(updatePrompt)
	print(string.format("[InteractionShell] Ready - %d interaction targets available", #targets))
end

return InteractionShellService
