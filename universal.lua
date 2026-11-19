local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
local Repo = "https://githubusercontent.com"

local Window = OrionLib:MakeWindow({
    Name = "Dodo Hub | Galaxy A12 Edition",
    HidePremium = true,
    SaveConfig = false,
    IntroEnabled = false
})

-- Services & Cached Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- State Toggles
local States = {
    Speed = 16,
    Jump = 50,
    InfJump = false,
    Noclip = false,
    Aimbot = false,
    ESP = false,
    AntiAFK = true
}

-- 1. COMBAT TAB (Lightweight Aimbot & ESP)
local CombatTab = Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://4483345998" })

local aimConn
CombatTab:AddToggle({
    Name = "Smooth Aimbot (Nearest Target)",
    Default = false,
    Callback = function(val)
        States.Aimbot = val
        if val then
            aimConn = RunService.RenderStepped:Connect(function()
                local closest, dist = nil, 250
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                        if vis then
                            local mag = (Vector2.new(pos.X, pos.Y) - (Camera.ViewportSize / 2)).Magnitude
                            if mag < dist then
                                dist = mag
                                closest = p.Character.Head
                            end
                        end
                    end
                end
                if closest then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
                end
            end)
        elseif aimConn then
            aimConn:Disconnect()
        end
    end
})

CombatTab:AddToggle({
    Name = "Low-Lag Highlight ESP",
    Default = false,
    Callback = function(val)
        States.ESP = val
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("DodoESP")
                if val and not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "DodoESP"
                    hl.FillColor = Color3.fromRGB(255, 50, 50)
                elseif not val and hl then
                    hl:Destroy()
                end
            end
        end
    end
})

-- 2. MOVEMENT TAB
local MoveTab = Window:MakeTab({ Name = "Movement", Icon = "rbxassetid://4483345998" })

MoveTab:AddSlider({
    Name = "Walkspeed",
    Min = 16, Max = 200, Default = 16, Increment = 1,
    Callback = function(val)
        States.Speed = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

MoveTab:AddSlider({
    Name = "Jump Power",
    Min = 50, Max = 300, Default = 50, Increment = 5,
    Callback = function(val)
        States.Jump = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
    end
})

MoveTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(val) States.InfJump = val end
})

UIS.JumpRequest:Connect(function()
    if States.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local noclipConn
MoveTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(val)
        States.Noclip = val
        if val then
            noclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        elseif noclipConn then
            noclipConn:Disconnect()
        end
    end
})

-- 3. VISUALS & FPS TAB
local VisTab = Window:MakeTab({ Name = "Visuals & FPS", Icon = "rbxassetid://4483345998" })

VisTab:AddToggle({
    Name = "Fullbright & NoFog",
    Default = false,
    Callback = function(val)
        if val then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 1000
        end
    end
})

VisTab:AddButton({
    Name = "Galaxy A12 FPS Booster",
    Callback = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        OrionLib:MakeNotification({Name = "Dodo Hub", Content = "Textures cleared for smooth FPS!", Time = 3})
    end
})

-- 4. ON-DEMAND EXTRA MODULES
local ExtraTab = Window:MakeTab({ Name = "Extra Modules", Icon = "rbxassetid://4483345998" })

ExtraTab:AddButton({
    Name = "Load Trolling & Animations",
    Callback = function()
        loadstring(game:HttpGet(Repo .. "modules/trolling.lua"))()
    end
})

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if States.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

OrionLib:Init()
