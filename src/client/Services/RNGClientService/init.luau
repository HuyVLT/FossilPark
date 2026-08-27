local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Networking.Remotes).init()

local RNGClientService = {}
RNGClientService.__index = RNGClientService

function RNGClientService.init()
	Remotes.RNGResult.OnClientEvent:Connect(function(resultName: string)
		print("RNG result:", resultName)
	end)
end

return RNGClientService
