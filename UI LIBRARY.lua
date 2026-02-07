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

    -- Иконка (двигается)
    local IconWrapper = Instance.new("Frame")
    IconWrapper.Size = UDim2.new(0, 64, 0, 64)
    IconWrapper.Position = UDim2.new(0.05, 0, 0.85, 0)
    IconWrapper.BackgroundTransparency = 1
    IconWrapper.Parent = sg
    IconWrapper.Visible = not keySystem

    local Icon = Instance.new("ImageButton")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://104955007759633" -- твоя иконка
    Icon.Parent = IconWrapper

    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = Icon

    local IconStroke = Instance.new("UIStroke")
    IconStroke.Color = Color3.fromRGB(140, 220, 255)
    IconStroke.Transparency = 0.3
    IconStroke.Thickness = 3
    IconStroke.Parent = Icon

    -- Перетаскивание иконки
    local iDragging, iDragInput, iDragStart, iStartPos
    IconWrapper.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            iDragging = true
            iDragStart = input.Position
            iStartPos = IconWrapper.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    iDragging = false
                end
            end)
        end
    end)

    IconWrapper.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            iDragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == iDragInput and iDragging then
            local delta = input.Position - iDragStart
            IconWrapper.Position = UDim2.new(
                iStartPos.X.Scale, iStartPos.X.Offset + delta.X,
                iStartPos.Y.Scale, iStartPos.Y.Offset + delta.Y
            )
        end
    end)

    Icon.MouseEnter:Connect(function()
        TS:Create(IconStroke, TweenInfo.new(0.3), {Transparency = 0.1}):Play()
    end)
    Icon.MouseLeave:Connect(function()
        TS:Create(IconStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
    end)

    -- Главное окно (скрыто до ввода ключа)
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

    IconWrapper.ZIndex = 50
    Icon.ZIndex = 51
    Icon.MouseButton1Click:Connect(toggleMain)

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 54)
    Topbar.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 20)
    TopCorner.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 24, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(220, 230, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

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

    -- Перетаскивание окна
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
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
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Sidebar (вкладки слева)
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

    -- Content (область для элементов)
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
        tabBtn.Text = " " .. name
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
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
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

    -- Key System
-- Key System
if keySystem then
    local KeyWindow = Instance.new("Frame")
    KeyWindow.Size = UDim2.new(0, 300, 0, 180)
    KeyWindow.Position = UDim2.new(0.5, -150, 0.5, -90)
    KeyWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    KeyWindow.BorderSizePixel = 0
    KeyWindow.Parent = sg

    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 12)
    keyCorner.Parent = KeyWindow

    local keyTitle = Instance.new("TextLabel")
    keyTitle.Size = UDim2.new(1, 0, 0, 40)
    keyTitle.BackgroundTransparency = 1
    keyTitle.Text = "Введи ключ"
    keyTitle.TextColor3 = Color3.new(1,1,1)
    keyTitle.Font = Enum.Font.GothamBold
    keyTitle.TextSize = 20
    keyTitle.Parent = KeyWindow

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.Position = UDim2.new(0, 20, 0, 50)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    keyInput.Text = ""
    keyInput.PlaceholderText = "1234..."
    keyInput.TextColor3 = Color3.new(1,1,1)
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextSize = 16
    keyInput.Parent = KeyWindow

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = keyInput

    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, -40, 0, 40)
    submitBtn.Position = UDim2.new(0, 20, 0, 100)
    submitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    submitBtn.Text = "Войти"
    submitBtn.TextColor3 = Color3.new(1,1,1)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 16
    submitBtn.Parent = KeyWindow

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = submitBtn

    submitBtn.MouseButton1Click:Connect(function()
        if keyInput.Text == correctKey then
            KeyWindow:Destroy()
            IconWrapper.Visible = true
            opened = true
            Main.Visible = true
            ShowNotify(sg, welcome, 5)
        else
            ShowNotify(sg, "Неверный ключ!", 3)
        end
    end)

else
    IconWrapper.Visible = true
    opened = true
    Main.Visible = true
    ShowNotify(sg, welcome, 5)
end

    return window
end

return TolikUI
