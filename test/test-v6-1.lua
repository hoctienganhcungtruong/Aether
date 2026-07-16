-- [[ Load Aether UI Library dynamically from your raw source ]]
local Success, Aether = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v6.lua"))()
end)

if not Success or not Aether then
    warn("Failed to load Aether UI Library. Please check your connection or the URL.")
    return
end

-- [[ Services ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ State Variables for exploits ]]
local NoclipEnabled = false
local InfiniteJumpEnabled = false

-- [[ Create Main Window ]]
local Window = Aether:CreateWindow({
    Title = "Aether Mod Menu",
    SubTitle = "v6.0 - Premium Edition",
    Size = Vector2.new(550, 380),
    Theme = "Dark" -- Options: "Dark", "Light", etc., depending on Aether's assets
})

-- [[ Initialize Tabs ]]
local PlayerTab = Window:AddTab({ Title = "Player Hacks" })
local WorldTab = Window:AddTab({ Title = "World/Misc" })

-- ==========================================
-- PLAYER HACKS TAB
-- ==========================================

-- 1. WalkSpeed Slider
PlayerTab:AddSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(value)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
    end
})

-- 2. JumpPower Slider
PlayerTab:AddSlider({
    Title = "Jump Power",
    Min = 50,
    Max = 350,
    Default = 50,
    Callback = function(value)
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = value
        end
    end
})

-- 3. Noclip Toggle
PlayerTab:AddToggle({
    Title = "Noclip (Phase Walls)",
    Default = false,
    Callback = function(state)
        NoclipEnabled = state
    end
})

-- 4. Infinite Jump Toggle
PlayerTab:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

-- ==========================================
-- WORLD & MISC TAB
-- ==========================================

WorldTab:AddButton({
    Title = "Print Player Coordinates",
    Callback = function()
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            print("Current Position: " .. tostring(Character.HumanoidRootPart.Position))
        end
    end
})

-- ==========================================
-- BACKGROUND LOOPS (For Toggles)
-- ==========================================

-- Handle Noclip
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local Character = LocalPlayer.Character
        if Character then
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Handle Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- [[ Welcome Notification ]]
Aether:Notify({
    Title = "Menu Loaded",
    Content = "Welcome to Aether Mod Menu, " .. LocalPlayer.Name .. "!",
    Duration = 5
})
