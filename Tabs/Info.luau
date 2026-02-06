Info_Tab = Window:Tab({
	Title = "Info",
	Icon = "info", -- optional
	Locked = false,
})
local Info_Biome = Info_Tab:Paragraph({
    Title = "Paragraph with Image, Thumbnail, Buttons",
    Desc = "Test Paragraph",
    Color = "Grey",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})
