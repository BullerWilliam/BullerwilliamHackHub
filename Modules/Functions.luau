local plr = game.Players.LocalPlayer -- updated
local char = plr.Character or plr.CharacterAdded:Wait()
plr.CharacterAdded:Connect(function(newchar)
	char = newchar
end)

local function trigger(prox:ProximityPrompt, proxpos)
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
    print("before cam")
    local beforetype = game.Workspace.CurrentCamera.CameraType
	game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    if not char then
        print("no char")
    else
        print("char")
    end
    print("-2")
    if char then
        if not char.PrimaryPart then
            print("No primary")
            char.PrimaryPart = char.HumanoidRootPart
        end
        local pos = char:GetPivot()
        print("-1")
    	char:PivotTo(CFrame.new(proxpos + Vector3.new(0, 8, 0)))
        print("1")
    	task.wait(0.1)
    	game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(proxpos + Vector3.new(0, 4, 5), proxpos)
	    print("2")
        task.wait(0.1)
    	prox:InputHoldBegin()
        print("3")
    	task.wait(0.1)
    	prox:InputHoldEnd()
        print("4")
    	task.wait(0.1)
        char:PivotTo(pos)
        print("5")
    end
    game.Workspace.CurrentCamera.CameraType = beforetype
    task.cancel(settings2)
end

GrabTool = function(name:string)
    local tool = game.Workspace:WaitForChild("Items"):FindFirstChild(name)
    if tool then
        local pos = char:GetPivot()
        char:PivotTo(tool:GetPivot() or tool:FindFirstAncestorWhichIsA("BasePart").CFrame)
        task.wait(0.1)
        local remoteevent:RemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").RequestHotbarItem
        remoteevent:FireServer(tool)
        task.wait(0.1)
        char:PivotTo(pos)
        return true
    else
        return false
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
local FileManagerService = game:GetService("FileManagerService")
local plrs=game:GetService("Players")
local plr=plrs.LocalPlayer

plr.DevEnableMouseLock=false

plr:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
	plr.DevEnableMouseLock=false
end)