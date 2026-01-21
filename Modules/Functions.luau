function FireClick(clickdetector:ClickDetector)
    fireclickdetector(clickdetector)
end
function FireProx(proximityprompt:ProximityPrompt)
    fireproximityprompt(proximityprompt)
end
local plrs=game:GetService("Players")
local plr=plrs.LocalPlayer

plr.DevEnableMouseLock=false

plr:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
	plr.DevEnableMouseLock=false
end)
