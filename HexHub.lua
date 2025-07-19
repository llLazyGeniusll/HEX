-- NexusUI - Beautiful UI Library for Roblox Exploiting
-- Version 1.0 - Lightweight & Modern Design

local NexusUI = {}
NexusUI.__index = NexusUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Utilities
local function createTween(obj, info, props)
    return TweenService:Create(obj, TweenInfo.new(info.Time or 0.3, info.Style or Enum.EasingStyle.Quad, info.Direction or Enum.EasingDirection.Out), props)
end

local function rippleEffect(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    local expandTween = createTween(ripple, {Time = 0.5}, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, x - maxSize/2, 0, y - maxSize/2),
        BackgroundTransparency = 1
    })
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 30),
        Surface = Color3.fromRGB(35, 35, 40),
        Primary = Color3.fromRGB(100, 150, 255),
        Secondary = Color3.fromRGB(150, 100, 255),
        Success = Color3.fromRGB(75, 200, 130),
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

-- Main Library
function NexusUI.new(title, theme)
    local self = setmetatable({}, NexusUI)
    self.Theme = Themes[theme] or Themes.Dark
    self.Title = title or "NexusUI"
    self.Visible = false
    self.Components = {}
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NexusUI_" .. math.random(1000, 9999)
    self.ScreenGui.ResetOnSpawn = false
    
    -- Protection
    pcall(function()
        self.ScreenGui.Parent = gethui() or game.CoreGui
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
    
    -- Corner Radius
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = self.Container
    
    -- Shadow Effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = self.Container.ZIndex - 1
    shadow.Parent = self.Container
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Theme.Surface
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.Container
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = self.TitleBar
    
    -- Title Text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -40, 0, 10)
    self.CloseButton.BackgroundColor3 = self.Theme.Error
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseButton.TextSize = 18
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = self.CloseButton
    
    -- Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -20, 1, -70)
    self.ContentContainer.Position = UDim2.new(0, 10, 0, 60)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ScrollBarThickness = 6
    self.ContentContainer.ScrollBarImageColor3 = self.Theme.Primary
    self.ContentContainer.Parent = self.Container
    
    -- Layout
    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Padding = UDim.new(0, 8)
    self.Layout.Parent = self.ContentContainer
    
    -- Dragging System
    self:_setupDragging()
    
    -- Close Button Logic
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    
    self.CloseButton.MouseEnter:Connect(function()
        createTween(self.CloseButton, {Time = 0.2}, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        createTween(self.CloseButton, {Time = 0.2}, {BackgroundColor3 = self.Theme.Error}):Play()
    end)
    
    return self
end

-- All Component methods below use self.Theme instead of tabSystem.Theme
-- (for brevity, only the changed lines shown below; the rest of your code remains the same)

-- Toggle Component
function NexusUI:Toggle(text, default, callback)
    local container = Instance.new("Frame")
    container.Name = "Toggle"
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer
    
    -- ... rest unchanged
end

-- Slider Component
function NexusUI:Slider(text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Name = "Slider"
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer
    
    -- ... rest unchanged
end

-- Input Component
function NexusUI:Input(text, placeholder, callback)
    local container = Instance.new("Frame")
    container.Name = "Input"
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    -- ... rest unchanged
end

-- Dropdown Component
function NexusUI:Dropdown(text, options, callback)
    local container = Instance.new("Frame")
    container.Name = "Dropdown"
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    -- ... rest unchanged
end

-- Notification System
function NexusUI:Notify(title, text, duration, type)
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "NexusNotify"
    notifyGui.ResetOnSpawn = false
    
    pcall(function()
        notifyGui.Parent = gethui() or game.CoreGui
    end)
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, 20, 0, 50)
    notification.BackgroundColor3 = self.Theme.Surface
    notification.BorderSizePixel = 0
    notification.Parent = notifyGui

    -- ... rest unchanged
end

-- Progress Bar Component
function NexusUI:ProgressBar(text, value)
    local container = Instance.new("Frame")
    container.Name = "ProgressBar"
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    -- ... rest unchanged
end

-- Keybind Component
function NexusUI:Keybind(text, defaultKey, callback)
    local container = Instance.new("Frame")
    container.Name = "Keybind"
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    -- ... rest unchanged
end

-- Color Picker Component (Simple)
function NexusUI:ColorPicker(text, defaultColor, callback)
    local container = Instance.new("Frame")
    container.Name = "ColorPicker"
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentContainer

    -- ... rest unchanged
end

-- Set Theme
function NexusUI:SetTheme(themeName)
    if not Themes[themeName] then return end
    
    self.Theme = Themes[themeName]
    
    -- Update existing elements
    self.Container.BackgroundColor3 = self.Theme.Background
    self.TitleBar.BackgroundColor3 = self.Theme.Surface
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.ContentContainer.ScrollBarImageColor3 = self.Theme.Primary
end

-- Tab System (remains unchanged, uses tabSystem.Theme inside tabSystem logic)

-- ... rest of your code remains the same ...

-- Return the library
return NexusUI
