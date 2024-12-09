-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player Reference
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local dragging = false
local dragInput, dragStart, startPos

-- GUI Creation
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
closeButton.Text = "❌"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 1
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -70, 0, 0)
minimizeButton.Text = "🔶"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Parent = titleBar

local contentVisible = true
minimizeButton.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    for _, child in pairs(mainFrame:GetChildren()) do
        if child ~= titleBar then
            child.Visible = contentVisible
        end
    end
    mainFrame.Size = contentVisible and UDim2.new(0, 400, 0, 300) or UDim2.new(0, 400, 0, 30)
end)

-- Draggable Functionality
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Scrolling Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.ScrollBarThickness = 10
scrollFrame.BackgroundTransparency = 1
scrollFrame.Parent = mainFrame

-- Functions for Input and Toggles
local function createInput(title, position, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = scrollFrame

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

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local value = tonumber(textBox.Text)
            if value then
                callback(value)
            end
        end
    end)
end

-- Walk Speed Input
createInput("Walk Speed (0-500):", UDim2.new(0, 10, 0, 10), function(value)
    if value >= 0 and value <= 500 then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Jump Boost Input
createInput("Jump Boost (0-500):", UDim2.new(0, 10, 0, 60), function(value)
    if value >= 0 and value <= 500 then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- Function to Create Toggles
local function createToggle(title, position, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = scrollFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = title
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -10, 1, 0)
    button.Position = UDim2.new(0.5, 5, 0, 0)
    button.Text = "Off"
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(75, 112, 245)
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        local newState = button.Text == "Off"
        button.Text = newState and "On" or "Off"
        callback(newState)
    end)
end

-- Float Toggle
local floatEnabled = false
createToggle("Float:", UDim2.new(0, 10, 0, 110), function(state)
    floatEnabled = state
    if floatEnabled then
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
        bodyPosition.Position = player.Character.HumanoidRootPart.Position
        bodyPosition.Parent = player.Character.HumanoidRootPart

        -- Keep updating the position to hover
        RunService.RenderStepped:Connect(function()
            if not floatEnabled then return end
            bodyPosition.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
        end)
    else
        for _, bp in pairs(player.Character.HumanoidRootPart:GetChildren()) do
            if bp:IsA("BodyPosition") then
                bp:Destroy()
            end
        end
    end
end)

-- No Clip Toggle
local noClipEnabled = false
createToggle("No Clip:", UDim2.new(0, 10, 0, 160), function(state)
    noClipEnabled = state
end)

RunService.Stepped:Connect(function()
    if noClipEnabled then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Fling Toggle
local flingEnabled = false
createToggle("Fling:", UDim2.new(0, 10, 0, 210), function(state)
    flingEnabled = state
    if flingEnabled then
        player.Character.HumanoidRootPart.Velocity = Vector3.new(1000, 0, 0)
    end
end)

-- Teleport Dropdown
local selectedPlayer
local function createDropdown(title, position, playersCallback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = scrollFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Text = title
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0.5, -10, 1, 0)
    dropdown.Position = UDim2.new(0.5, 5, 0, 0)
    dropdown.Text = "Select Player"
    dropdown.Font = Enum.Font.SourceSansBold
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.BackgroundColor3 = Color3.fromRGB(75, 112, 245)
    dropdown.Parent = frame

    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0.5, -10, 0, 100)
    menu.Position = UDim2.new(0.5, 5, 1, 0)
    menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    menu.BorderColor3 = Color3.fromRGB(75, 112, 245)
    menu.Visible = false
    menu.Parent = frame

    dropdown.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
        menu:ClearAllChildren()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local item = Instance.new("TextButton")
                item.Size = UDim2.new(1, 0, 0, 20)
                item.Text = p.Name
                item.Font = Enum.Font.SourceSans
                item.TextColor3 = Color3.fromRGB(255, 255, 255)
                item.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                item.Parent = menu

                item.MouseButton1Click:Connect(function()
                    dropdown.Text = p.Name
                    menu.Visible = false
                    playersCallback(p)
                end)
            end
        end
    end)
end

createDropdown("Teleport Player:", UDim2.new(0, 10, 0, 260), function(p)
    selectedPlayer = p
end)

-- Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 0, 310)
teleportButton.Text = "Teleport"
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.BackgroundColor3 = Color3.fromRGB(75, 112, 245)
teleportButton.Parent = scrollFrame

teleportButton.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        player.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- Function to Create Copy Buttons
local function createCopyButton(title, position, link)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = position
    button.Text = title
    button.Font = Enum.Font.SourceSansBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(75, 112, 245)
    button.Parent = scrollFrame

    button.MouseButton1Click:Connect(function()
        setclipboard(link) -- Copies the link to the clipboard
        button.Text = "Copied!"
        wait(1)
        button.Text = title
    end)
end

-- Discord Server Button
createCopyButton("Discord Server: Click to Copy", UDim2.new(0, 10, 0, 360), "https://discord.gg/ppPT3MvgCk")

-- YouTube Account Button
createCopyButton("YouTube Account: Click to Copy", UDim2.new(0, 10, 0, 410), "https://youtube.com/@BlueModsYT")

-- Official Website Button
createCopyButton("Official Website: Click to Copy", UDim2.new(0, 10, 0, 460), "https://bluemods.neocities.org")
