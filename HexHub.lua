-- Modern Roblox UI Library
-- Version 1.0.0

local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local Config = {
    Theme = {
        Background = Color3.fromRGB(18, 18, 24),
        Surface = Color3.fromRGB(28, 28, 35),
        Primary = Color3.fromRGB(88, 101, 242),
        Secondary = Color3.fromRGB(114, 137, 218),
        Accent = Color3.fromRGB(255, 115, 131),
        Text = Color3.fromRGB(220, 221, 222),
        TextSecondary = Color3.fromRGB(163, 166, 168),
        Border = Color3.fromRGB(47, 49, 54),
        Success = Color3.fromRGB(87, 242, 135),
        Warning = Color3.fromRGB(255, 202, 40),
        Error = Color3.fromRGB(237, 66, 69)
    },
    Animation = {
        Speed = 0.3,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out
    },
    Fonts = {
        Bold = Enum.Font.GothamBold,
        Medium = Enum.Font.GothamMedium,
        Regular = Enum.Font.Gotham
    }
}

-- Utility Functions
local function CreateTween(object, properties, duration)
    duration = duration or Config.Animation.Speed
    local tweenInfo = TweenInfo.new(
        duration,
        Config.Animation.Style,
        Config.Animation.Direction
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Config.Theme.Border
    stroke.Parent = parent
    return stroke
end

local function AddShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    AddCorner(shadow, 18)
    return shadow
end

-- Main Library Constructor
function UILibrary:CreateWindow(config)
    config = config or {}
    
    local Window = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "ModernUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
    MainFrame.BackgroundColor3 = Config.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, 1, Config.Theme.Border)
    AddShadow(MainFrame)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Config.Theme.Surface
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    AddCorner(TitleBar, 12)
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -60, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = config.Title or "Modern UI"
    TitleText.TextColor3 = Config.Theme.Text
    TitleText.TextSize = 16
    TitleText.Font = Config.Fonts.Bold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
    CloseButton.BackgroundColor3 = Config.Theme.Error
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.white
    CloseButton.TextSize = 18
    CloseButton.Font = Config.Fonts.Bold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    
    AddCorner(CloseButton, 6)
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -70)
    ContentFrame.Position = UDim2.new(0, 10, 0, 60)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Scrolling Frame
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.ScrollBarImageColor3 = Config.Theme.Primary
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Parent = ContentFrame
    
    -- Layout
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = ScrollingFrame
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        local closeTween = CreateTween(MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.2)
        closeTween:Play()
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
    end)
    
    -- Button hover effects
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Config.Theme.Error}):Play()
    end)
    
    -- Window methods
    function Window:CreateSection(title)
        local Section = {}
        
        -- Section Frame
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = "Section"
        SectionFrame.Size = UDim2.new(1, 0, 0, 35)
        SectionFrame.BackgroundColor3 = Config.Theme.Surface
        SectionFrame.BorderSizePixel = 0
        SectionFrame.Parent = ScrollingFrame
        
        AddCorner(SectionFrame, 8)
        
        -- Section Title
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "SectionTitle"
        SectionTitle.Size = UDim2.new(1, -20, 1, 0)
        SectionTitle.Position = UDim2.new(0, 15, 0, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = title or "Section"
        SectionTitle.TextColor3 = Config.Theme.Text
        SectionTitle.TextSize = 14
        SectionTitle.Font = Config.Fonts.Medium
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = SectionFrame
        
        return Section
    end
    
    function Window:CreateButton(config)
        config = config or {}
        
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Name = "ButtonFrame"
        ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
        ButtonFrame.BackgroundTransparency = 1
        ButtonFrame.Parent = ScrollingFrame
        
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundColor3 = Config.Theme.Primary
        Button.Text = config.Text or "Button"
        Button.TextColor3 = Color3.white
        Button.TextSize = 14
        Button.Font = Config.Fonts.Medium
        Button.BorderSizePixel = 0
        Button.Parent = ButtonFrame
        
        AddCorner(Button, 8)
        
        -- Hover effects
        Button.MouseEnter:Connect(function()
            CreateTween(Button, {BackgroundColor3 = Config.Theme.Secondary}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            CreateTween(Button, {BackgroundColor3 = Config.Theme.Primary}):Play()
        end)
        
        -- Click functionality
        if config.Callback then
            Button.MouseButton1Click:Connect(config.Callback)
        end
        
        return Button
    end
    
    function Window:CreateToggle(config)
        config = config or {}
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Config.Theme.Surface
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = ScrollingFrame
        
        AddCorner(ToggleFrame, 8)
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "ToggleLabel"
        ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = config.Text or "Toggle"
        ToggleLabel.TextColor3 = Config.Theme.Text
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Config.Fonts.Regular
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.BackgroundColor3 = Config.Theme.Border
        ToggleButton.Text = ""
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        AddCorner(ToggleButton, 10)
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Name = "ToggleCircle"
        ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
        ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
        ToggleCircle.BackgroundColor3 = Color3.white
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Parent = ToggleButton
        
        AddCorner(ToggleCircle, 8)
        
        local toggled = config.Default or false
        
        local function UpdateToggle()
            if toggled then
                CreateTween(ToggleButton, {BackgroundColor3 = Config.Theme.Success}):Play()
                CreateTween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
            else
                CreateTween(ToggleButton, {BackgroundColor3 = Config.Theme.Border}):Play()
                CreateTween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
        end
        
        UpdateToggle()
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            UpdateToggle()
            if config.Callback then
                config.Callback(toggled)
            end
        end)
        
        return {
            SetValue = function(value)
                toggled = value
                UpdateToggle()
            end,
            GetValue = function()
                return toggled
            end
        }
    end
    
    function Window:CreateSlider(config)
        config = config or {}
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = "SliderFrame"
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundColor3 = Config.Theme.Surface
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = ScrollingFrame
        
        AddCorner(SliderFrame, 8)
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Name = "SliderLabel"
        SliderLabel.Size = UDim2.new(1, -60, 0, 25)
        SliderLabel.Position = UDim2.new(0, 15, 0, 5)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = config.Text or "Slider"
        SliderLabel.TextColor3 = Config.Theme.Text
        SliderLabel.TextSize = 14
        SliderLabel.Font = Config.Fonts.Regular
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Name = "ValueLabel"
        ValueLabel.Size = UDim2.new(0, 50, 0, 25)
        ValueLabel.Position = UDim2.new(1, -60, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(config.Default or 0)
        ValueLabel.TextColor3 = Config.Theme.Primary
        ValueLabel.TextSize = 14
        ValueLabel.Font = Config.Fonts.Medium
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame
        
        local SliderTrack = Instance.new("Frame")
        SliderTrack.Name = "SliderTrack"
        SliderTrack.Size = UDim2.new(1, -30, 0, 4)
        SliderTrack.Position = UDim2.new(0, 15, 1, -15)
        SliderTrack.BackgroundColor3 = Config.Theme.Border
        SliderTrack.BorderSizePixel = 0
        SliderTrack.Parent = SliderFrame
        
        AddCorner(SliderTrack, 2)
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "SliderFill"
        SliderFill.Size = UDim2.new(0, 0, 1, 0)
        SliderFill.BackgroundColor3 = Config.Theme.Primary
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderTrack
        
        AddCorner(SliderFill, 2)
        
        local SliderHandle = Instance.new("TextButton")
        SliderHandle.Name = "SliderHandle"
        SliderHandle.Size = UDim2.new(0, 16, 0, 16)
        SliderHandle.Position = UDim2.new(0, -6, 0.5, -8)
        SliderHandle.BackgroundColor3 = Config.Theme.Primary
        SliderHandle.Text = ""
        SliderHandle.BorderSizePixel = 0
        SliderHandle.Parent = SliderFill
        
        AddCorner(SliderHandle, 8)
        
        local min = config.Min or 0
        local max = config.Max or 100
        local value = config.Default or min
        local dragging = false
        
        local function UpdateSlider(newValue)
            value = math.clamp(newValue, min, max)
            local percentage = (value - min) / (max - min)
            
            CreateTween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
            ValueLabel.Text = tostring(math.floor(value))
            
            if config.Callback then
                config.Callback(value)
            end
        end
        
        UpdateSlider(value)
        
        SliderHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation().X
                local trackPos = SliderTrack.AbsolutePosition.X
                local trackSize = SliderTrack.AbsoluteSize.X
                local percentage = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                UpdateSlider(min + (max - min) * percentage)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return {
            SetValue = function(newValue)
                UpdateSlider(newValue)
            end,
            GetValue = function()
                return value
            end
        }
    end
    
    function Window:CreateTextbox(config)
        config = config or {}
        
        local TextboxFrame = Instance.new("Frame")
        TextboxFrame.Name = "TextboxFrame"
        TextboxFrame.Size = UDim2.new(1, 0, 0, 40)
        TextboxFrame.BackgroundTransparency = 1
        TextboxFrame.Parent = ScrollingFrame
        
        local Textbox = Instance.new("TextBox")
        Textbox.Name = "Textbox"
        Textbox.Size = UDim2.new(1, 0, 1, 0)
        Textbox.BackgroundColor3 = Config.Theme.Surface
        Textbox.PlaceholderText = config.Placeholder or "Enter text..."
        Textbox.Text = config.Default or ""
        Textbox.TextColor3 = Config.Theme.Text
        Textbox.PlaceholderColor3 = Config.Theme.TextSecondary
        Textbox.TextSize = 14
        Textbox.Font = Config.Fonts.Regular
        Textbox.BorderSizePixel = 0
        Textbox.ClearTextOnFocus = false
        Textbox.Parent = TextboxFrame
        
        AddCorner(Textbox, 8)
        AddStroke(Textbox, 1, Config.Theme.Border)
        
        -- Focus effects
        Textbox.Focused:Connect(function()
            CreateTween(Textbox.UIStroke, {Color = Config.Theme.Primary}):Play()
        end)
        
        Textbox.FocusLost:Connect(function()
            CreateTween(Textbox.UIStroke, {Color = Config.Theme.Border}):Play()
            if config.Callback then
                config.Callback(Textbox.Text)
            end
        end)
        
        return Textbox
    end
    
    return Window
end

return UILibrary
