--!strict

local function loadServices(container: Instance)
	for _, child in container:GetChildren() do
		local module = if child:IsA("ModuleScript") then child elseif child:IsA("Folder") then child:FindFirstChild("init") else nil
		if module and module:IsA("ModuleScript") then
			local ok, service = pcall(require, module)
			if ok and type(service) == "table" and type(service.init) == "function" then
				service.init()
			end
		end
	end
end

loadServices(script:WaitForChild("Services"))
