--!strict

-- Client-only lookup for the named Site 1 blockout targets used by onboarding presentation.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FirstSessionConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("FirstSessionConfig"))

local BLOCKOUT_FOLDER_NAME = FirstSessionConfig.landmarks.blockoutFolder
local supportedTargets: { [string]: boolean } = {
	[FirstSessionConfig.landmarks.digArea] = true,
	[FirstSessionConfig.landmarks.revivalChamber] = true,
	[FirstSessionConfig.landmarks.researchMachine] = true,
	[FirstSessionConfig.landmarks.site2Gate] = true,
}
local warnedKeys: { [string]: boolean } = {}

local OnboardingTargetResolver = {}

local function warnOnce(key: string, message: string)
	if warnedKeys[key] then
		return
	end

	warnedKeys[key] = true
	warn(message)
end

function OnboardingTargetResolver.resolve(targetIdentifier: string?): Instance?
	if not targetIdentifier then
		return nil
	end

	if not supportedTargets[targetIdentifier] then
		warnOnce(targetIdentifier, string.format("[OnboardingGuidance] Unsupported target %q", targetIdentifier))
		return nil
	end

	local blockout = Workspace:FindFirstChild(BLOCKOUT_FOLDER_NAME)
	if not blockout then
		warnOnce(BLOCKOUT_FOLDER_NAME, "[OnboardingGuidance] Site1Blockout is not available")
		return nil
	end

	local target = blockout:FindFirstChild(targetIdentifier)
	if not target then
		warnOnce(targetIdentifier, string.format("[OnboardingGuidance] Target %q is not available", targetIdentifier))
	end

	return target
end

return OnboardingTargetResolver
