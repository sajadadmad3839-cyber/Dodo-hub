local Repo = "https://githubusercontent.com"
local PlaceId = tostring(game.PlaceId)

local function SafeLoad(path)
    local success, result = pcall(function()
        return game:HttpGet(Repo .. path)
    end)
    if success and result and not result:find("404: Not Found") then
        loadstring(result)()
        return true
    end
    return false
end

-- Check if a specialized game module exists first
local hasGameModule = SafeLoad("games/" .. PlaceId .. ".lua")

-- If no specialized module exists, fall back to Universal Hub
if not hasGameModule then
    SafeLoad("universal.lua")
end
