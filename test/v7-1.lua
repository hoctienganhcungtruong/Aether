-- 1. Load the UI Library from your GitHub source
local AetherAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v7.lua"))()

-- 2. Create the window
local UI = AetherAPI.new("Aether Control Panel", Vector2.new(580, 440))

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ESP State
local ESPEnabled = false
local HighlightFolder = Instance.new("Folder")
HighlightFolder.Name = "AetherESP"
HighlightFolder.Parent = Workspace:WaitForChild("CurrentCamera")

---------------------------------------------------------
-- TAB 1: PLAYER MODIFIERS
---------------------------------------------------------
local PlayerTab = UI:AddTab("Player")

PlayerTab:AddLabel("Character Settings", "h2")

-- Walkspeed Slider
PlayerTab:AddSlider("WalkSpeed", 16, 250, 16, function(value)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

-- Jump Power Slider
PlayerTab:AddSlider("Jump Power", 50, 500, 50, function(value)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = value
    end
end)

PlayerTab:AddLabel("Environment", "h2")

-- Gravity Slider
PlayerTab:AddSlider("Gravity", 0, 400, 196, function(value)
    Workspace.Gravity = value
end)

---------------------------------------------------------
-- TAB 2: VISUALS (ESP & CLIENT COLOR)
---------------------------------------------------------
local VisualsTab = UI:AddTab("Visuals")

VisualsTab:AddLabel("ESP Settings", "h2")

-- Helper function to apply ESP Highlight to a player
local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function setupHighlight(character)
        if not ESPEnabled then return end
        
        -- Remove existing highlight if any exists for this player
        local existing = HighlightFolder:FindFirstChild(player.Name)
        if existing then existing:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = player.Name
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(140, 82, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = HighlightFolder
    end
    
    if player.Character then
        setupHighlight(player.Character)
    end
    player.CharacterAdded:Connect(setupHighlight)
end

-- Clear highlights
local function clearESP()
    HighlightFolder:ClearAllChildren()
end

-- ESP Toggle
VisualsTab:AddToggle("Player ESP", false, function(state)
    ESPEnabled = state
    if ESPEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            applyESP(player)
        end
        Players.PlayerAdded:Connect(applyESP)
    else
        clearESP()
    end
end)

VisualsTab:AddLabel("Environment Color (Client-Only)", "h2")
VisualsTab:AddLabel("Changes the color of unanchored objects on your screen.", "p")

-- Color Picker (Modifies part color locally)
VisualsTab:AddColorPicker("Part Color Changer", Color3.fromRGB(140, 82, 255), function(color)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored then
            obj.Color = color
        end
    end
end)

---------------------------------------------------------
-- TAB 3: TELEPORT & POSITION
---------------------------------------------------------
local TeleportTab = UI:AddTab("Teleportation")

TeleportTab:AddLabel("Current Position Tracker", "h2")

-- Dynamic coordinate labels
local posXLabel = TeleportTab:AddLabel("X: 0", "p")
local posYLabel = TeleportTab:AddLabel("Y: 0", "p")
local posZLabel = TeleportTab:AddLabel("Z: 0", "p")

-- Track and update player coordinates in real time
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        posXLabel.Text = string.format("X: %.2f", pos.X)
        posYLabel.Text = string.format("Y: %.2f", pos.Y)
        posZLabel.Text = string.format("Z: %.2f", pos.Z)
    else
        posXLabel.Text = "X: N/A"
        posYLabel.Text = "Y: N/A"
        posZLabel.Text = "Z: N/A"
    end
end)

TeleportTab:AddLabel("Teleport to Coordinates", "h2")

-- Vector variables for the target destination
local tpX, tpY, tpZ = 0, 0, 0

TeleportTab:AddInput("Target X Coordinate", "0", function(text)
    tpX = tonumber(text) or 0
end)

TeleportTab:AddInput("Target Y Coordinate", "0", function(text)
    tpY = tonumber(text) or 0
end)

TeleportTab:AddInput("Target Z Coordinate", "0", function(text)
    tpZ = tonumber(text) or 0
end)

-- Execute Teleportation button
TeleportTab:AddButton("Teleport", function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(tpX, tpY, tpZ)
    end
end)
