Kid_Tab = Window:Tab({
	Title = "Kids",
	Icon = "baby", -- optional
	Locked = false,
})
local Kid_Selectedkids
local Dropdown = Kid_Tab:Dropdown({
	Title = "Kids",
	Desc = "Kids to get",
	Values = {"Kid1", "Kid2", "Kid3", "Kid4"},
	Value = {"Kid1", "Kid2", "Kid3", "Kid4"},
	Multi = true,
	AllowNone = true,
	Callback = function(option)
		Kid_Selectedkids = option
		print("Categories selected: " .. game:GetService("HttpService"):JSONEncode(option)) 
	end
})
local Button = Kid_Tab:Button({
	Title = "Save children",
	Desc = "Saves the selected children",
	Locked = false,
	Callback = function()
		local kidids = {"DinoKid", "KoalaKid", "KrakenKid", "SquidKid"}
		local kids = {}
		for _, character in ipairs(game.Workspace:WaitForChild("Characters"):GetChildren()) do
			if character:GetAttribute("NPCType") == "Lost Child" then
				if character:GetAttribute("Lost") then
					if table.find(Kid_Selectedkids, "Kid"..tostring(table.find(kidids, character:GetAttribute("KidId")))) then
						local head:Part = character:FindFirstChild("Head")
						local attachment = head:FindFirstChild("ProximityAttachment")
						local prox:ProximityPrompt = attachment:FindFirstChild("ProximityInteraction")
						FireProx(prox)
					end
				end
			end
		end
	end
})