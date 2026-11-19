local Repo = "https://githubusercontent.com"
local PlaceId = tostring(game.PlaceId)

local function SafeLoad(path)
    local success, result = pcall(function()
        return game:HttpGet(Repo .. path)
    end)
    if success and result and not result:find("404: Not Found") and #result > 10 then
        local func, err = loadstring(result)
        if func then
            task.spawn(func)
            return true
        end
    end
    return false
end

if not SafeLoad("games/" .. PlaceId .. ".lua") then
    SafeLoad("universal.lua")
end
