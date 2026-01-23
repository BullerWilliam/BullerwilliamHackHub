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