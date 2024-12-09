local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI Elements
local gui = Instance.new("ScreenGui")
gui.Name = "BlueModsGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- Cyan border
frame.BorderSizePixel = 2
frame.Parent = gui

-- Enable dragging functionality
local isDragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.Heartbeat:Connect(function()
    if isDragging and dragInput then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Title with Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.Image = "https://bluemods.neocities.org/p/ic_blue.png"
logo.BackgroundTransparency = 1
logo.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "BlueMods"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Position = UDim2.new(0, 70, 0, 10)
title.Size = UDim2.new(0, 200, 0, 50)
title.BackgroundTransparency = 1
title.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundTransparency = 0.5
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Walk Speed Slider
local walkSpeedSlider = Instance.new("TextBox")
walkSpeedSlider.PlaceholderText = "Walk Speed (0-100)"
walkSpeedSlider.Size = UDim2.new(0, 260, 0, 40)
walkSpeedSlider.Position = UDim2.new(0, 20, 0, 80)
walkSpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
walkSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedSlider.Font = Enum.Font.SourceSans
walkSpeedSlider.TextSize = 18
walkSpeedSlider.Parent = frame

walkSpeedSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local speed = tonumber(walkSpeedSlider.Text)
        if speed and speed >= 0 and speed <= 100 then
            humanoid.WalkSpeed = speed
        else
            walkSpeedSlider.Text = "Invalid Value"
        end
    end
end)

-- Jump Power Slider
local jumpPowerSlider = Instance.new("TextBox")
jumpPowerSlider.PlaceholderText = "Jump Power (0-100)"
jumpPowerSlider.Size = UDim2.new(0, 260, 0, 40)
jumpPowerSlider.Position = UDim2.new(0, 20, 0, 140)
jumpPowerSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jumpPowerSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpPowerSlider.Font = Enum.Font.SourceSans
jumpPowerSlider.TextSize = 18
jumpPowerSlider.Parent = frame

jumpPowerSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local power = tonumber(jumpPowerSlider.Text)
        if power and power >= 0 and power <= 100 then
            humanoid.JumpPower = power
        else
            jumpPowerSlider.Text = "Invalid Value"
        end
    end
end)

-- Levitation Toggle
local levitationToggle = Instance.new("TextButton")
levitationToggle.Text = "Levitation: OFF"
levitationToggle.Size = UDim2.new(0, 260, 0, 40)
levitationToggle.Position = UDim2.new(0, 20, 0, 200)
levitationToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
levitationToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
levitationToggle.Font = Enum.Font.SourceSans
levitationToggle.TextSize = 18
levitationToggle.Parent = frame

local isLevitating = false
levitationToggle.MouseButton1Click:Connect(function()
    isLevitating = not isLevitating
    levitationToggle.Text = "Levitation: " .. (isLevitating and "ON" or "OFF")
    if isLevitating then
        RunService.RenderStepped:Connect(function()
            if isLevitating then
                character:TranslateBy(Vector3.new(0, 0.5, 0))
            end
        end)
    end
end)

-- No Clip Toggle
local noClipToggle = Instance.new("TextButton")
noClipToggle.Text = "No Clip: OFF"
noClipToggle.Size = UDim2.new(0, 260, 0, 40)
noClipToggle.Position = UDim2.new(0, 20, 0, 260)
noClipToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noClipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noClipToggle.Font = Enum.Font.SourceSans
noClipToggle.TextSize = 18
noClipToggle.Parent = frame

local isNoClip = false
noClipToggle.MouseButton1Click:Connect(function()
    isNoClip = not isNoClip
    noClipToggle.Text = "No Clip: " .. (isNoClip and "ON" or "OFF")
    if isNoClip then
        RunService.Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)
