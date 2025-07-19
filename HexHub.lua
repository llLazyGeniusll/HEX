local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Main container
function UI:Create()
    local sg = Instance.new("ScreenGui")
    sg.Name = "MinimalUI"
    sg.Parent = game.CoreGui
    sg.ResetOnSpawn = false
    return sg
end

-- Window component
function UI:Window(parent, title, size)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local titlebar = Instance.new("Frame")
    titlebar.Size = UDim2.new(1, 0, 0, 30)
    titlebar.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    titlebar.BorderSizePixel = 0
    titlebar.Parent = frame
    
    local titlecorner = corner:Clone()
    titlecorner.Parent = titlebar
    
    local titlelabel = Instance.new("TextLabel")
    titlelabel.Size = UDim2.new(1, -10, 1, 0)
    titlelabel.Position = UDim2.new(0, 10, 0, 0)
    titlelabel.BackgroundTransparency = 1
    titlelabel.Text = title or "Window"
    titlelabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    titlelabel.TextScaled = true
    titlelabel.Font = Enum.Font.GothamMedium
    titlelabel.TextXAlignment = Enum.TextXAlignment.Left
    titlelabel.Parent = titlebar
    
    -- Dragging
    local dragging, dragStart, startPos
    titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return frame
end

-- Button component
function UI:Button(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BorderSizePixel = 0
    btn.Text = text or "Button"
    btn.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(callback or function() end)
    return btn
end

-- Toggle component
function UI:Toggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 25)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Toggle"
    label.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -40, 0.5, -10)
    toggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    local togglecorner = Instance.new("UICorner")
    togglecorner.CornerRadius = UDim.new(0, 10)
    togglecorner.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0, 2)
    knob.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    
    local knobcorner = Instance.new("UICorner")
    knobcorner.CornerRadius = UDim.new(0, 8)
    knobcorner.Parent = knob
    
    local enabled = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = toggle
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        local color = enabled and Color3.new(0.2, 0.7, 0.2) or Color3.new(0.3, 0.3, 0.3)
        local pos = enabled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
        
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = pos}):Play()
        
        if callback then callback(enabled) end
    end)
    
    return frame
end

-- Textbox component
function UI:Textbox(parent, placeholder)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 150, 0, 25)
    box.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholder or "Enter text..."
    box.Text = ""
    box.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    box.PlaceholderColor3 = Color3.new(0.6, 0.6, 0.6)
    box.TextScaled = true
    box.Font = Enum.Font.Gotham
    box.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = box
    
    return box
end

-- Layout helper
function UI:Layout(parent, direction)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = direction == "horizontal" and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 5)
    layout.Parent = parent
    return layout
end

return UI
