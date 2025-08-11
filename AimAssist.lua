-- Fixed Aim Assist Script - Choose the version that works for you

-- VERSION 1: Basic Version (Most Compatible)
--[[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local enabled = false
local fov = 100
local smoothness = 0.2
local connection

-- Simple GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -10, 0, 40)
ToggleButton.Position = UDim2.new(0, 5, 0, 5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "Aim Assist: OFF"
ToggleButton.TextColor3 = Color3.white
ToggleButton.TextScaled = true
ToggleButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 0, 30)
StatusLabel.Position = UDim2.new(0, 5, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Press to toggle"
StatusLabel.TextColor3 = Color3.white
StatusLabel.TextScaled = true
StatusLabel.Parent = Frame

-- Get closest player
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
            
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < fov and distance < shortestDistance then
                    closest = player
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closest
end

-- Aim assist function
local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local targetPosition = target.Character.Head.Position
        local cameraPosition = Camera.CFrame.Position
        local direction = (targetPosition - cameraPosition).Unit
        
        local targetCFrame = CFrame.lookAt(cameraPosition, cameraPosition + direction)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
    end
end

-- Toggle function
ToggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    
    if enabled then
        ToggleButton.Text = "Aim Assist: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StatusLabel.Text = "Active"
        
        connection = RunService.Heartbeat:Connect(function()
            if enabled then
                local target = getClosestPlayer()
                if target then
                    aimAt(target)
                end
            end
        end)
    else
        ToggleButton.Text = "Aim Assist: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "Inactive"
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

-- Cleanup
game.Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        if connection then
            connection:Disconnect()
        end
    end
end)

print("Aim Assist loaded successfully!")
--]]

-- VERSION 2: Enhanced Version with Error Handling
local success, error_msg = pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    
    -- Wait for character
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    
    local Mouse = LocalPlayer:GetMouse()
    local enabled = false
    local fov = 80
    local smoothness = 0.15
    local connection
    local fovCircle
    
    -- Create FOV Circle (if Drawing is supported)
    if Drawing then
        fovCircle = Drawing.new("Circle")
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Thickness = 2
        fovCircle.Transparency = 0.8
        fovCircle.Filled = false
        fovCircle.Radius = fov
        fovCircle.Visible = false
    end
    
    -- Enhanced GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EnhancedAimGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 180)
    MainFrame.Position = UDim2.new(0, 50, 0, 50)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Add corner radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.Text = "🎯 Enhanced Aim Assist"
    Title.TextColor3 = Color3.white
    Title.TextScaled = true
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title
    
    -- Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -20, 0, 35)
    ToggleButton.Position = UDim2.new(0, 10, 0, 40)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    ToggleButton.Text = "🔴 Disabled"
    ToggleButton.TextColor3 = Color3.white
    ToggleButton.TextScaled = true
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.Parent = MainFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleButton
    
    -- FOV Label
    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Size = UDim2.new(1, -20, 0, 25)
    FOVLabel.Position = UDim2.new(0, 10, 0, 85)
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.Text = "FOV: " .. fov
    FOVLabel.TextColor3 = Color3.white
    FOVLabel.TextScaled = true
    FOVLabel.Parent = MainFrame
    
    -- Smoothness Label
    local SmoothLabel = Instance.new("TextLabel")
    SmoothLabel.Size = UDim2.new(1, -20, 0, 25)
    SmoothLabel.Position = UDim2.new(0, 10, 0, 115)
    SmoothLabel.BackgroundTransparency = 1
    SmoothLabel.Text = "Smoothness: " .. smoothness
    SmoothLabel.TextColor3 = Color3.white
    SmoothLabel.TextScaled = true
    SmoothLabel.Parent = MainFrame
    
    -- Status
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 20)
    StatusLabel.Position = UDim2.new(0, 10, 0, 145)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Ready"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame
    
    -- Get closest player function
    local function getClosestPlayer()
        local closest = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local head = character:FindFirstChild("Head")
                
                if humanoidRootPart and head then
                    -- Check if player is alive
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                        
                        if onScreen then
                            local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            if distance < fov and distance < shortestDistance then
                                -- Simple wall check
                                local ray = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * (head.Position - Camera.CFrame.Position).Magnitude)
                                if not ray or ray.Instance:IsDescendantOf(character) then
                                    closest = player
                                    shortestDistance = distance
                                end
                            end
                        end
                    end
                end
            end
        end
        
        return closest
    end
    
    -- Aim function
    local function aimAtPlayer(target)
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPosition = target.Character.Head.Position
            local cameraPosition = Camera.CFrame.Position
            local direction = (targetPosition - cameraPosition).Unit
            
            local targetCFrame = CFrame.lookAt(cameraPosition, cameraPosition + direction)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
        end
    end
    
    -- Toggle functionality
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        if enabled then
            ToggleButton.Text = "🟢 Enabled"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            StatusLabel.Text = "Status: Active"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            if fovCircle then
                fovCircle.Visible = true
            end
            
            connection = RunService.Heartbeat:Connect(function()
                if enabled then
                    local target = getClosestPlayer()
                    if target then
                        aimAtPlayer(target)
                        StatusLabel.Text = "Status: Targeting " .. target.Name
                    else
                        StatusLabel.Text = "Status: Searching..."
                    end
                end
            end)
        else
            ToggleButton.Text = "🔴 Disabled"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            StatusLabel.Text = "Status: Inactive"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            if fovCircle then
                fovCircle.Visible = false
            end
            
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
    
    -- Update FOV circle position
    if fovCircle then
        RunService.Heartbeat:Connect(function()
            if fovCircle then
                fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
                fovCircle.Radius = fov
            end
        end)
    end
    
    -- Keybind (Toggle with T key)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.T then
            ToggleButton.MouseButton1Click:Fire()
        end
    end)
    
    -- Make GUI draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    Title.InputBegan:Connect(function(input)
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
    
    -- Cleanup
    game.Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            if connection then
                connection:Disconnect()
            end
            if fovCircle then
                fovCircle:Remove()
            end
        end
    end)
    
    -- Success notification
    if game:GetService("StarterGui") then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Aim Assist";
            Text = "Loaded successfully! Press T to toggle.";
            Duration = 5;
        })
    end
    
    print("✅ Enhanced Aim Assist loaded successfully!")
    print("🎯 Press T to toggle or use the GUI button")
    print("🔧 Features: Auto-aim, FOV circle, Wall check")
end)

if not success then
    warn("❌ Error loading Aim Assist: " .. tostring(error_msg))
    print("💡 Try using Version 1 (uncomment the first version)")
end
