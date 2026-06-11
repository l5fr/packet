-- Packet GUI Library (Based on Bracket but renamed)
local Packet = {}

-- Simple notification function
function Packet:Notification(data)
    data = data or {}
    local title = data.Title or "Notification"
    local content = data.Content or data.Description or ""
    local duration = data.Duration or 3
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = content,
        Duration = duration
    })
end

function Packet:Notification2()
    -- Placeholder for second notification type
end

-- Simple Window creation
function Packet:Window(data)
    local window = {}
    window.Name = data.Name or "Window"
    window.Enabled = data.Enabled ~= false
    window.Color = data.Color or Color3.new(1, 0.5, 0.25)
    window.Size = data.Size or UDim2.new(0, 496, 0, 496)
    window.Position = data.Position or UDim2.new(0.5, -248, 0.5, -248)
    
    -- Create a simple ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Packet_GUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Create main frame
    local frame = Instance.new("Frame")
    frame.Size = window.Size
    frame.Position = window.Position
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = window.Color
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = window.Name
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 14
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab container (simplified)
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = frame
    
    -- Scrollable content area
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
    window.Flags = {}
    
    function window:Tab(tabData)
        local tab = {}
        tab.Name = tabData.Name or "Tab"
        
        function tab:Divider(dividerData)
            local divider = Instance.new("TextLabel")
            divider.Size = UDim2.new(1, 0, 0, 25)
            divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            divider.Text = dividerData.Text or ""
            divider.TextColor3 = Color3.new(1, 1, 1)
            divider.Font = Enum.Font.GothamBold
            divider.TextSize = 12
            divider.Parent = scrollFrame
            return divider
        end
        
        function tab:Label(labelData)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = labelData.Text or ""
            label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.Parent = scrollFrame
            return label
        end
        
        function tab:Button(buttonData)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 30)
            button.BackgroundColor3 = window.Color
            button.Text = buttonData.Name or "Button"
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 12
            button.Parent = scrollFrame
            
            button.MouseButton1Click:Connect(function()
                if buttonData.Callback then
                    buttonData.Callback()
                end
            end)
            
            function button:ChangeName(newName)
                button.Text = newName
            end
            
            return button
        end
        
        function tab:Toggle(toggleData)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 30)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = scrollFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -40, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleData.Name or "Toggle"
            label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.Parent = toggleFrame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 30, 1, 0)
            toggleBtn.Position = UDim2.new(1, -30, 0, 0)
            toggleBtn.BackgroundColor3 = toggleData.Value and window.Color or Color3.fromRGB(60, 60, 70)
            toggleBtn.Text = toggleData.Value and "ON" or "OFF"
            toggleBtn.TextColor3 = Color3.new(1, 1, 1)
            toggleBtn.TextSize = 10
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Parent = toggleFrame
            
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
                end
            }
            
            return toggleObject
        end
        
        function tab:Slider(sliderData)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = scrollFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = sliderData.Name or "Slider"
            label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.Parent = sliderFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -50, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(sliderData.Value or 50)
            valueLabel.TextColor3 = window.Color
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextSize = 12
            valueLabel.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, 0, 0, 4)
            sliderBar.Position = UDim2.new(0, 0, 0, 25)
            sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            sliderBar.Parent = sliderFrame
            
            local fill = Instance.new("Frame")
            local percent = ((sliderData.Value or 50) - (sliderData.Min or 0)) / ((sliderData.Max or 100) - (sliderData.Min or 0))
            fill.Size = UDim2.new(percent, 0, 1, 0)
            fill.BackgroundColor3 = window.Color
            fill.Parent = sliderBar
            
            return {}
        end
        
        function tab:Textbox(textboxData)
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Size = UDim2.new(1, 0, 0, 50)
            textboxFrame.BackgroundTransparency = 1
            textboxFrame.Parent = scrollFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = textboxData.Name or "Textbox"
            label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.Parent = textboxFrame
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, 0, 0, 25)
            textBox.Position = UDim2.new(0, 0, 0, 22)
            textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            textBox.Text = textboxData.Text or ""
            textBox.PlaceholderText = textboxData.Placeholder or "Input here"
            textBox.TextColor3 = Color3.new(1, 1, 1)
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 12
            textBox.Parent = textboxFrame
            
            return {}
        end
        
        function tab:Section(sectionData)
            local section = {}
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = scrollFrame
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Size = UDim2.new(1, 0, 0, 25)
            sectionTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            sectionTitle.Text = sectionData.Name or "Section"
            sectionTitle.TextColor3 = Color3.new(1, 1, 1)
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 12
            sectionTitle.Parent = sectionFrame
            
            local sectionContent = Instance.new("Frame")
            sectionContent.Size = UDim2.new(1, -10, 0, 0)
            sectionContent.Position = UDim2.new(0, 5, 0, 25)
            sectionContent.BackgroundTransparency = 1
            sectionContent.Parent = sectionFrame
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Padding = UDim.new(0, 5)
            sectionLayout.Parent = sectionContent
            
            function section:Divider(dividerData)
                local divider = Instance.new("TextLabel")
                divider.Size = UDim2.new(1, 0, 0, 20)
                divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                divider.Text = dividerData.Text or ""
                divider.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                divider.Font = Enum.Font.Gotham
                divider.TextSize = 11
                divider.Parent = sectionContent
                return divider
            end
            
            function section:Label(labelData)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 20)
                label.BackgroundTransparency = 1
                label.Text = labelData.Text or ""
                label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.TextSize = 11
                label.Parent = sectionContent
                return label
            end
            
            function section:Button(buttonData)
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 25)
                button.BackgroundColor3 = window.Color
                button.Text = buttonData.Name or "Button"
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Font = Enum.Font.GothamBold
                button.TextSize = 11
                button.Parent = sectionContent
                
                button.MouseButton1Click:Connect(function()
                    if buttonData.Callback then
                        buttonData.Callback()
                    end
                end)
                return button
            end
            
            function section:Toggle(toggleData)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, 0, 0, 25)
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Parent = sectionContent
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -35, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = toggleData.Name or "Toggle"
                label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.TextSize = 11
                label.Parent = toggleFrame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 25, 1, 0)
                toggleBtn.Position = UDim2.new(1, -25, 0, 0)
                toggleBtn.BackgroundColor3 = toggleData.Value and window.Color or Color3.fromRGB(60, 60, 70)
                toggleBtn.Text = toggleData.Value and "ON" or "OFF"
                toggleBtn.TextColor3 = Color3.new(1, 1, 1)
                toggleBtn.TextSize = 9
                toggleBtn.Font = Enum.Font.GothamBold
                toggleBtn.Parent = toggleFrame
                
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
            
            function section:Slider(sliderData)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 40)
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Parent = sectionContent
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 15)
                label.BackgroundTransparency = 1
                label.Text = sliderData.Name or "Slider"
                label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.TextSize = 11
                label.Parent = sliderFrame
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Size = UDim2.new(1, 0, 0, 4)
                sliderBar.Position = UDim2.new(0, 0, 0, 20)
                sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                sliderBar.Parent = sliderFrame
                
                local fill = Instance.new("Frame")
                local percent = ((sliderData.Value or 50) - (sliderData.Min or 0)) / ((sliderData.Max or 100) - (sliderData.Min or 0))
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = window.Color
                fill.Parent = sliderBar
                
                return {}
            end
            
            function section:Textbox(textboxData)
                local textboxFrame = Instance.new("Frame")
                textboxFrame.Size = UDim2.new(1, 0, 0, 45)
                textboxFrame.BackgroundTransparency = 1
                textboxFrame.Parent = sectionContent
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 15)
                label.BackgroundTransparency = 1
                label.Text = textboxData.Name or "Textbox"
                label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.TextSize = 11
                label.Parent = textboxFrame
                
                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(1, 0, 0, 25)
                textBox.Position = UDim2.new(0, 0, 0, 17)
                textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                textBox.Text = textboxData.Text or ""
                textBox.PlaceholderText = textboxData.Placeholder or "Input here"
                textBox.TextColor3 = Color3.new(1, 1, 1)
                textBox.Font = Enum.Font.Gotham
                textBox.TextSize = 11
                textBox.Parent = textboxFrame
                
                return {}
            end
            
            -- Update section height
            local function updateHeight()
                task.wait()
                local contentHeight = sectionContent.AbsoluteContentSize.Y
                sectionFrame.Size = UDim2.new(1, 0, 0, 25 + contentHeight + 10)
            end
            sectionContent:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateHeight)
            task.spawn(updateHeight)
            
            return section
        end
        
        -- Update scroll frame canvas size
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

return Packet
