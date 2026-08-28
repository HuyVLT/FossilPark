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
local FirstSessionTimingTracker = require(script:WaitForChild("FirstSessionTimingTracker"))
local RevivalPreviewFixtures = require(script:WaitForChild("RevivalPreviewFixtures"))
local sharedConfig = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local CollectionConfig = require(sharedConfig:WaitForChild("CollectionConfig"))
local FirstSessionConfig = require(sharedConfig:WaitForChild("FirstSessionConfig"))
local OnboardingPresentationConfig = require(sharedConfig:WaitForChild("OnboardingPresentationConfig"))
local SpeciesConfig = require(sharedConfig:WaitForChild("SpeciesConfig"))

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
local timingReportRequestConnection: RBXScriptConnection? = nil
local revivalPreviewRequestConnection: RBXScriptConnection? = nil
local collectionPreviewRequestConnection: RBXScriptConnection? = nil
local timingTracker: any = nil

local PREVIEW_STATE_ATTRIBUTE = "Dev3PreviewState"
local PREVIEW_REQUEST_ID_ATTRIBUTE = "Dev3PreviewRequestId"
local TIMING_REPORT_REQUEST_ID_ATTRIBUTE = "Dev3TimingReportRequestId"
local REVIVAL_PREVIEW_NAME_ATTRIBUTE = "Dev3RevivalPreviewName"
local REVIVAL_PREVIEW_REQUEST_ID_ATTRIBUTE = "Dev3RevivalPreviewRequestId"
local COLLECTION_PREVIEW_COUNT_ATTRIBUTE = "Dev3CollectionPreviewCount"
local COLLECTION_PREVIEW_REQUEST_ID_ATTRIBUTE = "Dev3CollectionPreviewRequestId"

local function cleanup()
	if promptConnection then
		promptConnection:Disconnect()
		promptConnection = nil
	end

	if previewRequestConnection then
		previewRequestConnection:Disconnect()
		previewRequestConnection = nil
	end

	if timingReportRequestConnection then
		timingReportRequestConnection:Disconnect()
		timingReportRequestConnection = nil
	end

	if revivalPreviewRequestConnection then
		revivalPreviewRequestConnection:Disconnect()
		revivalPreviewRequestConnection = nil
	end

	if collectionPreviewRequestConnection then
		collectionPreviewRequestConnection:Disconnect()
		collectionPreviewRequestConnection = nil
	end

	if targetGuidance then
		targetGuidance:destroy()
		targetGuidance = nil
	end

	ContextActionService:UnbindAction("Dev3PlaceholderInteract")
	previewUi = nil
	timingTracker = nil
end

local function getPreviewScreenGui(): ScreenGui?
	local player = Players.LocalPlayer
	local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
	local screenGui = playerGui and playerGui:FindFirstChild("Dev3InteractionShell")
	if screenGui and screenGui:IsA("ScreenGui") then
		return screenGui
	end

	return nil
end

local function applyRevivalPreview(fixtureName: string): boolean
	local result = RevivalPreviewFixtures[fixtureName]
	if not result or not previewUi then
		return false
	end

	local species = SpeciesConfig[result.species]
	if not species then
		warn(string.format("[RevivalPreview] Unknown temporary species %q", result.species))
		return false
	end

	local resultLabel = if result.isNewDiscovery then "NEW DISCOVERY" else "DUPLICATE"
	previewUi.showRevivalResultPreview(species.displayName, result.variant, resultLabel)
	print(string.format("[RevivalPreview] %s: %s / %s / %s", fixtureName, result.species, result.variant, resultLabel))
	return true
end

local function applyCollectionPreview(discoveredCount: number): boolean
	if not previewUi or discoveredCount < 0 or discoveredCount > CollectionConfig.totalSpecies then
		return false
	end

	local slotLines: { string } = {}
	for _, slot in ipairs(CollectionConfig.slots) do
		local isDiscovered = slot.order <= discoveredCount
		local stateName = if isDiscovered then "Discovered" else "Undiscovered"
		local stateMetadata = CollectionConfig.discoveryPresentation[stateName]
		local species = SpeciesConfig[slot.speciesId]
		local identity = if isDiscovered and species then species.displayName else "???"
		local previewVariantLabel = if slot.order == 2
			then CollectionConfig.variantPresentation.Gold.label
			else CollectionConfig.variantPresentation.Normal.label
		local variantLabel = if isDiscovered then previewVariantLabel else "—"
		table.insert(slotLines, string.format("%d. %s — %s — %s", slot.order, identity, stateMetadata.label, variantLabel))
	end

	previewUi.showCollectionPreview(discoveredCount, CollectionConfig.totalSpecies, slotLines)
	print(string.format("[CollectionPreview] %d/%d", discoveredCount, CollectionConfig.totalSpecies))
	return true
end

-- DEV PREVIEW ONLY. Displays a named immutable fixture and changes no authoritative state.
function InteractionShellService.previewRevivalResult(fixtureName: string): boolean
	if RevivalPreviewFixtures[fixtureName] == nil then
		warn(string.format("[RevivalPreview] Unknown fixture %q", fixtureName))
		return false
	end

	if previewUi then
		return applyRevivalPreview(fixtureName)
	end

	local screenGui = getPreviewScreenGui()
	if not screenGui then
		warn("[RevivalPreview] UI shell is not initialized")
		return false
	end

	screenGui:SetAttribute(REVIVAL_PREVIEW_NAME_ATTRIBUTE, fixtureName)
	local requestId = screenGui:GetAttribute(REVIVAL_PREVIEW_REQUEST_ID_ATTRIBUTE)
	screenGui:SetAttribute(REVIVAL_PREVIEW_REQUEST_ID_ATTRIBUTE, if type(requestId) == "number" then requestId + 1 else 1)
	return true
end

-- DEV PREVIEW ONLY. Displays 0/2, 1/2, or 2/2 without storing Collection state.
function InteractionShellService.previewCollection(discoveredCount: number): boolean
	if discoveredCount % 1 ~= 0 or discoveredCount < 0 or discoveredCount > CollectionConfig.totalSpecies then
		warn(string.format("[CollectionPreview] Expected an integer from 0 to %d", CollectionConfig.totalSpecies))
		return false
	end

	if previewUi then
		return applyCollectionPreview(discoveredCount)
	end

	local screenGui = getPreviewScreenGui()
	if not screenGui then
		warn("[CollectionPreview] UI shell is not initialized")
		return false
	end

	screenGui:SetAttribute(COLLECTION_PREVIEW_COUNT_ATTRIBUTE, discoveredCount)
	local requestId = screenGui:GetAttribute(COLLECTION_PREVIEW_REQUEST_ID_ATTRIBUTE)
	screenGui:SetAttribute(COLLECTION_PREVIEW_REQUEST_ID_ATTRIBUTE, if type(requestId) == "number" then requestId + 1 else 1)
	return true
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
	if timingTracker then
		timingTracker:recordMilestone(stateName)
	end
	print(string.format("[OnboardingPreview] %s", stateName))
	return true
end

-- DEV PLAYTEST ONLY. Prints timestamps from the already initialized local tracker.
function InteractionShellService.printTimingReport(): boolean
	if timingTracker then
		timingTracker:printReport(FirstSessionConfig.timingMilestones)
		return true
	end

	local player = Players.LocalPlayer
	local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
	local screenGui = playerGui and playerGui:FindFirstChild("Dev3InteractionShell")
	if not screenGui or not screenGui:IsA("ScreenGui") then
		warn("[FirstSessionTiming] UI shell is not initialized")
		return false
	end

	local requestId = screenGui:GetAttribute(TIMING_REPORT_REQUEST_ID_ATTRIBUTE)
	screenGui:SetAttribute(TIMING_REPORT_REQUEST_ID_ATTRIBUTE, if type(requestId) == "number" then requestId + 1 else 1)
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
	timingTracker = FirstSessionTimingTracker.new(FirstSessionConfig.timingMilestones, FirstSessionConfig.playtest.timingTrackerEnabledInStudio)
	timingTracker:recordMilestone("Spawn")
	print("[InteractionShell] UI ready")
	targetGuidance = OnboardingTargetGuidance.new(player, ui)
	local screenGui = playerGui:WaitForChild("Dev3InteractionShell")
	previewRequestConnection = screenGui:GetAttributeChangedSignal(PREVIEW_REQUEST_ID_ATTRIBUTE):Connect(function()
		local requestedState = screenGui:GetAttribute(PREVIEW_STATE_ATTRIBUTE)
		if type(requestedState) == "string" then
			applyPreviewState(requestedState)
		end
	end)
	timingReportRequestConnection = screenGui:GetAttributeChangedSignal(TIMING_REPORT_REQUEST_ID_ATTRIBUTE):Connect(function()
		if timingTracker then
			timingTracker:printReport(FirstSessionConfig.timingMilestones)
		end
	end)
	revivalPreviewRequestConnection = screenGui:GetAttributeChangedSignal(REVIVAL_PREVIEW_REQUEST_ID_ATTRIBUTE):Connect(function()
		local fixtureName = screenGui:GetAttribute(REVIVAL_PREVIEW_NAME_ATTRIBUTE)
		if type(fixtureName) == "string" then
			applyRevivalPreview(fixtureName)
		end
	end)
	collectionPreviewRequestConnection = screenGui:GetAttributeChangedSignal(COLLECTION_PREVIEW_REQUEST_ID_ATTRIBUTE):Connect(function()
		local discoveredCount = screenGui:GetAttribute(COLLECTION_PREVIEW_COUNT_ATTRIBUTE)
		if type(discoveredCount) == "number" then
			applyCollectionPreview(discoveredCount)
		end
	end)
	InteractionShellService.setPreviewState("FirstDig")

	local blockout = Workspace:WaitForChild(FirstSessionConfig.landmarks.blockoutFolder)
	print("[InteractionShell] Found Site1Blockout")
	local targets: { InteractionTarget } = {
	{
		kind = "Dig",
		instance = blockout:WaitForChild(FirstSessionConfig.landmarks.digArea),
		promptTitle = "[E] Dig",
		range = FirstSessionConfig.interactionRanges.Dig,
	},
	{
		kind = "Revival",
		instance = blockout:WaitForChild(FirstSessionConfig.landmarks.revivalChamber),
		promptTitle = "[E] Use Revival Chamber",
		range = FirstSessionConfig.interactionRanges.Revival,
	},
	{
		kind = "Research",
		instance = blockout:WaitForChild(FirstSessionConfig.landmarks.researchMachine),
		promptTitle = "[E] Open Research",
		range = FirstSessionConfig.interactionRanges.Research,
	},
	{
		kind = "Gate",
		instance = blockout:WaitForChild(FirstSessionConfig.landmarks.site2Gate),
		promptTitle = "[E] Inspect Site 2 Gate",
		range = FirstSessionConfig.interactionRanges.Gate,
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
