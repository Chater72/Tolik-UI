-- TolikUI - UI библиотека для Roblox
-- Автор: ты + помощь Grok
-- Использование:
-- local TolikUI = loadstring(game:HttpGet("твоя_ссылка"))()
-- local window = TolikUI:CreateWindow("Моё меню")
-- local tab = window:Tab("Main")
-- tab:Toggle("Speed Hack", false, function(state) ... end)
-- tab:Slider("Скорость", 16, 200, 50, function(val) ... end)
-- tab:Button("Нажми", function() print("Работает") end)

local TolikUI = {}

-- Сервисы
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- =============================================
-- Уведомление
-- =============================================
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

-- =============================================
-- Создание окна
-- =============================================
function TolikUI:CreateWindow(title)
    local window = {}

    -- ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = "TolikUI_" .. math.random(1000,9999)
    sg.ResetOnSpawn = false
    sg.Parent = pg

    -- Кнопка открытия (иконка + draggable)
    local OpenBtn = Instance.new("ImageButton")
    OpenBtn.Size = UDim2.new(0, 64, 0, 64)
    OpenBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Image = "rbxassetid://137745684190476"  -- твоя иконка
    OpenBtn.Parent = sg

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(1, 0)
    OpenCorner.Parent = OpenBtn

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(140, 220, 255)
    OpenStroke.Transparency = 0.3
    OpenStroke.Thickness = 3
    OpenStroke.Parent = OpenBtn

    -- Перетаскивание кнопки (ИСПРАВЛЕНО)
    local obDragging, obDragInput, obDragStart, obStartPos

    OpenBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            obDragging = true
            obDragStart = input.Position
            obStartPos = OpenBtn.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    obDragging = false
                end
            end)
        end
    end)

    OpenBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            obDragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == obDragInput and obDragging then
            local delta = input.Position - obDragStart
            OpenBtn.Position = UDim2.new(
                obStartPos.X.Scale,
                obStartPos.X.Offset + delta.X,
                obStartPos.Y.Scale,
                obStartPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Hover
    OpenBtn.MouseEnter:Connect(function()
        TS:Create(OpenStroke, TweenInfo.new(0.3), {Transparency = 0.1}):Play()
    end)

    OpenBtn.MouseLeave:Connect(function()
        TS:Create(OpenStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
    end)

    -- Главное окно
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 760, 0, 580)
    Main.Position = UDim2.new(0.5, -380, 0.5, -290)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = true
    Main.Parent = sg

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
    TitleLabel.Text = title or "TolikUI"
    TitleLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    -- Только красная кнопка закрытия
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

    -- =============================================
    -- Открытие/закрытие по иконке
    -- =============================================
    OpenBtn.MouseButton1Click:Connect(function()
        if Main.Visible then
            TS:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.35)
            Main.Visible = false
            Main.Size = UDim2.new(0, 760, 0, 580)
            Main.Position = UDim2.new(0.5, -380, 0.5, -290)
            Main.BackgroundTransparency = 0
        else
            Main.Visible = true
            Main.Size = UDim2.new(0, 0, 0, 0)
            Main.Position = UDim2.new(0.5, 0, 0.5, 0)
            Main.BackgroundTransparency = 0.4
            TS:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 760, 0, 580),
                Position = UDim2.new(0.5, -380, 0.5, -290),
                BackgroundTransparency = 0
            }):Play()
        end
    end)

    -- =============================================
    -- Перетаскивание окна
    -- =============================================
    local dragging, dragInput, dragStart, startPos

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- =============================================
    -- Уведомление при запуске
    -- =============================================
    ShowNotify(sg, "TolikUI загружен!\nНажми на иконку для открытия", 5)

    -- =============================================
    -- Вкладки
    -- =============================================
    local CurrentTab = nil

    function window:Tab(name)
        local tab = {}

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -24, 0, 52)
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = "  " .. name
        tabBtn.TextColor3 = Color3.fromRGB(180, 190, 220)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 15
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = sg -- упрощённо, можно потом в Sidebar

        local btnC = Instance.new("UICorner")
        btnC.CornerRadius = UDim.new(0, 12)
        btnC.Parent = tabBtn

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, -54)
        tabContent.Position = UDim2.new(0, 0, 0, 54)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 100, 180)
        tabContent.Visible = false
        tabContent.Parent = Main

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

        -- Методы вкладки
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

        return tab
    end

    return window
end

return TolikUI
