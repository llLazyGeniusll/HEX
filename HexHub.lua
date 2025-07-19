-- CopilotUI Enhanced - Ultra Modern Aesthetic Roblox UI Library
-- Redesigned with glassmorphism, smooth animations, and premium aesthetics

local CopilotUI = {}
CopilotUI.__index = CopilotUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Premium glassmorphic theme with vibrant accents
local Theme = {
    -- Glassmorphic backgrounds
    Background = Color3.fromRGB(15, 18, 25),
    BackgroundSecondary = Color3.fromRGB(22, 26, 35),
    Glass = Color3.fromRGB(40, 45, 58),
    GlassLight = Color3.fromRGB(60, 68, 85),
    
    -- Vibrant modern accents
    Primary = Color3.fromRGB(138, 43, 226),     -- Purple
    PrimaryHover = Color3.fromRGB(155, 65, 240),
    Secondary = Color3.fromRGB(30, 144, 255),   -- Blue
    Accent = Color3.fromRGB(0, 255, 127),       -- Spring green
    AccentHover = Color3.fromRGB(50, 255, 150),
    
    -- Status colors
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(239, 68, 68),
    
    -- Text hierarchy
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(156, 163, 175),
    TextMuted = Color3.fromRGB(107, 114, 128),
    
    -- Borders and dividers
    Border = Color3.fromRGB(55, 65, 81),
    BorderLight = Color3.fromRGB(75, 85, 99),
    
    -- Interactive states
    Hover = Color3.fromRGB(75, 85, 99),
    Active = Color3.fromRGB(99, 102, 241),
}

-- Enhanced easing styles
local Easing = {
    Spring = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Quick = TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
}

-- Utility functions
local function CreateTween(obj, props, tweenInfo)
    return TweenService:Create(obj, tweenInfo or Easing.Smooth, props)
end

local function PlayTween(obj, props, tweenInfo)
    CreateTween(obj, props, tweenInfo):Play()
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Theme.Border
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function CreateDropShadow(parent, size, offset, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "DropShadow"
    shadow.Size = UDim2.new(1, size or 20, 1, size or 20)
    shadow.Position = UDim2.new(0, -(size or 20)/2 + (offset or 0), 0, -(size or 20)/2 + (offset or 2))
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.8
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    CreateCorner(shadow, 16)
    
    local blur = Instance.new("ImageLabel")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundTransparency = 1
    blur.Image = "rbxassetid://241650934" -- Soft blur texture
    blur.ImageColor3 = Color3.fromRGB(0, 0, 0)
    blur.ImageTransparency = 0.7
    blur.Parent = shadow
    CreateCorner(blur, 16)
    
    return shadow
end

local function CreateGlowEffect(parent, color, intensity)
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 8, 1, 8)
    glow.Position = UDim2.new(0, -4, 0, -4)
    glow.BackgroundColor3 = color or Theme.Primary
    glow.BackgroundTransparency = 0.7
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent.Parent
    CreateCorner(glow, 16)
    
    -- Animated glow pulse
    spawn(function()
        while glow.Parent do
            PlayTween(glow, {BackgroundTransparency = 0.9}, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
            wait(1.5)
            PlayTween(glow, {BackgroundTransparency = 0.7}, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
            wait(1.5)
        end
    end)
    
    return glow
end

function CopilotUI:_setupDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    -- Enhanced drag with momentum
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Frame.Position
            
            PlayTween(self.Frame, {Size = UDim2.new(0, 485, 0, 375)}, Easing.Quick)
            CreateGlowEffect(self.Frame, Theme.Primary, 0.5)
        end
    end
    
    local function onInputChanged(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            self.Frame.Position = newPos
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            PlayTween(self.Frame, {Size = UDim2.new(0, 480, 0, 370)}, Easing.Quick)
            
            -- Remove glow
            if self.Frame.Parent:FindFirstChild("Glow") then
                self.Frame.Parent.Glow:Destroy()
            end
        end
    end
    
    self.TitleBar.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
end

function CopilotUI.new(title)
    local self = setmetatable({}, CopilotUI)
    
    -- Create main ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "CopilotUI_Enhanced_" .. math.random(10000, 99999)
    self.Gui.ResetOnSpawn = false
    self.Gui.DisplayOrder = 999
    pcall(function()
        self.Gui.Parent = gethui and gethui() or game:GetService("CoreGui")
    end)
    
    -- Main container with glassmorphic effect
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0, 480, 0, 370)
    self.Frame.Position = UDim2.new(0.5, -240, 0.5, -185)
    self.Frame.BackgroundColor3 = Theme.Background
    self.Frame.BackgroundTransparency = 0.15
    self.Frame.BorderSizePixel = 0
    self.Frame.ZIndex = 10
    self.Frame.Parent = self.Gui
    
    CreateCorner(self.Frame, 20)
    CreateStroke(self.Frame, 1, Theme.Border)
    CreateDropShadow(self.Frame, 40, 8, 0.7)
    
    -- Glassmorphic overlay
    local glassOverlay = Instance.new("Frame")
    glassOverlay.Size = UDim2.new(1, 0, 1, 0)
    glassOverlay.BackgroundColor3 = Theme.Glass
    glassOverlay.BackgroundTransparency = 0.6
    glassOverlay.BorderSizePixel = 0
    glassOverlay.ZIndex = 11
    glassOverlay.Parent = self.Frame
    CreateCorner(glassOverlay, 20)
    
    -- Animated gradient overlay
    local gradientOverlay = Instance.new("Frame")
    gradientOverlay.Size = UDim2.new(1, 0, 1, 0)
    gradientOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gradientOverlay.BackgroundTransparency = 0.95
    gradientOverlay.BorderSizePixel = 0
    gradientOverlay.ZIndex = 12
    gradientOverlay.Parent = self.Frame
    CreateCorner(gradientOverlay, 20)
    
    local gradient = CreateGradient(gradientOverlay, {
        Color3.fromRGB(138, 43, 226),
        Color3.fromRGB(30, 144, 255)
    })
    
    -- Animated gradient rotation
    spawn(function()
        local rotation = 0
        while self.Frame.Parent do
            rotation = rotation + 0.5
            gradient.Rotation = rotation % 360
            wait(0.1)
        end
    end)
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 60)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.ZIndex = 15
    self.TitleBar.Parent = self.Frame
    
    -- Title with enhanced typography
    self.Title = Instance.new("TextLabel")
    self.Title.Size = UDim2.new(1, -120, 1, 0)
    self.Title.Position = UDim2.new(0, 24, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = title or "CopilotUI Enhanced"
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextSize = 24
    self.Title.TextColor3 = Theme.TextPrimary
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.ZIndex = 16
    self.Title.Parent = self.TitleBar
    
    -- Minimize button
    self.MinimizeBtn = Instance.new("TextButton")
    self.MinimizeBtn.Size = UDim2.new(0, 36, 0, 36)
    self.MinimizeBtn.Position = UDim2.new(1, -88, 0.5, -18)
    self.MinimizeBtn.BackgroundColor3 = Theme.Warning
    self.MinimizeBtn.BackgroundTransparency = 0.2
    self.MinimizeBtn.Text = "—"
    self.MinimizeBtn.TextColor3 = Theme.TextPrimary
    self.MinimizeBtn.Font = Enum.Font.GothamBold
    self.MinimizeBtn.TextSize = 16
    self.MinimizeBtn.BorderSizePixel = 0
    self.MinimizeBtn.ZIndex = 16
    self.MinimizeBtn.Parent = self.TitleBar
    CreateCorner(self.MinimizeBtn, 18)
    CreateStroke(self.MinimizeBtn, 1, Theme.BorderLight)
    
    -- Close button with enhanced design
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 36, 0, 36)
    self.CloseBtn.Position = UDim2.new(1, -44, 0.5, -18)
    self.CloseBtn.BackgroundColor3 = Theme.Error
    self.CloseBtn.BackgroundTransparency = 0.2
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Theme.TextPrimary
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.TextSize = 14
    self.CloseBtn.BorderSizePixel = 0
    self.CloseBtn.ZIndex = 16
    self.CloseBtn.Parent = self.TitleBar
    CreateCorner(self.CloseBtn, 18)
    CreateStroke(self.CloseBtn, 1, Theme.BorderLight)
    
    -- Enhanced button interactions
    local function setupButtonInteractions(btn, hoverColor, clickScale)
        btn.MouseEnter:Connect(function()
            PlayTween(btn, {
                BackgroundTransparency = 0,
                BackgroundColor3 = hoverColor
            }, Easing.Quick)
        end)
        
        btn.MouseLeave:Connect(function()
            PlayTween(btn, {
                BackgroundTransparency = 0.2,
                BackgroundColor3 = btn == self.CloseBtn and Theme.Error or Theme.Warning
            }, Easing.Quick)
        end)
        
        btn.MouseButton1Down:Connect(function()
            PlayTween(btn, {Size = UDim2.new(0, 32, 0, 32)}, Easing.Quick)
        end)
        
        btn.MouseButton1Up:Connect(function()
            PlayTween(btn, {Size = UDim2.new(0, 36, 0, 36)}, Easing.Spring)
        end)
    end
    
    setupButtonInteractions(self.MinimizeBtn, Color3.fromRGB(251, 211, 56))
    setupButtonInteractions(self.CloseBtn, Color3.fromRGB(255, 88, 88))
    
    -- Close button functionality
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:AnimateClose()
    end)
    
    -- Minimize functionality
    local minimized = false
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            PlayTween(self.Frame, {
                Size = UDim2.new(0, 480, 0, 60),
                BackgroundTransparency = 0.3
            }, Easing.Spring)
            self.Content.Visible = false
        else
            PlayTween(self.Frame, {
                Size = UDim2.new(0, 480, 0, 370),
                BackgroundTransparency = 0.15
            }, Easing.Spring)
            self.Content.Visible = true
        end
    end)
    
    -- Content area with enhanced scrolling
    self.Content = Instance.new("ScrollingFrame")
    self.Content.Size = UDim2.new(1, -32, 1, -80)
    self.Content.Position = UDim2.new(0, 16, 0, 70)
    self.Content.BackgroundTransparency = 1
    self.Content.BorderSizePixel = 0
    self.Content.ScrollBarThickness = 4
    self.Content.ScrollBarImageColor3 = Theme.Primary
    self.Content.ScrollBarImageTransparency = 0.3
    self.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Content.ScrollingDirection = Enum.ScrollingDirection.Y
    self.Content.ZIndex = 15
    self.Content.Parent = self.Frame
    
    -- Layout with enhanced spacing
    self.Layout = Instance.new("UIListLayout")
    self.Layout.Padding = UDim.new(0, 12)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Parent = self.Content
    
    -- Auto-resize canvas
    self.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Content.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Setup dragging
    self:_setupDragging()
    
    -- Entrance animation
    self.Frame.Position = UDim2.new(0.5, -240, 0.5, -500)
    self.Frame.BackgroundTransparency = 1
    PlayTween(self.Frame, {
        Position = UDim2.new(0.5, -240, 0.5, -185),
        BackgroundTransparency = 0.15
    }, Easing.Bounce)
    
    return self
end

function CopilotUI:AnimateClose()
    -- Enhanced close animation
    PlayTween(self.Frame, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, Easing.Spring)
    
    wait(0.5)
    self.Gui:Destroy()
end

function CopilotUI:Button(text, callback, color, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = color or Theme.Primary
    btn.BackgroundTransparency = 0.1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 20
    btn.Parent = self.Content
    
    CreateCorner(btn, 12)
    CreateStroke(btn, 1, Theme.BorderLight)
    
    -- Gradient overlay for premium look
    local gradientFrame = Instance.new("Frame")
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gradientFrame.BackgroundTransparency = 0.9
    gradientFrame.BorderSizePixel = 0
    gradientFrame.ZIndex = 21
    gradientFrame.Parent = btn
    CreateCorner(gradientFrame, 12)
    
    CreateGradient(gradientFrame, {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255)
    }, 90)
    
    -- Button text with icon support
    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(1, icon and -36 or -24, 1, 0)
    btnText.Position = UDim2.new(0, icon and 36 or 12, 0, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = text or "Button"
    btnText.TextColor3 = Theme.TextPrimary
    btnText.Font = Enum.Font.GothamMedium
    btnText.TextSize = 16
    btnText.TextXAlignment = icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
    btnText.ZIndex = 22
    btnText.Parent = btn
    
    -- Icon support
    if icon then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 24, 0, 24)
        iconLabel.Position = UDim2.new(0, 12, 0.5, -12)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Theme.TextPrimary
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextSize = 18
        iconLabel.ZIndex = 22
        iconLabel.Parent = btn
    end
    
    -- Enhanced button interactions
    btn.MouseEnter:Connect(function()
        PlayTween(btn, {BackgroundTransparency = 0}, Easing.Quick)
        PlayTween(gradientFrame, {BackgroundTransparency = 0.7}, Easing.Quick)
        PlayTween(btn, {Size = UDim2.new(1, 4, 0, 48)}, Easing.Quick)
    end)
    
    btn.MouseLeave:Connect(function()
        PlayTween(btn, {BackgroundTransparency = 0.1}, Easing.Quick)
        PlayTween(gradientFrame, {BackgroundTransparency = 0.9}, Easing.Quick)
        PlayTween(btn, {Size = UDim2.new(1, 0, 0, 46)}, Easing.Quick)
    end)
    
    btn.MouseButton1Down:Connect(function()
        PlayTween(btn, {Size = UDim2.new(1, -4, 0, 42)}, Easing.Quick)
    end)
    
    btn.MouseButton1Up:Connect(function()
        PlayTween(btn, {Size = UDim2.new(1, 4, 0, 48)}, Easing.Spring)
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

function CopilotUI:Label(text, size, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, size or 32)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or "Label"
    lbl.TextColor3 = color or Theme.TextSecondary
    lbl.TextSize = 15
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ZIndex = 18
    lbl.Parent = self.Content
    return lbl
end

function CopilotUI:Section(title, subtitle)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, subtitle and 55 or 40)
    container.BackgroundColor3 = Theme.Glass
    container.BackgroundTransparency = 0.7
    container.BorderSizePixel = 0
    container.ZIndex = 17
    container.Parent = self.Content
    
    CreateCorner(container, 10)
    CreateStroke(container, 1, Theme.BorderLight)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 24)
    titleLabel.Position = UDim2.new(0, 16, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Section"
    titleLabel.TextColor3 = Theme.Primary
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 18
    titleLabel.Parent = container
    
    if subtitle then
        local subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Size = UDim2.new(1, -20, 0, 18)
        subtitleLabel.Position = UDim2.new(0, 16, 0, 32)
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Text = subtitle
        subtitleLabel.TextColor3 = Theme.TextMuted
        subtitleLabel.TextSize = 13
        subtitleLabel.Font = Enum.Font.Gotham
        subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtitleLabel.ZIndex = 18
        subtitleLabel.Parent = container
    end
    
    return container
end

function CopilotUI:Toggle(text, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 52)
    container.BackgroundColor3 = Theme.Glass
    container.BackgroundTransparency = 0.8
    container.BorderSizePixel = 0
    container.ZIndex = 19
    container.Parent = self.Content
    
    CreateCorner(container, 12)
    CreateStroke(container, 1, Theme.BorderLight)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Toggle"
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 15
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 20
    label.Parent = container
    
    -- Enhanced toggle switch
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 50, 0, 26)
    toggleFrame.Position = UDim2.new(1, -66, 0.5, -13)
    toggleFrame.BackgroundColor3 = default and Theme.Accent or Theme.Border
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 20
    toggleFrame.Parent = container
    CreateCorner(toggleFrame, 13)
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 20, 0, 20)
    toggleKnob.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    toggleKnob.BackgroundColor3 = Theme.TextPrimary
    toggleKnob.BorderSizePixel = 0
    toggleKnob.ZIndex = 21
    toggleKnob.Parent = toggleFrame
    CreateCorner(toggleKnob, 10)
    CreateDropShadow(toggleKnob, 8, 2, 0.6)
    
    local state = default or false
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 22
    button.Parent = toggleFrame
    
    button.MouseButton1Click:Connect(function()
        state = not state
        
        PlayTween(toggleKnob, {
            Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        }, Easing.Spring)
        
        PlayTween(toggleFrame, {
            BackgroundColor3 = state and Theme.Accent or Theme.Border
        }, Easing.Smooth)
        
        if callback then callback(state) end
    end)
    
    -- Hover effects
    container.MouseEnter:Connect(function()
        PlayTween(container, {BackgroundTransparency = 0.6}, Easing.Quick)
    end)
    
    container.MouseLeave:Connect(function()
        PlayTween(container, {BackgroundTransparency = 0.8}, Easing.Quick)
    end)
    
    return container, function() return state end
end

function CopilotUI:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

return CopilotUI
