local Repo = "https://githubusercontent.com"
local PlaceId = tostring(game.PlaceId)

-- 1. AUTOMATIC GALAXY A12 OPTIMIZER (Runs instantly on launch)
local Lighting = game:GetService("Lighting")
Lighting.GlobalShadows = false
Lighting.FogEnd = 100000
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

-- 2. CUSTOM GAME ROUTER (Checks your Dodo-hub/games/ folder first)
local function LoadCustomGame()
    local ok, res = pcall(function()
        return game:HttpGet(Repo .. "games/" .. PlaceId .. ".lua")
    end)
    if ok and res and not res:find("404: Not Found") and #res > 10 then
        local fn = loadstring(res)
        if fn then
            task.spawn(fn)
            return true
        end
    end
    return false
end

-- If no custom game file exists in your repo, load Cerberus Base
if not LoadCustomGame() then
    task.spawn(function()
        loadstring(game:HttpGet("https://getcerberus.com"))()
    end)
end

-- 3. FLOATING "DODO EXTRAS" BUTTON (Loads Trolling/Animations on demand)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("DodoFloatingBtn") then
    CoreGui.DodoFloatingBtn:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "DodoFloatingBtn"

local Btn = Instance.new("TextButton", ScreenGui)
Btn.Size = UDim2.new(0, 95, 0, 32)
Btn.Position = UDim2.new(0, 10, 0.5, -16)
Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 12
Btn.Text = "Dodo Trolls"
Btn.Draggable = true

local Corner = Instance.new("UICorner", Btn)
Corner.CornerRadius = UDim.new(0, 8)

Btn.MouseButton1Click:Connect(function()
    Btn.Text = "Loading..."
    -- Loads AquaMatrix (Keyless FE Trolling & Animations) on demand
    loadstring(game:HttpGet("https://githubusercontent.com"))()
    Btn.Text = "Dodo Trolls"
end)
