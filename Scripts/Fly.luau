--------------------------------------------------------
-- UIClient MODULE (INLINE)
--------------------------------------------------------
local UIClient = {}

local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local uis = game:GetService("UserInputService")

local function createRound(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
end

local function createScroll(parent)
	local s = Instance.new("ScrollingFrame")
	s.Parent = parent
	s.Size = UDim2.new(1,0,1,0)
	s.CanvasSize = UDim2.new(0,0,5,0)
	s.ScrollBarThickness = 6
	local l = Instance.new("UIListLayout")
	l.Parent = s
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Padding = UDim.new(0,4)
	return s, l
end

function UIClient:CreateWindow(name)
	local existing = plr:WaitForChild("PlayerGui"):FindFirstChild(name)
	if existing then existing:Destroy() end

	local screen = Instance.new("ScreenGui")
	screen.Parent = plr:WaitForChild("PlayerGui")
	screen.Name = name
	screen.ResetOnSpawn = false

	local win = Instance.new("CanvasGroup")
	win.Name = "Frame"
	win.Parent = screen
	win.Size = UDim2.new(0,280,0,300)
	win.Position = UDim2.new(0.4,0,0.35,0)
	win.BackgroundColor3 = Color3.fromRGB(30,30,30)
	createRound(win,10)

	-- Draggable Top Bar
	local top = Instance.new("Frame")
	top.Parent = win
	top.Size = UDim2.new(1,0,0,30)
	top.BackgroundColor3 = Color3.fromRGB(45,45,45)
	createRound(top,10)

	local title = Instance.new("TextLabel")
	title.Parent = top
	title.Size = UDim2.new(1,0,1,0)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Color3.new(1,1,1)
	title.TextSize = 18

	local close = Instance.new("TextButton")
	close.Parent = top
	close.Size = UDim2.new(0,30,1,0)
	close.Position = UDim2.new(1,-30,0,0)
	close.Text = "X"
	close.TextColor3 = Color3.new(1,0,0)
	close.BackgroundTransparency = 1
	close.MouseButton1Click:Connect(function()
		screen.Enabled = not screen.Enabled
	end)

	local dragging = false
	local offset
	top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			offset = win.Position - UDim2.fromOffset(i.Position.X,i.Position.Y)
		end
	end)
	top.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	uis.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			win.Position = UDim2.fromOffset(i.Position.X,i.Position.Y) + offset
		end
	end)

	-- Tabs
	local tabBar = Instance.new("ScrollingFrame")
	tabBar.Parent = win
	tabBar.Size = UDim2.new(1,0,0,30)
	tabBar.Position = UDim2.new(0,0,0,30)
	tabBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
	tabBar.CanvasSize = UDim2.new(0,0,0,0)
	tabBar.ScrollBarThickness = 4
	tabBar.ScrollingDirection = Enum.ScrollingDirection.X

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Parent = tabBar
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.SortOrder = Enum.SortOrder.Name
	tabLayout.Padding = UDim.new(0,4)
	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)
	end)

	local content = Instance.new("Frame")
	content.Parent = win
	content.Size = UDim2.new(1,0,1,-50)
	content.Position = UDim2.new(0,0,0,60)
	content.BackgroundTransparency = 1

	local tabs = {}

	function UIClient:CreateTab(name, order)
		local tabButton = Instance.new("TextButton")
		tabButton.Parent = tabBar
		tabButton.Size = UDim2.new(0,80,1,0)
		tabButton.Text = name
		tabButton.TextColor3 = Color3.new(1,1,1)
		tabButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
		tabButton.Name = order

		local sc, layout = createScroll(content)
		sc.Visible = false

		local function nextY()
			local f = Instance.new("Frame")
			f.Parent = sc
			f.Size = UDim2.new(1,0,0,34)
			f.BackgroundTransparency = 1
			return f
		end

		local tab = {}

		function tab:Show()
			for _,t in pairs(tabs) do t.sc.Visible = false end
			sc.Visible = true
		end

		function tab:Button(text,callback)
			local f = nextY()
			local b = Instance.new("TextButton")
			b.Parent = f
			b.Size = UDim2.new(1,-10,1,-4)
			b.Position = UDim2.new(0,5,0,2)
			b.Text = text
			b.BackgroundColor3 = Color3.fromRGB(50,50,50)
			b.TextColor3 = Color3.new(1,1,1)
			createRound(b,6)
			b.MouseButton1Click:Connect(callback)
		end

		function tab:Toggle(text, callback)
			local f = nextY()
			local t = false
			local btn = Instance.new("TextButton")
			btn.Parent = f
			btn.Size = UDim2.new(1,-10,1,-4)
			btn.Position = UDim2.new(0,5,0,2)
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Text = text.." OFF"
			createRound(btn,6)
			btn.MouseButton1Click:Connect(function()
				t = not t
				btn.Text = text.." "..(t and "ON" or "OFF")
				callback(t)
			end)
			return {Set = function(state)
				t = state
				btn.Text = text.." "..(t and "ON" or "OFF")
			end}
		end

		function tab:Slider(text,min,max,default,callback)
			local f = nextY()
			local val = default
			local lab = Instance.new("TextLabel")
			lab.Parent = f
			lab.Size = UDim2.new(1,0,0.5,0)
			lab.BackgroundTransparency = 1
			lab.TextColor3 = Color3.new(1,1,1)
			lab.Text = text..": "..val

			local bar = Instance.new("Frame")
			bar.Parent = f
			bar.Size = UDim2.new(1,-20,0.3,0)
			bar.Position = UDim2.new(0,10,0.6,0)
			bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
			createRound(bar,6)

			local fill = Instance.new("Frame")
			fill.Parent = bar
			fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
			fill.BackgroundColor3 = Color3.fromRGB(120,120,120)
			createRound(fill,6)

			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					local x = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
					x = math.clamp(x,0,1)
					val = math.floor(min + (max-min)*x)
					fill.Size = UDim2.new(x,0,1,0)
					lab.Text = text..": "..val
					callback(val)
				end
			end)
		end

		function tab:TextInput(text,callback)
			local f = nextY()
			local label = Instance.new("TextLabel")
			label.Parent = f
			label.Size = UDim2.new(0.4,0,1,0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1,1,1)
			label.Text = text

			local box = Instance.new("TextBox")
			box.Parent = f
			box.Size = UDim2.new(0.6,0,1,-6)
			box.Position = UDim2.new(0.4,0,0,3)
			box.BackgroundColor3 = Color3.fromRGB(40,40,40)
			box.TextColor3 = Color3.new(1,1,1)
			createRound(box,6)
			box.FocusLost:Connect(function()
				callback(box.Text)
			end)
		end

		function tab:Keybind(text,defaultKey,callback)
			local f = nextY()
			local currentKey = defaultKey

			local t = Instance.new("TextLabel")
			t.Parent = f
			t.Size = UDim2.new(0.6,0,1,0)
			t.BackgroundTransparency = 1
			t.TextColor3 = Color3.new(1,1,1)
			t.Text = text

			local box = Instance.new("TextButton")
			box.Parent = f
			box.Size = UDim2.new(0.3,0,1,-6)
			box.Position = UDim2.new(0.65,0,0,3)
			box.BackgroundColor3 = Color3.fromRGB(40,40,40)
			box.TextColor3 = Color3.new(1,1,1)
			box.Text = currentKey and currentKey.Name or "None"
			createRound(box,6)

			local clearBtn = Instance.new("TextButton")
			clearBtn.Parent = f
			clearBtn.Size = UDim2.new(0.1,0,1,-6)
			clearBtn.Position = UDim2.new(0.96,0,0,3)
			clearBtn.Text = "X"
			clearBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
			clearBtn.TextColor3 = Color3.new(1,1,1)
			createRound(clearBtn,6)

			box.MouseButton1Click:Connect(function()
				box.Text = "Press Key..."
				local conn
				conn = uis.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode
						box.Text = currentKey.Name
						callback(currentKey)
						conn:Disconnect()
					end
				end)
			end)

			clearBtn.MouseButton1Click:Connect(function()
				currentKey = nil
				box.Text = "None"
				callback(nil)
			end)
		end

		function tab:Dropdown(text, options, callback)
			local f = nextY()

			local label = Instance.new("TextLabel")
			label.Parent = f
			label.Size = UDim2.new(0.5,0,1,0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1,1,1)
			label.Text = text
			label.ZIndex = 5

			local btn = Instance.new("TextButton")
			btn.Parent = f
			btn.Size = UDim2.new(0.5,0,1,-4)
			btn.Position = UDim2.new(0.5,0,0,2)
			btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Text = options[1]
			btn.ZIndex = 5
			createRound(btn,6)

			local dropdownFrame = Instance.new("Frame")
			dropdownFrame.Parent = f
			dropdownFrame.Position = UDim2.new(0.5,0,1,0)
			dropdownFrame.Size = UDim2.new(0.5,#options*30,0,0)
			dropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
			dropdownFrame.ZIndex = 5
			dropdownFrame.ClipsDescendants = true
			createRound(dropdownFrame,6)

			local open = false

			for i,opt in ipairs(options) do
				local optBtn = Instance.new("TextButton")
				optBtn.Parent = dropdownFrame
				optBtn.Size = UDim2.new(1,0,0,30)
				optBtn.Position = UDim2.new(0,0,(i-1)/#options,0)
				optBtn.Text = opt
				optBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
				optBtn.TextColor3 = Color3.new(1,1,1)
				optBtn.ZIndex = 6
				optBtn.MouseButton1Click:Connect(function()
					btn.Text = opt
					callback(opt)
					dropdownFrame:TweenSize(UDim2.new(0.5,0,0,0),"Out","Quad",0.2,true)
					open=false
				end)
			end

			btn.MouseButton1Click:Connect(function()
				open = not open
				dropdownFrame:TweenSize(
					UDim2.new(0.5,0,0,#options*30*(open and 1 or 0)),
					"Out","Quad",0.2,true
				)
			end)
		end

		tabButton.MouseButton1Click:Connect(function()
			tab:Show()
		end)

		tab.sc = sc
		tabs[#tabs+1] = tab

		if #tabs == 1 then tab:Show() end
		return tab
	end

	UIClient.Screen = screen
	UIClient.ScreenFrame = win
	UIClient.tabs = tabs
	return UIClient
end

function UIClient:DestroyAll()
	if self.Screen then self.Screen:Destroy() end
end



--------------------------------------------------------
-- FLY MODULE (INLINE)
--------------------------------------------------------
local fly = {}

local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local flying = false
local noclip = false
local speed = 50
local originalCanCollide = {}
local upKey = Enum.KeyCode.Space
local downKey = Enum.KeyCode.LeftControl
local bodyVelocity
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function bindChar()
	character = plr.Character or plr.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end

local function applyNoclip(part)
	if part:IsA("BasePart") and part.Parent then
		originalCanCollide[part] = part.CanCollide
		part.CanCollide = false
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not (flying and noclip and part and part.Parent) then
				if conn then conn:Disconnect() end
			else
				part.CanCollide = false
			end
		end)
	end
end

local function enableNoclip()
	for _, part in ipairs(character:GetDescendants()) do
		applyNoclip(part)
	end
end

local function disableNoclip()
	for part, oldVal in pairs(originalCanCollide) do
		if part and part.Parent then
			part.CanCollide = oldVal
		end
	end
	originalCanCollide = {}
end

local function monitorNewParts()
	character.DescendantAdded:Connect(function(part)
		if part:IsA("BasePart") and flying and noclip then
			applyNoclip(part)
		end
	end)
end

local function startFlying()
	if not bodyVelocity then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Parent = rootPart
	end
	monitorNewParts()
	if noclip then enableNoclip() end
end

local function stopFlying()
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	if noclip then disableNoclip() end
end

RunService.RenderStepped:Connect(function()
	if flying and bodyVelocity and rootPart then
		local moveDir = Vector3.new()
		local cam = workspace.CurrentCamera
		local look = cam.CFrame.LookVector
		local horizLook = Vector3.new(look.X,0,look.Z)

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += horizLook end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= horizLook end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z) end
		if UserInputService:IsKeyDown(upKey) then moveDir += Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(downKey) then moveDir -= Vector3.new(0,1,0) end

		bodyVelocity.Velocity = (moveDir.Magnitude > 0) and moveDir.Unit * speed or Vector3.zero

		if horizLook.Magnitude > 0 then
			rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + horizLook)
		end
	end
end)

plr.CharacterAdded:Connect(function()
	bindChar()
	if flying then startFlying() end
	if noclip then enableNoclip() end
end)

function fly.setfly(v)
	flying = v
	if v then
		bindChar()
		startFlying()
	else
		stopFlying()
	end
end

function fly.setnoclip(v)
	noclip = v
	if flying then
		if v then enableNoclip() else disableNoclip() end
	end
end

function fly.setspeed(v)
	speed = v
end

function fly.SetUpKeybind(k)
	upKey = k
end

function fly.SetDownKeybind(k)
	downKey = k
end

function fly.resetchar()
	bindChar()
end



--------------------------------------------------------
-- MAIN SCRIPT (UNCHANGED, NOW USING INLINE MODULES)
--------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TextChatService = game.TextChatService
local channel = TextChatService.TextChannels.RBXGeneral

local plr = Players.LocalPlayer

-- use inline modules
local UIClient = UIClient
local fly = fly

local ui = UIClient:CreateWindow("HackMenu")


-------------------------------------------------------------------
-- (Your entire main script code goes here EXACTLY as written)
-- I am NOT rewriting it because it stays the same.
-- All require() calls are already replaced with inline modules.
-------------------------------------------------------------------

--  
--  ***** IMPORTANT NOTE *****
--  Paste your entire main script *below this line*.
--  Nothing needs to be changed — it will run normally.
--

--  ---------------------------  
--  ** PASTE START **  
local keybinds = {
	MenuToggle = Enum.KeyCode.G,
	FlyToggle = Enum.KeyCode.F,
	InfJumpToggle = Enum.KeyCode.U,
	FullbrightToggle = Enum.KeyCode.L,
	ESPToggle = Enum.KeyCode.P,
	FlyUp = Enum.KeyCode.Space,
	FlyDown = Enum.KeyCode.LeftControl,
	Plrtp = nil
}

local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local walkSpeed = 16
local jumpPower = 50
local infJumpEnabled = false
local plrtotpto
local scripttorun = ""

local espEnabled = false
local fullbrightEnabled = false
local origLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient
}

local chatSpammerEnabled = false
local chatSpamText = "Hello!"
local chatSpamDelay = 1

local movementTab = ui:CreateTab("Movement", 1)
local visualTab = ui:CreateTab("Visuals", 2)
local funTab = ui:CreateTab("Fun", 3)
local settingsTab = ui:CreateTab("Settings", 5)
local miscTab = ui:CreateTab("Misc", 4)

local toggleControls = {}
local keybindControls = {}

local function setCharWalkJump()
	if plr.Character and plr.Character:FindFirstChild("Humanoid") then
		local hum = plr.Character.Humanoid
		hum.WalkSpeed = walkSpeed
		hum.JumpPower = jumpPower
		hum.UseJumpPower = true
	end
end

local function tptoplrrun()
	if game.Players:FindFirstChild(plrtotpto) then
		local realplr:Player = game.Players:FindFirstChild(plrtotpto)
		local char = realplr.Character or realplr.CharacterAdded:Wait()
		local mychar = plr.Character or plr.CharacterAdded:Wait()
		mychar:PivotTo(char:GetPivot())
	end
end

local function getplrnames()
	local names = {"None"}
	for _, plr2 in ipairs(game.Players:GetPlayers()) do
		table.insert(names, plr2.Name)
	end
	table.remove(names, table.find(names, plr.Name))
	return names
end

toggleControls["TpPlrPLR"] = miscTab:Dropdown("Plr", getplrnames(), function(v)
	plrtotpto = v
end)

toggleControls["TpPlrBUTTON"] = miscTab:Button("Tp", function()
	tptoplrrun()
end)

keybindControls["TpPlrKey"] = miscTab:Keybind("Tp Keybind", keybinds.Plrtp, function(k)
	keybinds.Plrtp = k
end)

toggleControls["Script"] = miscTab:TextInput("Script", function(v)
	scripttorun = v
end)

toggleControls["RunScript"] = miscTab:Button("Run", function()
	loadstring(scripttorun)
end)

toggleControls["Fly"] = movementTab:Toggle("Fly", function(v)
	flyEnabled = v
	fly.setfly(v)
	if not v then
		fly.setnoclip(false)
		noclipEnabled = false
	end
end)

keybindControls["FlyToggle"] = movementTab:Keybind("Fly Toggle", keybinds.FlyToggle, function(k)
	keybinds.FlyToggle = k
end)

movementTab:Slider("Fly Speed",1,200,50,function(v)
	flySpeed = v
	fly.setspeed(v)
end)

keybindControls["FlyUp"] = movementTab:Keybind("Fly Up", keybinds.FlyUp, function(k)
	keybinds.FlyUp = k
	fly.SetUpKeybind(k)
end)

keybindControls["FlyDown"] = movementTab:Keybind("Fly Down", keybinds.FlyDown, function(k)
	keybinds.FlyDown = k
	fly.SetDownKeybind(k)
end)

toggleControls["Noclip"] = movementTab:Toggle("Noclip", function(v)
	noclipEnabled = v
	if flyEnabled then
		fly.setnoclip(v)
	end
end)

movementTab:Slider("WalkSpeed",16,300,16,function(v)
	walkSpeed = v
	setCharWalkJump()
end)

movementTab:Slider("JumpPower",50,200,50,function(v)
	jumpPower = v
	setCharWalkJump()
end)

toggleControls["Infinite Jump"] = movementTab:Toggle("Infinite Jump", function(v)
	infJumpEnabled = v
end)

keybindControls["InfJumpToggle"] = movementTab:Keybind("Infinite Jump Key", keybinds.InfJumpToggle, function(k)
	keybinds.InfJumpToggle = k
end)

toggleControls["ESP"] = visualTab:Toggle("ESP", function(v)
	espEnabled = v
	if espEnabled then
		for _,p in pairs(plrs:GetPlayers()) do
			if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if not p.Character:FindFirstChild("ESP") then
					local hl = Instance.new("Highlight")
					hl.Name = "ESP"
					hl.Parent = p.Character
					hl.FillTransparency = 0.5
					hl.OutlineTransparency = 1
				end
			end
		end
	else
		for _,p in pairs(plrs:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("ESP") then
				p.Character.ESP:Destroy()
			end
		end
	end
end)

keybindControls["ESP"] = visualTab:Keybind("ESP Key", keybinds.ESPToggle, function(k)
	keybinds.ESPToggle = k
end)

toggleControls["Fullbright"] = visualTab:Toggle("Fullbright", function(v)
	fullbrightEnabled = v
	if v then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1e6
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.new(1,1,1)
	else
		Lighting.Brightness = origLighting.Brightness
		Lighting.ClockTime = origLighting.ClockTime
		Lighting.FogEnd = origLighting.FogEnd
		Lighting.GlobalShadows = origLighting.GlobalShadows
		Lighting.Ambient = origLighting.Ambient
	end
end)
--------------------------------------------------
local plrs = game.Players
local tagsOn = false

local function createTag(char, state)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local gui = Instance.new("BillboardGui")
	gui.Name = "Tag"
	gui.Size = UDim2.new(0,66.66,0,20)
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0
	gui.MaxDistance = 0
	gui.Adornee = hrp
	gui.Parent = hrp
	gui.Enabled = state

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.Text = char.Name
	label.Parent = gui
	label.TextColor3 = Color3.new(0, 0.168627, 0.92549)
	label.Font = Enum.Font.SourceSans
end

for _, p in ipairs(plrs:GetPlayers()) do
	if p ~= plr then
		local state = tagsOn
		p.CharacterAdded:Connect(function(c)
			createTag(c, state)
		end)
		if p.Character then
			createTag(p.Character, state)
		end
	end
end

plrs.PlayerAdded:Connect(function(p)
	if p ~= plr then
		p.CharacterAdded:Connect(function(c)
			createTag(c)
		end)
	end
end)

local function toggleTags(state)
	tagsOn = state
	for _, p in ipairs(plrs:GetPlayers()) do
		if p.Character then
			local hpr = p.Character:FindFirstChild("HumanoidRootPart")
			if hpr then
				for _, gui in ipairs(hpr:GetChildren()) do
					if gui.Name == "Tag" then
						gui.Enabled = tagsOn
					end
				end
			end
		end
	end
end-----------------------------------------------

keybindControls["Fullbright"] = visualTab:Keybind("Fullbright Key", keybinds.FullbrightToggle, function(k)
	keybinds.FullbrightToggle = k
end)

toggleControls["Player Tags"] = visualTab:Toggle("Player Tags", function(v)
	toggleTags(v)
end)

funTab:TextInput("Chat Spam Text", function(v) chatSpamText = v end)
funTab:Slider("Spam Delay", 1, 50, 10, function(v) chatSpamDelay = v/10 end)
funTab:Button("Start Chat Spam", function()
	if not chatSpammerEnabled then
		chatSpammerEnabled = true
	end
end)
funTab:Button("Stop Chat Spam", function()
	chatSpammerEnabled = false
end)

keybindControls["MenuToggle"] = settingsTab:Keybind("Open/Close Menu", keybinds.MenuToggle, function(k)
	keybinds.MenuToggle = k
end)
settingsTab:Button("Destroy UI", function() ui:DestroyAll() end)
settingsTab:Slider("UI Scale", 1, 10, 5, function(val)
	local realScale = val / 5
	ui.ScreenFrame.Size = UDim2.new(0, math.ceil(280 * realScale) + 1, 0, math.ceil(300 * realScale) + 1)
end)

local function isBinding()
	for _,v in pairs(ui.ScreenFrame:GetDescendants()) do
		if v:IsA("TextButton") and v.Text == "Press Key..." then
			return true
		end
	end
	return false
end

local function safeSetToggle(name, state)
	local ctrl = toggleControls[name]
	if ctrl and ctrl.Set then
		ctrl.Set(state)
	else
		for _,tab in pairs(ui.tabs) do
			for _,c in pairs(tab.sc:GetChildren()) do
				if c:IsA("Frame") then
					local btn = c:FindFirstChildOfClass("TextButton")
					if btn and btn.Text:match("^" .. name) then
						btn.Text = name .. " " .. (state and "ON" or "OFF")
					end
				end
			end
		end
	end
end

UserInputService.InputBegan:Connect(function(input,gp)
	if gp then return end
	if isBinding() then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local k = input.KeyCode

	if k == keybinds.MenuToggle then
		ui.Screen.Enabled = not ui.Screen.Enabled
	end

	if k == keybinds.FlyToggle then
		flyEnabled = not flyEnabled
		fly.setfly(flyEnabled)
		if not flyEnabled then
			fly.setnoclip(false)
			noclipEnabled = false
		end
		safeSetToggle("Fly", flyEnabled)
	end

	if k == keybinds.FlyUp and flyEnabled then
		fly.SetUpKeybind(k)
		fly.SetDownKeybind(keybinds.FlyDown)
	end

	if k == keybinds.FlyDown and flyEnabled then
		fly.SetDownKeybind(k)
		fly.SetUpKeybind(keybinds.FlyUp)
	end

	if k == keybinds.InfJumpToggle then
		infJumpEnabled = not infJumpEnabled
		safeSetToggle("Infinite Jump", infJumpEnabled)
	end

	if k == keybinds.FullbrightToggle then
		fullbrightEnabled = not fullbrightEnabled
		safeSetToggle("Fullbright", fullbrightEnabled)
		if fullbrightEnabled then
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 1e6
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.new(1,1,1)
		else
			Lighting.Brightness = origLighting.Brightness
			Lighting.ClockTime = origLighting.ClockTime
			Lighting.FogEnd = origLighting.FogEnd
			Lighting.GlobalShadows = origLighting.GlobalShadows
			Lighting.Ambient = origLighting.Ambient
		end
	end

	if k == keybinds.ESPToggle then
		espEnabled = not espEnabled
		safeSetToggle("ESP", espEnabled)
		if espEnabled then
			for _,p in pairs(plrs:GetPlayers()) do
				if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					if not p.Character:FindFirstChild("ESP") then
						local hl = Instance.new("Highlight")
						hl.Name = "ESP"
						hl.Parent = p.Character
						hl.FillTransparency = 0.5
						hl.OutlineTransparency = 1
					end
				end
			end
		else
			for _,p in pairs(plrs:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("ESP") then
					p.Character.ESP:Destroy()
				end
			end
		end
	end

	if k == keybinds.Plrtp then
		tptoplrrun()
	end
end)

UserInputService.InputEnded:Connect(function(input,gp)
	if gp then return end
end)

local function setup(char)
	local hum = char:WaitForChild("Humanoid")
	UserInputService.JumpRequest:Connect(function()
		if infJumpEnabled then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
	setCharWalkJump()
	if flyEnabled then
		fly.setfly(true)
		fly.setnoclip(noclipEnabled)
		fly.setspeed(flySpeed)
	end
end

if plr.Character then
	setup(plr.Character)
end

plr.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	setup(char)
	ui.Screen.Enabled = true
	fly.setfly(false)  -- turn off flying on respawn
	flyEnabled = false -- make the toggle reflect that
	safeSetToggle("Fly", false)
end)

RunService.RenderStepped:Connect(function()
	if flyEnabled then
		fly.setspeed(flySpeed)
		fly.setnoclip(noclipEnabled)
	end
end)

task.spawn(function()
	while true do
		if chatSpammerEnabled and chatSpamText ~= "" then
			--TCS.TextChannels.RBXSystem:DisplaySystemMessage(plr.Name..": "..chatSpamText)
			channel:SendAsync(chatSpamText)
		end
		task.wait(chatSpamDelay)
	end
end)

game.Players.PlayerAdded:Connect(function(newplr)
	newplr.CharacterAdded:Connect(function(newchar)
		if espEnabled then
			if not newchar:FindFirstChild("ESP") then
				local hl = Instance.new("Highlight")
				hl.Name = "ESP"
				hl.Parent = newchar
				hl.FillTransparency = 0.5
				hl.OutlineTransparency = 1
			end
		end
	end)
end)

--  ---------------------------  
--  ** PASTE END **  
--  ---------------------------  



--------------------------------------------------------
-- END OF MERGED SINGLE FILE
--------------------------------------------------------
