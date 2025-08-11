-- Simple Aimbot for Solara
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Settings
local enabled = false
local fov = 200
local connection = nil

-- Simple function to get closest enemy
local function getClosest()
    local closest = nil
    local shortestDistance = math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos = Camera:WorldToScreenPoint(v.Character.Head.Position)
            local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            
            if distance < fov and distance < shortestDistance then
                closest = v
                shortestDistance = distance
            end
        end
    end
    
    return closest
end

-- Aimbot function
local function aimbot()
    if enabled then
        local target = getClosest()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end

-- Toggle with T key
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        enabled = not enabled
        
        if enabled then
            print("🟢 Aimbot ON")
            connection = RunService.Heartbeat:Connect(aimbot)
        else
            print("🔴 Aimbot OFF")
            if connection then
                connection:Disconnect()
            end
        end
    end
end)

print("✅ Simple Aimbot Loaded!")
print("🎯 Press T to toggle ON/OFF")
