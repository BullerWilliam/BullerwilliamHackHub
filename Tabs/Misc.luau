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
local Misc_NoLeaving = Misc_Tab:Toggle({
    Title = "No Leaving",
    Desc = "When this is enabled it disables your abilty to leave",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        game:GetService("CoreGui").RobloxGui.Enabled = state
    end
})