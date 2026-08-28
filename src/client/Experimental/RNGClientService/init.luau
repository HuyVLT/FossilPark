-- CONTRACT CONFLICT: preserved remote prototype; deliberately outside Client.Services and not loaded.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Experimental.Networking.Remotes).init()

local RNGClientService = {}
RNGClientService.__index = RNGClientService

function RNGClientService.init()
	Remotes.RNGResult.OnClientEvent:Connect(function(resultName: string)
		print("RNG result:", resultName)
	end)
end

return RNGClientService
