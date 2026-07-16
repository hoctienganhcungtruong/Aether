--[[
    Aether Mod Menu
--]]

-- 1. Load the Aether v2 Library
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v2.lua"))()

-- 2. Create Mod Menu Window
local Window = Aether.new("Aether Mod Menu v2")

-- 3. Setup Tabs
local PlayerTab = Window:AddTab("Local Player")
local VisualsTab = Window:AddTab("Visuals")
local AutomationTab = Window:AddTab("Misc / Config")

-- Global Variables for Mod States
local Plr = game.Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
Plr.CharacterAdded:Connect(function(newChar) Char = newChar end)

local InfJumpEnabled = false
local NoclipEnabled = false
local EspColor = Color3.fromRGB(140, 82, 255)
local EspEnabled = false

--------------------------------------------------------------------------------
-- LOCAL PLAYER TAB
--------------------------------------------------------------------------------
PlayerTab:AddLabel("Character Modifiers", "h2")
PlayerTab:AddLabel("Safely adjust your local humanoid parameters.", "p")

-- WalkSpeed Modifier
PlayerTab:AddButtonWithInput("Set WalkSpeed", "16", function(val)
    local speed = tonumber(val)
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if speed and hum then
        hum.WalkSpeed = speed
    end
end)

-- JumpPower Modifier
PlayerTab:AddButtonWithInput("Set JumpPower", "50", function(val)
    local jp = tonumber(val)
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if jp and hum then
        hum.UseJumpPower = true
        hum.JumpPower = jp
    end
end)

PlayerTab:AddLabel("Toggles", "h3")

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
PlayerTab:AddToggle("Noclip", false, function(state)
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
-- VISUALS TAB (ESP)
--------------------------------------------------------------------------------
VisualsTab:AddLabel("Render Settings", "h2")

-- ESP Toggle
VisualsTab:AddToggle("Chams (Highlight ESP)", false, function(state)
    EspEnabled = state
    
    -- Clear old highlights if turning off
    if not state then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= Plr and player.Character then
                local hl = player.Character:FindFirstChild("AetherESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- Esp Color Picker
VisualsTab:AddColorPicker("ESP Fill Color", EspColor, function(color)
    EspColor = color
end)

-- Realtime Highlight Loop
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
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = charModel
            end
            
            highlight.FillColor = EspColor
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)


--------------------------------------------------------------------------------
-- MISC & CONFIG TAB
--------------------------------------------------------------------------------
AutomationTab:AddLabel("Server Actions", "h2")

-- Rejoin Server Button
AutomationTab:AddButton("Rejoin Server", function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Plr)
end)

-- Collapse Menu demonstration
local AdvancedConfig = AutomationTab:AddCollapsible("Developer Configs")
