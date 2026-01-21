FireClick = function(clickdetector:ClickDetector)
    print("FIRE - click")
    fireclickdetector(clickdetector)
end
FireProx = function(proximityprompt:ProximityPrompt)
    print("FIRE - prox")
    fireproximityprompt(proximityprompt)
end
local plrs=game:GetService("Players")
local plr=plrs.LocalPlayer

plr.DevEnableMouseLock=false

plr:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
	plr.DevEnableMouseLock=false
end)
