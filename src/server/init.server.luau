local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("Hello world, from server!")

require(ReplicatedStorage.Shared.Modules.Car).init()
