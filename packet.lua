local Packet = loadstring(game:HttpGet("https://raw.githubusercontent.com/l5fr/packet/main/packet.lua"))()

-- Create the GUI Window
local Window = Packet:Window({
    Name = "Packet 1.1",
    Enabled = true,
    Color = Color3.new(1, 0.5, 0.25),
    Size = UDim2.new(0, 496, 0, 496),
    Position = UDim2.new(0.5, -248, 0.5, -248)
})

-- Create a Tab
local MainTab = Window:Tab({Name = "Main"})

-- Add a Divider
MainTab:Divider({Text = "Auto Features", Side = "Left"})

-- Add a Toggle
local AutoBuyToggle = MainTab:Toggle({
    Name = "Auto Buy: OFF",
    Side = "Left",
    Value = false,
    Callback = function(Value)
        local status = Value and "ON" or "OFF"
        AutoBuyToggle:ChangeName("Auto Buy: " .. status)
        Packet:Notification({
            Title = "Auto Buy",
            Content = Value and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

-- Add another Toggle
local AutoUpgradeToggle = MainTab:Toggle({
    Name = "Auto Upgrade: OFF",
    Side = "Left",
    Value = false,
    Callback = function(Value)
        local status = Value and "ON" or "OFF"
        AutoUpgradeToggle:ChangeName("Auto Upgrade: " .. status)
        Packet:Notification({
            Title = "Auto Upgrade",
            Content = Value and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

-- Add a Button
MainTab:Button({
    Name = "Click Me",
    Side = "Left",
    Callback = function()
        Packet:Notification({
            Title = "Button",
            Content = "You clicked the button!",
            Duration = 2
        })
    end
})

-- Add a Section on the Right side
local StatusSection = MainTab:Section({Name = "Status", Side = "Right"})
StatusSection:Label({Text = "Ready to go!"})

-- Success notification
Packet:Notification({
    Title = "Packet 1.1",
    Content = "GUI Loaded Successfully!",
    Duration = 3
})
