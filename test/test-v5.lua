--========================================================================--
-- 1. LOAD AETHER UI LIBRARY VIA LOADSTRING
--========================================================================--
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v5.lua", true))()

--========================================================================--
-- 2. WRITE YOUR CUSTOM CODE BELOW
--========================================================================--
local Menu = Aether.new("Aether Utility Engine", Vector2.new(580, 440), Vector2.new(450, 320))

-- Local Player Variables
local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- Create Menu Tabs
local PlayerTab = Menu:AddTab("Player")
local VisualsTab = Menu:AddTab("Visuals")
local TeleportTab = Menu:AddTab("Teleport")
local UtilityTab = Menu:AddTab("Utility")
local WorldTab = Menu:AddTab("World")

--------------------------------------------------------------------------------
-- PLAYER TAB
--------------------------------------------------------------------------------
PlayerTab:AddLabel("Physical Configuration", "h2")

-- WalkSpeed Slider
PlayerTab:AddSlider("Walk Speed", 16, 250, 16, function(val)
    local Hum = Character:FindFirstChildOfClass("Humanoid")
    if Hum then Hum.WalkSpeed = val end
end)

-- JumpPower Slider
PlayerTab:AddSlider("Jump Power", 50, 500, 50, function(val)
    local Hum = Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        Hum.UseJumpPower = true
        Hum.JumpPower = val
    end
end)

-- Gravity Controller
PlayerTab:AddSlider("Gravity Control", 0, 196, 196, function(val)
    workspace.Gravity = val
end)

PlayerTab:AddLabel("Toggle Abilities", "h3")

-- Infinite Jump
local InfiniteJumpEnabled = false
PlayerTab:AddToggle("Infinite Jump", false, function(state)
    InfiniteJumpEnabled = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local Hum = Character:FindFirstChildOfClass("Humanoid")
        if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Noclip
local NoclipEnabled = false
PlayerTab:AddToggle("Noclip", false, function(state)
    NoclipEnabled = state
end)

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Flight System
local Flying = false
local FlySpeed = 50
local FlightConnection

local function ToggleFlight(state)
    Flying = state
    local Hum = Character:FindFirstChildOfClass("Humanoid")
    local Root = Character:FindFirstChild("HumanoidRootPart")
    
    if not Root or not Hum then return end
    
    if Flying then
        Hum.PlatformStand = true
        local BV = Instance.new("BodyVelocity")
        BV.Name = "AetherFly_BV"
        BV.Velocity = Vector3.zero
        BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        BV.Parent = Root
        
        local BG = Instance.new("BodyGyro")
        BG.Name = "AetherFly_BG"
        BG.CFrame = Root.CFrame
        BG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        BG.Parent = Root

        local Camera = workspace.CurrentCamera

        FlightConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not Flying or not Root or not Root.Parent then
                if FlightConnection then FlightConnection:Disconnect() end
                return
            end
            
            BG.CFrame = Camera.CFrame
            local Direction = Vector3.zero
            
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then Direction = Direction + Camera.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then Direction = Direction - Camera.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then Direction = Direction + Camera.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then Direction = Direction - Camera.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then Direction = Direction + Vector3.new(0, 1, 0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then Direction = Direction - Vector3.new(0, 1, 0) end
            
            BV.Velocity = Direction.Unit * FlySpeed
            if Direction == Vector3.zero then BV.Velocity = Vector3.zero end
        end)
    else
        Hum.PlatformStand = false
        local BV = Root:FindFirstChild("AetherFly_BV")
        local BG = Root:FindFirstChild("AetherFly_BG")
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
        if FlightConnection then FlightConnection:Disconnect() end
    end
end

PlayerTab:AddToggle("Flight Active", false, ToggleFlight)

PlayerTab:AddSlider("Flight Speed", 10, 250, 50, function(val)
    FlySpeed = val
end)

--------------------------------------------------------------------------------
-- VISUALS TAB
--------------------------------------------------------------------------------
VisualsTab:AddLabel("Render Engine ESP", "h2")

local ESPColor = Color3.fromRGB(140, 82, 255)
local ESPEnabled = false
local HighLightStorage = {}

local function createESP(plr)
    if plr == LocalPlayer then return end
    
    local function applyESP(char)
        if not ESPEnabled then return end
        task.wait(0.5)
        if char:FindFirstChildOfClass("Highlight") then return end
        
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "Aether_ESP"
        Highlight.FillColor = ESPColor
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight.OutlineTransparency = 0
        Highlight.Parent = char
        HighLightStorage[plr] = Highlight
    end
    
    plr.CharacterAdded:Connect(applyESP)
    if plr.Character then applyESP(plr.Character) end
end

local function cleanESP()
    for _, highlight in pairs(workspace:GetDescendants()) do
        if highlight.Name == "Aether_ESP" then highlight:Destroy() end
    end
    table.clear(HighLightStorage)
end

VisualsTab:AddToggle("Player Chams (ESP)", false, function(state)
    ESPEnabled = state
    if ESPEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do createESP(player) end
    else
        cleanESP()
    end
end)

VisualsTab:AddColorPicker("ESP Overlay Color", ESPColor, function(color)
    ESPColor = color
    for _, hl in pairs(HighLightStorage) do
        if hl and hl.Parent then hl.FillColor = color end
    end
end)

game.Players.PlayerAdded:Connect(createESP)
game.Players.PlayerRemoving:Connect(function(plr) HighLightStorage[plr] = nil end)

--------------------------------------------------------------------------------
-- TELEPORT TAB
--------------------------------------------------------------------------------
TeleportTab:AddLabel("Teleport to Players", "h2")

local targetPlayerName = ""
TeleportTab:AddInput("Target Username", "Type Username...", function(text)
    targetPlayerName = text
end)

TeleportTab:AddButton("Teleport to Player", function()
    if targetPlayerName == "" then return end
    for _, player in ipairs(game.Players:GetPlayers()) do
        if string.find(string.lower(player.Name), string.lower(targetPlayerName)) or string.find(string.lower(player.DisplayName), string.lower(targetPlayerName)) then
            local root = Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and targetRoot then
                root.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 0)
                break
            end
        end
    end
end)

TeleportTab:AddLabel("Location Waypoints", "h3")

local waypoints = {}
local currentWaypointName = ""

TeleportTab:AddInput("Waypoint Name", "My Safe Zone...", function(text)
    currentWaypointName = text
end)

TeleportTab:AddButton("Save Location", function()
    local root = Character:FindFirstChild("HumanoidRootPart")
    if root and currentWaypointName ~= "" then
        waypoints[currentWaypointName] = root.CFrame
    end
end)

TeleportTab:AddButton("Teleport to Saved Waypoint", function()
    local root = Character:FindFirstChild("HumanoidRootPart")
    if root and waypoints[currentWaypointName] then
        root.CFrame = waypoints[currentWaypointName]
    end
end)

--------------------------------------------------------------------------------
-- UTILITY TAB
--------------------------------------------------------------------------------
UtilityTab:AddLabel("Utility & Automation Tools", "h2")

-- Anti-AFK Setup
local AntiAFKConnection
UtilityTab:AddToggle("Anti-AFK Engine", false, function(state)
    if state then
        local VirtualUser = game:GetService("VirtualUser")
        AntiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.zero)
        end)
    else
        if AntiAFKConnection then AntiAFKConnection:Disconnect() end
    end
end)

-- Click Teleport Tool
local tpToolActive = false
UtilityTab:AddToggle("Click-To-Teleport Tool", false, function(state)
    tpToolActive = state
    local backpack = LocalPlayer:WaitForChild("Backpack")
    
    if tpToolActive then
        local tool = Instance.new("Tool")
        tool.Name = "Aether Click TP"
        tool.RequiresHandle = false
        
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local root = Character:FindFirstChild("HumanoidRootPart")
            if root and mouse.Target then
                root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        
        tool.Parent = backpack
    else
        local found = backpack:FindFirstChild("Aether Click TP") or Character:FindFirstChild("Aether Click TP")
        if found then found:Destroy() end
    end
end)

-- Get BTools
UtilityTab:AddButton("Inject Classic BTools", function()
    local btools = {"Clone", "Delete", "Grab"}
    for _, toolName in ipairs(btools) do
        local tool = Instance.new("Tool")
        tool.Name = toolName
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Transparency = 1
        handle.Parent = tool
        Instance.new("LocalScript", tool)
        tool.Parent = LocalPlayer:WaitForChild("Backpack")
    end
end)

-- Infinite Yield
UtilityTab:AddButton("Load Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

--------------------------------------------------------------------------------
-- WORLD TAB
--------------------------------------------------------------------------------
WorldTab:AddLabel("Client & Server Utilities", "h2")

-- Camera Unlocker
WorldTab:AddButton("Unlock Max Camera Zoom", function()
    LocalPlayer.CameraMaxZoomDistance = 99999
end)

-- Rejoin Server
WorldTab:AddButton("Rejoin Current Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- Server Hop
WorldTab:AddButton("Server Hop", function()
    local Servers = {}
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local function GetServers(cursor)
        local raw = game:HttpGet(Api .. (cursor and "&cursor=" .. cursor or ""))
        return game:GetService("HttpService"):JSONDecode(raw)
    end
    
    local serverList = GetServers()
    for _, s in ipairs(serverList.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            table.insert(Servers, s.id)
        end
    end
    
    if #Servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)], LocalPlayer)
    end
end)

WorldTab:AddLabel("Destruct System", "h3")

-- Unload Completely
WorldTab:AddButton("Unload Engine UI", function()
    cleanESP()
    ToggleFlight(false)
    NoclipEnabled = false
    InfiniteJumpEnabled = false
    if AntiAFKConnection then AntiAFKConnection:Disconnect() end
    
    local MainFrame = Menu.MainFrame
    local t = game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 0)})
    t:Play()
    task.wait(0.2)
    Menu.ScreenGui:Destroy()
end)
