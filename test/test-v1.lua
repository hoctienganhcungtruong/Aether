--[[
    Aether UI Library Example
--]]

-- 1. Load the Library from your Repository
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v1.lua"))()

-- 2. Create the Main Window
local Window = Aether.new("Aether Showcase")

-- 3. Setup Side Tabs
local MainTab = Window:AddTab("Controls")
local TextTab = Window:AddTab("Typography")
local CreditsTab = Window:AddTab("Credits")

---------------------------------------------------------
-- CONTROLS TAB (Interactive Elements)
---------------------------------------------------------

MainTab:AddLabel("Interactive Components", "h2")
MainTab:AddLabel("Test all of Aether's custom-built inputs below.", "p")

-- Standard Button
MainTab:AddButton("Print Active Workspace", function()
    print("Current Workspace Children:")
    for _, child in ipairs(workspace:GetChildren()) do
        print(" - " .. child.Name)
    end
end)

-- Toggle Button
MainTab:AddToggle("Super Jump Enable", false, function(state)
    print("Super Jump state changed to: ", state)
    -- Your execution logic here...
end)

-- Text Input
MainTab:AddInput("Custom Command", "Type a command...", function(text, enterPressed)
    if enterPressed then
        print("Command executed via Enter key:", text)
    else
        print("Input focus lost. Value:", text)
    end
end)

-- Color Picker (Swapper)
MainTab:AddColorPicker("Theme Color Picker", Color3.fromRGB(140, 82, 255), function(selectedColor)
    print("New color picked:", tostring(selectedColor))
end)

-- Button + Input Combo (Value is dynamically passed to the button callback)
MainTab:AddButtonWithInput("Set WalkSpeed", "16", function(inputValue)
    local speed = tonumber(inputValue)
    local character = game.Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if speed and humanoid then
        humanoid.WalkSpeed = speed
        print("WalkSpeed successfully set to:", speed)
    else
        warn("Please enter a valid number value.")
    end
end)

-- Collapsible Accordion Block
local AdvancedSection = MainTab:AddCollapsible("Advanced Panel")
-- Note: Collapsible block returns a container to nest further custom assets if needed.


---------------------------------------------------------
-- TYPOGRAPHY TAB (HTML Semantic Mapping)
---------------------------------------------------------

TextTab:AddLabel("Aether Type System", "h1")
TextTab:AddLabel("Sub-Heading Style", "h2")
TextTab:AddLabel("Section Header Style", "h3")
TextTab:AddLabel("Minor Header Style", "h4")
TextTab:AddLabel("Micro Header Style", "h5")
TextTab:AddLabel("Labels Style", "h6")

TextTab:AddLabel("Standard Paragraph: This text block utilizes <b>bold text</b>, <i>italic styling</i>, and <s>strikethroughs</s> seamlessly using native RichText.", "p")


---------------------------------------------------------
-- CREDITS TAB
---------------------------------------------------------

CreditsTab:AddLabel("Aether UI Base", "h1")
CreditsTab:AddLabel("Designed to emulate sleek, CSS-inspired layouts inside Luau.", "p")
CreditsTab:AddLabel("<b>Developer:</b> hoctienganhcungtruong", "p")
CreditsTab:AddLabel("<b>Version:</b> 1.0.0 (Aether Amethyst Edition)", "p")
