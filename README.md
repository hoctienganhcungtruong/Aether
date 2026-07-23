# Aether UI Library

A high-performance, modern, and dark-themed Luau user interface library designed specifically for Roblox scripting environments. Aether UI combines a sleek, modern visual aesthetic with robust mechanics like dual-edge dragging, a multi-handle drag system, dynamic canvas scaling, and programmatic layout adjustments.

---

## Key Features

*   🎨 **Fully Customizable Themes:** Overwrite or modify the modern dark indigo color palette to match your branding.
*   📐 **Dynamic Programmatic Resize:** Resize your window layout smoothly using custom duration tweens with state synchronization.
*   ↕️ **Dual-Edge & Corner Resizing:** Manual resizing handles let users grab the right edge, bottom edge, or corner grip to scale manually.
*   🎛️ **Rich Component Suite:** Built-in controls including Saturation-Value color pickers, dynamic sliders, collapsible folders, and dual button-inputs.
*   ⚡ **Robust Drag System:** Drag the window seamlessly via the topbar, outer left border, or outer top border.

---

# Initialization & Window API

## `Aether.new(titleText, initialSize, minSize)`
Creates and returns a new Aether UI Window instance
- `titleText` (string): Text displayed in the top bar
- `initialSize` (Vector2, optional): (Vector2, optional): Initial size of the window (Default: `Vector2.new(580, 380)`)
- `minSize` (Vector2, optional): Minimum size constraint (Default: `Vector2.new(450, 250)`)
```lua
local Aether = loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/hoctienganhcungtruong/Aether@main/latest.lua"))()
local Window = Aether.new("Aether Hub", Vector2.new(600, 400))
```

## `Window:Resize(newSize, tweenDuration)`
Resizes the main window frame, optionally animating the transition.
- `newSize` (Vector2): Target dimensions for the window.
- `tweenDuration` (number, optional): Duration of the resize animation in seconds.
```lua
Window:Resize(Vector2.new(700, 500), 0.3)
```

## `Window:AddTab(tabName)`
Adds a new navigation tab to the window sidebar and returns a Tab instance.
- `tabName` (string): Name of the tab shown on the sidebar button.
```lua
local SettingsTab = Window:AddTab("Settings")
```

# Tab Component Methods

Every tab object created via Window:AddTab() supports the following component methods:

## `Tab:AddLabel(text, tag)`
Adds a styled text label. Supports HTML-like formatting tags and RichText formatting.
- `text (string)`: Text string to display.
- `tag` (string, optional): Style preset key. Supported tags:
 - `"h1"` – Header 1 (Size 22, Bold)
 - `"h2"` – Header 2 (Size 18, Bold)
 - `"h3"` – Header 3 (Size 16, Semibold)
 - `"h4"` – Header 4 (Size 14, Semibold)
 - `"p"` – Paragraph (Size 13, Regular) (default)
 - `"b"` – Bold text
 - `"i"` – Italic text
 - `"s"` – Strikethrough text
```lua
MainTab:AddLabel("Main Title", "h1")
MainTab:AddLabel("This is a description text.", "p")
```

## `Tab:AddButton(text, callback)`
Adds a standard clickable action button.
- `text` (string): Button label text.
- `callback` (function): Function called when clicked
```lua
MainTab:AddButton("Execute", function()
    print("Action executed")
end)
```

## `Tab:AddToggle(text, default, callback)`
Adds an interactive toggle switch.
- `text` (string): Label text.
- `default` (boolean): Initial state (true or false).
- `callback` (function): Function called on toggle state change. Receives (toggled: boolean)
```lua
MainTab:AddToggle("Auto Farm", false, function(enabled)
    print("Auto Farm set to:", enabled)
end)
```

## `Tab:AddDropdown(text, options, default, callback)`
Adds an expandable dropdown menu with radio selection options.
- `text` (string): Dropdown title label.  
- `options` (table): Array of options.
- `default` (any): Initially selected option.
- `callback` (function): Function called when an option is chosen. Receives (`selectedOption`)
```lua
MainTab:AddDropdown("Choose Mode", {"Easy", "Medium", "Hard"}, "Medium", function(selected)
    print("Difficulty set to:", selected)
end)
```

## `Tab:AddInput(text, placeholder, callback)`
Adds a text input box.
- `text` (string): Label text.
- `placeholder` (string): Placeholder text displayed inside the input field.
- `callback` (function): Called on FocusLost. Receives (`inputText`, `enterPressed`).
```lua
MainTab:AddInput("Player Name", "Enter name...", function(text, enterPressed)
    if enterPressed then
        print("Submitted text:", text)
    end
end)
```

## `Tab:AddKeybind(text, defaultKey, callback)`
Adds a keybind picker component.
- `text` (string): Keybind action description.
- `defaultKey` (Enum.KeyCode): Default trigger key (e.g., `Enum.KeyCode.E`).
- `callback` (function): Triggered when the assigned key is pressed.
```lua
MainTab:AddKeybind("Teleport Key", Enum.KeyCode.T, function(pressedKey)
    print("Teleport key pressed!")
end)
```

## `Tab:AddSlider(text, min, max, default, callback)`
Adds an interactive slider component.
- `text` (string): Title label.
- `min` (number): Minimum allowed value.
- `max` (number): Maximum allowed value.
- `default` (number): Initial slider value.
- `callback` (function): Called when slider moves. Receives (`integerValue`). 

## `Tab:AddColorPicker(text, defaultColor, callback)`
Adds an HSV color picker with visual saturation/value selection and a hue bar.
- `text` (string): Component label.
- `defaultColor` (Color3): Initial selected color.
- `callback` (function): Triggered upon color selection. Receives (`color3Value`).
```lua
MainTab:AddColorPicker("Accent Color", Color3.fromRGB(140, 82, 255), function(color)
    print("Selected Color:", color)
end)
```

## `Tab:AddCollapsible(text)`
Creates an expandable/collapsible accordion container for sub-items and returns a SubTab instance.
- `text` (string): Title header for the collapsible section.

### `SubTab` Methods

- `SubTab:AddButton(btnText, callback)`: Adds a button inside the collapsible container.
- `SubTab:AddLabel(labelText, tag)`: Adds a label inside the collapsible container.
```lua
local Group = MainTab:AddCollapsible("Advanced Controls")

Group:AddLabel("These settings are optional.", "p")
Group:AddButton("Reset Settings", function()
    print("Resetting settings...")
end)
```

## `Tab:AddButtonWithInput(buttonText, placeholder, callback)`
Adds an inline action block containing a text input field accompanied by a button.
- `buttonText` (string): Action button label.
- `placeholder` (string): Input field placeholder.
- `callback` (function): Triggered when clicking the action button. Receives (`inputText`).
```lua
MainTab:AddButtonWithInput("Teleport", "Target Player Name...", function(inputText)
    print("Teleporting to:", inputText)
end)
```

# Sample code

```lua
-- Load Aether (Replace with your actual loader script / file path)
local Aether = loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/hoctienganhcungtruong/Aether@main/latest.lua"))()

-- 1. WINDOW INSTANTIATION (titleText, initialSize, minSize)
local Window = Aether.new("Aether Showcase Dashboard", Vector2.new(620, 420), Vector2.new(450, 250))

-- Programmatically resize window (newSize, duration)
Window:Resize(Vector2.new(640, 450), 0.3)

-- 2. ADD TABS TO SIDEBAR
local ElementsTab = Window:AddTab("Components")
local PickersTab = Window:AddTab("Inputs & Keybinds")
local ContainersTab = Window:AddTab("Containers")

-- ====================================================================
-- TAB 1: BASIC COMPONENTS & TYPOGRAPHY
-- ====================================================================

-- Typography Labels (Supports rich text and tags: h1, h2, h3, h4, p, b, i, s)
ElementsTab:AddLabel("Typography Headers", "h1")
ElementsTab:AddLabel("Subheading level 2", "h2")
ElementsTab:AddLabel("Section header level 3", "h3")
ElementsTab:AddLabel("Minor header level 4", "h4")
ElementsTab:AddLabel("Paragraph text describing the standard components below.", "p")
ElementsTab:AddLabel("Bold styled label text", "b")
ElementsTab:AddLabel("Italic styled label text", "i")
ElementsTab:AddLabel("Strikethrough styled label text", "s")

-- Standard Clickable Button
ElementsTab:AddButton("Click Action Button", function()
    print("Standard Button Clicked!")
end)

-- Toggle Switch (text, default, callback)
ElementsTab:AddToggle("Enable Feature State", false, function(toggled)
    print("Toggle State Changed:", toggled)
end)

-- Number Slider (text, min, max, default, callback)
ElementsTab:AddSlider("WalkSpeed Modifier", 16, 200, 16, function(value)
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

-- Dropdown Menu (text, optionsTable, defaultOption, callback)
ElementsTab:AddDropdown("Select Game Mode", {"Casual", "Competitive", "Hardcore"}, "Casual", function(selectedOption)
    print("Dropdown Selected Option:", selectedOption)
end)


-- ====================================================================
-- TAB 2: INPUTS, KEYBINDS & COLOR PICKERS
-- ====================================================================

PickersTab:AddLabel("Interactive Input Controls", "h2")

-- Text Input Field (text, placeholder, callback)
PickersTab:AddInput("Player Username", "Type username...", function(inputText, enterPressed)
    print("Input Text:", inputText, "Submitted with Enter:", enterPressed)
end)

-- Inline Button with Text Input (buttonText, placeholder, callback)
PickersTab:AddButtonWithInput("Teleport Target", "Player name...", function(targetPlayer)
    print("Executing Teleport Action to:", targetPlayer)
end)

-- Keybind Picker (text, defaultKey, callback)
PickersTab:AddKeybind("Trigger Ability Keybind", Enum.KeyCode.E, function(triggeredKey)
    print("Keybind triggered via key:", triggeredKey.Name)
end)

-- HSV Color Picker (text, defaultColor3, callback)
PickersTab:AddColorPicker("UI Accent Color", Color3.fromRGB(140, 82, 255), function(color)
    print("Color Picker Selected RGB:", color.R * 255, color.G * 255, color.B * 255)
end)


-- ====================================================================
-- TAB 3: COLLAPSIBLE CONTAINERS
-- ====================================================================

ContainersTab:AddLabel("Collapsible Groups", "h2")

-- Collapsible Accordion (text) -> Returns SubTab container
local CollapsibleGroup = ContainersTab:AddCollapsible("Advanced Utilities")

-- Adding SubTab elements inside the Collapsible Container
CollapsibleGroup:AddLabel("Sub-element label inside container.", "p")
CollapsibleGroup:AddButton("Execute Sub-Action", function()
    print("Sub-button inside collapsible frame clicked!")
end)
```
