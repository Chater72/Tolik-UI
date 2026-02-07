-- TolikUI v1.0 - UI библиотека для Roblox
-- KeySystem опциональный — включается только если передать KeySystem = true

local TolikUI = {}

-- Сервисы
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

-- =============================================
-- Уведомления
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
function TolikUI:CreateWindow(options)
    options = options or {}
    local title = options.Title or "TolikUI"
    local welcome = options.WelcomeMessage or "TolikUI загружен!"
    local keySystem = options.KeySystem or false
    local correctKey = options.CorrectKey or "tolik123"  -- дефолтный, если кто-то забудет указать

    local window = {}

    -- ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = "TolikUI_" .. math.random(1000,9999)
    sg.ResetOnSpawn = false
    sg.Parent = pg

    -- Кнопка открытия (иконка)
    local OpenBtn = Instance.new("ImageButton")
    OpenBtn.Size = UDim2.new(0, 64, 0, 64)
    OpenBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Image = "rbxassetid://137745684190476"
    OpenBtn.Parent = sg

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(1, 0)
    OpenCorner.Parent = OpenBtn

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(140, 220, 255)
    OpenStroke.Transparency = 0.3
    OpenStroke.Thickness = 3
    OpenStroke.Parent = OpenBtn

    -- Перетаскивание кнопки
    local obDragging, obDragInput, obDragStart, obStartPos

    OpenBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            obDragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == obDragInput and obDragging then
            local delta = input.Position - obDragStart
            OpenBtn.Position = UDim2.new(obStartPos.X.Scale, obStartPos.X.Offset + delta.X, obStartPos.Y.Scale, obStartPos.Y.Offset + delta.Y)
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
    Main.Visible = not keySystem  -- если ключ включён — окно скрыто
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
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    -- Кнопка закрытия (только красная)
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
    -- Key System — только если включён
    -- =============================================
    if keySystem then
        local KeyWindow = Instance.new("Frame")
        KeyWindow.Size = UDim2.new(0, 400, 0, 250)
        KeyWindow.Position = UDim2.new(0.5, -200, 0.5, -125)
        KeyWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        KeyWindow.BorderSizePixel = 0
        KeyWindow.Parent = sg

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 12)
        KeyCorner.Parent = KeyWindow

        local KeyStroke = Instance.new("UIStroke")
        KeyStroke.Color = Color3.fromRGB(0,0,0)
        KeyStroke.Transparency = 0.55
        KeyStroke.Thickness = 2.2
        KeyStroke.Parent = KeyWindow

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, 0, 0, 50)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = "Введите ключ"
        KeyTitle.TextColor3 = Color3.fromRGB(220, 230, 255)
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.TextSize = 20
        KeyTitle.Parent = KeyWindow

        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(1, -40, 0, 50)
        KeyInput.Position = UDim2.new(0, 20, 0, 70)
        KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        KeyInput.Text = ""
        KeyInput.TextColor3 = Color3.new(1,1,1)
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.TextSize = 15
        KeyInput.PlaceholderText = "Введи ключ..."
        KeyInput.Parent = KeyWindow

        local InputC = Instance.new("UICorner")
        InputC.CornerRadius = UDim.new(0, 10)
        InputC.Parent = KeyInput

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Size = UDim2.new(0.5, -30, 0, 50)
        SubmitBtn.Position = UDim2.new(0, 20, 1, -70)
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
        SubmitBtn.Text = "Войти"
        SubmitBtn.TextColor3 = Color3.new(1,1,1)
        SubmitBtn.Font = Enum.Font.GothamBold
        SubmitBtn.TextSize = 15
        SubmitBtn.Parent = KeyWindow

        local SubmitC = Instance.new("UICorner")
        SubmitC.CornerRadius = UDim.new(0, 10)
        SubmitC.Parent = SubmitBtn

        SubmitBtn.MouseButton1Click:Connect(function()
            local key = KeyInput.Text
            if key == correctKey then
                KeyWindow:Destroy()
                Main.Visible = true
                ShowNotify(sg, welcome, 5)
            else
                ShowNotify(sg, "Неверный ключ!", 3)
            end
        end)
    else
        -- Если ключ не нужен — сразу показываем приветствие
        Main.Visible = true
        ShowNotify(sg, welcome, 5)
    end

    -- =============================================
    -- Перетаскивание окна
    -- =============================================
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
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- =============================================
    -- Метод уведомления
    -- =============================================
    function window:Notify(text, duration)
        ShowNotify(sg, text, duration)
    end

    -- =============================================
    -- Вкладки и элементы (добавляй свои)
    -- =============================================
    function window:Tab(name)
        local tab = {}

        -- ... (здесь можно добавить код вкладок, если хочешь сразу готовые)

        return tab
    end

    return window
end

return TolikUI
