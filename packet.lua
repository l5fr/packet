local Packet = loadstring(game:HttpGet("https://raw.githubusercontent.com/l5fr/packet/main/packet.lua"))()
Packet:Notification() Packet:Notification2()

local Window = Packet:Window({
    Name = "Packet 1.1",
    Enabled = true,
    Color = Color3.new(1, 0.5, 0.25),
    Size = UDim2.new(0, 496, 0, 496),
    Position = UDim2.new(0.5, -248, 0.5, -248)
}) do

    local Tab = Window:Tab({Name = "Main"}) do

        Tab:Divider({Text = "Auto Features", Side = "Left"})

        -- Auto Buy Toggle with ON/OFF display
        local AutoBuyToggle = Tab:Toggle({
            Name = "Auto Buy: OFF",
            Side = "Left",
            Value = false,
            Callback = function(Value)
                local status = Value and "ON" or "OFF"
                AutoBuyToggle:ChangeName("Auto Buy: " .. status)
                Packet:Notification({
                    Title = "Auto Buy",
                    Content = Value and "Enabled" or "Disabled",
                    Duration = 3
                })
            end
        })

        -- Auto Upgrade Toggle with ON/OFF display
        local AutoUpgradeToggle = Tab:Toggle({
            Name = "Auto Upgrade: OFF",
            Side = "Left",
            Value = false,
            Callback = function(Value)
                local status = Value and "ON" or "OFF"
                AutoUpgradeToggle:ChangeName("Auto Upgrade: " .. status)
                Packet:Notification({
                    Title = "Auto Upgrade",
                    Content = Value and "Enabled" or "Disabled",
                    Duration = 3
                })
            end
        })

        -- Auto Fruit Toggle with ON/OFF display
        local AutoFruitToggle = Tab:Toggle({
            Name = "Auto Fruit: OFF",
            Side = "Left",
            Value = false,
            Callback = function(Value)
                local status = Value and "ON" or "OFF"
                AutoFruitToggle:ChangeName("Auto Fruit: " .. status)
                Packet:Notification({
                    Title = "Auto Fruit",
                    Content = Value and "Enabled" or "Disabled",
                    Duration = 3
                })
            end
        })

        -- Auto Rebirth Toggle with ON/OFF display
        local AutoRebirthToggle = Tab:Toggle({
            Name = "Auto Rebirth: OFF",
            Side = "Left",
            Value = false,
            Callback = function(Value)
                local status = Value and "ON" or "OFF"
                AutoRebirthToggle:ChangeName("Auto Rebirth: " .. status)
                Packet:Notification({
                    Title = "Auto Rebirth",
                    Content = Value and "Enabled" or "Disabled",
                    Duration = 3
                })
            end
        })

        -- Auto Evolve Toggle with ON/OFF display
        local AutoEvolveToggle = Tab:Toggle({
            Name = "Auto Evolve: OFF",
            Side = "Left",
            Value = false,
            Callback = function(Value)
                local status = Value and "ON" or "OFF"
                AutoEvolveToggle:ChangeName("Auto Evolve: " .. status)
                Packet:Notification({
                    Title = "Auto Evolve",
                    Content = Value and "Enabled" or "Disabled",
                    Duration = 3
                })
            end
        })

        -- Auto Power Level Toggle with ON/OFF display
        local AutoPowerLevelToggle = Tab:Toggle({
            Name = "Auto Power Level: OFF",
            Side = "Left",
            Value = false,
            Callback = function(Value)
                local status = Value and "ON" or "OFF"
                AutoPowerLevelToggle:ChangeName("Auto Power Level: " .. status)
                Packet:Notification({
                    Title = "Auto Power Level",
                    Content = Value and "Enabled" or "Disabled",
                    Duration = 3
                })
            end
        })

        Tab:Divider({Text = "Sewer Utilities", Side = "Left"})

        Tab:Button({
            Name = "Pull All Levers",
            Side = "Left",
            Callback = function()
                Packet:Notification({
                    Title = "Pull All Levers",
                    Content = "Pulled levers!",
                    Duration = 3
                })
            end
        })

        Tab:Button({
            Name = "Vine Harvest",
            Side = "Left",
            Callback = function()
                Packet:Notification({
                    Title = "Vine Harvest",
                    Content = "Harvesting vines...",
                    Duration = 3
                })
            end
        })

        Tab:Button({
            Name = "Teleport to Sewer Alien",
            Side = "Left",
            Callback = function()
                Packet:Notification({
                    Title = "Teleport",
                    Content = "Teleported to Sewer Alien",
                    Duration = 3
                })
            end
        })

        local Section = Tab:Section({Name = "Settings", Side = "Right"}) do
            Section:Divider()
            Section:Label({Text = "Status: Ready"})
            Section:Button({
                Name = "Destroy GUI",
                Callback = function()
                    Window:Toggle(false)
                    Packet:Notification({
                        Title = "Packet 1.1",
                        Content = "GUI Destroyed",
                        Duration = 2
                    })
                    task.wait(2)
                    Window = nil
                end
            })
        end
    end
end

Packet:Notification({
    Title = "Packet 1.1",
    Content = "Loaded Successfully!",
    Duration = 5
})
Packet:Notification2()
