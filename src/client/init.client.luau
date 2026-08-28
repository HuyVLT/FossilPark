local function loadServices(container)
	for _, child in container:GetChildren() do
		local module = if child:IsA("ModuleScript")
			then child
			elseif child:IsA("Folder") then child:FindFirstChild("init")
			else nil

		if module then
			local loaded, serviceOrError = pcall(require, module)
			if not loaded then
				warn(string.format("[ClientLoader] Failed to require %s: %s", child.Name, tostring(serviceOrError)))
			elseif type(serviceOrError) ~= "table" or type(serviceOrError.init) ~= "function" then
				warn(string.format("[ClientLoader] %s does not return a service table with init()", child.Name))
			else
				local initialized, initError = pcall(serviceOrError.init)
				if not initialized then
					warn(string.format("[ClientLoader] Failed to initialize %s: %s", child.Name, tostring(initError)))
				end
			end
		end
	end
end

loadServices(script.Services)
