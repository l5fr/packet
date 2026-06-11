-- Load the Packet library (which is actually the Bracket library)
local Packet = loadstring(game:HttpGet("https://raw.githubusercontent.com/l5fr/packet/main/packet.lua"))()

if not Packet then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Failed to load Packet library!",
        Duration = 5
    })
    return
end

-- Now add ALL your auto-farm features
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Find Tycoon
local userTycoon = (function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Folder") and v.Name:match("Tycoon%d") then
            if v:FindFirstChild("Owner") and v.Owner.Value == LocalPlayer then
                return v
            end
        end
    end
end)()

-- Variables
local AutoBuy = false
local AutoUpgrade = false
local AutoFruit = false
local AutoRebirth = false
local AutoEvolve = false
local AutoPowerLevel = false

-- Counters
local stats = { buys = 0, upgrades = 0, fruit = 0, rebirths = 0, evolves = 0 }

-- Notification function
local function Notify(title, content)
    pcall(function()
        Packet:Notification({ Title = title, Content = content, Duration = 3 })
    end)
end

-- Update toggle button names
local function UpdateToggleName(button, name, value)
    local status = value and "ON" or "OFF"
    pcall(function() button:ChangeName(name .. ": " .. status) end)
end

-- AUTO BUY
local function buyAllAffordable()
    if not userTycoon then return end
    local purchases = userTycoon:FindFirstChild("Purchases")
    if not purchases then return end
    
    for _, obj in ipairs(purchases:GetDescendants()) do
        if obj:IsA("Model") then
            local shown = obj:GetAttribute("Shown")
            local purchased = obj:GetAttribute("Purchased")
            if shown == true and purchased ~= true then
                local purchase = obj:FindFirstChild("Purchase")
                if purchase and purchase:IsA("RemoteFunction") then
                    pcall(function() purchase:InvokeServer() end)
                    stats.buys = stats.buys + 1
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.05)
        if AutoBuy and userTycoon then pcall(buyAllAffordable) end
    end
end)

-- AUTO UPGRADE
local upgradeRemotes = {}
local upgradeLevel = {}
local lastUpgradeScan = 0

local function refreshUpgradeRemotes()
    if not userTycoon then return end
    upgradeRemotes = {}
    upgradeLevel = {}
    local purchases = userTycoon:FindFirstChild("Purchases")
    if not purchases then return end
    for _, obj in ipairs(purchases:GetDescendants()) do
        if obj:IsA("RemoteFunction") and obj.Name == "Upgrade" then
            upgradeRemotes[#upgradeRemotes + 1] = obj
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.25)
        if AutoUpgrade and userTycoon then
            if tick() - lastUpgradeScan > 3 then
                refreshUpgradeRemotes()
                lastUpgradeScan = tick()
            end
            for _, remote in ipairs(upgradeRemotes) do
                if remote.Parent then
                    local lvl = (upgradeLevel[remote] or 0) + 1
                    while lvl <= 100 do
                        local ok, res = pcall(function() return remote:InvokeServer(lvl) end)
                        if (not ok) or res == false then break end
                        upgradeLevel[remote] = lvl
                        stats.upgrades = stats.upgrades + 1
                        lvl = lvl + 1
                    end
                end
            end
        end
    end
end)

-- AUTO POWER LEVEL
local function getPowerLevelRemote()
    if not userTycoon then return nil end
    local remotes = userTycoon:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("UpgradePowerLevel")
end

task.spawn(function()
    while true do
        task.wait(0.25)
        if AutoPowerLevel then
            local remote = getPowerLevelRemote()
            if remote then pcall(function() remote:InvokeServer() end) end
        end
    end
end)

-- AUTO REBIRTH
local RebirthGainMultiple = 1.0
local MinPotential = 1
local RebirthCooldown = 2
local RebirthTimeout = 8
local rebirthBusy = false

local function getRebirthRemote()
    if not userTycoon then return nil end
    local remotes = userTycoon:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("Rebirth")
end

local function getRebirthedSignal()
    if not userTycoon then return nil end
    local remotes = userTycoon:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("Rebirthed")
end

local NUM_SCALE = {
    thousand=1e3, million=1e6, billion=1e9, trillion=1e12, quadrillion=1e15,
    quintillion=1e18, sextillion=1e21, septillion=1e24, octillion=1e27,
    nonillion=1e30, decillion=1e33, undecillion=1e36, duodecillion=1e39,
    tredecillion=1e42, quattuordecillion=1e45, quindecillion=1e48,
    sexdecillion=1e51, septendecillion=1e54, octodecillion=1e57,
    novemdecillion=1e60, vigintillion=1e63,
    k=1e3, m=1e6, b=1e9, t=1e12, qd=1e15, qn=1e18, sx=1e21, sp=1e24,
}

local function parseNumber(s)
    if not s then return nil end
    s = tostring(s):gsub(",", ""):lower()
    local num = s:match("[%d%.]+")
    local val = num and tonumber(num)
    if not val then return nil end
    local word = s:match("[%d%.%s]+([a-z]+)")
    if word and NUM_SCALE[word] then val = val * NUM_SCALE[word] end
    return val
end

local function investorBody()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local r = pg and pg:FindFirstChild("Rebirth")
    local im = r and r:FindFirstChild("InvestorsMenu")
    return im and im:FindFirstChild("Body")
end

local function readQuantity(frameName)
    local body = investorBody()
    local frame = body and body:FindFirstChild(frameName)
    local q = frame and frame:FindFirstChild("Quantity")
    return q and parseNumber(q.Text)
end

local function getCurrentInvestors() return readQuantity("Amount") or 0 end
local function getPotentialInvestors() return readQuantity("Potential") end

task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoRebirth and not rebirthBusy and userTycoon then
            local remote = getRebirthRemote()
            local potential = getPotentialInvestors()
            local current = getCurrentInvestors()
            local worthIt = remote and potential and potential >= MinPotential and potential >= current * RebirthGainMultiple
            if worthIt then
                rebirthBusy = true
                pcall(function()
                    local done = false
                    local signal = getRebirthedSignal()
                    local conn
                    if signal and signal:IsA("RemoteEvent") then
                        conn = signal.OnClientEvent:Connect(function() done = true end)
                    end
                    remote:InvokeServer()
                    stats.rebirths = stats.rebirths + 1
                    local t = 0
                    while not done and t < RebirthTimeout do
                        task.wait(0.1)
                        t = t + 0.1
                    end
                    if conn then conn:Disconnect() end
                end)
                task.wait(RebirthCooldown)
                rebirthBusy = false
            end
        end
    end
end)

-- AUTO EVOLVE
local EvolveAt = 100
local EvolveCooldown = 2
local EvolveTimeout = 8
local evolveBusy = false

local function getEvolveRemote()
    if not userTycoon then return nil end
    local remotes = userTycoon:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("Evolve")
end

local function getEvolvedSignal()
    if not userTycoon then return nil end
    local remotes = userTycoon:FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("Evolved")
end

local function getEvolveProgress()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local r = pg and pg:FindFirstChild("Rebirth")
    local em = r and r:FindFirstChild("EvolutionMenu")
    local body = em and em:FindFirstChild("Body")
    local p = body and body:FindFirstChild("Progress")
    if not p then return nil end
    return tonumber(tostring(p.Text):match("[%d%.]+"))
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoEvolve and not evolveBusy and userTycoon then
            local remote = getEvolveRemote()
            local progress = getEvolveProgress()
            if remote and progress and progress >= EvolveAt then
                evolveBusy = true
                pcall(function()
                    local done = false
                    local signal = getEvolvedSignal()
                    local conn
                    if signal and signal:IsA("RemoteEvent") then
                        conn = signal.OnClientEvent:Connect(function() done = true end)
                    end
                    remote:InvokeServer()
                    stats.evolves = stats.evolves + 1
                    local t = 0
                    while not done and t < EvolveTimeout do
                        task.wait(0.1)
                        t = t + 0.1
                    end
                    if conn then conn:Disconnect() end
                end)
                task.wait(EvolveCooldown)
                evolveBusy = false
            end
        end
    end
end)

-- SEWER UTILITIES
local function pullAllLevers()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return 0 end
    local map = workspace:FindFirstChild("Map")
    local sewer = map and map:FindFirstChild("Sewer")
    local root = sewer or workspace
    local pulled = 0
    for _, o in ipairs(root:GetDescendants()) do
        if o:IsA("BasePart") and (o.Name == "Lever" or string.find(string.lower(o.Name), "lever", 1, true)) then
            pcall(function()
                firetouchinterest(hrp, o, 0)
                firetouchinterest(hrp, o, 1)
            end)
            pulled = pulled + 1
        end
    end
    if sewer then
        for _, o in ipairs(sewer:GetDescendants()) do
            if o:IsA("BasePart") and (o.Name == "VineKey" or o.Name == "UFOKey") then
                pcall(function()
                    firetouchinterest(hrp, o, 0)
                    firetouchinterest(hrp, o, 1)
                end)
            end
        end
    end
    Notify("Pull All Levers", pulled > 0 and ("Pulled " .. pulled .. " lever(s)") or "No levers found")
    return pulled
end

local function touchPart(hrp, part)
    pcall(function() firetouchinterest(hrp, part, 0) firetouchinterest(hrp, part, 1) end)
end

local function doSewerRun()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then Notify("Vine Harvest", "Failed: No character"); return false end
    local map = workspace:FindFirstChild("Map")
    local sewer = map and map:FindFirstChild("Sewer")
    if not sewer then Notify("Vine Harvest", "Failed: Sewer not loaded"); return false end
    
    for _, o in ipairs(sewer:GetDescendants()) do
        if o:IsA("BasePart") and string.find(string.lower(o.Name), "lever", 1, true) then touchPart(hrp, o) end
    end
    for _, folderName in ipairs({ "CashVine", "SewerAlien" }) do
        local folder = sewer:FindFirstChild(folderName)
        if folder then
            for _, o in ipairs(folder:GetDescendants()) do
                if o:IsA("BasePart") and (o.Name == "VineKey" or o.Name == "UFOKey") then touchPart(hrp, o) end
            end
        end
    end
    task.wait(0.3)
    local cashVine = sewer:FindFirstChild("CashVine")
    if cashVine then
        local vineDoor = cashVine:FindFirstChild("VineDoor")
        if vineDoor then
            for _, o in ipairs(vineDoor:GetDescendants()) do if o:IsA("BasePart") then touchPart(hrp, o) end end
        end
    end
    task.wait(0.3)
    if cashVine then
        local vineModel = cashVine:FindFirstChild("CashVine")
        if vineModel then
            local pivot = vineModel:GetPivot()
            pcall(function() hrp.CFrame = pivot + Vector3.new(0, 3, 0) end)
            task.wait(0.2)
            for _, o in ipairs(vineModel:GetDescendants()) do if o:IsA("BasePart") then touchPart(hrp, o) end end
        end
    end
    Notify("Vine Harvest", "Completed!")
    return true
end

local SEWER_ALIEN_POS = Vector3.new(-42, -41, 180)
local function teleportToAlien()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then Notify("Teleport", "Failed: No character"); return false end
    pcall(function() hrp.CFrame = CFrame.new(SEWER_ALIEN_POS) end)
    Notify("Teleport", "Teleported to Sewer Alien")
    return true
end

-- AUTO FRUIT (LEMON TREES)
local Trees = {}

local function addTree(obj)
    if obj:IsA("Model") and obj.Name == "LemonTree" then
        if not table.find(Trees, obj) then table.insert(Trees, obj) end
    end
end

local function removeTree(obj)
    local index = table.find(Trees, obj)
    if index then table.remove(Trees, index) end
end

for _, v in ipairs(workspace:GetDescendants()) do addTree(v) end
workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(removeTree)

local function collectFruit(tree)
    for _, obj in ipairs(tree:GetDescendants()) do
        if obj:IsA("BasePart") then obj.CanCollide = false end
    end
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cf = tree:GetPivot()
    hrp.CFrame = cf + Vector3.new(0, 5, 0)
    for _, obj in ipairs(tree:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Fruit" then
            obj.CanCollide = false
            local clickPart = obj:FindFirstChild("ClickPart")
            if clickPart then
                local detector = clickPart:FindFirstChildOfClass("ClickDetector")
                if detector then
                    task.wait(0.45)
                    pcall(function() fireclickdetector(detector) end)
                    stats.fruit = stats.fruit + 1
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFruit then
            for _, tree in ipairs(Trees) do
                if not AutoFruit then break end
                if tree and tree.Parent then pcall(function() collectFruit(tree) end) end
            end
        end
    end
end)

-- CREATE GUI
local Window = Packet:Window({
    Name = "Packet 1.1",
    Enabled = true,
    Color = Color3.new(1, 0.5, 0.25),
    Size = UDim2.new(0, 496, 0, 496),
    Position = UDim2.new(0.5, -248, 0.5, -248)
})

local MainTab = Window:Tab({Name = "Main"})

MainTab:Divider({Text = "Auto Features", Side = "Left"})

local AutoBuyToggle = MainTab:Toggle({
    Name = "Auto Buy: OFF", Side = "Left", Value = false,
    Callback = function(Value) AutoBuy = Value; UpdateToggleName(AutoBuyToggle, "Auto Buy", Value); Notify("Auto Buy", Value and "Enabled" or "Disabled") end
})

local AutoUpgradeToggle = MainTab:Toggle({
    Name = "Auto Upgrade: OFF", Side = "Left", Value = false,
    Callback = function(Value) AutoUpgrade = Value; UpdateToggleName(AutoUpgradeToggle, "Auto Upgrade", Value); Notify("Auto Upgrade", Value and "Enabled" or "Disabled") end
})

local AutoFruitToggle = MainTab:Toggle({
    Name = "Auto Fruit: OFF", Side = "Left", Value = false,
    Callback = function(Value) AutoFruit = Value; UpdateToggleName(AutoFruitToggle, "Auto Fruit", Value); Notify("Auto Fruit", Value and "Enabled" or "Disabled") end
})

local AutoRebirthToggle = MainTab:Toggle({
    Name = "Auto Rebirth: OFF", Side = "Left", Value = false,
    Callback = function(Value) AutoRebirth = Value; UpdateToggleName(AutoRebirthToggle, "Auto Rebirth", Value); Notify("Auto Rebirth", Value and "Enabled" or "Disabled") end
})

local AutoEvolveToggle = MainTab:Toggle({
    Name = "Auto Evolve: OFF", Side = "Left", Value = false,
    Callback = function(Value) AutoEvolve = Value; UpdateToggleName(AutoEvolveToggle, "Auto Evolve", Value); Notify("Auto Evolve", Value and "Enabled" or "Disabled") end
})

local AutoPowerLevelToggle = MainTab:Toggle({
    Name = "Auto Power Level: OFF", Side = "Left", Value = false,
    Callback = function(Value) AutoPowerLevel = Value; UpdateToggleName(AutoPowerLevelToggle, "Auto Power Level", Value); Notify("Auto Power Level", Value and "Enabled" or "Disabled") end
})

MainTab:Divider({Text = "Sewer Utilities", Side = "Left"})

MainTab:Button({Name = "Pull All Levers", Side = "Left", Callback = function() pullAllLevers() end})
MainTab:Button({Name = "Vine Harvest", Side = "Left", Callback = function() task.spawn(doSewerRun) end})
MainTab:Button({Name = "Teleport to Sewer Alien", Side = "Left", Callback = function() teleportToAlien() end})

local StatusSection = MainTab:Section({Name = "Status Panel", Side = "Right"})
local StatusLabel = StatusSection:Label({Text = "Loading..."})

-- LIVE STATUS PANEL
task.spawn(function()
    local parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not parent then
        local okh, hui = pcall(function() return gethui() end)
        parent = (okh and hui) or game:GetService("CoreGui")
    end
    pcall(function() local old = parent:FindFirstChild("AutoStatusGui"); if old then old:Destroy() end end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "AutoStatusGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 168)
    frame.Position = UDim2.new(0, 10, 0, 90)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local packetLabel = Instance.new("TextLabel")
    packetLabel.Size = UDim2.new(0, 80, 0, 18)
    packetLabel.Position = UDim2.new(1, -85, 0, 5)
    packetLabel.BackgroundTransparency = 1
    packetLabel.Text = "Packet 1.1"
    packetLabel.TextColor3 = Color3.fromRGB(120, 235, 140)
    packetLabel.Font = Enum.Font.GothamBold
    packetLabel.TextSize = 11
    packetLabel.TextXAlignment = Enum.TextXAlignment.Right
    packetLabel.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 24)
    title.BackgroundColor3 = Color3.fromRGB(38, 40, 54)
    title.BorderSizePixel = 0
    title.Text = "AUTO STATUS"
    title.TextColor3 = Color3.fromRGB(120, 235, 140)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.Parent = frame
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -12, 1, -30)
    body.Position = UDim2.new(0, 8, 0, 28)
    body.BackgroundTransparency = 1
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.RichText = true
    body.Text = "starting..."
    body.TextColor3 = Color3.fromRGB(235, 235, 245)
    body.Font = Enum.Font.Code
    body.TextSize = 12
    body.Parent = frame

    local UIS = game:GetService("UserInputService")
    local dragging, ds, sp
    title.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, ds, sp = true, i.Position, frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)

    local RunService = game:GetService("RunService")
    local frames, fps, fpsT = 0, 0, tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - fpsT >= 1 then fps, frames, fpsT = frames, 0, tick() end
    end)

    local function on(b) return b and "<font color='#7CFF7C'>ON</font>" or "<font color='#777'>off</font>" end

    while gui.Parent do
        local cashStr = "?"
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        local c = ls and ls:FindFirstChild("Cash")
        if c then cashStr = tostring(c.Value) end

        body.Text = string.format("FPS: %d\nCash: %s\n\nBuys: %d (%s)\nUpgr: %d (%s)\nFruit: %d (%s)\nReb: %d (%s)\nEvo: %d (%s)",
            fps, cashStr, stats.buys, on(AutoBuy), stats.upgrades, on(AutoUpgrade), stats.fruit, on(AutoFruit), stats.rebirths, on(AutoRebirth), stats.evolves, on(AutoEvolve))
        pcall(function() StatusLabel:ChangeText(body.Text) end)
        task.wait(0.25)
    end
end)

Notify("Packet 1.1", "Tycoon Autofarm Loaded Successfully")
