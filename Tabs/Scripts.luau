Scripts_Tab = Window:Tab({
	Title = "Scripts",
	Icon = "scroll-text", -- optional
	Locked = false,
})
local Scripts_Fly = Scripts_Tab:Button({
    Title = "Fly Script",
    Desc = "Fly and other features",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BullerWilliam/BullerwilliamHackHub/refs/heads/main/Scripts/Fly.luau"))()
    end
})