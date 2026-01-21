FireClick = function(clickdetector:ClickDetector, clickpos)
    print("FIRE - click")
    local befdis = clickdetector.MaxActivationDistance
    clickdetector.MaxActivationDistance = 10000000
    local pos = char:GetPivot()
    char:PivotTo(clickpos)
    task.wait(0.1)
    fireclickdetector(clickdetector)
    task.wait(0.1)
    char:PivotTo(pos)
    clickdetector.MaxActivationDistance = befdis
end
FireProx = function(proximityprompt:ProximityPrompt, proxpos)
    print("FIRE - prox")
    local befdis = proximityprompt.MaxActivationDistance
    proximityprompt.MaxActivationDistance = 10000000
    local pos = char:GetPivot()
    char:PivotTo(proxpos)
    task.wait(0.1)
    fireproximityprompt(proximityprompt)
    task.wait(0.1)
    char:PivotTo(pos)
    proximityprompt.MaxActivationDistance = befdis
end
local plrs=game:GetService("Players")
local plr=plrs.LocalPlayer

plr.DevEnableMouseLock=false

plr:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
	plr.DevEnableMouseLock=false
end)
