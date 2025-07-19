--// Nova UI Library
local Nova = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local dragging = false
local dragInput, dragStart, startPos

-- Main UI Container
function Nova:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Parent = ScreenGui

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(100, 100, 255)
    Stroke.Thickness = 2

    local Blur = Instance.new("BlurEffect")
    Blur.Size = 15
    Blur.Parent = game.Lighting

    local Title = Instance.new("TextLabel")
    Title.Text = title or "Nova UI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Parent = Main

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -130, 1, -40)
    ContentFrame.Position = UDim2.new(0, 130, 0, 35)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = Main

    local Tabs = {}

    -- Dragging
    Main.InputBegan:Connect(function(input)
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

    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Public Methods
    function Nova:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Text = name
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.BorderSizePixel = 0
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = TabContainer

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentFrame

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 6)
        UIListLayout.Parent = TabContent

        Tabs[name] = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(ContentFrame:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            TabContent.Visible = true
        end)

        local ElementCreator = {}

        function ElementCreator:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Button.BorderSizePixel = 0
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = TabContent
            Button.MouseButton1Click:Connect(callback or function() end)
        end

        function ElementCreator:AddToggle(text, callback)
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1, -10, 0, 30)
            Toggle.Text = "[ OFF ] " .. text
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Toggle.BorderSizePixel = 0
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.Parent = TabContent

            local toggled = false
            Toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                Toggle.Text = (toggled and "[ ON  ] " or "[ OFF ] ") .. text
                if callback then callback(toggled) end
            end)
        end

        function ElementCreator:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.Parent = TabContent
        end

        return ElementCreator
    end

    return Nova
end

return Nova
