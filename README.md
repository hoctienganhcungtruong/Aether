# Aether

A modern, loadstring-compatible, and responsive Lua UI library for Roblox executors. Designed with a CSS-inspired purplish theme, featuring responsive desktop/mobile dragging, side-tabs, and an HTML-like Rich Text semantic engine.

---

## 🚀 Installation & Initialization

Fetch the library dynamically using `loadstring`:

```lua
local Aether = loadstring(game:HttpGet("https://raw.githubusercontent.com/hoctienganhcungtruong/Aether/main/v1.lua"))()

-- Create the main UI Window
local Window = Aether.new("Aether Base")

```

---

## API Reference

### Create Window

```lua
local Window = Aether.new(titleText)

```

* **`titleText`** (string): The title displayed in the upper-left sidebar.
* **Returns**: Window Object.

### Create Tab

```lua
local Tab = Window:AddTab(tabName)

```

* **`tabName`** (string): The text shown on the sidebar navigation button.
* **Returns**: Tab Object.

---

## Tab Elements

### 1. Semantic Text Labels

Supports HTML-style tag categorization. Native Roblox formatting (`<b>`, `<i>`, `<s>`) parses automatically when `RichText` is enabled.

```lua
Tab:AddLabel("Main Header", "h1")
Tab:AddLabel("Sub Header", "h2")
Tab:AddLabel("Standard Paragraph with <b>bold text</b>", "p")

```

* **Available tags**: `"h1"`, `"h2"`, `"h3"`, `"h4"`, `"h5"`, `"h6"`, `"p"`

### 2. Button

```lua
Tab:AddButton("Execute Script", function()
    print("Executed!")
end)

```

### 3. Toggle

```lua
Tab:AddToggle("God Mode", false, function(state)
    print("Toggle is now:", state)
end)

```

### 4. Text Input

```lua
Tab:AddInput("Walkspeed", "Enter speed...", function(text, enterPressed)
    print("Input changed to:", text)
end)

```

### 5. Color Picker

Quick-select color swapper cycling through essential accent choices.

```lua
Tab:AddColorPicker("ESP Color", Color3.fromRGB(140, 82, 255), function(color)
    print("Color selected:", color)
end)

```

### 6. Collapsible Block (Accordion)

Creates an expandable/collapsible canvas container. Returns a frame to layout inner elements.

```lua
local Collapsible = Tab:AddCollapsible("Advanced Options")

```

### 7. Button + Input (Combined)

Combines an input field and a validation button into one sleek row. Passes the text input directly to the button callback.

```lua
Tab:AddButtonWithInput("Set JumpPower", "Type value...", function(value)
    local num = tonumber(value)
    if num then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = num
    end
end)

```

---

## Theme Properties

Modify these colors directly in the top block of the source code to customize your UI theme:

```lua
local Theme = {
    Background = Color3.fromRGB(15, 12, 24),        -- Main background
    SidebarBg = Color3.fromRGB(22, 18, 36),         -- Sidebar background
    ContainerBg = Color3.fromRGB(28, 24, 46),       -- Input/Button background
    Accent = Color3.fromRGB(140, 82, 255),          -- Primary purple elements
    AccentHover = Color3.fromRGB(162, 114, 255),    -- Interactive hover highlights
    Text = Color3.fromRGB(245, 242, 255),           -- Active white text
    TextMuted = Color3.fromRGB(150, 140, 175),      -- Off-white/gray descriptions
    Border = Color3.fromRGB(45, 35, 70),            -- Outline stroke boundaries
    BorderActive = Color3.fromRGB(100, 70, 180),    -- Active input boundaries
    CornerRadius = UDim.new(0, 8),                  -- Component corner roundness
}

```
