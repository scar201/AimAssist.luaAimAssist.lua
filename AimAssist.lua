-- Simple Working Aimbot - Copy and paste this entire code

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings
local enabled = false
local connection = nil
local fov = 100
local smoothness = 0.2

-- Wait for character
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

wait(1) -- Wait a bit more

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotGUI"
screenGui.Parent = LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -10, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🎯 Aim Bot"
titleText.TextColor3 = Color3.white
titleText.TextScaled = true
titleText.Font = Enum.Font.SourceSansBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 250, 0, 45)
toggleButton.Position = UDim2.new(0, 25, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "🔴 Aim Bot: OFF"
toggleButton.TextColor3 = Color3.white
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 110)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready to use"
statusLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = mainFrame

-- FOV Label
local fovLabel = Instance.new("TextLabel")
fovLabel.Name = "FOVLabel"
fovLabel.Size = UDim2.new(1, -20, 0, 25)
fovLabel.Position = UDim2.new(0, 10, 0, 145)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. fov .. " | Smoothness: " .. smoothness
fovLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
fovLabel.TextScaled = true
fovLabel.Font = Enum.Font.SourceSans
fovLabel.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.white
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Functions
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local screenPosition, onScreen = Camera:WorldToScreenPoint(head.Position)
                
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                    
                    if distance < fov and distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAtPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local head = targetPlayer.Character:FindFirstChild("Head")
        if head then
            local targetPosition = head.Position
            local cameraPosition = Camera.CFrame.Position
            local direction = (targetPosition - cameraPosition).Unit
            
            local targetCFrame = CFrame.lookAt(cameraPosition, cameraPosition + direction)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
        end
    end
end

local function startAimbot()
    if connection then
        connection:Disconnect()
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if enabled then
            local target = getClosestPlayer()
            if target then
                aimAtPlayer(target)
                statusLabel.Text = "Status: Targeting → " .. target.Name
                statusLabel.TextColor3 = Color3.fromRGB(40, 167, 69)
            else
                statusLabel.Text = "Status: Searching for targets..."
                statusLabel.TextColor3 = Color3.fromRGB(255, 193, 7)
            end
        end
    end)
end

local function stopAimbot()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    statusLabel.Text = "Status: Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(108, 117, 125)
end

-- Events
toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    
    if enabled then
        toggleButton.Text = "🟢 Aim Bot: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
        startAimbot()
    else
        toggleButton.Text = "🔴 Aim Bot: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        stopAimbot()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    enabled = false
    stopAimbot()
    screenGui:Destroy()
end)

-- Keybind (Press T to toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.T then
        toggleButton.MouseButton1Click:Fire()
    end
end)

-- Cleanup when player leaves
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        stopAimbot()
    end
end)

-- Success message
print("✅ Aimbot loaded successfully!")
print("🎯 Click the button or press 'T' to toggle")
print("🖱️ You can drag the GUI window around")

-- Show notification if possible
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Aimbot Ready!";
        Text = "Press T to toggle or use the GUI";
        Duration = 4;
    })
end)
