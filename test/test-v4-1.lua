--[[
    Aether Mod Menu - Complete Production Implementation
    Features: No-conflict edge scrolling, adjustable window bounds,
    Chams visual engine, Character modifiers, and a nested Developer Config section.
--]]

-- 1. Load the Patched Aether v3 Library
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v4.lua"))()

-- 2. Define Custom Window Sizing Constraints
local InitialSize = Vector2.new(600, 400) -- Clean starting size
local MinimumSize = Vector2.new(480, 280) -- Minimum size protection

-- 3. Create the Main Window
local Window = Aether.new("Aether Premium Menu", InitialSize, MinimumSize)

-- 4. Setup Side Navigation Tabs
local PlayerTab = Window:AddTab("Combat & Player")
local VisualsTab = Window:AddTab("Visuals & ESP")
local MiscTab = Window:AddTab("Misc / Config")

-- Global Environment Variables
local Plr = game.Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
Plr.CharacterAdded:Connect(function(newChar) Char = newChar end)

local InfJumpEnabled = false
local NoclipEnabled = false
local EspEnabled = false
local EspColor = Color3.fromRGB(140, 82, 255) -- Matches default purple theme

--------------------------------------------------------------------------------
-- 1. COMBAT & PLAYER TAB
--------------------------------------------------------------------------------
PlayerTab:AddLabel("Humanoid Modifiers", "h2")
PlayerTab:AddLabel("Safely adjust local player physics attributes.", "p")

-- WalkSpeed Modifier (Combined Input + Button)
PlayerTab:AddButtonWithInput("Modify WalkSpeed", "16", function(inputValue)
    local speed = tonumber(inputValue)
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if speed and hum then
        hum.WalkSpeed = speed
    end
end)

-- JumpPower Modifier (Combined Input + Button)
PlayerTab:AddButtonWithInput("Modify JumpPower", "50", function(inputValue)
    local jp = tonumber(inputValue)
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if jp and hum then
        hum.UseJumpPower = true
        hum.JumpPower = jp
    end
end)

PlayerTab:AddLabel("Movement Toggles", "h3")

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
PlayerTab:AddToggle("Noclip (Phase Walls)", false, function(state)
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
-- 2. VISUALS & ESP TAB (Utilizing Asset-Free Canvas Color Picker)
--------------------------------------------------------------------------------
VisualsTab:AddLabel("World Renderers", "h2")

-- ESP Toggle
VisualsTab:AddToggle("Chams (Player Highlights)", false, function(state)
    EspEnabled = state
    
    -- Clear highlights instantly if toggled off
    if not state then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= Plr and player.Character then
                local hl = player.Character:FindFirstChild("AetherESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- Advanced Color Picker (Unfolds displaying Saturation-Value Canvas & Hue Slider)
VisualsTab:AddColorPicker("Highlight Hue/Chams Color", EspColor, function(selectedColor)
    EspColor = selectedColor
end)

-- Dedicated Render Loop for Chams
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
            
            -- Updates on-the-fly dynamically when dragging color sliders
            highlight.FillColor = EspColor
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end)


--------------------------------------------------------------------------------
-- 3. MISC & CONFIG TAB (Nesting elements within Collapsible)
--------------------------------------------------------------------------------
MiscTab:AddLabel("Global Commands", "h2")

-- Rejoin Server Button
MiscTab:AddButton("Rejoin Server Instance", function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Plr)
end)

-- Collapsible Accordion Block (Instantiates separate sub-frame)
local SettingsPanel = MiscTab:AddCollapsible("Advanced Developer Tools")

-- Note: We add components directly to the returned 'SettingsPanel' container, not 'MiscTab'
SettingsPanel:AddLabel("Danger Zone: Destructive actions below.", "p")

SettingsPanel:AddButton("Self-Reset Character", function()
    local hum = Char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = 0
    end
end)

SettingsPanel:AddButton("Shutdown UI Instance", function()
    Window.ScreenGui:Destroy()
end)
