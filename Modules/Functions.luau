local function trigger(prox:ProximityPrompt, proxpos)
	local parentpos = proxpos
	if parentpos then
		local settings2 = task.spawn(function()
			while true do
				prox.HoldDuration = 0
				prox.MaxActivationDistance = 1000000
				prox.MaxIndicatorDistance = 1000000
				prox.RequiresLineOfSight = false
				prox.Enabled = true
				task.wait()
			end
		end)
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		local pos = char:GetPivot()
		char:PivotTo(CFrame.new(parentpos + Vector3.new(0, 2, 0)))
		task.wait(0.1)
		game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.Position, parentpos)
		task.wait(0.1)
		prox:InputHoldBegin()
		task.wait(0.1)
		prox:InputHoldEnd()
		task.wait(0.1)
		char:PivotTo(pos)
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		task.cancel(settings2)
	end
end

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
    trigger(proximityprompt, proxpos.Position)
end
local plrs=game:GetService("Players")
local plr=plrs.LocalPlayer

plr.DevEnableMouseLock=false

plr:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
	plr.DevEnableMouseLock=false
end)
