print("Players Log - start")
Players_Tab = Window:Tab({
	Title = "Players",
	Icon = "users", -- optional
	Locked = false,
})
local function reviveplayer(plrtorevive)
    if game.Workspace:WaitForChild("Characters"):FindFirstChild(plrtorevive.Name.." Body") then
        local body = game.Workspace:WaitForChild("Characters"):FindFirstChild(plrtorevive.Name.." Body")
        FireProx(body.PrimaryPart:FindFirstChild("ProximityAttachment"):FindFirstChild("ProximityInteraction"), body.PrimaryPart.CFrame)
        --[[if hasrevivetool() then
            print("has tool")
            local body = game.Workspace:WaitForChild("Characters"):FindFirstChild(plrtorevive.Name.." Body")
            FireProx(body.PrimaryPart:FindFirstChild("ProximityAttachment"):FindFirstChild("ProximityInteraction"), body.PrimaryPart.CFrame)
        else
            print("has not tool")
            if GrabTool("Bandage") or GrabTool("MedKit") then
                local body = game.Workspace:WaitForChild("Characters"):FindFirstChild(plrtorevive.Name.." Body")
                FireProx(body.PrimaryPart:FindFirstChild("ProximityAttachment"):FindFirstChild("ProximityInteraction"), body.PrimaryPart.CFrame)
                return true
            else
                return false
            end
        end]]
    end
end
local function hasrevivetool()
    local inventory = game.Players.LocalPlayer:WaitForChild("Inventory")
    return inventory:FindFirstChild("Bandage") or inventory:FindFirstChild("MedKit")
end
print("Players Log - loaded functions")
local Players_Selected
local Players_Dropdown = Players_Tab:Dropdown({
	Title = "Players",
	Desc = "Players to revive",
	Values = {},
	Value = {},
	Multi = true,
	AllowNone = true,
	Callback = function(option)
		Players_Selected = option
		print("Categories selected: " .. game:GetService("HttpService"):JSONEncode(option)) 
	end
})
local Players_Button = Players_Tab:Button({
    Title = "Revive",
    Desc = "Revive the selected players",
    Locked = false,
    Callback = function()
        for _, plrtorevive in ipairs(Players_Selected) do
            reviveplayer(game:GetService("Players"):FindFirstChild(plrtorevive))
        end
    end
})
local Players_Auto = false
local Players_Toggle = Players_Tab:Toggle({
    Title = "Auto Revive",
    Desc = "Automaticly revives the selected players",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        Players_Auto = state
    end
})
task.spawn(function()
    while true do
        if Players_Auto then
            for _, plrtorevive in ipairs(Players_Selected) do
                reviveplayer(game:GetService("Players"):FindFirstChild(plrtorevive))
            end
        end
        task.wait(2)
    end
end)
task.spawn(function()
    while true do
        local Players_Plrnames = {}
        for _, Players_plr in ipairs(game:GetService("Players"):GetPlayers()) do
            if Players_plr.Name ~= game.Players.LocalPlayer.Name then
                table.insert(Players_Plrnames, Players_plr.Name)
            end
        end
        Players_Dropdown:Refresh(Players_Plrnames)
        task.wait(5)
    end
end)