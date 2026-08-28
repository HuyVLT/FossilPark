--!strict

-- DEV PREVIEW ONLY. This module presents local target guidance and owns no onboarding state.

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local OnboardingTargetResolver = require(script.Parent:WaitForChild("OnboardingTargetResolver"))
local FirstSessionConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("FirstSessionConfig"))

local DISTANCE_UPDATE_INTERVAL = FirstSessionConfig.guidance.distanceUpdateInterval
local HIGHLIGHT_NAME = "Dev3OnboardingTargetHighlight"

local OnboardingTargetGuidance = {}
OnboardingTargetGuidance.__index = OnboardingTargetGuidance

local function getWorldPosition(instance: Instance): Vector3?
	if instance:IsA("BasePart") then
		return instance.Position
	end

	if instance:IsA("Model") then
		return instance:GetPivot().Position
	end

	return nil
end

function OnboardingTargetGuidance.new(player: Player, ui: any)
	local existingHighlight = Workspace:FindFirstChild(HIGHLIGHT_NAME)
	if existingHighlight and existingHighlight:IsA("Highlight") and existingHighlight:GetAttribute("Dev3ClientOnly") == true then
		existingHighlight:Destroy()
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = HIGHLIGHT_NAME
	highlight.FillColor = Color3.fromRGB(76, 184, 188)
	highlight.FillTransparency = 0.72
	highlight.OutlineColor = Color3.fromRGB(245, 247, 248)
	highlight.OutlineTransparency = 0.15
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = false
	highlight:SetAttribute("Dev3ClientOnly", true)
	highlight.Parent = Workspace

	local self: any = setmetatable({
		player = player,
		ui = ui,
		highlight = highlight,
		targetIdentifier = nil :: string?,
		target = nil :: Instance?,
		elapsed = 0,
		connections = {} :: { RBXScriptConnection },
	}, OnboardingTargetGuidance)

	table.insert(self.connections, player.CharacterAdded:Connect(function()
		self:update()
	end))
	table.insert(self.connections, RunService.Heartbeat:Connect(function(deltaTime)
		self.elapsed += deltaTime
		if self.elapsed >= DISTANCE_UPDATE_INTERVAL then
			self.elapsed = 0
			self:update()
		end
	end))

	return self
end

function OnboardingTargetGuidance:setTarget(targetIdentifier: string?)
	self.targetIdentifier = targetIdentifier
	self.elapsed = DISTANCE_UPDATE_INTERVAL
	self:update()
end

function OnboardingTargetGuidance:update()
	local resolvedTarget = OnboardingTargetResolver.resolve(self.targetIdentifier)
	self.target = resolvedTarget
	self.highlight.Adornee = resolvedTarget
	self.highlight.Enabled = resolvedTarget ~= nil

	if not resolvedTarget then
		self.ui.setOnboardingDistance(nil)
		return
	end

	local character = self.player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	local targetPosition = getWorldPosition(resolvedTarget)
	if not rootPart or not rootPart:IsA("BasePart") or not targetPosition then
		self.ui.setOnboardingDistance(nil)
		return
	end

	local distance = (rootPart.Position - targetPosition).Magnitude
	self.ui.setOnboardingDistance(math.floor(distance + 0.5))
end

function OnboardingTargetGuidance:destroy()
	for _, connection in ipairs(self.connections) do
		connection:Disconnect()
	end
	table.clear(self.connections)

	if self.highlight then
		self.highlight:Destroy()
	end

	self.ui.setOnboardingDistance(nil)
end

return OnboardingTargetGuidance
