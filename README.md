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

## Installation & Setup

Load the library directly into your Luau script execution environment:

```lua
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v9.lua"))()

```

---

## Theme Customization

You can customize the visual colors of the library before calling `Aether.new()`. To do this, simply modify the values in the public dictionary or define your custom colors:

---

## API Documentation

### Window Setup

#### `Aether.new(titleText, initialSize, minSize)`

Creates a new root UI window instance.

* `titleText` (string) — The title displayed in the topbar header.
* `initialSize` (Vector2, optional) — The starting width and height (Default: `580, 380`).
* `minSize` (Vector2, optional) — The minimum size limits for manual resize boundaries (Default: `450, 250`).

```lua
local UI = Aether.new("My Script Menu", Vector2.new(580, 420), Vector2.new(450, 250))

```

#### `UI:Resize(newSize, tweenDuration)`

Programmatically scales the UI main frame size.

* `newSize` (Vector2) — The target width and height dimensions.
* `tweenDuration` (number, optional) — The transition time in seconds. Leaving this blank or using `0` scales the UI instantly.

```lua
-- Instantly resize the frame
UI:Resize(Vector2.new(650, 450))

-- Smoothly animate transition over 0.4 seconds
UI:Resize(Vector2.new(650, 450), 0.4)

```

#### `UI:AddTab(tabName)`

Adds a sidebar navigation tab button and content container.

* `tabName` (string) — Name of the navigation tab.
* **Returns**: A `Tab` object.

```lua
local MainTab = UI:AddTab("Combat")

```

---

### Tab Elements

#### `Tab:AddLabel(text, tag)`

Creates a structured text label supporting Roblox RichText.

* `text` (string) — Text string payload.
* `tag` (string, optional) — Semantic styles: `"h1"` (Title), `"h2"` (Subheader), `"h3"`, `"h4"`, or `"p"` (Paragraph text).

```lua
MainTab:AddLabel("Visual Modules", "h1")

```

#### `Tab:AddButton(text, callback)`

Appends a sleek interactive button.

* `text` (string) — Action text.
* `callback` (function) — Triggers when clicked.

```lua
MainTab:AddButton("Destroy Projectiles", function()
    -- Your action here
end)

```

#### `Tab:AddToggle(text, default, callback)`

Appends a modern state switch.

* `text` (string) — Toggle label description.
* `default` (boolean) — Initial state.
* `callback` (function) — Triggers and returns boolean state (`true`/`false`).

```lua
MainTab:AddToggle("Infinite Ammo", false, function(state)
    -- Your action here
end)

```

#### `Tab:AddInput(text, placeholder, callback)`

Appends a textbox field with placeholder text.

* `text` (string) — Label description.
* `placeholder` (string) — Textbox hint.
* `callback` (function) — Triggers `(text, enterPressed)` on focus loss.

```lua
MainTab:AddInput("Speed Adjuster", "e.g., 25", function(value, enterPressed)
    if enterPressed then print("Entered:", value) end
end)

```

#### `Tab:AddSlider(text, min, max, default, callback)`

Appends a clean slider with an updating numerical readout.

* `text` (string) — Slider name.
* `min`, `max` (number) — Numerical range.
* `default` (number) — Initial value.
* `callback` (function) — Returns selected integer on drag.

```lua
MainTab:AddSlider("Field of View", 70, 120, 90, function(value)
    -- Your action here
end)

```

#### `Tab:AddColorPicker(text, defaultColor, callback)`

Appends an expandable 2D Color canvas with hue spectrum slider.

* `text` (string) — Name label.
* `defaultColor` (Color3) — Color loaded on startup.
* `callback` (function) — Returns updating `Color3` object.

```lua
MainTab:AddColorPicker("Esp Color", Color3.fromRGB(140, 82, 255), function(color)
    -- Your action here
end)

```

#### `Tab:AddCollapsible(text)`

Appends a collapsable menu module to stack components logically.

* `text` (string) — Group header title.
* **Returns**: A `SubTab` folder capable of holding sub-buttons and labels.

```lua
local Folder = MainTab:AddCollapsible("Extra Settings")
Folder:AddButton("Perform Wipe", function() end)

```

#### `Tab:AddButtonWithInput(buttonText, placeholder, callback)`

A modern dual element holding a textbox and custom button packed in a single row.

* `buttonText` (string) — Trigger button label.
* `placeholder` (string) — Textbox hint.
* `callback` (function) — Returns the typed input text `(value)` on button click.

```lua
MainTab:AddButtonWithInput("Teleport To Player", "Target Name...", function(name)
    -- Your action here
end)

```

#### `Tab:AddDropdown(text, optionsArray, defaultDisplay, callback)`
Appends a advanced, polymorphic dropdown row. It accepts basic string arrays or structured dictionaries containing images, display text titles, and arbitrary values (such as `Vector3` coordinates, tables, or configurations). When an option is selected, it returns the completely raw, original data payload back to your callback function execution context.

<ul>
    <li>`text` (string) — Dropdown menu header label description.</li>
    <li>`optionsArray` (table) — An array list of strings, or dictionaries mapping out custom options:
        <ul>
            <li>`Display` or `Text` (string) — The text visible to the user on the screen.</li>
            <li>`Value` (any, optional) — The raw hidden payload returned to your callback (e.g. `Vector3`, `boolean`, `table`). Defaults to the display string if left empty.</li>
            <li>`Image` (number/string, optional) — A Roblox image asset ID to display as a custom option icon.</li>
        </ul>
    </li>
    <li>`defaultDisplay` (string, optional) — The initial active choice text displayed inside the header panel on boot.</li>
    <li>`callback` (function) — Fires and returns the raw `Value` payload object of the selected choice.</li>
</ul>

```lua
-- Example 1: Passing a dictionary array with explicit Vector3 coordinates and asset icons!
local TeleportPoints = {
    {Display = "Spawn Area", Value = Vector3.new(0, 50, 0), Image = 10839423450},
    {Display = "Desert Base", Value = Vector3.new(1420, 12, -85), Image = 10839424121},
    {Display = "Secret Vault", Value = Vector3.new(-500, -100, 2500)}
}

MainTab:AddDropdown("Warp Destination", TeleportPoints, "Spawn Area", function(targetVector)
    -- 'targetVector' passed here is a pure Vector3 data type, not a text string!
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(targetVector) end
end)

-- Example 2: Still completely backwards-compatible with simple string lists!
MainTab:AddDropdown("Weapon Loadout", {"M4A1", "AWM", "Deagle"}, "M4A1", function(selectedWeapon)
    print("Equipped text name string: " .. selectedWeapon)
end)
```

### Default Color Palette

```lua
-- Access and modify the styling configurations
local Theme = {
    Background = Color3.fromRGB(15, 12, 24),     -- Main background panel
    SidebarBg = Color3.fromRGB(22, 18, 36),      -- Left sidebar navigation background
    ContainerBg = Color3.fromRGB(28, 24, 46),    -- Inner element boxes/cards
    Accent = Color3.fromRGB(140, 82, 255),       -- Active purple accents, highlights, toggles
    AccentHover = Color3.fromRGB(162, 114, 255),  -- Highlight hover effects
    Text = Color3.fromRGB(245, 242, 255),        -- Primary headers & text
    TextMuted = Color3.fromRGB(150, 140, 175),   -- Descriptions, placeholders, inactive buttons
    Border = Color3.fromRGB(45, 35, 70),         -- Default borders and lines
    BorderActive = Color3.fromRGB(100, 70, 180),  -- Highlighted or focused borders
    CornerRadius = UDim.new(0, 8),               -- Frame corner roundness
}

```
---

## Full Code Demo

```lua
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v9.lua"))()

-- Instantiate UI Window
local UI = Aether.new("⚡ Aether v9 Active Mod Menu", Vector2.new(580, 420))

-- Create Tabs
local MainTab = UI:AddTab("Main")
local VisualsTab = UI:AddTab("Visuals")
local SizingTab = UI:AddTab("Sizing")

-- Create Controls
MainTab:AddLabel("Player Modifiers", "h1")
MainTab:AddToggle("Infinite Jump", false, function(state)
    -- Code execution
end)

VisualsTab:AddColorPicker("Chams Color", Color3.fromRGB(255, 0, 100), function(color)
    -- Code execution
end)

SizingTab:AddButton("Compact View", function()
    UI:Resize(Vector2.new(460, 300), 0.3)
end)

```
