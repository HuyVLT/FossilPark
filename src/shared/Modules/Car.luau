local Car = {}
Car.__index = Car

function Car.init()
	print("The car is now initialized!")
end

return Car
