local TolikUI = {}

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- Уведомление
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

    local nC = Instance.new("UICorner")
    nC.CornerRadius = UDim.new(0, 14)
    nC.Parent = notify

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = Color3.fromRGB(80, 140, 255)
    nStroke.Transparency = 0.5
    nStroke.Thickness = 2
    nStroke.Parent = notify

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

    ------------------------------
    -- Иконка (двигается)
    ------------------------------
    local IconWrapper = Instance.new("Frame")
    IconWrapper.Size = UDim2.new(0, 64, 0, 64)
    IconWrapper.Position = UDim2.new(0.05, 0, 0.85, 0)
    IconWrapper.BackgroundTransparency = 1
    IconWrapper.Parent = sg
    IconWrapper.Visible = not keySystem

    local Icon = Instance.new("ImageButton")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://104955007759633"
    Icon.Parent = IconWrapper

    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = Icon

    local IconStroke = Instance.new("UIStroke")
    IconStroke.Color = Color3.fromRGB(140, 220, 255)
    IconStroke.Transparency = 0.3
    IconStroke.Thickness = 3
    IconStroke.Parent = Icon

    -- Drag для иконки
    local iconDragging = false
    local iconDragStart
    local iconStartPos
    local dragThreshold = 6

    Icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            iconDragging = false
            iconDragStart = input.Position
            iconStartPos = IconWrapper.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and iconDragStart then
            local delta = input.Position - iconDragStart
            if delta.Magnitude > dragThreshold then
                iconDragging = true
            end
            if iconDragging then
                IconWrapper.Position = UDim2.new(
                    iconStartPos.X.Scale,
                    iconStartPos.X.Offset + delta.X,
                    iconStartPos.Y.Scale,
                    iconStartPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    ------------------------------
    -- Главное окно
    ------------------------------
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 760, 0, 580)
    Main.Position = UDim2.new(0.5, -380, 0.5, -290)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = false
    Main.Parent = sg

    local opened = false
    local function toggleMain()
        opened = not opened
        Main.Visible = opened
    end

    IconWrapper.MouseButton1Click:Connect(function()
        if not iconDragging then
            toggleMain()
        end
    end)

    IconWrapper.ZIndex = 50
    Icon.ZIndex = 51

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(0,0,0)
    MainStroke.Transparency = 0.55
    MainStroke.Thickness = 2.2
    MainStroke.Parent = Main

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 54)
    Topbar.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 20)
    TopCorner.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 24, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 14, 0, 14)
    CloseBtn.Position = UDim2.new(1, -36, 0.5, -7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 70, 70)
    CloseBtn.Text = ""
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Topbar

    local CloseC = Instance.new("UICorner")
    CloseC.CornerRadius = UDim.new(1, 0)
    CloseC.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        sg:Destroy()
    end)

    -- Drag окна
    local windowDragging = false
    local windowDragStart
    local windowStartPos
    local dragInput

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            windowDragging = true
            windowDragStart = input.Position
            windowStartPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    windowDragging = false
                end
            end)
        end
    end)

    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and windowDragging then
            local delta = input.Position - windowDragStart
            Main.Position = UDim2.new(
                windowStartPos.X.Scale,
                windowStartPos.X.Offset + delta.X,
                windowStartPos.Y.Scale,
                windowStartPos.Y.Offset + delta.Y
            )
        end
    end)

    ------------------------------
    -- Sidebar и Content
    ------------------------------
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 220, 1, -54)
    Sidebar.Position = UDim2.new(0, 0, 0, 54)
    Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 12)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabScroll

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -220, 1, -54)
    Content.Position = UDim2.new(0, 220, 0, 54)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local ContentPad = Instance.new("UIPadding")
    ContentPad.PaddingLeft = UDim.new(0, 24)
    ContentPad.PaddingRight = UDim.new(0, 24)
    ContentPad.PaddingTop = UDim.new(0, 20)
    ContentPad.Parent = Content

    local CurrentTab = nil

    function window:Tab(name)
        local tab = {}

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -24, 0, 52)
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
        tabBtn.Text = "  " .. name
        tabBtn.TextColor3 = Color3.fromRGB(180, 190, 220)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 15
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = TabScroll

        local btnC = Instance.new("UICorner")
        btnC.CornerRadius = UDim.new(0, 12)
        btnC.Parent = tabBtn

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 100, 180)
        tabContent.Visible = false
        tabContent.Parent = Content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 18)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = tabContent

        local function activate()
            if CurrentTab then
                CurrentTab.content.Visible = false
                TS:Create(CurrentTab.btn, TweenInfo.new(0.35), {
                    BackgroundColor3 = Color3.fromRGB(22, 22, 34),
                    TextColor3 = Color3.fromRGB(180, 190, 220)
                }):Play()
            end
            tabContent.Visible = true
            TS:Create(tabBtn, TweenInfo.new(0.35), {
                BackgroundColor3 = Color3.fromRGB(60, 100, 200),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            CurrentTab = {btn = tabBtn, content = tabContent}
        end

        tabBtn.MouseButton1Click:Connect(activate)
        if not CurrentTab then activate() end

        -- Кнопка
        function tab:Button(name, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -40, 0, 50)
            btn.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
            btn.Text = name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.Parent = tabContent
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 10)
            c.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        -- Toggle
        function tab:Toggle(name, default, callback)
            local tog = Instance.new("TextButton")
            tog.Size = UDim2.new(1, -40, 0, 50)
            tog.BackgroundColor3 = default and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(30, 30, 45)
            tog.Text = name .. ": " .. (default and "ON" or "OFF")
            tog.TextColor3 = Color3.new(1,1,1)
            tog.Font = Enum.Font.GothamSemibold
            tog.TextSize = 15
            tog.Parent = tabContent
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 10)
            c.Parent = tog
            local state = default or false
            tog.MouseButton1Click:Connect(function()
                state = not state
                tog.Text = name .. ": " .. (state and "ON" or "OFF")
                tog.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(30, 30, 45)
                if callback then callback(state) end
            end)
        end

        -- Slider
        function tab:Slider(name, min, max, default, callback)
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(1, -40, 0, 60)
            slider.BackgroundTransparency = 1
            slider.Parent = tabContent
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(220, 230, 255)
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = slider
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, 0, 0, 8)
            bar.Position = UDim2.new(0, 0, 0, 30)
            bar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            bar.Parent = slider
            local barC = Instance.new("UICorner")
            barC.CornerRadius = UDim.new(1, 0)
            barC.Parent = bar
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
            fill.BorderSizePixel = 0
            fill.Parent = bar
            local fillC = Instance.new("UICorner")
            fillC.CornerRadius = UDim.new(1, 0)
            fillC.Parent = fill
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = UDim2.new((default - min) / (max - min), -12, 0.5, -12)
            knob.BackgroundColor3 = Color3.fromRGB(220, 220, 255)
            knob.Parent = bar
            local knobC = Instance.new("UICorner")
            knobC.CornerRadius = UDim.new(1, 0)
            knobC.Parent = knob
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 60, 0, 30)
            valueLabel.Position = UDim2.new(1, -80, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextSize = 14
            valueLabel.Parent = slider
            local sliding = false
            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            UIS.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    knob.Position = UDim2.new(rel, -12, 0.5, -12)
                    valueLabel.Text = tostring(val)
                    if callback then callback(val) end
                end
            end)
        end

        return tab
    end

    ------------------------------
    -- Key System
