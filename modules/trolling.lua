local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

local Window = OrionLib:MakeWindow({
    Name = "Dodo Hub | Trolling & Animations",
    HidePremium = true,
    SaveConfig = false,
    IntroEnabled = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TargetPlayerName = ""
local States = {
    TouchFling = false,
    WalkFling = false,
    Spinbot = false,
    SpiderWalk = false,
    Headsit = false,
    Bang = false
}

-- Helper to get player names for dropdown
local function GetPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- 1. PLAYER TARGET & INTERACTION TAB
local TargetTab = Window:MakeTab({ Name = "Target Trolls", Icon = "rbxassetid://4483345998" })

local PlayerDropdown = TargetTab:AddDropdown({
    Name = "Select Target Player",
    Default = "",
    Options = GetPlayerList(),
    Callback = function(val)
        TargetPlayerName = val
    end
})

TargetTab:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        PlayerDropdown:Refresh(GetPlayerList(), true)
    end
})

TargetTab:AddButton({
    Name = "Teleport to Target",
    Callback = function()
        local target = Players:FindFirstChild(TargetPlayerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character:PivotTo(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
        end
    end
})

local headsitConn
TargetTab:AddToggle({
    Name = "Headsit on Target",
    Default = false,
    Callback = function(val)
        States.Headsit = val
        if val then
            headsitConn = RunService.Heartbeat:Connect(function()
                local target = Players:FindFirstChild(TargetPlayerName)
                local char = LocalPlayer.Character
                if target and target.Character and target.Character:FindFirstChild("Head") and char and char:FindFirstChild("HumanoidRootPart") then
                    char.Humanoid.Sit = true
                    char.HumanoidRootPart.CFrame = target.Character.Head.CFrame * CFrame.new(0, 1.5, 0)
                end
            end)
        elseif headsitConn then
            headsitConn:Disconnect()
        end
    end
})

local bangConn
TargetTab:AddToggle({
    Name = "Follow / Attach Behind Target",
    Default = false,
    Callback = function(val)
        States.Bang = val
        local offset = 1.2
        local dir = 1
        if val then
            bangConn = RunService.Heartbeat:Connect(function()
                local target = Players:FindFirstChild(TargetPlayerName)
                local char = LocalPlayer.Character
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
                    offset = offset + (0.15 * dir)
                    if offset >= 2.2 then dir = -1 elseif offset <= 0.8 then dir = 1 end
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, offset)
                end
            end)
        elseif bangConn then
            bangConn:Disconnect()
        end
    end
})

-- 2. FLING & PHYSICS TAB
local PhysicsTab = Window:MakeTab({ Name = "Fling & Physics", Icon = "rbxassetid://4483345998" })

local flingConn
PhysicsTab:AddToggle({
    Name = "Touch Fling / WalkFling",
    Default = false,
    Callback = function(val)
        States.TouchFling = val
        if val then
            flingConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local oldVel = hrp.Velocity
                    hrp.Velocity = oldVel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    if hrp then hrp.Velocity = oldVel end
                end
            end)
        elseif flingConn then
            flingConn:Disconnect()
        end
    end
})

local spinConn
PhysicsTab:AddToggle({
    Name = "Spinbot (Fast Spin)",
    Default = false,
    Callback = function(val)
        States.Spinbot = val
        if val then
            spinConn = RunService.RenderStepped:Connect(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(35), 0)
                end
            end)
        elseif spinConn then
            spinConn:Disconnect()
        end
    end
})

local spiderConn
PhysicsTab:AddToggle({
    Name = "Spider Wall-Walk",
    Default = false,
    Callback = function(val)
        States.SpiderWalk = val
        if val then
            spiderConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 2.5)
                    local hit = workspace:FindPartOnRay(ray, char)
                    if hit then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 30, hrp.Velocity.Z)
                    end
                end
            end)
        elseif spiderConn then
            spiderConn:Disconnect()
        end
    end
})

-- 3. ANIMATIONS & EMOTES TAB
local AnimTab = Window:MakeTab({ Name = "Animations", Icon = "rbxassetid://4483345998" })

local currentTrack
local function PlayAnim(id)
    if currentTrack then currentTrack:Stop() end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. tostring(id)
        currentTrack = hum:LoadAnimation(anim)
        currentTrack.Looped = true
        currentTrack:Play()
    end
end

AnimTab:AddButton({
    Name = "Stop Current Animation",
    Callback = function()
        if currentTrack then currentTrack:Stop() end
    end
})

AnimTab:AddButton({ Name = "Emote: Floss Dance", Callback = function() PlayAnim(5917459365) end })
AnimTab:AddButton({ Name = "Emote: Helicopter Spin", Callback = function() PlayAnim(3333499508) end })
AnimTab:AddButton({ Name = "Emote: Zombie Walk", Callback = function() PlayAnim(616163682) end })
AnimTab:AddButton({ Name = "Emote: Levitate Float", Callback = function() PlayAnim(616006778) end })

OrionLib:Init()
