-- CopilotUI - Aesthetic Roblox UI Library
-- Designed by GitHub Copilot Chat, 2025

local CopilotUI = {}
CopilotUI.__index = CopilotUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Modern, soft glass theme
local Theme = {
    Background     = Color3.fromRGB(33, 37, 43),
    Surface        = Color3.fromRGB(47, 52, 61),
    Primary        = Color3.fromRGB(105, 176, 240),
    Accent         = Color3.fromRGB(80, 220, 185),
    Error          = Color3.fromRGB(255, 90, 120),
    Success        = Color3.fromRGB(120, 210, 130),
    Border         = Color3.fromRGB(55, 60, 70),
    Text           = Color3.fromRGB(240, 245, 255),
    TextSecondary  = Color3.fromRGB(160, 170, 185)
}

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function Shadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.9
    shadow.Size = UDim2.new(1, 36, 1, 36)
    shadow.Position = UDim2.new(0, -18, 0, -18)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
end

function CopilotUI:_drag()
    local dragging, dragStart, startPos = false, nil, nil
    self.Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function CopilotUI.new(title)
    local self = setmetatable({}, CopilotUI)

    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "CopilotUI_" .. math.random(1000,9999)
    self.Gui.ResetOnSpawn = false
    pcall(function() self.Gui.Parent = gethui and gethui() or game:GetService("CoreGui") end)

    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(0, 480, 0, 370)
    self.Frame.Position = UDim2.new(0.5, -240, 0.5, -185)
    self.Frame.BackgroundColor3 = Theme.Background
    self.Frame.BorderSizePixel = 0
    self.Frame.BackgroundTransparency = 0.08
    self.Frame.Parent = self.Gui
    self.Frame.ZIndex = 10
    local corner = Instance.new("UICorner", self.Frame)
    corner.CornerRadius = UDim.new(0, 18)
    Shadow(self.Frame)

    self.Title = Instance.new("TextLabel")
    self.Title.Size = UDim2.new(1, -60, 0, 52)
    self.Title.Position = UDim2.new(0, 22, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = title or "CopilotUI"
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextSize = 22
    self.Title.TextColor3 = Theme.Text
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.Frame
    self.Title.ZIndex = 12

    self.Close = Instance.new("TextButton")
    self.Close.Size = UDim2.new(0, 40, 0, 40)
    self.Close.Position = UDim2.new(1, -52, 0, 8)
    self.Close.BackgroundColor3 = Theme.Error
    self.Close.Text = "×"
    self.Close.TextColor3 = Color3.fromRGB(255,255,255)
    self.Close.Font = Enum.Font.GothamBold
    self.Close.TextSize = 20
    self.Close.BorderSizePixel = 0
    self.Close.Parent = self.Frame
    self.Close.ZIndex = 13
    local closeCorner = Instance.new("UICorner", self.Close)
    closeCorner.CornerRadius = UDim.new(1, 0)
    self.Close.MouseEnter:Connect(function()
        Tween(self.Close, {BackgroundColor3 = Color3.fromRGB(255, 130, 130)}, 0.16)
    end)
    self.Close.MouseLeave:Connect(function()
        Tween(self.Close, {BackgroundColor3 = Theme.Error}, 0.16)
    end)
    self.Close.MouseButton1Click:Connect(function()
        Tween(self.Frame, {BackgroundTransparency = 1}, 0.18)
        wait(0.18)
        self.Frame.Visible = false
    end)

    self.Content = Instance.new("ScrollingFrame")
    self.Content.Size = UDim2.new(1, -32, 1, -80)
    self.Content.Position = UDim2.new(0, 16, 0, 64)
    self.Content.BackgroundTransparency = 1
    self.Content.BorderSizePixel = 0
    self.Content.ScrollBarThickness = 7
    self.Content.ScrollBarImageColor3 = Theme.Primary
    self.Content.CanvasSize = UDim2.new(0,0,0,0)
    self.Content.Parent = self.Frame
    self.Content.ZIndex = 15

    self.Layout = Instance.new("UIListLayout", self.Content)
    self.Layout.Padding = UDim.new(0, 15)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder

    self:_drag()
    Tween(self.Frame, {BackgroundTransparency = 0.08}, 0.15)
    self.Frame.Visible = true
    return self
end

function CopilotUI:Button(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = color or Theme.Primary
    btn.Text = text or "Button"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 17
    btn.BorderSizePixel = 0
    btn.Parent = self.Content
    btn.ZIndex = 20
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)
    Shadow(btn)
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundTransparency = 0.15}, 0.11) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundTransparency = 0}, 0.11) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function CopilotUI:Label(text, size)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, size or 30)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or "Label"
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 16
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = self.Content
    lbl.ZIndex = 18
    return lbl
end

function CopilotUI:Section(title)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(1, 0, 0, 35)
    sec.BackgroundTransparency = 1
    sec.Parent = self.Content
    sec.ZIndex = 17
    local secTitle = Instance.new("TextLabel", sec)
    secTitle.Size = UDim2.new(1, 0, 1, 0)
    secTitle.BackgroundTransparency = 1
    secTitle.Text = title or "Section"
    secTitle.TextColor3 = Theme.Accent
    secTitle.TextSize = 18
    secTitle.Font = Enum.Font.GothamBold
    secTitle.TextXAlignment = Enum.TextXAlignment.Left
    secTitle.ZIndex = 18
    return sec
end

function CopilotUI:Separator()
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 2)
    sep.BackgroundColor3 = Theme.Border
    sep.BorderSizePixel = 0
    sep.Parent = self.Content
    sep.ZIndex = 16
    return sep
end

function CopilotUI:Toggle(text, default, callback)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 44)
    box.BackgroundColor3 = Theme.Surface
    box.BorderSizePixel = 0
    box.Parent = self.Content
    box.ZIndex = 19
    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", box)
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or "Toggle"
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 16
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 20

    local toggle = Instance.new("TextButton", box)
    toggle.Size = UDim2.new(0, 38, 0, 22)
    toggle.Position = UDim2.new(1, -54, 0.5, -11)
    toggle.BackgroundColor3 = default and Theme.Accent or Theme.Border
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.ZIndex = 21
    local toggleCorner = Instance.new("UICorner", toggle)
    toggleCorner.CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", toggle)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 22
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    local state = default or false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        Tween(knob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.16)
        Tween(toggle, {BackgroundColor3 = state and Theme.Accent or Theme.Border}, 0.16)
        if callback then callback(state) end
    end)
    return box, function() return state end
end

function CopilotUI:Input(text, placeholder, callback)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 62)
    box.BackgroundColor3 = Theme.Surface
    box.BorderSizePixel = 0
    box.Parent = self.Content
    box.ZIndex = 19
    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", box)
    lbl.Size = UDim2.new(1, -20, 0, 22)
    lbl.Position = UDim2.new(0, 10, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or "Input"
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 16
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox", box)
    input.Size = UDim2.new(1, -20, 0, 32)
    input.Position = UDim2.new(0, 10, 0, 28)
    input.BackgroundColor3 = Theme.Background
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = placeholder or "Type here..."
    input.TextColor3 = Theme.Text
    input.PlaceholderColor3 = Theme.TextSecondary
    input.TextSize = 16
    input.Font = Enum.Font.Gotham
    input.TextXAlignment = Enum.TextXAlignment.Left
    local inputCorner = Instance.new("UICorner", input)
    inputCorner.CornerRadius = UDim.new(0, 8)
    input.FocusLost:Connect(function(enterPressed)
        if callback and enterPressed then callback(input.Text) end
    end)
    return input
end

function CopilotUI:Dropdown(text, options, callback)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 44)
    box.BackgroundColor3 = Theme.Surface
    box.BorderSizePixel = 0
    box.Parent = self.Content
    box.ZIndex = 19
    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", box)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or "Dropdown"
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 16
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local drop = Instance.new("TextButton", box)
    drop.Size = UDim2.new(0.5, -20, 0, 32)
    drop.Position = UDim2.new(0.5, 0, 0.5, -16)
    drop.BackgroundColor3 = Theme.Background
    drop.BorderSizePixel = 0
    drop.Text = options[1] or "Select..."
    drop.TextColor3 = Theme.Text
    drop.TextSize = 16
    drop.Font = Enum.Font.Gotham

    local dropCorner = Instance.new("UICorner", drop)
    dropCorner.CornerRadius = UDim.new(0, 8)

    local arrow = Instance.new("TextLabel", drop)
    arrow.Size = UDim2.new(0, 22, 1, 0)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.TextSecondary
    arrow.TextSize = 15
    arrow.Font = Enum.Font.Gotham

    local optsFrame = Instance.new("Frame", drop)
    optsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    optsFrame.Position = UDim2.new(0, 0, 1, 4)
    optsFrame.BackgroundColor3 = Theme.Background
    optsFrame.BorderSizePixel = 0
    optsFrame.Visible = false
    optsFrame.ZIndex = 30
    local optsCorner = Instance.new("UICorner", optsFrame)
    optsCorner.CornerRadius = UDim.new(0, 8)
    local optsLayout = Instance.new("UIListLayout", optsFrame)
    optsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton", optsFrame)
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundColor3 = Theme.Background
        optBtn.BorderSizePixel = 0
        optBtn.Text = opt
        optBtn.TextColor3 = Theme.Text
        optBtn.TextSize = 16
        optBtn.Font = Enum.Font.Gotham
        optBtn.MouseEnter:Connect(function()
            Tween(optBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255,255,255)}, 0.12)
        end)
        optBtn.MouseLeave:Connect(function()
            Tween(optBtn, {BackgroundColor3 = Theme.Background, TextColor3 = Theme.Text}, 0.12)
        end)
        optBtn.MouseButton1Click:Connect(function()
            drop.Text = opt
            optsFrame.Visible = false
            arrow.Text = "▼"
            if callback then callback(opt, i) end
        end)
    end

    drop.MouseButton1Click:Connect(function()
        optsFrame.Visible = not optsFrame.Visible
        arrow.Text = optsFrame.Visible and "▲" or "▼"
        if optsFrame.Visible then
            box.Size = UDim2.new(1, 0, 0, 44 + #options * 30 + 8)
        else
            box.Size = UDim2.new(1, 0, 0, 44)
        end
    end)
    return drop
end

function CopilotUI:Notify(title, text, duration, type)
    local gui = Instance.new("ScreenGui")
    gui.Name = "CopilotNotify"
    gui.ResetOnSpawn = false
    pcall(function() gui.Parent = gethui and gethui() or game:GetService("CoreGui") end)

    local note = Instance.new("Frame")
    note.Size = UDim2.new(0, 320, 0, 86)
    note.Position = UDim2.new(1, 24, 0, 60)
    note.BackgroundColor3 = Theme.Surface
    note.BorderSizePixel = 0
    note.Parent = gui
    local noteCorner = Instance.new("UICorner", note)
    noteCorner.CornerRadius = UDim.new(0, 12)

    local colors = {
        info = Theme.Primary,
        success = Theme.Success,
        error = Theme.Error
    }
    local indicator = Instance.new("Frame", note)
    indicator.Size = UDim2.new(0, 6, 1, 0)
    indicator.Position = UDim2.new(0,0,0,0)
    indicator.BackgroundColor3 = colors[type] or Theme.Primary
    indicator.BorderSizePixel = 0
    local indicatorCorner = Instance.new("UICorner", indicator)
    indicatorCorner.CornerRadius = UDim.new(0, 12)

    local titleLabel = Instance.new("TextLabel", note)
    titleLabel.Size = UDim2.new(1, -60, 0, 30)
    titleLabel.Position = UDim2.new(0, 18, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local textLabel = Instance.new("TextLabel", note)
    textLabel.Size = UDim2.new(1, -60, 0, 36)
    textLabel.Position = UDim2.new(0, 18, 0, 38)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or "Notification text"
    textLabel.TextColor3 = Theme.TextSecondary
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true

    local closeBtn = Instance.new("TextButton", note)
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -34, 0, 14)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.TextSecondary
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.MouseButton1Click:Connect(function()
        Tween(note, {Position = UDim2.new(1, 24, 0, 60)}, 0.18)
        wait(0.18)
        gui:Destroy()
    end)
    Tween(note, {Position = UDim2.new(1, -344, 0, 60)}, 0.28)
    if duration then spawn(function() wait(duration) gui:Destroy() end) end
    return note
end

function CopilotUI:Destroy()
    if self.Gui then self.Gui:Destroy() end
end

return CopilotUI
