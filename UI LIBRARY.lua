local TolikUI = {}

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local function ShowNotify(sg, text, duration)
	duration = duration or 4

	local notify = Instance.new("TextLabel")
	notify.Size = UDim2.new(0, 320, 0, 90)
	notify.Position = UDim2.new(1, -340, 1, -110)
	notify.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	notify.Text = text
	notify.TextColor3 = Color3.new(1,1,1)
	notify.Font = Enum.Font.GothamSemibold
	notify.TextSize = 16
	notify.TextWrapped = true
	notify.Parent = sg

	local nC = Instance.new("UICorner", notify)
	nC.CornerRadius = UDim.new(0, 14)

	local nStroke = Instance.new("UIStroke", notify)
	nStroke.Color = Color3.fromRGB(80, 140, 255)
	nStroke.Transparency = 0.5
	nStroke.Thickness = 2

	notify.BackgroundTransparency = 1
	notify.TextTransparency = 1

	TS:Create(notify, TweenInfo.new(0.5), {
		Position = UDim2.new(1, -340, 1, -170),
		BackgroundTransparency = 0,
		TextTransparency = 0
	}):Play()

	task.wait(duration)

	TS:Create(notify, TweenInfo.new(0.5), {
		Position = UDim2.new(1, -340, 1, -110),
		BackgroundTransparency = 1,
		TextTransparency = 1
	}):Play()

	task.wait(0.5)
	notify:Destroy()
end

function TolikUI:CreateWindow(options)

	options = options or {}
	local title = options.Title or "TolikUI"
	local keySystem = options.KeySystem or false
	local correctKey = options.CorrectKey or "1234"
	local welcome = options.WelcomeMessage or "TolikUI загружен!"

	local window = {}

	local sg = Instance.new("ScreenGui")
	sg.Name = "TolikUI_" .. math.random(1000,9999)
	sg.ResetOnSpawn = false
	sg.Parent = pg

	-- ================= ICON =================

	local IconWrapper = Instance.new("Frame")
	IconWrapper.Size = UDim2.new(0, 64, 0, 64)
	IconWrapper.Position = UDim2.new(0.05, 0, 0.85, 0)
	IconWrapper.BackgroundTransparency = 1
	IconWrapper.Parent = sg
	IconWrapper.ZIndex = 50

	local Icon = Instance.new("ImageButton")
	Icon.Size = UDim2.new(1, 0, 1, 0)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://104955007759633"
	Icon.Parent = IconWrapper
	Icon.ZIndex = 51

	local IconCorner = Instance.new("UICorner", Icon)
	IconCorner.CornerRadius = UDim.new(1, 0)

	local IconStroke = Instance.new("UIStroke", Icon)
	IconStroke.Color = Color3.fromRGB(140, 220, 255)
	IconStroke.Transparency = 0.3
	IconStroke.Thickness = 3

	-- Drag icon
	local draggingIcon = false
	local dragStart, startPos

	IconWrapper.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingIcon = true
			dragStart = input.Position
			startPos = IconWrapper.Position
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingIcon = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if draggingIcon and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			IconWrapper.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	-- ================= MAIN WINDOW =================

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 760, 0, 580)
	Main.Position = UDim2.new(0.5, -380, 0.5, -290)
	Main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Visible = false
	Main.Parent = sg

	local opened = false
	local unlocked = not keySystem

	local function toggleMain()
		if not unlocked then return end
		opened = not opened
		Main.Visible = opened
	end

	Icon.MouseButton1Click:Connect(toggleMain)

	if not keySystem then
		unlocked = true
		opened = true
		Main.Visible = true
	end

	local MainCorner = Instance.new("UICorner", Main)
	MainCorner.CornerRadius = UDim.new(0, 20)

	local MainStroke = Instance.new("UIStroke", Main)
	MainStroke.Color = Color3.fromRGB(0,0,0)
	MainStroke.Transparency = 0.55
	MainStroke.Thickness = 2.2

	-- ================= KEY SYSTEM =================

	if keySystem then

		local KeyWindow = Instance.new("Frame")
		KeyWindow.Size = UDim2.new(0, 300, 0, 180)
		KeyWindow.Position = UDim2.new(0.5, -150, 0.5, -90)
		KeyWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
		KeyWindow.Parent = sg
		KeyWindow.ZIndex = 60

		local keyCorner = Instance.new("UICorner", KeyWindow)
		keyCorner.CornerRadius = UDim.new(0, 12)

		local keyTitle = Instance.new("TextLabel", KeyWindow)
		keyTitle.Size = UDim2.new(1, 0, 0, 40)
		keyTitle.BackgroundTransparency = 1
		keyTitle.Text = "Введи ключ"
		keyTitle.TextColor3 = Color3.new(1,1,1)
		keyTitle.Font = Enum.Font.GothamBold
		keyTitle.TextSize = 20

		local keyInput = Instance.new("TextBox", KeyWindow)
		keyInput.Size = UDim2.new(1, -40, 0, 40)
		keyInput.Position = UDim2.new(0, 20, 0, 50)
		keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		keyInput.PlaceholderText = "1234..."
		keyInput.TextColor3 = Color3.new(1,1,1)
		keyInput.Font = Enum.Font.Gotham
		keyInput.TextSize = 16

		local inputCorner = Instance.new("UICorner", keyInput)
		inputCorner.CornerRadius = UDim.new(0, 8)

		local submitBtn = Instance.new("TextButton", KeyWindow)
		submitBtn.Size = UDim2.new(1, -40, 0, 40)
		submitBtn.Position = UDim2.new(0, 20, 0, 100)
		submitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
		submitBtn.Text = "Войти"
		submitBtn.TextColor3 = Color3.new(1,1,1)
		submitBtn.Font = Enum.Font.GothamBold
		submitBtn.TextSize = 16

		local btnCorner = Instance.new("UICorner", submitBtn)
		btnCorner.CornerRadius = UDim.new(0, 8)

		submitBtn.MouseButton1Click:Connect(function()
			if keyInput.Text == correctKey then
				KeyWindow:Destroy()
				unlocked = true
				opened = true
				Main.Visible = true
				ShowNotify(sg, welcome, 5)
			else
				ShowNotify(sg, "Неверный ключ!", 3)
			end
		end)
	end

	return window
end

return TolikUI
