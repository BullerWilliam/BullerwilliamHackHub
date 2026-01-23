local plr = game.Players.LocalPlayer
local playergui = plr.PlayerGui
local interface:Frame = playergui.Interface
local mapholder:Frame = interface.MapHolder
local uis = game:GetService("UserInputService")
local pointer:Frame = nil
local tpbutton:TextButton = nil
local minimapGLOBAL:Frame = nil
local function buildtpbutton(closebutton:TextButton)
	local tper:TextButton = closebutton:Clone()
	tper.Position = UDim2.new(1.029, 0, 0.18, 0)
	tper.Name = "TpButton"
	tper.BackgroundColor3 = Color3.new(0.454902, 0.454902, 0.454902)
	tper.Text = "Teleport"
	tper.Size = UDim2.new(0.3, 0, 0.157, 0)
	local aspect = tper:FindFirstChildWhichIsA("UIAspectRatioConstraint")
	aspect.AspectRatio = 2.5
	tper.Parent = closebutton.Parent
	return tper
end
uis.InputBegan:Connect(function(input, gpe)
	if not gpe then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			print("press - mouse")
			if mapholder:FindFirstChild("Map") then
				local function GetMouseScaleInFrame(frame)
					if frame then
						local mousePos = uis:GetMouseLocation()
						local framePos = frame.AbsolutePosition
						local frameSize = frame.AbsoluteSize

						local x = (mousePos.X - framePos.X) / frameSize.X
						local y = (mousePos.Y - framePos.Y) / frameSize.Y

						return x, y-0.115
					else
						print("nil!")
						return 0, 0
					end
				end
				if not pointer then
					pointer = Instance.new("Frame")
					pointer.Size = UDim2.new(0.02, 0, 0.02, 0)
					pointer.Parent = mapholder:FindFirstChild("Map"):FindFirstChild("Icons")
					pointer.BackgroundColor3 = Color3.new(0.0627451, 0.360784, 1)
					pointer.AnchorPoint = Vector2.new(0.5, 0)
					pointer.ZIndex = 100
					pointer.Name = "Pointer"
				end
				local mouseposx, mouseposy = GetMouseScaleInFrame(mapholder)
				if (mouseposx>=0.01) and (mouseposx<=0.99) and (mouseposy>=0) and (mouseposy<=0.98) then
					pointer.Position = UDim2.new(mouseposx, 0, mouseposy, 0)
				end
			end
		end
	end
end)
task.spawn(function()
	interface:WaitForChild("PartyDeadFrame"):WaitForChild("SubTitleLabel").Text = "you are so bad"
	interface:WaitForChild("PartyGameLostFrame"):WaitForChild("SubLabel").Text = "ARE YOU ALL REALLY THIS BAD?"
	interface:WaitForChild("DeadFrame"):WaitForChild("TitleLabel").Text = "you are so bad"
	interface:WaitForChild("GameLostFrame"):WaitForChild("SubLabel").Text = "ARE YOU ALL REALLY THIS BAD?"
end)
task.spawn(function()
	repeat
		task.wait(1)
	until mapholder:FindFirstChild("Map")
	local justmap = mapholder:FindFirstChild("Map")
	repeat
		task.wait(2)
	until plr:HasTag("minimap")
	local minimap = justmap:Clone()
	minimap.Parent = interface
	minimap.Name = "Minimap"
	minimap.Size = UDim2.new(0.4, 0, 0.4, 0)
	local ratio = Instance.new("UIAspectRatioConstraint")
	ratio.Parent = minimap
	minimap.AnchorPoint = Vector2.new(1, 0)
	minimap.Position = UDim2.new(1, 0, 0, 0)
	minimap.Visible = true
	minimapGLOBAL = minimap
	--interface:WaitForChild("TopRight"):WaitForChild("Frame"):WaitForChild("Map").Size = UDim2.new(1, 0, 1, 0)
	--interface:WaitForChild("TopRight"):WaitForChild("Frame"):WaitForChild("Map").Position = UDim2.new(0, 0, 0, 0)
	--local button:ImageButton = interface:WaitForChild("TopRight"):WaitForChild("Frame"):WaitForChild("Map")
	--button.Parent = minimapGLOBAL
	--button.ImageTransparency = 1
	--button.BackgroundTransparency = 0.99
	while true do
		if mapholder:FindFirstChild("Map") then
			minimap.Visible = false
		else
			minimap.Visible = true
		end
		for _, plricon in ipairs(minimap:WaitForChild("Players"):GetChildren()) do
			plricon:Destroy()
		end
		for _, backicon in ipairs(minimap:WaitForChild("Tiles"):GetChildren()) do
			backicon:Destroy()
		end
		for _, icon in ipairs(minimap:WaitForChild("Icons"):GetChildren()) do
			icon:Destroy()
		end
		for _, plricon in ipairs(justmap:WaitForChild("Players"):GetChildren()) do
			local newplricon = plricon:Clone()
			newplricon.Parent = minimap:WaitForChild("Players")
		end
		for _, backicon in ipairs(justmap:WaitForChild("Tiles"):GetChildren()) do
			local newbackicon = backicon:Clone()
			newbackicon.Parent = minimap:WaitForChild("Tiles")
		end
		for _, icon in ipairs(justmap:WaitForChild("Icons"):GetChildren()) do
			local newicon = icon:Clone()
			newicon.Parent = minimap:WaitForChild("Icons")
		end
		task.wait(0.1)
	end
end)
task.spawn(function()
	repeat
		task.wait(2)
	until mapholder:FindFirstChild("Map")
	for _, icon in mapholder:FindFirstChild("Map"):FindFirstChild("Icons"):GetChildren() do
		if icon:IsA("ImageLabel") then
			icon.Visible = true
		end
	end
end)
task.spawn(function()
	repeat
		task.wait(2)
	until not tpbutton
	tpbutton = buildtpbutton(mapholder:WaitForChild("CloseButton"))
	tpbutton.MouseButton1Click:Connect(function()
	if pointer then
		local times = 1390 * 2
		local x = (pointer.Position.X.Scale - 0.5)
		local y = (pointer.Position.Y.Scale - 0.5)
		local char = plr.Character or plr.CharacterAdded:Wait()
		char:PivotTo(CFrame.new(Vector3.new(x * times, 12, y * times)))
	end
end)