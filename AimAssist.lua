-- Precise Aimbot with Camera Control - Solara
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings
local enabled = false
local connection = nil
local fov = 150 -- Field of view for targeting
local smoothness = 0.15 -- Lower = smoother, higher = snappier
local currentTarget = nil
local lockOnDistance = 200 -- Distance to lock onto target
local aimOffset = Vector3.new(0, 0.5, 0) -- Slight offset for headshots

-- Get the closest player to crosshair
local function getClosestToCrosshair()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local screenPosition, onScreen = Camera:WorldToScreenPoint(head.Position)
                
                if onScreen then
                    local distance2D = (screenCenter - Vector2.new(screenPosition.X, screenPosition.Y)).Magnitude
                    local distance3D = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                    
                    -- Check if target is within FOV and reasonable 3D distance
                    if distance2D < fov and distance3D < lockOnDistance and distance2D < shortestDistance then
                        -- Check if we have line of sight
                        local ray = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * distance3D)
                        if not ray or ray.Instance:IsDescendantOf(character) then
                            closestPlayer = player
                            shortestDistance = distance2D
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Smooth aim function
local function aimAtTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        currentTarget = nil
        return
    end
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    
    if head and humanoid and humanoid.Health > 0 then
        currentTarget = targetPlayer
        
        -- Calculate target position with offset for headshots
        local targetPosition = head.Position + aimOffset
        local currentCameraPosition = Camera.CFrame.Position
        
        -- Calculate direction to target
        local direction = (targetPosition - currentCameraPosition).Unit
        
        -- Create target CFrame
        local targetCFrame = CFrame.lookAt(currentCameraPosition, currentCameraPosition + direction)
        
        -- Smooth camera movement
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
        
        -- Reduce weapon sway by stabilizing camera
        local stabilizer = Camera.CFrame * CFrame.Angles(0, 0, 0)
        Camera.CFrame = stabilizer
        
        return true
    else
        currentTarget = nil
        return false
    end
end

-- Main aimbot loop
local function aimbotLoop()
    if not enabled then return end
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    -- If we have a current target, check if it's still valid
    if currentTarget then
        local head = currentTarget.Character and currentTarget.Character:FindFirstChild("Head")
        local humanoid = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
        
        if head and humanoid and humanoid.Health > 0 then
            local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local distanceFromCenter = (screenCenter - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
            
            -- Keep aiming at current target if still in FOV
            if onScreen and distanceFromCenter < fov * 1.5 then
                aimAtTarget(currentTarget)
                return
            end
        end
        
        -- Target is no longer valid, clear it
        currentTarget = nil
    end
    
    -- Find new target
    local newTarget = getClosestToCrosshair()
    if newTarget then
        aimAtTarget(newTarget)
    end
end

-- Start aimbot
local function startAimbot()
    if connection then
        connection:Disconnect()
    end
    
    connection = RunService.Heartbeat:Connect(aimbotLoop)
    print("🎯 Aimbot activated")
end

-- Stop aimbot
local function stopAimbot()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    currentTarget = nil
    print("❌ Aimbot deactivated")
end

-- Toggle function
local function toggleAimbot()
    enabled = not enabled
    
    if enabled then
        startAimbot()
        print("🟢 Precise Aimbot: ON")
    else
        stopAimbot()
        print("🔴 Precise Aimbot: OFF")
    end
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        toggleAimbot()
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        -- Hold Ctrl for temporary aim
        if not enabled then
            enabled = true
            startAimbot()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        -- Release Ctrl to stop temporary aim
        if enabled then
            enabled = false
            stopAimbot()
        end
    end
end)

-- Mouse targeting (right click to lock onto nearest target)
Mouse.Button2Down:Connect(function()
    if not enabled then return end
    
    local target = getClosestToCrosshair()
    if target then
        currentTarget = target
        print("🔒 Locked onto: " .. target.Name)
    end
end)

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
    if currentTarget == player then
        currentTarget = nil
    end
end)

-- Settings adjustment (optional)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Equal then -- Plus key
        fov = math.min(fov + 10, 300)
        print("FOV: " .. fov)
    elseif input.KeyCode == Enum.KeyCode.Minus then
        fov = math.max(fov - 10, 50)
        print("FOV: " .. fov)
    elseif input.KeyCode == Enum.KeyCode.RightBracket then -- ]
        smoothness = math.min(smoothness + 0.05, 1)
        print("Smoothness: " .. smoothness)
    elseif input.KeyCode == Enum.KeyCode.LeftBracket then -- [
        smoothness = math.max(smoothness - 0.05, 0.01)
        print("Smoothness: " .. smoothness)
    end
end)

print("🎯 Precise Aimbot Loaded Successfully!")
print("⌨️  Controls:")
print("   T = Toggle On/Off")
print("   Hold Ctrl = Temporary Aim")
print("   Right Click = Lock Target")
print("   +/- = Adjust FOV")
print("   [/] = Adjust Smoothness")
print("🎮 Current Settings:")
print("   FOV: " .. fov)
print("   Smoothness: " .. smoothness)
