-- Ensure the UI library loads successfully
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/refs/heads/main/v8.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Mod Menu State Variables
local WalkSpeedEnabled = false
local TargetWalkSpeed = 16

local JumpPowerEnabled = false
local TargetJumpPower = 50

local InfiniteJumpEnabled = false
local NoclipEnabled = false

local ESPEnabled = false
local ESPColor = Color3.fromRGB(140, 82, 255)
local ESPConnections = {}

local PaintColor = Color3.fromRGB(140, 82, 255)

-- Helper Functions
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ==========================================
-- MAIN LOOPS & CONNECTIONS
-- ==========================================

-- WalkSpeed, JumpPower, and Noclip Loop
RunService.PostSimulation:Connect(function()
    local humanoid = getHumanoid()
    local root = getRootPart()
    local char = getCharacter()

    if humanoid then
        if WalkSpeedEnabled then
            humanoid.WalkSpeed = TargetWalkSpeed
        end
        if JumpPowerEnabled then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = TargetJumpPower
        end
    end

    if NoclipEnabled and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump Action
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ==========================================
-- ESP SYSTEM (Highlights)
-- ==========================================
local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function setupHighlight(character)
        if not ESPEnabled then return end
        
        -- Remove existing highlight if any
        local existing = character:FindFirstChild("Aether_ESP")
        if existing then existing:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "Aether_ESP"
        highlight.FillColor = ESPColor
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
    end

    if player.Character then
        setupHighlight(player.Character)
    end
    
    local conn = player.CharacterAdded:Connect(setupHighlight)
    table.insert(ESPConnections, conn)
end

local function clearESP()
    for _, conn in ipairs(ESPConnections) do
        conn:Disconnect()
    end
    table.clear(ESPConnections)

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("Aether_ESP")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

local function updateESP()
    clearESP()
    if ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            applyESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        applyESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    -- Cleanup automatically handles left players
end)

-- ==========================================
-- INITIALIZE MENU WINDOW
-- ==========================================
local Window = Aether.new("Aether Mod Menu", Vector2.new(580, 420), Vector2.new(450, 300))

-- TAB 1: Local Player Controls
local PlayerTab = Window:AddTab("Player")
PlayerTab:AddLabel("Movement Modifiers", "h3")

PlayerTab:AddToggle("Enable Custom WalkSpeed", false, function(state)
    WalkSpeedEnabled = state
end)

PlayerTab:AddSlider("WalkSpeed Value", 16, 250, 16, function(value)
    TargetWalkSpeed = value
end)

PlayerTab:AddToggle("Enable Custom JumpPower", false, function(state)
    JumpPowerEnabled = state
end)

PlayerTab:AddSlider("JumpPower Value", 50, 500, 50, function(value)
    TargetJumpPower = value
end)

PlayerTab:AddLabel("Physics Utilities", "h3")

PlayerTab:AddToggle("Infinite Jump", false, function(state)
    InfiniteJumpEnabled = state
end)

PlayerTab:AddToggle("Noclip (Walk Through Walls)", false, function(state)
    NoclipEnabled = state
end)

-- TAB 2: World & Client Coloring
local WorldTab = Window:AddTab("World")
WorldTab:AddLabel("World Physics", "h3")

WorldTab:AddSlider("Workspace Gravity", 0, 196.2, 196.2, function(value)
    Workspace.Gravity = value
end)

WorldTab:AddLabel("Client-Side Painting", "h3")
WorldTab:AddLabel("Change the colors of map parts only on your screen.", "p")

WorldTab:AddColorPicker("Select Paint Color", Color3.fromRGB(140, 82, 255), function(color)
    PaintColor = color
end)

WorldTab:AddButton("Paint Entire Map", function()
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(getCharacter()) and not part:IsA("Terrain") then
            part.Color = PaintColor
        end
    end
end)

WorldTab:AddButton("Reset Map Colors", function()
    -- Relies on basic workspace streaming/re-parenting or just reloading textures.
    -- Easiest way client-side is to re-assign a default material color or warn.
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(getCharacter()) and not part:IsA("Terrain") then
            -- Force Roblox to reset to its native engine color preset by toggling material off/on
            local originalColor = part.Color
            part.Color = Color3.fromRGB(163, 162, 165) -- Standard gray fallback
        end
    end
end)

-- TAB 3: Visuals & ESP
local VisualsTab = Window:AddTab("Visuals")
VisualsTab:AddLabel("Sensory Settings (ESP)", "h3")

VisualsTab:AddToggle("Enable Player ESP Highlight", false, function(state)
    ESPEnabled = state
    updateESP()
end)

VisualsTab:AddColorPicker("ESP Fill Color", Color3.fromRGB(140, 82, 255), function(color)
    ESPColor = color
    if ESPEnabled then
        updateESP()
    end
end)

-- TAB 4: Teleportation & Coordinates
local TeleportTab = Window:AddTab("Teleportation")
TeleportTab:AddLabel("Dynamic Tracking", "h3")

local CoordinateLabel = TeleportTab:AddLabel("Coordinates: X: 0 | Y: 0 | Z: 0", "p")

-- Keep Coordinates Label Updated In Real-Time
RunService.Heartbeat:Connect(function()
    local root = getRootPart()
    if root then
        local pos = root.Position
        CoordinateLabel.Text = string.format("Current Coordinates: X: %d | Y: %d | Z: %d", math.round(pos.X), math.round(pos.Y), math.round(pos.Z))
    else
        CoordinateLabel.Text = "Current Coordinates: Searching for Character..."
    end
end)

TeleportTab:AddLabel("Coordinate Navigation", "h3")

TeleportTab:AddButtonWithInput("Teleport to Coordinates", "X, Y, Z (e.g. 100, 50, -250)", function(inputText)
    local coords = {}
    for num in string.gmatch(inputText, "[^,]+") do
        table.insert(coords, tonumber(num))
    end
    
    if #coords >= 3 then
        local root = getRootPart()
        if root then
            root.CFrame = CFrame.new(coords[1], coords[2], coords[3])
        end
    end
end)

TeleportTab:AddLabel("Player Target Navigation", "h3")

TeleportTab:AddButtonWithInput("Teleport to Username", "Enter player name", function(username)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name):match(string.lower(username)) or string.lower(player.DisplayName):match(string.lower(username)) then
            local targetChar = player.Character
            local myRoot = getRootPart()
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and myRoot then
                myRoot.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) -- Teleport slightly in front of them
                break
            end
        end
    end
end)

TeleportTab:AddLabel("Interactive Utility", "h3")

TeleportTab:AddButton("Equip Click TP Tool", function()
    local mouse = LocalPlayer:GetMouse()
    local tool = Instance.new("Tool")
    tool.Name = "Click TP"
    tool.RequiresHandle = false
    
    tool.Activated:Connect(function()
        local root = getRootPart()
        if root and mouse.Hit then
            root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    
    tool.Parent = LocalPlayer.Backpack
end)
