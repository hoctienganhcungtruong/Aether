--[[ Aether UI Library --]]

local Aether = {}
Aether.__index = Aether

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Fallback for testing environments
local ParentGui = RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or (CoreGui:FindFirstChild("RobloxGui") or CoreGui)

-- CSS to Luau Theme Mapping
local Theme = {
    Background = Color3.fromRGB(15, 12, 24),        -- Deep dark violet
    SidebarBg = Color3.fromRGB(22, 18, 36),         -- Slightly lighter violet
    ContainerBg = Color3.fromRGB(28, 24, 46),       -- Element container background
    Accent = Color3.fromRGB(140, 82, 255),          -- Vibrant amethyst purple
    AccentHover = Color3.fromRGB(162, 114, 255),    -- Light purple for hover states
    Text = Color3.fromRGB(245, 242, 255),           -- Clean off-white
    TextMuted = Color3.fromRGB(150, 140, 175),      -- Secondary text
    Border = Color3.fromRGB(45, 35, 70),            -- Subtle border stroke
    BorderActive = Color3.fromRGB(100, 70, 180),    -- Active border stroke
    CornerRadius = UDim.new(0, 8),
}

-- Utility: Smooth Tween Helper
local function tween(object, info, properties)
    local t = TweenService:Create(object, info, properties)
    t:Play()
    return t
end

-- Utility: Draggable Framework (Mobile & PC Friendly)
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create Window Creator
function Aether.new(titleText)
    local self = setmetatable({}, Aether)
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AetherUI_" .. math.random(1000, 9999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = ParentGui
    self.ScreenGui = ScreenGui
    
    -- Main Frame (CSS flex container imitation)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 580, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = Theme.CornerRadius
    MainCorner.Parent = MainFrame
    
    local MainBorder = Instance.new("UIStroke")
    MainBorder.Color = Theme.Border
    MainBorder.Thickness = 1
    MainBorder.Parent = MainFrame
    
    makeDraggable(MainFrame)
    
    -- Sidebar (Navigation)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Theme.SidebarBg
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarRightLine = Instance.new("Frame")
    SidebarRightLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarRightLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarRightLine.BackgroundColor3 = Theme.Border
    SidebarRightLine.BorderSizePixel = 0
    SidebarRightLine.Parent = Sidebar
    
    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "  " .. titleText
    Title.TextColor3 = Theme.Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Sidebar
    
    -- Tab Scroller
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Theme.Accent
    TabContainer.Parent = Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Parent = TabContainer
    
    -- Page Container
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -160, 1, 0)
    PageContainer.Position = UDim2.new(0, 160, 0, 0)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    self.MainFrame = MainFrame
    self.TabContainer = TabContainer
    self.PageContainer = PageContainer
    self.Tabs = {}
    self.ActiveTab = nil
    
    return self
end

-- Create Tab API
function Aether:AddTab(tabName)
    local Tab = {}
    Tab.Elements = {}
    
    -- Tab Switch Button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 36)
    TabButton.BackgroundColor3 = Theme.ContainerBg
    TabButton.Text = tabName
    TabButton.TextColor3 = Theme.TextMuted
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabContainer
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabButton
    
    local TabBtnStroke = Instance.new("UIStroke")
    TabBtnStroke.Color = Theme.Border
    TabBtnStroke.Thickness = 1
    TabBtnStroke.Parent = TabButton
    
    -- Page View Scroll
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Theme.Accent
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = self.PageContainer
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.Parent = Page
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Page
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Switch Tab Execution
    local function selectTab()
        if self.ActiveTab then
            self.ActiveTab.Page.Visible = false
            tween(self.ActiveTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ContainerBg, TextColor3 = Theme.TextMuted})
            self.ActiveTab.Stroke.Color = Theme.Border
        end
        Page.Visible = true
        tween(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text})
        TabBtnStroke.Color = Theme.Accent
        self.ActiveTab = {Page = Page, Button = TabButton, Stroke = TabBtnStroke}
    end
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    -- Hover Animations
    TabButton.MouseEnter:Connect(function()
        if self.ActiveTab.Button ~= TabButton then
            tween(TabButton, TweenInfo.new(0.2), {TextColor3 = Theme.Text})
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if self.ActiveTab.Button ~= TabButton then
            tween(TabButton, TweenInfo.new(0.2), {TextColor3 = Theme.TextMuted})
        end
    end)
    
    -- Auto Select First Tab
    if #self.TabContainer:GetChildren() == 2 then -- Layout object exists, so index 2 is first element
        selectTab()
    end
    
    -- ELEMENT CREATOR FUNCTIONS
    
    -- 0. Semantic Text Labels (HTML inspired Headers & Paragraphs)
    function Tab:AddLabel(text, tag)
        tag = string.lower(tag or "p")
        
        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextYAlignment = Enum.TextYAlignment.Center
        Label.RichText = true  -- Enables inline formatting tags like <b>, <i>, <s>, etc.
        Label.Text = text
        Label.Parent = Page

        -- CSS Config Mapper
        local tagStyles = {
            h1 = {size = 24, font = Enum.Font.GothamBold, color = Theme.Text, height = 30},
            h2 = {size = 20, font = Enum.Font.GothamBold, color = Theme.Text, height = 26},
            h3 = {size = 18, font = Enum.Font.GothamSemibold, color = Theme.Text, height = 24},
            h4 = {size = 16, font = Enum.Font.GothamSemibold, color = Theme.Text, height = 22},
            h5 = {size = 14, font = Enum.Font.GothamSemibold, color = Theme.TextMuted, height = 20},
            h6 = {size = 12, font = Enum.Font.GothamSemibold, color = Theme.TextMuted, height = 18},
            p  = {size = 13, font = Enum.Font.Gotham, color = Theme.TextMuted, height = 18}
        }

        local config = tagStyles[tag] or tagStyles.p
        Label.TextSize = config.size
        Label.Font = config.font
        Label.TextColor3 = config.color
        Label.Size = UDim2.new(1, 0, 0, config.height)

        return Label
    end

    -- 1. Standard Button
    function Tab:AddButton(text, callback)
        callback = callback or function() end
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 38)
        Btn.BackgroundColor3 = Theme.ContainerBg
        Btn.Text = text
        Btn.TextColor3 = Theme.Text
        Btn.TextSize = 14
        Btn.Font = Enum.Font.GothamSemibold
        Btn.AutoButtonColor = false
        Btn.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = Btn
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = Btn
        
        Btn.MouseButton1Down:Connect(function()
            tween(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent})
            callback()
        end)
        Btn.MouseButton1Up:Connect(function()
            tween(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ContainerBg})
        end)
        Btn.MouseEnter:Connect(function()
            tween(Stroke, TweenInfo.new(0.15), {Color = Theme.Accent})
        end)
        Btn.MouseLeave:Connect(function()
            tween(Stroke, TweenInfo.new(0.15), {Color = Theme.Border})
        end)
    end
    
    -- 2. Toggle Button
    function Tab:AddToggle(text, default, callback)
        callback = callback or function() end
        local toggled = default or false
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
        ToggleFrame.BackgroundColor3 = Theme.ContainerBg
        ToggleFrame.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = ToggleFrame
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        -- Toggle Switch Indicator
        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 44, 0, 22)
        Switch.Position = UDim2.new(1, -59, 0.5, -11)
        Switch.BackgroundColor3 = toggled and Theme.Accent or Color3.fromRGB(50, 45, 65)
        Switch.Text = ""
        Switch.AutoButtonColor = false
        Switch.Parent = ToggleFrame
        
        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch
        
        local Node = Instance.new("Frame")
        Node.Size = UDim2.new(0, 16, 0, 16)
        Node.Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        Node.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Node.Parent = Switch
        
        local NodeCorner = Instance.new("UICorner")
        NodeCorner.CornerRadius = UDim.new(1, 0)
        NodeCorner.Parent = Node
        
        local function toggle()
            toggled = not toggled
            local goalPos = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            local goalColor = toggled and Theme.Accent or Color3.fromRGB(50, 45, 65)
            
            tween(Node, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = goalPos})
            tween(Switch, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = goalColor})
            
            callback(toggled)
        end
        
        Switch.MouseButton1Click:Connect(toggle)
    end
    
    -- 3. Input Element
    function Tab:AddInput(text, placeholder, callback)
        callback = callback or function() end
        
        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(1, 0, 0, 42)
        InputFrame.BackgroundColor3 = Theme.ContainerBg
        InputFrame.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = InputFrame
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = InputFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, -10, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = InputFrame
        
        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(0.5, -15, 0, 26)
        TextBox.Position = UDim2.new(0.5, 0, 0.5, -13)
        TextBox.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
        TextBox.Text = ""
        TextBox.PlaceholderText = placeholder
        TextBox.PlaceholderColor3 = Theme.TextMuted
        TextBox.TextColor3 = Theme.Text
        TextBox.TextSize = 12
        TextBox.Font = Enum.Font.Gotham
        TextBox.ClipsDescendants = true
        TextBox.Parent = InputFrame
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 5)
        BoxCorner.Parent = TextBox
        
        local BoxStroke = Instance.new("UIStroke")
        BoxStroke.Color = Theme.Border
        BoxStroke.Thickness = 1
        BoxStroke.Parent = TextBox
        
        TextBox.Focused:Connect(function()
            tween(BoxStroke, TweenInfo.new(0.15), {Color = Theme.Accent})
        end)
        TextBox.FocusLost:Connect(function(enterPressed)
            tween(BoxStroke, TweenInfo.new(0.15), {Color = Theme.Border})
            callback(TextBox.Text, enterPressed)
        end)
    end
    
    -- 4. Color Picker Element
    function Tab:AddColorPicker(text, defaultColor, callback)
        callback = callback or function() end
        local activeColor = defaultColor or Color3.fromRGB(255, 255, 255)
        
        local ColorFrame = Instance.new("Frame")
        ColorFrame.Size = UDim2.new(1, 0, 0, 42)
        ColorFrame.BackgroundColor3 = Theme.ContainerBg
        ColorFrame.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = ColorFrame
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = ColorFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ColorFrame
        
        local ShowButton = Instance.new("TextButton")
        ShowButton.Size = UDim2.new(0, 36, 0, 22)
        ShowButton.Position = UDim2.new(1, -51, 0.5, -11)
        ShowButton.BackgroundColor3 = activeColor
        ShowButton.Text = ""
        ShowButton.Parent = ColorFrame
        
        local ShowCorner = Instance.new("UICorner")
        ShowCorner.CornerRadius = UDim.new(0, 4)
        ShowCorner.Parent = ShowButton
        
        -- Pre-configured minimal Color Choice cycle (saves screen real estate)
        local ColorsList = {
            Color3.fromRGB(255, 60, 60),   -- Red
            Color3.fromRGB(255, 160, 0),   -- Orange
            Color3.fromRGB(255, 240, 0),   -- Yellow
            Color3.fromRGB(60, 255, 60),   -- Green
            Color3.fromRGB(60, 200, 255),  -- Cyan
            Color3.fromRGB(140, 82, 255),  -- Purple
            Color3.fromRGB(255, 255, 255)  -- White
        }
        
        local colorIndex = 1
        ShowButton.MouseButton1Click:Connect(function()
            colorIndex = colorIndex + 1
            if colorIndex > #ColorsList then colorIndex = 1 end
            activeColor = ColorsList[colorIndex]
            ShowButton.BackgroundColor3 = activeColor
            callback(activeColor)
        end)
    end
    
    -- 5. Collapsible Block
    function Tab:AddCollapsible(text)
        local isOpened = false
        
        local CollapseFrame = Instance.new("Frame")
        CollapseFrame.Size = UDim2.new(1, 0, 0, 42)
        CollapseFrame.BackgroundColor3 = Theme.ContainerBg
        CollapseFrame.ClipsDescendants = true
        CollapseFrame.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = CollapseFrame
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = CollapseFrame
        
        local Header = Instance.new("TextButton")
        Header.Size = UDim2.new(1, 0, 0, 42)
        Header.BackgroundTransparency = 1
        Header.Text = ""
        Header.Parent = CollapseFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Header
        
        local Arrow = Instance.new("TextLabel")
        Arrow.Size = UDim2.new(0, 30, 0, 30)
        Arrow.Position = UDim2.new(1, -35, 0.5, -15)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "v" -- Simple fallback character pointing down
        Arrow.TextColor3 = Theme.TextMuted
        Arrow.TextSize = 14
        Arrow.Font = Enum.Font.GothamSemibold
        Arrow.Parent = Header
        
        -- Container inside collapsible block
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -30, 0, 100)
        Content.Position = UDim2.new(0, 15, 0, 42)
        Content.BackgroundTransparency = 1
        Content.Visible = false
        Content.Parent = CollapseFrame
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = Content
        
        Header.MouseButton1Click:Connect(function()
            isOpened = not isOpened
            Content.Visible = isOpened
            local targetHeight = isOpened and (ContentLayout.AbsoluteContentSize.Y + 55) or 42
            
            tween(CollapseFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, targetHeight)})
            Arrow.Text = isOpened and "^" or "v"
        end)
        
        return Content -- Return so elements can nest inside
    end
    
    -- 6. Button + Input Integration (Dynamic callback triggered by text value)
    function Tab:AddButtonWithInput(buttonText, placeholder, callback)
        callback = callback or function() end
        
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, 0, 0, 42)
        Container.BackgroundColor3 = Theme.ContainerBg
        Container.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = Container
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = Container
        
        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(0.5, -15, 0, 26)
        TextBox.Position = UDim2.new(0, 10, 0.5, -13)
        TextBox.BackgroundColor3 = Color3.fromRGB(22, 18, 32)
        TextBox.Text = ""
        TextBox.PlaceholderText = placeholder
        TextBox.PlaceholderColor3 = Theme.TextMuted
        TextBox.TextColor3 = Theme.Text
        TextBox.TextSize = 12
        TextBox.Font = Enum.Font.Gotham
        TextBox.ClipsDescendants = true
        TextBox.Parent = Container
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 5)
        BoxCorner.Parent = TextBox
        
        local BoxStroke = Instance.new("UIStroke")
        BoxStroke.Color = Theme.Border
        BoxStroke.Thickness = 1
        BoxStroke.Parent = TextBox
        
        local ActionBtn = Instance.new("TextButton")
        ActionBtn.Size = UDim2.new(0.5, -15, 0, 26)
        ActionBtn.Position = UDim2.new(0.5, 5, 0.5, -13)
        ActionBtn.BackgroundColor3 = Theme.Accent
        ActionBtn.Text = buttonText
        ActionBtn.TextColor3 = Theme.Text
        ActionBtn.TextSize = 12
        ActionBtn.Font = Enum.Font.GothamBold
        ActionBtn.Parent = Container
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 5)
        BtnCorner.Parent = ActionBtn
        
        ActionBtn.MouseButton1Click:Connect(function()
            callback(TextBox.Text)
        end)
    end
    
    return Tab
end

return Aether
