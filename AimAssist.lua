-- Compact Aim Assist Script
local P,U,R,C = game:GetService("Players"),game:GetService("UserInputService"),game:GetService("RunService"),workspace.CurrentCamera
local L,M = P.LocalPlayer,L:GetMouse()
local S = {E=false,F=80,Sm=0.3,T="Head",SF=true,TC=true}
local G,T,Con,FOV

-- Create GUI
local function CG()
    local sg = Instance.new("ScreenGui") sg.Name="AimGUI" sg.Parent=L:WaitForChild("PlayerGui") sg.ResetOnSpawn=false
    local mf = Instance.new("Frame") mf.Size=UDim2.new(0,250,0,200) mf.Position=UDim2.new(0,50,0,50) mf.BackgroundColor3=Color3.fromRGB(30,30,30) mf.Parent=sg
    local c = Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=mf
    
    local tb = Instance.new("Frame") tb.Size=UDim2.new(1,0,0,25) tb.BackgroundColor3=Color3.fromRGB(50,50,50) tb.Parent=mf
    local tc = Instance.new("UICorner") tc.CornerRadius=UDim.new(0,8) tc.Parent=tb
    local tl = Instance.new("TextLabel") tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Text="🎯 Aim Assist" tl.TextColor3=Color3.white tl.TextScaled=true tl.Font=Enum.Font.SourceSansBold tl.Parent=tb
    
    local et = Instance.new("TextButton") et.Size=UDim2.new(1,-20,0,35) et.Position=UDim2.new(0,10,0,35) et.BackgroundColor3=Color3.fromRGB(120,50,50) et.Text="🔴 OFF" et.TextColor3=Color3.white et.TextScaled=true et.Font=Enum.Font.SourceSansBold et.Parent=mf
    local ec = Instance.new("UICorner") ec.CornerRadius=UDim.new(0,6) ec.Parent=et
    
    local fl = Instance.new("TextLabel") fl.Size=UDim2.new(1,-20,0,20) fl.Position=UDim2.new(0,10,0,80) fl.BackgroundTransparency=1 fl.Text="FOV: "..S.F fl.TextColor3=Color3.white fl.TextScaled=true fl.Parent=mf
    local fs = Instance.new("Frame") fs.Size=UDim2.new(1,-20,0,15) fs.Position=UDim2.new(0,10,0,100) fs.BackgroundColor3=Color3.fromRGB(60,60,60) fs.Parent=mf
    local fsc = Instance.new("UICorner") fsc.CornerRadius=UDim.new(0,8) fsc.Parent=fs
    local fh = Instance.new("TextButton") fh.Size=UDim2.new(0,15,1,0) fh.Position=UDim2.new(S.F/200,-7,0,0) fh.BackgroundColor3=Color3.fromRGB(100,150,255) fh.Text="" fh.Parent=fs
    local fhc = Instance.new("UICorner") fhc.CornerRadius=UDim.new(1,0) fhc.Parent=fh
    
    local sl = Instance.new("TextLabel") sl.Size=UDim2.new(1,-20,0,20) sl.Position=UDim2.new(0,10,0,125) sl.BackgroundTransparency=1 sl.Text="Smooth: "..S.Sm sl.TextColor3=Color3.white sl.TextScaled=true sl.Parent=mf
    local ss = Instance.new("Frame") ss.Size=UDim2.new(1,-20,0,15) ss.Position=UDim2.new(0,10,0,145) ss.BackgroundColor3=Color3.fromRGB(60,60,60) ss.Parent=mf
    local ssc = Instance.new("UICorner") ssc.CornerRadius=UDim.new(0,8) ssc.Parent=ss
    local sh = Instance.new("TextButton") sh.Size=UDim2.new(0,15,1,0) sh.Position=UDim2.new(S.Sm,-7,0,0) sh.BackgroundColor3=Color3.fromRGB(100,150,255) sh.Text="" sh.Parent=ss
    local shc = Instance.new("UICorner") shc.CornerRadius=UDim.new(1,0) shc.Parent=sh
    
    local ft = Instance.new("TextButton") ft.Size=UDim2.new(1,-20,0,25) ft.Position=UDim2.new(0,10,0,170) ft.BackgroundColor3=Color3.fromRGB(50,120,50) ft.Text="✅ Show FOV" ft.TextColor3=Color3.white ft.TextScaled=true ft.Parent=mf
    local ftc = Instance.new("UICorner") ftc.CornerRadius=UDim.new(0,6) ftc.Parent=ft
    
    et.MouseButton1Click:Connect(function()
        S.E = not S.E
        if S.E then et.Text,et.BackgroundColor3="🟢 ON",Color3.fromRGB(50,120,50) SA() else et.Text,et.BackgroundColor3="🔴 OFF",Color3.fromRGB(120,50,50) ST() end
    end)
    
    ft.MouseButton1Click:Connect(function()
        S.SF = not S.SF
        if S.SF then ft.Text,ft.BackgroundColor3="✅ Show FOV",Color3.fromRGB(50,120,50) CF() else ft.Text,ft.BackgroundColor3="❌ Hide FOV",Color3.fromRGB(120,50,50) if FOV then FOV:Remove() end end
    end)
    
    local function SS(h,s,min,max,set,lbl,fmt)
        local d=false
        h.MouseButton1Down:Connect(function() d=true end)
        U.InputChanged:Connect(function(i)
            if d and i.UserInputType==Enum.UserInputType.MouseMovement then
                local p=math.clamp((M.X-s.AbsolutePosition.X)/s.AbsoluteSize.X,0,1)
                h.Position=UDim2.new(p,-7,0,0)
                local v=min+(max-min)*p
                S[set]=v lbl.Text=fmt:format(v)
                if set=="F" and FOV then FOV.Radius=v end
            end
        end)
        U.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end end)
    end
    
    SS(fh,fs,50,200,"F",fl,"FOV: %.0f")
    SS(sh,ss,0.1,1,"Sm",sl,"Smooth: %.1f")
    
    return sg
end

-- Create FOV Circle
function CF()
    if FOV then FOV:Remove() end
    FOV = Drawing.new("Circle")
    FOV.Color,FOV.Thickness,FOV.Transparency,FOV.Filled,FOV.Radius,FOV.Visible = Color3.white,2,0.7,false,S.F,S.SF
end

-- Get Closest Player
function GCP()
    local cp,sd = nil,math.huge
    for _,p in pairs(P:GetPlayers()) do
        if p~=L and p.Character and p.Character:FindFirstChild(S.T) then
            if S.TC and p.Team==L.Team then continue end
            local tp=p.Character[S.T]
            local sp,os=C:WorldToScreenPoint(tp.Position)
            if os then
                local d=(Vector2.new(M.X,M.Y)-Vector2.new(sp.X,sp.Y)).Magnitude
                if d<S.F and d<sd then cp,sd=p,d end
            end
        end
    end
    return cp
end

-- Start Aim Assist
function SA()
    Con = R.Heartbeat:Connect(function()
        if S.E then
            T = GCP()
            if T and T.Character and T.Character:FindFirstChild(S.T) then
                local tp,cp = T.Character[S.T].Position,C.CFrame.Position
                local d = (tp-cp).Unit
                local tc = CFrame.lookAt(cp,cp+d)
                C.CFrame = C.CFrame:Lerp(tc,S.Sm)
            end
        end
    end)
end

-- Stop Aim Assist
function ST()
    if Con then Con:Disconnect() Con=nil end
    T=nil
end

-- Update FOV
R.Heartbeat:Connect(function()
    if FOV then FOV.Position,FOV.Visible = Vector2.new(M.X,M.Y),S.SF end
end)

-- Initialize
G = CG()
CF()
game:GetService("StarterGui"):SetCore("SendNotification",{Title="Aim Assist";Text="Loaded Successfully!";Duration=3})