task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BullerWilliam/BullerwilliamHackHub/refs/heads/main/Tabs/Kids.luau"))()
end)
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BullerWilliam/BullerwilliamHackHub/refs/heads/main/Tabs/Players.luau"))()
end)
--[[
local list2 = game:HttpGet("https://raw.githubusercontent.com/BullerWilliam/BullerwilliamHackHub/refs/heads/main/Tabs/All.txt")
local https = game:GetService("HttpService")
local list = https:JSONDecode(list2)
for _, codename in ipairs(list) do
    local func = loadstring(game:HttpGet("https://raw.githubusercontent.com/BullerWilliam/BullerwilliamHackHub/refs/heads/main/Tabs/"..codename..".luau"))
    func()
end
]]