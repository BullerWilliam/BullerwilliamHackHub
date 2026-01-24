Misc_Tab = Window:Tab({
	Title = "Misc",
	Icon = "wrench", -- optional
	Locked = false,
})
local Misc_Minimap = Misc_Tab:Button({
    Title = "Enable Minimap",
    Desc = "Cant disable again once enabled (May lag)",
    Locked = false,
    Callback = function()
        game.Players.LocalPlayer:AddTag("minimap")
    end
})