local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

if player.PlayerGui:FindFirstChild("Zer0WareHub") then
	player.PlayerGui.Zer0WareHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "Zer0WareHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- MAIN
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 320)
main.Position = UDim2.new(0.5, -260, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- GRADIENT
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,120,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,60))
}
gradient.Rotation = 45
gradient.Parent = main

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Text = "Zer0Ware Brainrot Hub v1 🧠"
title.Parent = main

-- Rainbow Gradient on Zer0Ware
local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,127,0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,255,0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,0)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(148,0,211))
}
rainbowGradient.Parent = title

RunService.RenderStepped:Connect(function()
	rainbowGradient.Rotation += 1
end)

-- CLOSE BUTTON (smaller to fit emoji)
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -34, 0, 6)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- TOGGLE WITH P
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.P then
		main.Visible = not main.Visible
	end
end)

-- CATEGORY FRAME
local categories = Instance.new("Frame")
categories.Size = UDim2.new(0, 140, 1, -45)
categories.Position = UDim2.new(0, 0, 0, 45)
categories.BackgroundColor3 = Color3.fromRGB(18,18,18)
categories.Parent = main
Instance.new("UICorner", categories)

-- CONTENT FRAME (background for buttons with corner)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -150, 1, -55)
content.Position = UDim2.new(0, 150, 0, 50)
content.BackgroundColor3 = Color3.fromRGB(25,25,25)
content.ClipsDescendants = true
content.Parent = main
Instance.new("UICorner", content)

-- ANIMATED TAB SWITCH FUNCTION
local function switchTab(newFrame)
	local currentFrame = content:FindFirstChildWhichIsA("Frame")
	if currentFrame then
		-- Slide out left
		local tweenOut = TweenService:Create(currentFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Position = UDim2.new(-1,0,0,0)
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		currentFrame:Destroy()
	end

	-- Prepare new frame offscreen right
	newFrame.Position = UDim2.new(1,0,0,0)
	newFrame.Size = UDim2.new(1,0,1,0)
	newFrame.Parent = content

	-- Slide in
	TweenService:Create(newFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
		Position = UDim2.new(0,0,0,0)
	}):Play()
end

-- BOOSTERS TAB
local function createBoosters()
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1

	-- SPEED TOGGLE BUTTON
	local speed = Instance.new("TextButton")
	speed.Size = UDim2.new(0.7,0,0,45)
	speed.Position = UDim2.new(0.15,0,0.1,0)
	speed.Text = "Speed Boost: OFF"
	speed.BackgroundColor3 = Color3.fromRGB(35,35,35)
	speed.TextColor3 = Color3.new(1,1,1)
	speed.Parent = frame
	Instance.new("UICorner", speed)

	local speedEnabled = false
	local defaultSpeed = 16
	local speedConnection

	speed.MouseButton1Click:Connect(function()
		local hum = player.Character and player.Character:FindFirstChild("Humanoid")
		if not hum then return end

		if not speedEnabled then
			speedEnabled = true
			speed.Text = "Speed Boost: ON"
			defaultSpeed = hum.WalkSpeed
			speedConnection = RunService.RenderStepped:Connect(function()
				if hum then
					hum.WalkSpeed = 52
				end
			end)
		else
			speedEnabled = false
			speed.Text = "Speed Boost: OFF"
			if speedConnection then speedConnection:Disconnect() end
			hum.WalkSpeed = defaultSpeed
		end
	end)

	return frame
end

-- DUELS TAB
local function createDuels()
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1

	-- Unwalk Animation toggle
	local unwalkBtn = Instance.new("TextButton")
	unwalkBtn.Size = UDim2.new(0.7,0,0,45)
	unwalkBtn.Position = UDim2.new(0.15,0,0.1,0)
	unwalkBtn.Text = "Unwalk Animation: OFF"
	unwalkBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	unwalkBtn.TextColor3 = Color3.new(1,1,1)
	unwalkBtn.Parent = frame
	Instance.new("UICorner", unwalkBtn)

	local unwalkEnabled = false

	unwalkBtn.MouseButton1Click:Connect(function()
		local char = player.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		local animate = char:FindFirstChild("Animate")

		if not unwalkEnabled then
			unwalkEnabled = true
			unwalkBtn.Text = "Unwalk Animation: ON"
			if animate then
				local walkAnim = animate:FindFirstChild("walk")
				if walkAnim then
					hum:LoadAnimation(walkAnim):Stop()
				end
			end
		else
			unwalkEnabled = false
			unwalkBtn.Text = "Unwalk Animation: OFF"
			if animate then
				local walkAnim = animate:FindFirstChild("walk")
				if walkAnim then
					hum:LoadAnimation(walkAnim):Play()
				end
			end
		end
	end)

	return frame
end

-- BOOSTERS BUTTON
local boosterBtn = Instance.new("TextButton")
boosterBtn.Size = UDim2.new(1, -10, 0, 45)
boosterBtn.Position = UDim2.new(0, 5, 0, 5)
boosterBtn.Text = "Boosters"
boosterBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
boosterBtn.TextColor3 = Color3.new(1,1,1)
boosterBtn.Parent = categories
Instance.new("UICorner", boosterBtn)

-- DUELS BUTTON
local duelsBtn = Instance.new("TextButton")
duelsBtn.Size = UDim2.new(1, -10, 0, 45)
duelsBtn.Position = UDim2.new(0, 5, 0, 55)
duelsBtn.Text = "Duels"
duelsBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
duelsBtn.TextColor3 = Color3.new(1,1,1)
duelsBtn.Parent = categories
Instance.new("UICorner", duelsBtn)

-- BUTTON CONNECTIONS
boosterBtn.MouseButton1Click:Connect(function()
	switchTab(createBoosters())
end)

duelsBtn.MouseButton1Click:Connect(function()
	switchTab(createDuels())
end)

-- DEFAULT TAB
switchTab(createBoosters())
