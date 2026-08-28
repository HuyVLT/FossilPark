--!strict

-- DEV PLAYTEST ONLY. Records local elapsed time and never changes player progression.

local RunService = game:GetService("RunService")

local FirstSessionTimingTracker = {}
FirstSessionTimingTracker.__index = FirstSessionTimingTracker

local function formatElapsed(elapsedSeconds: number): string
	local wholeSeconds = math.max(0, math.floor(elapsedSeconds + 0.5))
	return string.format("%02d:%02d", math.floor(wholeSeconds / 60), wholeSeconds % 60)
end

function FirstSessionTimingTracker.new(milestones: { string }, enabledInStudio: boolean)
	local supportedMilestones: { [string]: boolean } = {}
	for _, milestone in ipairs(milestones) do
		supportedMilestones[milestone] = true
	end

	return setmetatable({
		enabled = enabledInStudio and RunService:IsStudio(),
		startedAt = os.clock(),
		supportedMilestones = supportedMilestones,
		recordedTimes = {} :: { [string]: number },
	}, FirstSessionTimingTracker)
end

function FirstSessionTimingTracker:recordMilestone(milestone: string): boolean
	if not self.enabled or not self.supportedMilestones[milestone] then
		return false
	end

	if self.recordedTimes[milestone] ~= nil then
		return false
	end

	local elapsed = os.clock() - self.startedAt
	self.recordedTimes[milestone] = elapsed
	print(string.format("[FirstSessionTiming] %s: %s", milestone, formatElapsed(elapsed)))
	return true
end

function FirstSessionTimingTracker:printReport(milestones: { string })
	if not self.enabled then
		warn("[FirstSessionTiming] Tracker is available only during Studio playtests")
		return
	end

	print("[FirstSessionTiming] --- First 10 Minutes Report ---")
	for _, milestone in ipairs(milestones) do
		local elapsed = self.recordedTimes[milestone]
		print(string.format("[FirstSessionTiming] %s: %s", milestone, if elapsed then formatElapsed(elapsed) else "--:--"))
	end
end

return FirstSessionTimingTracker
