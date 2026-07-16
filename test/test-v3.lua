--[[
    Aether Mod Menu - v3 Integration
    Features: Draggable topbar, resizable frame, advanced color picker ESP, and nested collapsibles.
--]]

-- 1. Load the Aether v3 Library
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v3.lua"))()

-- 2. Create Mod Menu Window (Resize grip is located at the bottom right)
local Window = Aether.new("Aether Mod Menu v3")

-- 3. Setup Tabs
local PlayerTab = Window:AddTab("Player")
local VisualsTab = Window:AddTab("Visuals")
local SettingsTab = Window:AddTab("Settings")

-- Global Mod Variables
local Plr = game.Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
Plr.CharacterAdded:Connect(function(newChar) Char = newChar end)

local InfJumpEnabled = false
local NoclipEnabled = false
local EspEnabled = false
local EspColor = Color3.fromRGB(140, 82, 255) -- Matches default purple theme

--------------------------------------------------------------------------------
-- 1. PLAYER TAB
--------------------------------------------------------------------------------
PlayerTab:AddLabel("Movement Modifiers", "h2")
PlayerTab:AddLabel("Modify standard humanoid parameters safely.", "p")

-- WalkSpeed Modifier (Input + Button Combo)
PlayerTab:AddButtonWithInput("Set WalkSpeed", "16", function(val)
    local speed = tonumber(val)
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if speed and hum then
        hum.WalkSpeed = speed
    end
end)

-- JumpPower Modifier (Input + Button Combo)
PlayerTab:AddButtonWithInput("Set JumpPower", "50", function(val)
    local jp = tonumber(val)
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if jp and hum then
        hum.UseJumpPower = true
        hum.JumpPower = jp
    end
end)

PlayerTab:AddLabel("Abilities", "h3")

-- Infinite Jump Toggle
PlayerTab:AddToggle("Infinite Jump", false, function(state)
    InfJumpEnabled = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = Char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip Toggle
PlayerTab:AddToggle("Noclip (Wall-Phase)", false, function(state)
    NoclipEnabled = state
end)

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and Char then
        for _, part in ipairs(Char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- 2. VISUALS TAB (With Advanced Color Picker)
--------------------------------------------------------------------------------
VisualsTab:AddLabel("Visual Enhancements", "h2")

-- ESP Toggle
VisualsTab:AddToggle("Chams (Highlight ESP)", false, function(state)
    EspEnabled = state
    
    -- Clear old highlights instantly when toggling off
    if not state then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= Plr and player.Character then
                local hl = player.Character:FindFirstChild("AetherESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- Advanced Color Picker (Expands to show S-V grid & Rainbow Hue slider)
VisualsTab:AddColorPicker("ESP Highlight Color", EspColor, function(selectedColor)
    EspColor = selectedColor
end)

-- Real-time Render Loop for Chams
game:GetService("RunService").RenderStepped:Connect(function()
    if not EspEnabled then return end
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= Plr and player.Character then
            local charModel = player.Character
            local highlight = charModel:FindFirstChild("AetherESP")
            
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "AetherESP"
                highlight.Adornee = charModel
                highlight.FillTransparency = 0.4
                highlight.OutlineTransparency = 0.1
                highlight.Parent = charModel
            end
            
            -- Updates dynamically as you drag inside the Advanced Color Picker
            highlight.FillColor = EspColor
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)

--------------------------------------------------------------------------------
-- 3. SETTINGS TAB (With Fixed Nested Collapsible)
--------------------------------------------------------------------------------
SettingsTab:AddLabel("Configuration & Tools", "h2")

-- Standard Settings Elements
SettingsTab:AddButton("Rejoin Server", function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Plr)
end)

-- Fixed Collapsible Panel (Returns nested interface container)
local DevPanel = SettingsTab:AddCollapsible("Developer Configurations")

-- Adding elements directly INSIDE the collapsible block
DevPanel:AddLabel("Warning: Restrict modifications here.", "p")

DevPanel:AddButton("Kill Character", function()
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

DevPanel:AddButton("Destroy Mod Menu", function()
    Window.ScreenGui:Destroy()
end)
