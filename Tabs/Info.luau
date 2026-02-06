Info_Tab = Window:Tab({
	Title = "Info",
	Icon = "info", -- optional
	Locked = false,
})
local textlabel:TextLabel = game.Workspace:WaitForChild("Map").Campground.NoticeBoard.OtherWarning.Part.SurfaceGui.Frame.Title
local Info_Biome = "Snow"
if textlabel.Text == "MOVE LEFT OR RIGHT TO DODGE ITS CHARGE" then
    Info_Biome = "Volcano"
else
    Info_Biome = "Snow"
end
local Info_Info = Info_Tab:Paragraph({
    Title = "Info",
    Desc = "Biome: "..Info_Biome,
    Color = "Grey",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})
