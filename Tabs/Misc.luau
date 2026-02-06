Misc_Tab = Window:Tab({
	Title = "Misc",
	Icon = "wrench", -- optional
	Locked = false,
})
local Misc_Minimap = Misc_Tab:Button({
    Title = "Enable Map Functions",
    Desc = "Cant disable again once enabled (May lag)",
    Locked = false,
    Callback = function()
        Misc_Minimap:Lock()
        game.Players.LocalPlayer:AddTag("minimap")
    end
})
local Misc_NoLeaving = Misc_Tab:Button({
    Title = "No Leaving",
    Desc = "When pressing this it disables your abilty to leave",
    Locked = false,
    Callback = function()
        game:GetService("CoreGui").RobloxGui.Enabled = false
    end
})