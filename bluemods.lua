-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Player Reference
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local guiDragging = false
local dragInput, startPos, startOffset

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlueModsGUI"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderColor3 = Color3.fromRGB(75, 112, 245)
mainFrame.Parent = screenGui

-- Draggable TitleBar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 24, 0, 24)
logo.Position = UDim2.new(0, 3, 0.5, -12)
logo.Image = "https://bluemods.neocities.org/p/ic_blue.png"
logo.BackgroundTransparency = 1
logo.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 30, 0, 0)
titleLabel.Text = "BlueMods"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Text = "❎"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 1
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Add Buttons and Inputs
local function createTextInput(title, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = mainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = title
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.5, -10, 1, 0)
    textBox.Position = UDim2.new(0.5, 5, 0, 0)
    textBox.Text = "0"
    textBox.Font = Enum.Font.SourceSans
    textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Parent = frame

    return textBox
end

local walkSpeedInput = createTextInput("Walk Speed (0-500):", UDim2.new(0, 10, 0, 40))
local jumpBoostInput = createTextInput("Jump Boost (0-500):", UDim2.new(0, 10, 0, 90))

-- Drag Functionality
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        guiDragging = true
        startPos = input.Position
        startOffset = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        guiDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if guiDragging and input == dragInput then
        local delta = input.Position - startPos
        mainFrame.Position = UDim2.new(
            startOffset.X.Scale,
            startOffset.X.Offset + delta.X,
            startOffset.Y.Scale,
            startOffset.Y.Offset + delta.Y
        )
    end
end)

-- Functionality (Walk Speed and Jump Boost)
walkSpeedInput.FocusLost:Connect(function()
    local speed = tonumber(walkSpeedInput.Text)
    if speed and speed >= 0 and speed <= 500 then
        player.Character.Humanoid.WalkSpeed = speed
    else
        walkSpeedInput.Text = tostring(player.Character.Humanoid.WalkSpeed)
    end
end)

jumpBoostInput.FocusLost:Connect(function()
    local jump = tonumber(jumpBoostInput.Text)
    if jump and jump >= 0 and jump <= 500 then
        player.Character.Humanoid.JumpPower = jump
    else
        jumpBoostInput.Text = tostring(player.Character.Humanoid.JumpPower)
    end
end)
