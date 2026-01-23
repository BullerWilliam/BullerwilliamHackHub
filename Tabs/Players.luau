Players_Tab = Window:Tab({
	Title = "Players",
	Icon = "users", -- optional
	Locked = false,
})
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
task.spawn(function()
    while true do
        local Players_Plrnames = {}
        for _, Players_plr in ipairs(game.Players:GetChildren()) do
            table.insert(Players_Plrnames, Players_plr.Name)
        end
        Players_Dropdown:Refresh(Players_Plrnames)
    end
end)