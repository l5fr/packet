local Packet = InitScreen()
function Packet:Window(Window)
	Window = GetType(Window,{},"table")
	Window.Name = GetType(Window.Name,"Window","string")
	Window.Color = GetType(Window.Color,Color3.new(1,0.5,0.25),"Color3")
	Window.Size = GetType(Window.Size,UDim2.new(0,496,0,496),"UDim2")
	Window.Position = GetType(Window.Position,UDim2.new(0.5,-248,0.5,-248),"UDim2")
	Window.Enabled = GetType(Window.Enabled,true,"boolean")

	Window.RainbowHue = 0
	Window.Colorable = {}
	Window.Elements = {}
	Window.Flags = {}

	local WindowAsset = InitWindow(Packet.ScreenAsset,Window)
	function Window:Tab(Tab)
		Tab = GetType(Tab,{},"table")
		Tab.Name = GetType(Tab.Name,"Tab","string")
		local ChooseTab = InitTab(Packet.ScreenAsset,WindowAsset,Window,Tab)
        
        -- ... (rest of the function stays the same, just change Bracket.ScreenAsset to Packet.ScreenAsset throughout)
    end
    return Window
end

function Packet:TableToColor(Table)
	if type(Table) ~= "table" then return Table end
	return Color3.fromHSV(Table[1],Table[2],Table[3])
end

function Packet:Notification(Notification)
	Notification = GetType(Notification,{},"table")
	Notification.Title = GetType(Notification.Title,"Title","string")
	Notification.Description = GetType(Notification.Description,"Description","string")

	local NotificationAsset = GetAsset("Notification/ND")
	NotificationAsset.Parent = Packet.ScreenAsset.NDHandle
    -- ... rest stays the same
end

function Packet:Notification2(Notification)
	Notification = GetType(Notification,{},"table")
	Notification.Title = GetType(Notification.Title,"Title","string")
	Notification.Duration = GetType(Notification.Duration,5,"number")
	Notification.Color = GetType(Notification.Color,Color3.new(1,0.5,0.25),"Color3")

	local NotificationAsset = GetAsset("Notification/NL")
	NotificationAsset.Parent = Packet.ScreenAsset.NLHandle
    -- ... rest stays the same
end

return Packet
