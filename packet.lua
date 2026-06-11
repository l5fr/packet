local Packet = {}

-- Create a simple GUI from scratch
function Packet:Window(data)
    local window = {}
    window.Name = data.Name or "Window"
    window.Color = data.Color or Color3.new(1, 0.5, 0.25)
    window.Size = data.Size or UDim2.new(0, 496, 0, 496)
    window.Position = data.Position or UDim2.new(0.5, -248, 0.5, -248)
    
    -- Create ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "Packet_GUI"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Size = window.Size
    frame.Position = window.Position
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = window.Color
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 1, 0)
    title.Position = UDim2.new(0, 5, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = window.Name
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 14
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = frame
    
    -- Scroll Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Parent = tabContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    window.Elements = {}
    window.Tabs = {}
    
    function window:Tab(tabData)
        local tab = {}
        tab.Name = tabData.Name or "Tab"
        
        function tab:Divider(dividerData)
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 25)
            div.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            div.Parent = scrollFrame
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = dividerData.Text or ""
            text.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            text.Font = Enum.Font.GothamBold
            text.TextSize = 12
            text.Parent = div
            return div
        end
        
        function tab:Label(labelData)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = labelData.Text or ""
            label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.Parent = scrollFrame
            return label
        end
        
        function tab:Button(buttonData)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = window.Color
            btn.Text = buttonData.Name or "Button"
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.Parent = scrollFrame
            btn.MouseButton1Click:Connect(function()
                if buttonData.Callback then
                    buttonData.Callback()
                end
            end)
            
            function btn:ChangeName(newName)
                btn.Text = newName
            end
            return btn
        end
        
        function tab:Toggle(toggleData)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 30)
            frame.BackgroundTransparency = 1
            frame.Parent = scrollFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -40, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleData.Name or "Toggle"
            label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.Parent = frame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 35, 1, 0)
            toggleBtn.Position = UDim2.new(1, -35, 0, 0)
            toggleBtn.BackgroundColor3 = toggleData.Value and window.Color or Color3.fromRGB(60, 60, 70)
            toggleBtn.Text = toggleData.Value and "ON" or "OFF"
            toggleBtn.TextColor3 = Color3.new(1, 1, 1)
            toggleBtn.TextSize = 11
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Parent = frame
            
            local value = toggleData.Value or false
            
            toggleBtn.MouseButton1Click:Connect(function()
                value = not value
                toggleBtn.BackgroundColor3 = value and window.Color or Color3.fromRGB(60, 60, 70)
                toggleBtn.Text = value and "ON" or "OFF"
                if toggleData.Callback then
                    toggleData.Callback(value)
                end
            end)
            
            local toggleObject = {
                ChangeName = function(self, newName)
                    label.Text = newName
                end,
                SetValue = function(self, newValue)
                    value = newValue
                    toggleBtn.BackgroundColor3 = value and window.Color or Color3.fromRGB(60, 60, 70)
                    toggleBtn.Text = value and "ON" or "OFF"
                end
            }
            return toggleObject
        end
        
        function tab:Section(sectionData)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = scrollFrame
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Size = UDim2.new(1, 0, 0, 25)
            sectionTitle.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
            sectionTitle.Text = sectionData.Name or "Section"
            sectionTitle.TextColor3 = Color3.new(1, 1, 1)
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 12
            sectionTitle.Parent = sectionFrame
            
            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, -10, 0, 0)
            content.Position = UDim2.new(0, 5, 0, 25)
            content.BackgroundTransparency = 1
            content.Parent = sectionFrame
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 5)
            contentLayout.Parent = content
            
            local section = {}
            
            function section:Label(labelData)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 20)
                label.BackgroundTransparency = 1
                label.Text = labelData.Text or ""
                label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.TextSize = 11
                label.Parent = content
                return label
            end
            
            function section:Button(buttonData)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.BackgroundColor3 = window.Color
                btn.Text = buttonData.Name or "Button"
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 11
                btn.Parent = content
                btn.MouseButton1Click:Connect(function()
                    if buttonData.Callback then
                        buttonData.Callback()
                    end
                end)
                return btn
            end
            
            function section:Divider(dividerData)
                local div = Instance.new("Frame")
                div.Size = UDim2.new(1, 0, 0, 20)
                div.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                div.Parent = content
                
                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = dividerData.Text or ""
                text.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                text.Font = Enum.Font.Gotham
                text.TextSize = 11
                text.Parent = div
                return div
            end
            
            function section:Toggle(toggleData)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 25)
                frame.BackgroundTransparency = 1
                frame.Parent = content
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -35, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = toggleData.Name or "Toggle"
                label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.TextSize = 11
                label.Parent = frame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 30, 1, 0)
                toggleBtn.Position = UDim2.new(1, -30, 0, 0)
                toggleBtn.BackgroundColor3 = toggleData.Value and window.Color or Color3.fromRGB(60, 60, 70)
                toggleBtn.Text = toggleData.Value and "ON" or "OFF"
                toggleBtn.TextColor3 = Color3.new(1, 1, 1)
                toggleBtn.TextSize = 9
                toggleBtn.Font = Enum.Font.GothamBold
                toggleBtn.Parent = frame
                
                local value = toggleData.Value or false
                
                toggleBtn.MouseButton1Click:Connect(function()
                    value = not value
                    toggleBtn.BackgroundColor3 = value and window.Color or Color3.fromRGB(60, 60, 70)
                    toggleBtn.Text = value and "ON" or "OFF"
                    if toggleData.Callback then
                        toggleData.Callback(value)
                    end
                end)
                return {}
            end
            
            -- Update height
            local function updateHeight()
                task.wait()
                sectionFrame.Size = UDim2.new(1, 0, 0, 25 + content.AbsoluteContentSize.Y + 10)
            end
            content:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeight)
            task.spawn(updateHeight)
            
            return section
        end
        
        -- Update scroll canvas
        local function updateCanvas()
            task.wait()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.AbsoluteContentSize.Y + 10)
        end
        scrollFrame:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        task.spawn(updateCanvas)
        
        return tab
    end
    
    return window
end

function Packet:Notification(notification)
    notification = notification or {}
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = notification.Title or "Packet",
        Text = notification.Content or notification.Description or "",
        Duration = notification.Duration or 3
    })
end

function Packet:Notification2()
    -- Placeholder
end

return Packet
