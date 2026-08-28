-- CONTRACT CONFLICT: preserved remote prototype; no runtime service loads this module.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remotes = {}
Remotes.__index = Remotes

local function getOrCreate(name: string)
	if RunService:IsServer() then
		local remote = ReplicatedStorage:FindFirstChild(name)
		if not remote then
			remote = Instance.new("RemoteEvent")
			remote.Name = name
			remote.Parent = ReplicatedStorage
		end
		return remote
	end
	return ReplicatedStorage:WaitForChild(name)
end

function Remotes.init()
	Remotes.RNGResult = getOrCreate("RNGResult")
	return Remotes
end

return Remotes
