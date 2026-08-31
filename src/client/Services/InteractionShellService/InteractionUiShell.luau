--!strict

-- Temporary Dev 3 playtest UI. Final UI/UX is owned by Dev 2.
-- This module displays local placeholder information only and owns no authoritative state.

local InteractionUiShell = {}

local PANEL_COLOR = Color3.fromRGB(19, 25, 29)
local PANEL_TRANSPARENCY = 0.16
local TEXT_COLOR = Color3.fromRGB(245, 247, 248)
local SUBTEXT_COLOR = Color3.fromRGB(191, 201, 203)
local CYAN = Color3.fromRGB(76, 184, 188)

local function addCorner(instance: Instance, radius: number)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
end

local function addStroke(instance: Instance, color: Color3)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Transparency = 0.35
	stroke.Thickness = 1
	stroke.Parent = instance
end

local function createTextLabel(name: string, text: string, font: Enum.Font, textSize: number, color: Color3): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.BackgroundTransparency = 1
	label.Font = font
	label.Text = text
	label.TextColor3 = color
	label.TextSize = textSize
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	return label
end

function InteractionUiShell.new(playerGui: PlayerGui)
	local existing = playerGui:FindFirstChild("Dev3InteractionShell")
	if existing then
		existing:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Dev3InteractionShell"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 10
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screenGui.Parent = playerGui

	local topHud = Instance.new("Frame")
	topHud.Name = "TopHud"
	topHud.AnchorPoint = Vector2.new(0, 0)
	topHud.Position = UDim2.fromOffset(20, 20)
	topHud.Size = UDim2.fromOffset(210, 74)
	topHud.BackgroundColor3 = PANEL_COLOR
	topHud.BackgroundTransparency = PANEL_TRANSPARENCY
	topHud.ZIndex = 1
	addCorner(topHud, 10)
	addStroke(topHud, CYAN)
	topHud.Parent = screenGui

	local fossilsLabel = createTextLabel("FossilsLabel", "Fossils: 0", Enum.Font.GothamBold, 16, TEXT_COLOR)
	fossilsLabel.Position = UDim2.fromOffset(16, 10)
	fossilsLabel.Size = UDim2.fromOffset(178, 24)
	fossilsLabel.ZIndex = 2
	fossilsLabel.Parent = topHud

	local discoveriesLabel = createTextLabel("DiscoveriesLabel", "Discoveries: 0 / 2", Enum.Font.Gotham, 15, SUBTEXT_COLOR)
	discoveriesLabel.Position = UDim2.fromOffset(16, 38)
	discoveriesLabel.Size = UDim2.fromOffset(178, 22)
	discoveriesLabel.ZIndex = 2
	discoveriesLabel.Parent = topHud

	local onboardingObjective = Instance.new("Frame")
	onboardingObjective.Name = "OnboardingObjective"
	onboardingObjective.AnchorPoint = Vector2.new(1, 0)
	onboardingObjective.Position = UDim2.new(1, -20, 0, 20)
	onboardingObjective.Size = UDim2.fromOffset(320, 108)
	onboardingObjective.BackgroundColor3 = PANEL_COLOR
	onboardingObjective.BackgroundTransparency = PANEL_TRANSPARENCY
	onboardingObjective.ZIndex = 1
	addCorner(onboardingObjective, 10)
	addStroke(onboardingObjective, CYAN)
	onboardingObjective.Parent = screenGui

	local objectiveTitle = createTextLabel("Title", "", Enum.Font.GothamBold, 16, TEXT_COLOR)
	objectiveTitle.Position = UDim2.fromOffset(16, 10)
	objectiveTitle.Size = UDim2.fromOffset(288, 22)
	objectiveTitle.ZIndex = 2
	objectiveTitle.Parent = onboardingObjective

	local objectiveInstruction = createTextLabel("Instruction", "", Enum.Font.Gotham, 14, SUBTEXT_COLOR)
	objectiveInstruction.Position = UDim2.fromOffset(16, 38)
	objectiveInstruction.Size = UDim2.fromOffset(288, 32)
	objectiveInstruction.TextYAlignment = Enum.TextYAlignment.Top
	objectiveInstruction.ZIndex = 2
	objectiveInstruction.Parent = onboardingObjective

	local objectiveDistance = createTextLabel("Distance", "", Enum.Font.GothamBold, 13, CYAN)
	objectiveDistance.Position = UDim2.fromOffset(16, 76)
	objectiveDistance.Size = UDim2.fromOffset(288, 18)
	objectiveDistance.Visible = false
	objectiveDistance.ZIndex = 2
	objectiveDistance.Parent = onboardingObjective

	local prompt = Instance.new("Frame")
	prompt.Name = "InteractionPrompt"
	prompt.AnchorPoint = Vector2.new(0.5, 1)
	prompt.Position = UDim2.new(0.5, 0, 1, -34)
	prompt.Size = UDim2.fromOffset(360, 72)
	prompt.BackgroundColor3 = PANEL_COLOR
	prompt.BackgroundTransparency = PANEL_TRANSPARENCY
	prompt.Visible = false
	prompt.ZIndex = 1
	addCorner(prompt, 10)
	addStroke(prompt, CYAN)
	prompt.Parent = screenGui

	local promptTitle = createTextLabel("PromptTitle", "", Enum.Font.GothamBold, 18, TEXT_COLOR)
	promptTitle.Position = UDim2.fromOffset(18, 9)
	promptTitle.Size = UDim2.fromOffset(324, 24)
	promptTitle.ZIndex = 2
	promptTitle.Parent = prompt

	local promptDetail = createTextLabel("PromptDetail", "", Enum.Font.Gotham, 14, SUBTEXT_COLOR)
	promptDetail.Position = UDim2.fromOffset(18, 34)
	promptDetail.Size = UDim2.fromOffset(324, 28)
	promptDetail.ZIndex = 2
	promptDetail.Parent = prompt

	local panel = Instance.new("Frame")
	panel.Name = "PlaceholderPanel"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = UDim2.fromOffset(390, 236)
	panel.BackgroundColor3 = PANEL_COLOR
	panel.BackgroundTransparency = 0.04
	panel.Visible = false
	panel.ZIndex = 10
	addCorner(panel, 12)
	addStroke(panel, CYAN)
	panel.Parent = screenGui

	local panelTitle = createTextLabel("Title", "", Enum.Font.GothamBold, 21, TEXT_COLOR)
	panelTitle.Position = UDim2.fromOffset(24, 22)
	panelTitle.Size = UDim2.fromOffset(340, 30)
	panelTitle.ZIndex = 11
	panelTitle.Parent = panel

	local panelContent = createTextLabel("Content", "", Enum.Font.Gotham, 16, SUBTEXT_COLOR)
	panelContent.Position = UDim2.fromOffset(24, 68)
	panelContent.Size = UDim2.fromOffset(342, 48)
	panelContent.TextYAlignment = Enum.TextYAlignment.Top
	panelContent.ZIndex = 11
	panelContent.Parent = panel

	local secondaryLabel = createTextLabel("Secondary", "", Enum.Font.Gotham, 14, SUBTEXT_COLOR)
	secondaryLabel.Position = UDim2.fromOffset(24, 118)
	secondaryLabel.Size = UDim2.fromOffset(342, 34)
	secondaryLabel.TextYAlignment = Enum.TextYAlignment.Top
	secondaryLabel.Visible = false
	secondaryLabel.ZIndex = 11
	secondaryLabel.Parent = panel

	local statusLabel = createTextLabel("Status", "", Enum.Font.GothamBold, 16, CYAN)
	statusLabel.Position = UDim2.fromOffset(24, 154)
	statusLabel.Size = UDim2.fromOffset(220, 24)
	statusLabel.Visible = false
	statusLabel.ZIndex = 11
	statusLabel.Parent = panel

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.AnchorPoint = Vector2.new(1, 1)
	closeButton.Position = UDim2.new(1, -24, 1, -20)
	closeButton.Size = UDim2.fromOffset(96, 36)
	closeButton.BackgroundColor3 = CYAN
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "Close"
	closeButton.TextColor3 = Color3.fromRGB(14, 20, 22)
	closeButton.TextSize = 15
	closeButton.ZIndex = 12
	addCorner(closeButton, 8)
	closeButton.Parent = panel

	closeButton.Activated:Connect(function()
		panel.Visible = false
	end)

	local shell = {}

	function shell.setPrompt(title: string, detail: string?)
		promptTitle.Text = title
		promptDetail.Text = detail or ""
		promptDetail.Visible = detail ~= nil and detail ~= ""
		prompt.Visible = true
	end

	function shell.clearPrompt()
		prompt.Visible = false
	end

	function shell.setOnboardingObjective(title: string, instruction: string, target: string?)
		objectiveTitle.Text = title
		objectiveInstruction.Text = instruction
		onboardingObjective:SetAttribute("TargetIdentifier", target)
		objectiveDistance.Visible = false
		onboardingObjective.Visible = true
	end

	function shell.setOnboardingDistance(distanceStuds: number?)
		if distanceStuds then
			objectiveDistance.Text = string.format("%d studs", distanceStuds)
			objectiveDistance.Visible = true
		else
			objectiveDistance.Visible = false
		end
	end

	local function showPanel(title: string, content: string, secondary: string?, status: string?)
		panelTitle.Text = title
		panelContent.Text = content
		secondaryLabel.Text = secondary or ""
		secondaryLabel.Visible = secondary ~= nil and secondary ~= ""
		statusLabel.Text = status or ""
		statusLabel.Visible = status ~= nil and status ~= ""
		panel.Visible = true
	end

	function shell.showDigPanel()
		showPanel("DIG SITE", "Brittle Rock excavation will be available here.", "Strike → Read Cracks → Hit Weak Point → Break")
	end

	function shell.showRevivalPanel()
		showPanel("REVIVAL CHAMBER", "Insert a fossil to begin revival.", nil, "No Fossil Selected")
	end

	function shell.showResearchPanel()
		showPanel("RESEARCH — DEV PREVIEW", "Duplicates can contribute to Research.", nil, "Waiting for authoritative Research data")
	end

	function shell.showGatePanel()
		showPanel("SITE 2", "Locked", "Discover more species to continue.")
	end

	function shell.showRevivalResultPreview(speciesName: string, variantName: string, resultLabel: string)
		showPanel("REVIVAL RESULT — DEV PREVIEW", speciesName, variantName, resultLabel)
	end

	function shell.showCollectionPreview(discoveredCount: number, totalCount: number, slotLines: { string })
		discoveriesLabel.Text = string.format("Discoveries: %d / %d", discoveredCount, totalCount)
		showPanel(
			"COLLECTION — DEV PREVIEW",
			string.format("%d / %d Species", discoveredCount, totalCount),
			table.concat(slotLines, "\n")
		)
	end

	function shell.showResearchPreview(instruction: string, displayProgress: string, statusLabel: string)
		showPanel("RESEARCH — DEV PREVIEW", instruction, displayProgress, statusLabel)
	end

	function shell.showBreakthroughPreview(instruction: string, detail: string, statusLabel: string)
		showPanel("BREAKTHROUGH — DEV PREVIEW", instruction, detail, statusLabel)
	end

	function shell.showProfilePreview(displayName: string, titleLabel: string, discoveryLabel: string, showcaseLabel: string)
		showPanel("PLAYER PROFILE — DEV PREVIEW", displayName, string.format("%s\n%s", titleLabel, showcaseLabel), discoveryLabel)
	end

	function shell.isPanelOpen(): boolean
		return panel.Visible
	end

	return shell
end

return InteractionUiShell
