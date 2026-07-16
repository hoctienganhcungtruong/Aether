-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Load Aether UI Library
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v9.lua"))()

-- Initialize UI Window
local UI = Aether.new("⚡ Aether v5 Active Mod Menu", Vector2.new(580, 420), Vector2.new(450, 250))

-- Create Navigation Sidebar Tabs
local CombatTab = UI:AddTab("Combat")
local VisualsTab = UI:AddTab("Visuals")
local UtilityTab = UI:AddTab("Utility")
local ResizeTab = UI:AddTab("Sizing Tests")

----------------------------------------------------
-- SYSTEM VARIABLES
----------------------------------------------------
-- Combat Config
local aimbotEnabled = false
local aimbotFov = 90

-- Visual Config
local espEnabled = false
local espColor = Color3.fromRGB(140, 82, 255)
local espHighlights = {}

-- Utility State
local customWalkspeed = 16
local customJumppower = 50

----------------------------------------------------
-- COMBAT SYSTEM (AIMBOT ENGINE)
----------------------------------------------------
CombatTab:AddLabel("Aimbot Settings", "h1")
CombatTab:AddLabel("Configure active camera targeting assistance.", "p")

CombatTab:AddToggle("Aimbot Enabled", false, function(toggled)
    aimbotEnabled = toggled
end)

CombatTab:AddSlider("Aim Assist FOV", 30, 360, 90, function(value)
    aimbotFov = value
end)

-- Find closest target within FOV limits
local function getClosestPlayerToCursor()
    local target = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance and distance <= aimbotFov then
                        shortestDistance = distance
                        target = player
                    end
                end
            end
        end
    end
    return target
end

-- Hook into Render Cycle for seamless camera adjustment
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)


----------------------------------------------------
-- VISUALS SYSTEM (HIGHLIGHT ESP ENGINE)
----------------------------------------------------
VisualsTab:AddLabel("ESP Engine", "h1")
VisualsTab:AddLabel("Visualize players through structures in real-time.", "p")

-- Function to safely clear and update highlights
local function updateESP()
    for player, highlight in pairs(espHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
        espHighlights[player] = nil
    end

    if not espEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "Aether_ESP"
            highlight.FillColor = espColor
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
            
            espHighlights[player] = highlight
        end
    end
end

-- Refresh highlights as players join or spawn
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5) -- Wait for assembly
        updateESP()
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if espHighlights[player] then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
end)

VisualsTab:AddToggle("Active Highlights ESP", false, function(toggled)
    espEnabled = toggled
    updateESP()
end)

VisualsTab:AddColorPicker("ESP Overlay Color", Color3.fromRGB(140, 82, 255), function(selectedColor)
    espColor = selectedColor
    updateESP()
end)


----------------------------------------------------
-- UTILITY TAB (MOVESPEED & TELEPORTS)
----------------------------------------------------
UtilityTab:AddLabel("Physical Utilities", "h1")

UtilityTab:AddInput("Target WalkSpeed", "Default: 16", function(text, enterPressed)
    if enterPressed then
        local num = tonumber(text)
        if num then
            customWalkspeed = num
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = num end
        end
    end
end)

UtilityTab:AddInput("Target JumpPower", "Default: 50", function(text, enterPressed)
    if enterPressed then
        local num = tonumber(text)
        if num then
            customJumppower = num
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then 
                hum.UseJumpPower = true
                hum.JumpPower = num 
            end
        end
    end
end)

-- Keep physical stats locked in case of resets/respawns
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = customWalkspeed
    hum.UseJumpPower = true
    hum.JumpPower = customJumppower
end)

UtilityTab:AddButtonWithInput("Teleport To Player", "Target Name...", function(targetName)
    if targetName == "" then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if string.find(string.lower(player.Name), string.lower(targetName)) or string.find(string.lower(player.DisplayName), string.lower(targetName)) then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
                break
            end
        end
    end
end)

UtilityTab:AddButton("Instant Force Reset", function()
    local char = LocalPlayer.Character
    if char then
        char:BreakJoints()
    end
end)


----------------------------------------------------
-- SIZING & API TESTS TAB
----------------------------------------------------
ResizeTab:AddLabel("Programmatic Resize API", "h1")
ResizeTab:AddLabel("Adjust the interface dimensions dynamically in real-time.", "p")

ResizeTab:AddButton("Set Window: Compact (480x300)", function()
    UI:Resize(Vector2.new(480, 300), 0.4)
end)

ResizeTab:AddButton("Set Window: Default Size (580x420)", function()
    UI:Resize(Vector2.new(580, 420), 0.4)
end)

ResizeTab:AddButton("Set Window: Cinematic Wide (750x550)", function()
    UI:Resize(Vector2.new(750, 550), 0.4)
end)

ResizeTab:AddButton("Set Window: Instant Extreme (800x600)", function()
    UI:Resize(Vector2.new(800, 600))
end)
