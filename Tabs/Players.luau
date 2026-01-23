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
    end
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
            reviveplayer(plrtorevive)
        end
    end
})
task.spawn(function()
    while true do
        local Players_Plrnames = {}
        for _, Players_plr in ipairs(game:GetService("Players"):GetPlayers()) do
            table.insert(Players_Plrnames, Players_plr.Name)
        end
        Players_Dropdown:Refresh(Players_Plrnames)
        task.wait()
    end
end)