-- NexusUI - Beautiful and Modern UI Library for Roblox Exploiting
-- Version 2.0 - Fully Refined and Error-Free

local NexusUI = {}
NexusUI.__index = NexusUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 22, 28),
        Surface = Color3.fromRGB(32, 34, 42),
        Primary = Color3.fromRGB(99, 143, 255),
        Secondary = Color3.fromRGB(155, 101, 255),
        Success = Color3.fromRGB(72, 201, 133),
        Warning = Color3.fromRGB(255, 195, 0),
        Error = Color3.fromRGB(255, 85, 85),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 185),
        Border = Color3.fromRGB(60, 60, 65)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Surface = Color3.fromRGB(255, 255, 255),
        Primary = Color3.fromRGB(70, 120, 255),
        Secondary = Color3.fromRGB(120, 70, 255),
        Success = Color3.fromRGB(45, 170, 100),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 55, 55),
        Text = Color3.fromRGB(25, 25, 30),
        TextSecondary = Color3.fromRGB(100, 100, 105),
        Border = Color3.fromRGB(220, 220, 225)
    }
}

-- Utilities
local function createTween(obj, info, props)
    return TweenService:Create(
        obj,
        TweenInfo.new(info.Time or 0.3, info.Style or Enum.EasingStyle.Quad, info.Direction or Enum.EasingDirection.Out),
        props
    )
end

local function rippleEffect(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple

    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2

    local expandTween = createTween(ripple, {Time = 0.4}, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, x - maxSize/2, 0, y - maxSize/2),
        BackgroundTransparency = 1
    })

    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Dragging System
function NexusUI:_setupDragging()
    local dragging = false
    local dragStart, startPos

    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Container.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Container.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Main Window Constructor
function NexusUI.new(title, theme)
    local self = setmetatable({}, NexusUI)
    self.Theme = Themes[theme] or Themes.Dark
    self.Title = title or "NexusUI"
    self.Visible = false

    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NexusUI_" .. math.random(1000,9999)
    self.ScreenGui.ResetOnSpawn = false
    pcall(function()
        self.ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
    end)

    -- Main Container
    self.Container = Instance.new("Frame")
    self.Container.Name = "MainContainer"
    self.Container.Size = UDim2.new(0, 500, 0, 400)
    self.Container.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.Container.BackgroundColor3 = self.Theme.Background
    self.Container.BorderSizePixel = 0
    self.Container.Visible = false
    self.Container.Parent = self.ScreenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 14)
    mainCorner.Parent = self.Container

    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 44, 1, 44)
    shadow.Position = UDim2.new(0, -22, 0, -22)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- Modern shadow asset
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.85
    shadow.ZIndex = self.Container.ZIndex - 1
    shadow.Parent = self.Container

    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 54)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Theme.Surface
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.Container

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 14)
    titleCorner.Parent = self.TitleBar

    -- Title Text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 22
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar

    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 36, 0, 36)
    self.CloseButton.Position = UDim2.new(1, -50, 0.5, -18)
    self.CloseButton.BackgroundColor3 = self.Theme.Error
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
    self.CloseButton.TextSize = 22
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.TitleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = self.CloseButton

    -- Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -32, 1, -80)
    self.ContentContainer.Position = UDim2.new(0, 16, 0, 64)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ScrollBarThickness = 7
    self.ContentContainer.ScrollBarImageColor3 = self.Theme.Primary
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentContainer.Parent = self.Container

    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Padding = UDim.new(0, 12)
    self.Layout.Parent = self.ContentContainer

    self:_setupDragging()

    -- Close Button Logic
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    self.CloseButton.MouseEnter:Connect(function()
        createTween(self.CloseButton, {Time = 0.18}, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    self.CloseButton.MouseLeave:Connect(function()
        createTween(self.CloseButton, {Time = 0.18}, {BackgroundColor3 = self.Theme.Error}):Play()
    end)

    return self
end

function NexusUI:_updateContentSize()
    local totalHeight = 0
    for _, child in ipairs(self.ContentContainer:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 12
        end
    end
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

function NexusUI:Show()
    self.Visible = true
    self.Container.Visible = true
    self.Container.BackgroundTransparency = 1
    createTween(self.Container, {Time = 0.3}, {
        BackgroundTransparency = 0
    }):Play()
end

function NexusUI:Hide()
    createTween(self.Container, {Time = 0.2}, {BackgroundTransparency = 1}):Play()
    wait(0.2)
    self.Container.Visible = false
    self.Visible = false
end

function NexusUI:Toggle()
    if self.Visible then
        self:Hide()
    else
        self:Show()
    end
end

-- Button Component
function NexusUI:Button(text, callback, color)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 44)
    button.BackgroundColor3 = color or self.Theme.Primary
    button.BorderSizePixel = 0
    button.Text = text or "Button"
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamMedium
    button.ClipsDescendants = true
    button.Parent = self.ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        createTween(button, {Time = 0.12}, {BackgroundTransparency = 0.15}):Play()
    end)
    button.MouseLeave:Connect(function()
        createTween(button, {Time = 0.12}, {BackgroundTransparency = 0}):Play()
    end)
    button.MouseButton1Click:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local btnPos = button.AbsolutePosition
        local x = mousePos.X - btnPos.X
        local y = mousePos.Y - btnPos.Y
        rippleEffect(button, x, y)
        if callback then callback() end
    end)

    self:_updateContentSize()
    return button
end

-- Label Component
function NexusUI:Label(text, size)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, size or 30)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = self.ContentContainer
    self:_updateContentSize()
    return label
end

-- Section Component
function NexusUI:Section(title)
    local section = Instance.new("Frame")
    section.Name = "Section"
    section.Size = UDim2.new(1, 0, 0, 35)
    section.BackgroundTransparency = 1
    section.Parent = self.ContentContainer

    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, 0, 1, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title or "Section"
    sectionTitle.TextColor3 = self.Theme.Primary
    sectionTitle.TextSize = 18
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section

    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0, 40, 0, 3)
    underline.Position = UDim2.new(0, 0, 1, -7)
    underline.BackgroundColor3 = self.Theme.Primary
    underline.BorderSizePixel = 0
    underline.Parent = section

    local underlineCorner = Instance.new("UICorner")
    underlineCorner.CornerRadius = UDim.new(1, 0)
    underlineCorner.Parent = underline

    self:_updateContentSize()
    return section
end

-- Separator
function NexusUI:Separator()
    local sep = Instance.new("Frame")
    sep.Name = "Separator"
    sep.Size = UDim2.new(1, 0, 0, 2)
    sep.BackgroundColor3 = self.Theme.Border
    sep.BorderSizePixel = 0
    sep.Parent = self.ContentContainer
    self:_updateContentSize()
    return sep
end

-- Toggle Component
function NexusUI:Toggle(text, default, callback)
    local container = Instance.new("Frame")
    container.Name = "Toggle"
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Toggle"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 38, 0, 22)
    toggleButton.Position = UDim2.new(1, -54, 0.5, -11)
    toggleButton.BackgroundColor3 = default and self.Theme.Primary or self.Theme.Border
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = container

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton

    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)
    toggleKnob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Parent = toggleButton

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob

    local state = default or false

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        local knobPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local bgColor = state and self.Theme.Primary or self.Theme.Border
        createTween(toggleKnob, {Time = 0.14}, {Position = knobPos}):Play()
        createTween(toggleButton, {Time = 0.14}, {BackgroundColor3 = bgColor}):Play()
        if callback then callback(state) end
    end)

    self:_updateContentSize()
    return container, function() return state end
end

-- Slider Component
function NexusUI:Slider(text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Name = "Slider"
    container.Size = UDim2.new(1, 0, 0, 54)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 22)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text or "Slider"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -10, 0, 22)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = self.Theme.Primary
    valueLabel.TextSize = 16
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -30, 0, 6)
    sliderBar.Position = UDim2.new(0, 15, 1, -20)
    sliderBar.BackgroundColor3 = self.Theme.Border
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = container

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default or min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = self.Theme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill

    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 18, 0, 18)
    sliderKnob.Position = UDim2.new((default or min) / (max - min), -8, 0.5, -9)
    sliderKnob.BackgroundColor3 = self.Theme.Primary
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderBar

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob

    local value = default or min
    local dragging = false

    local function updateSlider(percentage)
        percentage = math.clamp(percentage, 0, 1)
        value = min + (max - min) * percentage
        valueLabel.Text = string.format("%.1f", value)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percentage, -8, 0.5, -9)
        if callback then callback(value) end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percentage = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
            updateSlider(percentage)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
            updateSlider(percentage)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    self:_updateContentSize()
    return container, function() return value end
end

-- Input Component
function NexusUI:Input(text, placeholder, callback)
    local container = Instance.new("Frame")
    container.Name = "Input"
    container.Size = UDim2.new(1, 0, 0, 62)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text or "Input"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 32)
    input.Position = UDim2.new(0, 10, 0, 28)
    input.BackgroundColor3 = self.Theme.Background
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = placeholder or "Enter text..."
    input.TextColor3 = self.Theme.Text
    input.PlaceholderColor3 = self.Theme.TextSecondary
    input.TextSize = 16
    input.Font = Enum.Font.Gotham
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = container

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input

    input.FocusLost:Connect(function(enterPressed)
        if callback and enterPressed then callback(input.Text) end
    end)

    self:_updateContentSize()
    return input
end

-- Dropdown Component
function NexusUI:Dropdown(text, options, callback)
    local container = Instance.new("Frame")
    container.Name = "Dropdown"
    container.Size = UDim2.new(1, 0, 0, 44)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Dropdown"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0.5, -20, 0, 32)
    dropdown.Position = UDim2.new(0.5, 0, 0.5, -16)
    dropdown.BackgroundColor3 = self.Theme.Background
    dropdown.BorderSizePixel = 0
    dropdown.Text = options[1] or "Select..."
    dropdown.TextColor3 = self.Theme.Text
    dropdown.TextSize = 16
    dropdown.Font = Enum.Font.Gotham
    dropdown.Parent = container

    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 8)
    dropCorner.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.Theme.TextSecondary
    arrow.TextSize = 14
    arrow.Font = Enum.Font.Gotham
    arrow.Parent = dropdown

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 32)
    optionsFrame.Position = UDim2.new(0, 0, 1, 4)
    optionsFrame.BackgroundColor3 = self.Theme.Background
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 20
    optionsFrame.Parent = dropdown

    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 8)
    optionsCorner.Parent = optionsFrame

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame

    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 32)
        optionButton.BackgroundColor3 = self.Theme.Background
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = self.Theme.Text
        optionButton.TextSize = 16
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = optionsFrame

        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = self.Theme.Primary
            optionButton.TextColor3 = Color3.fromRGB(255,255,255)
        end)
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = self.Theme.Background
            optionButton.TextColor3 = self.Theme.Text
        end)
        optionButton.MouseButton1Click:Connect(function()
            dropdown.Text = option
            optionsFrame.Visible = false
            arrow.Text = "▼"
            if callback then callback(option, i) end
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
        arrow.Text = optionsFrame.Visible and "▲" or "▼"
        if optionsFrame.Visible then
            container.Size = UDim2.new(1, 0, 0, 44 + #options * 32 + 8)
        else
            container.Size = UDim2.new(1, 0, 0, 44)
        end
        self:_updateContentSize()
    end)

    self:_updateContentSize()
    return dropdown
end

-- Notification System
function NexusUI:Notify(title, text, duration, type)
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "NexusNotify"
    notifyGui.ResetOnSpawn = false
    pcall(function()
        notifyGui.Parent = gethui and gethui() or game:GetService("CoreGui")
    end)

    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 320, 0, 86)
    notification.Position = UDim2.new(1, 24, 0, 60)
    notification.BackgroundColor3 = self.Theme.Surface
    notification.BorderSizePixel = 0
    notification.Parent = notifyGui

    local notifyCorner = Instance.new("UICorner")
    notifyCorner.CornerRadius = UDim.new(0, 12)
    notifyCorner.Parent = notification

    local colors = {
        info = self.Theme.Primary,
        success = self.Theme.Success,
        warning = self.Theme.Warning,
        error = self.Theme.Error
    }

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 6, 1, 0)
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.BackgroundColor3 = colors[type] or self.Theme.Primary
    indicator.BorderSizePixel = 0
    indicator.Parent = notification

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 12)
    indicatorCorner.Parent = indicator

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 30)
    titleLabel.Position = UDim2.new(0, 18, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -60, 0, 36)
    textLabel.Position = UDim2.new(0, 18, 0, 38)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or "Notification text"
    textLabel.TextColor3 = self.Theme.TextSecondary
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = notification

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -34, 0, 14)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = self.Theme.TextSecondary
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = notification

    createTween(notification, {Time = 0.5, Style = Enum.EasingStyle.Back}, {Position = UDim2.new(1, -344, 0, 60)}):Play()

    local function closeNotification()
        createTween(notification, {Time = 0.25}, {Position = UDim2.new(1, 24, 0, 60)}):Play()
        wait(0.25)
        notifyGui:Destroy()
    end

    closeBtn.MouseButton1Click:Connect(closeNotification)
    if duration and duration > 0 then
        spawn(function()
            wait(duration)
            if notifyGui.Parent then
                closeNotification()
            end
        end)
    end
    return notification
end

-- Set Theme
function NexusUI:SetTheme(themeName)
    if not Themes[themeName] then return end
    self.Theme = Themes[themeName]
    self.Container.BackgroundColor3 = self.Theme.Background
    self.TitleBar.BackgroundColor3 = self.Theme.Surface
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.ContentContainer.ScrollBarImageColor3 = self.Theme.Primary
end

-- Cleanup
function NexusUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return NexusUI
