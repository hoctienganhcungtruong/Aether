--[[
    Aether UI Library - Version 9
--]]

local Aether = {}
Aether.__index = Aether

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ParentGui = RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or (CoreGui:FindFirstChild("RobloxGui") or CoreGui)

local Theme = {
    Background = Color3.fromRGB(15, 12, 24),
    SidebarBg = Color3.fromRGB(22, 18, 36),
    ContainerBg = Color3.fromRGB(28, 24, 46),
    Accent = Color3.fromRGB(140, 82, 255),
    AccentHover = Color3.fromRGB(162, 114, 255),
    Text = Color3.fromRGB(245, 242, 255),
    TextMuted = Color3.fromRGB(150, 140, 175),
    Border = Color3.fromRGB(45, 35, 70),
    BorderActive = Color3.fromRGB(100, 70, 180),
    CornerRadius = UDim.new(0, 8),
}

local function tween(object, info, properties)
    local t = TweenService:Create(object, info, properties)
    t:Play()
    return t
end

-- MULTI-HANDLE DRAG SYSTEM (Allows moving UI via multiple handles)
local function makeDraggable(dragHandle, targetFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Aether.new(titleText, initialSize, minSize)
    local self = setmetatable({}, Aether)
    
    initialSize = initialSize or Vector2.new(580, 380)
    minSize = minSize or Vector2.new(450, 250)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AetherUI_" .. math.random(1000, 9999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = ParentGui
    self.ScreenGui = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, initialSize.X, 0, initialSize.Y)
    MainFrame.Position = UDim2.new(0.5, -initialSize.X/2, 0.5, -initialSize.Y/2)
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
    
    -- Topbar (Primary Drag Area)
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 36)
    Topbar.BackgroundColor3 = Theme.SidebarBg
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarBottomLine = Instance.new("Frame")
    TopbarBottomLine.Size = UDim2.new(1, 0, 0, 1)
    TopbarBottomLine.Position = UDim2.new(0, 0, 1, -1)
    TopbarBottomLine.BackgroundColor3 = Theme.Border
    TopbarBottomLine.BorderSizePixel = 0
    TopbarBottomLine.Parent = Topbar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Theme.Text
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar
    
    makeDraggable(Topbar, MainFrame)
    
    -- UNLOCK: Outer Left Border Drag-To-Move Handles
    local LeftDragEdge = Instance.new("Frame")
    LeftDragEdge.Name = "LeftDragEdge"
    LeftDragEdge.Size = UDim2.new(0, 6, 1, 0)
    LeftDragEdge.Position = UDim2.new(0, 0, 0, 0)
    LeftDragEdge.BackgroundTransparency = 1
    LeftDragEdge.Active = true
    LeftDragEdge.ZIndex = 15
    LeftDragEdge.Parent = MainFrame
    makeDraggable(LeftDragEdge, MainFrame)

    -- UNLOCK: Outer Top Border Drag-To-Move Handles
    local TopDragEdge = Instance.new("Frame")
    TopDragEdge.Name = "TopDragEdge"
    TopDragEdge.Size = UDim2.new(1, 0, 0, 6)
    TopDragEdge.Position = UDim2.new(0, 0, 0, 0)
    TopDragEdge.BackgroundTransparency = 1
    TopDragEdge.Active = true
    TopDragEdge.ZIndex = 15
    TopDragEdge.Parent = MainFrame
    makeDraggable(TopDragEdge, MainFrame)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 26, 0, 26)
    CloseButton.Position = UDim2.new(1, -31, 0.5, -13)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.TextMuted
    CloseButton.TextSize = 22
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.ZIndex = 16
    CloseButton.Parent = Topbar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
    MinimizeButton.Position = UDim2.new(1, -60, 0.5, -13)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.TextMuted
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.ZIndex = 16
    MinimizeButton.Parent = Topbar
    
    local isMinimized = false
    self.OriginalHeight = initialSize.Y
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            self.OriginalHeight = MainFrame.Size.Y.Offset
            tween(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 36)})
            MinimizeButton.Text = "+"
        else
            tween(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, self.OriginalHeight)})
            MinimizeButton.Text = "−"
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        tween(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 0)})
        task.wait(0.2)
        ScreenGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -36)
    Sidebar.Position = UDim2.new(0, 0, 0, 36)
    Sidebar.BackgroundColor3 = Theme.SidebarBg
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarRightLine = Instance.new("Frame")
    SidebarRightLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarRightLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarRightLine.BackgroundColor3 = Theme.Border
    SidebarRightLine.BorderSizePixel = 0
    SidebarRightLine.Parent = Sidebar
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Theme.Accent
    TabContainer.Parent = Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.Parent = TabContainer
    
    -- Dynamic Page Container
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -166, 1, -42)
    PageContainer.Position = UDim2.new(0, 160, 0, 36)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame
    
    ----------------------------------------------------------------------------
    -- INVISIBLE EDGE DRAG RESIZE SENSORS
    ----------------------------------------------------------------------------
    local RightDragEdge = Instance.new("Frame")
    RightDragEdge.Name = "RightDragEdgeSensor"
    RightDragEdge.Size = UDim2.new(0, 6, 1, -36) -- Stretches down the right side
    RightDragEdge.Position = UDim2.new(1, -6, 0, 36)
    RightDragEdge.BackgroundTransparency = 1
    RightDragEdge.Active = true
    RightDragEdge.ZIndex = 15
    RightDragEdge.Parent = MainFrame
    makeDraggable(RightDragEdge, MainFrame)
    
    local BottomDragEdge = Instance.new("Frame")
    BottomDragEdge.Name = "BottomDragEdgeSensor"
    BottomDragEdge.Size = UDim2.new(1, 0, 0, 6) -- Full width across the bottom
    BottomDragEdge.Position = UDim2.new(0, 0, 1, -6)
    BottomDragEdge.BackgroundTransparency = 1
    BottomDragEdge.Active = true
    BottomDragEdge.ZIndex = 15
    BottomDragEdge.Parent = MainFrame
    makeDraggable(BottomDragEdge, MainFrame)
    
    local CornerDragGrip = Instance.new("Frame")
    CornerDragGrip.Name = "CornerDragGripSensor"
    CornerDragGrip.Size = UDim2.new(0, 12, 0, 12)
    CornerDragGrip.Position = UDim2.new(1, -12, 1, -12)
    CornerDragGrip.BackgroundTransparency = 1
    CornerDragGrip.Active = true
    CornerDragGrip.ZIndex = 16 -- Highest layer priority
    CornerDragGrip.Parent = MainFrame
    
    local CornerIcon = Instance.new("ImageLabel")
    CornerIcon.Size = UDim2.new(1, 0, 1, 0)
    CornerIcon.BackgroundTransparency = 1
    CornerIcon.Image = "rbxassetid://6031093149"
    CornerIcon.ImageColor3 = Theme.TextMuted
    CornerIcon.Parent = CornerDragGrip
    makeDraggable(CornerDragGrip, MainFrame)

    self.MainFrame = MainFrame
    self.TabContainer = TabContainer
    self.PageContainer = PageContainer
    self.Tabs = {}
    self.ActiveTab = nil
    
    return self
end

-- Programmatic Resize API
function Aether:Resize(newSize, tweenDuration)
    if not self.MainFrame then return end
    
    local targetSize = UDim2.new(0, newSize.X, 0, newSize.Y)
    self.OriginalHeight = newSize.Y -- Updates reference height for minimize function
    
    if tweenDuration and tweenDuration > 0 then
        tween(self.MainFrame, TweenInfo.new(tweenDuration, Enum.EasingStyle.Quad), {Size = targetSize})
    else
        self.MainFrame.Size = targetSize
    end
end

-- Create Tab API
function Aether:AddTab(tabName)
    local Tab = {}
    Tab.Elements = {}
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 36)
    TabButton.BackgroundColor3 = Theme.ContainerBg
    TabButton.Text = tabName
    TabButton.TextColor3 = Theme.TextMuted
    TabButton.TextSize = 13
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
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -8, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.ScrollBarThickness = 5
    Page.ScrollBarImageColor3 = Theme.Accent
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Parent = self.PageContainer
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 10)
    PagePadding.Parent = Page
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Page
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
    end)
    
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
    
    if #self.TabContainer:GetChildren() == 2 then
        selectTab()
    end
    
    -- Text Label Element
    function Tab:AddLabel(text, tag)
        tag = string.lower(tag or "p")
        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.RichText = true
        Label.Text = text
        Label.Parent = Page

        local tagStyles = {
            h1 = {size = 22, font = Enum.Font.GothamBold, color = Theme.Text, height = 30},
            h2 = {size = 18, font = Enum.Font.GothamBold, color = Theme.Text, height = 26},
            h3 = {size = 16, font = Enum.Font.GothamSemibold, color = Theme.Text, height = 24},
            h4 = {size = 14, font = Enum.Font.GothamSemibold, color = Theme.Text, height = 22},
            p  = {size = 13, font = Enum.Font.Gotham, color = Theme.TextMuted, height = 18}
        }

        local config = tagStyles[tag] or tagStyles.p
        Label.TextSize = config.size
        Label.Font = config.font
        Label.TextColor3 = config.color
        Label.Size = UDim2.new(1, 0, 0, config.height)
        return Label
    end

    -- Button Element
    function Tab:AddButton(text, callback)
        callback = callback or function() end
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 38)
        Btn.BackgroundColor3 = Theme.ContainerBg
        Btn.Text = text
        Btn.TextColor3 = Theme.Text
        Btn.TextSize = 13
        Btn.Font = Enum.Font.GothamSemibold
        Btn.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = Btn
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = Btn
        
        Btn.MouseButton1Click:Connect(callback)
    end
    
    -- Toggle Element
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
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 44, 0, 22)
        Switch.Position = UDim2.new(1, -59, 0.5, -11)
        Switch.BackgroundColor3 = toggled and Theme.Accent or Color3.fromRGB(50, 45, 65)
        Switch.Text = ""
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
        
        Switch.MouseButton1Click:Connect(function()
            toggled = not toggled
            local goalPos = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            local goalColor = toggled and Theme.Accent or Color3.fromRGB(50, 45, 65)
            
            tween(Node, TweenInfo.new(0.15), {Position = goalPos})
            tween(Switch, TweenInfo.new(0.15), {BackgroundColor3 = goalColor})
            callback(toggled)
        end)
    end
    
    -- Input Element
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
        Label.TextSize = 13
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
        TextBox.Parent = InputFrame
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 5)
        BoxCorner.Parent = TextBox
        
        local BoxStroke = Instance.new("UIStroke")
        BoxStroke.Color = Theme.Border
        BoxStroke.Thickness = 1
        BoxStroke.Parent = TextBox
        
        TextBox.FocusLost:Connect(function(enterPressed)
            callback(TextBox.Text, enterPressed)
        end)
    end

    -- UNLOCK: Numeric Slider with dynamic hovering Value Label
    function Tab:AddSlider(text, min, max, default, callback)
        callback = callback or function() end
        local value = default or min
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 54)
        SliderFrame.BackgroundColor3 = Theme.ContainerBg
        SliderFrame.Parent = Page
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = Theme.CornerRadius
        Corner.Parent = SliderFrame
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = SliderFrame
        
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0.7, 0, 0, 20)
        Title.Position = UDim2.new(0, 15, 0, 8)
        Title.BackgroundTransparency = 1
        Title.Text = text
        Title.TextColor3 = Theme.Text
        Title.TextSize = 13
        Title.Font = Enum.Font.GothamSemibold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.3, -15, 0, 20)
        ValueLabel.Position = UDim2.new(0.7, 0, 0, 8)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(value)
        ValueLabel.TextColor3 = Theme.Accent
        ValueLabel.TextSize = 13
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame
        
        local Track = Instance.new("TextButton")
        Track.Size = UDim2.new(1, -30, 0, 6)
        Track.Position = UDim2.new(0, 15, 0, 36)
        Track.BackgroundColor3 = Color3.fromRGB(45, 38, 65)
        Track.Text = ""
        Track.AutoButtonColor = false
        Track.Parent = SliderFrame
        
        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1, 0)
        TrackCorner.Parent = Track
        
        local Fill = Instance.new("Frame")
        local startPercent = math.clamp((value - min) / (max - min), 0, 1)
        Fill.Size = UDim2.new(startPercent, 0, 1, 0)
        Fill.BackgroundColor3 = Theme.Accent
        Fill.Parent = Track
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill
        
        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 12, 0, 12)
        Knob.Position = UDim2.new(startPercent, -6, 0.5, -6)
        Knob.BackgroundColor3 = Theme.Text
        Knob.Parent = Track
        
        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1, 0)
        KnobCorner.Parent = Knob
        
        local sliding = false
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            local rawVal = min + (max - min) * relativeX
            local exactVal = math.floor(rawVal + 0.5)
            
            ValueLabel.Text = tostring(exactVal)
            Fill.Size = UDim2.new(relativeX, 0, 1, 0)
            Knob.Position = UDim2.new(relativeX, -6, 0.5, -6)
            
            callback(exactVal)
        end
        
        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                updateSlider(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
    end
    
    -- Saturation-Value Color Picker
    function Tab:AddColorPicker(text, defaultColor, callback)
        callback = callback or function() end
        local isOpened = false
        local h, s, v = defaultColor:ToHSV()
        local activeColor = defaultColor or Color3.fromRGB(140, 82, 255)
        
        local PickerFrame = Instance.new("Frame")
        PickerFrame.Size = UDim2.new(1, 0, 0, 42)
        PickerFrame.BackgroundColor3 = Theme.ContainerBg
        PickerFrame.ClipsDescendants = true
        PickerFrame.Parent = Page
        
        local PickerCorner = Instance.new("UICorner")
        PickerCorner.CornerRadius = Theme.CornerRadius
        PickerCorner.Parent = PickerFrame
        
        local PickerStroke = Instance.new("UIStroke")
        PickerStroke.Color = Theme.Border
        PickerStroke.Thickness = 1
        PickerStroke.Parent = PickerFrame
        
        local Header = Instance.new("TextButton")
        Header.Size = UDim2.new(1, 0, 0, 42)
        Header.BackgroundTransparency = 1
        Header.Text = ""
        Header.Parent = PickerFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Theme.Text
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Header
        
        local MiniShow = Instance.new("Frame")
        MiniShow.Size = UDim2.new(0, 22, 0, 22)
        MiniShow.Position = UDim2.new(1, -37, 0.5, -11)
        MiniShow.BackgroundColor3 = activeColor
        MiniShow.Parent = Header
        
        local MiniCorner = Instance.new("UICorner")
        MiniCorner.CornerRadius = UDim.new(1, 0)
        MiniCorner.Parent = MiniShow
        
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -30, 0, 140)
        Content.Position = UDim2.new(0, 15, 0, 42)
        Content.BackgroundTransparency = 1
        Content.Visible = false
        Content.Parent = PickerFrame
        
        local PreviewBox = Instance.new("Frame")
        PreviewBox.Size = UDim2.new(0.3, 0, 0, 90)
        PreviewBox.BackgroundColor3 = activeColor
        PreviewBox.Parent = Content
        
        local PreviewCorner = Instance.new("UICorner")
        PreviewCorner.CornerRadius = Theme.CornerRadius
        PreviewCorner.Parent = PreviewBox
        
        local SVCanvas = Instance.new("TextButton")
        SVCanvas.Size = UDim2.new(0.7, -10, 0, 90)
        SVCanvas.Position = UDim2.new(0.3, 10, 0, 0)
        SVCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        SVCanvas.Text = ""
        SVCanvas.Parent = Content
        
        local SVCorner = Instance.new("UICorner")
        SVCorner.CornerRadius = Theme.CornerRadius
        SVCorner.Parent = SVCanvas
        
        local WhiteOverlay = Instance.new("Frame")
        WhiteOverlay.Size = UDim2.new(1, 0, 1, 0)
        WhiteOverlay.Parent = SVCanvas
        
        local WhiteGrad = Instance.new("UIGradient")
        WhiteGrad.Transparency = NumberSequence.new(0, 1)
        WhiteGrad.Parent = WhiteOverlay
        
        local BlackOverlay = Instance.new("Frame")
        BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
        BlackOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        BlackOverlay.Parent = SVCanvas
        
        local BlackGrad = Instance.new("UIGradient")
        BlackGrad.Rotation = 90
        BlackGrad.Transparency = NumberSequence.new(1, 0)
        BlackGrad.Parent = BlackOverlay
        
        local Cursor = Instance.new("Frame")
        Cursor.Size = UDim2.new(0, 12, 0, 12)
        Cursor.Position = UDim2.new(s, -6, 1 - v, -6)
        Cursor.BackgroundTransparency = 1
        Cursor.Parent = SVCanvas
        
        local CursorRing = Instance.new("UIStroke")
        CursorRing.Color = Color3.fromRGB(255, 255, 255)
        CursorRing.Thickness = 2
        CursorRing.Parent = Cursor
        
        local CursorCorner = Instance.new("UICorner")
        CursorCorner.CornerRadius = UDim.new(1, 0)
        CursorCorner.Parent = Cursor
        
        local HueSlider = Instance.new("TextButton")
        HueSlider.Size = UDim2.new(1, 0, 0, 14)
        HueSlider.Position = UDim2.new(0, 0, 0, 105)
        HueSlider.Parent = Content
        
        local HueGrad = Instance.new("UIGradient")
        HueGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
        })
        HueGrad.Parent = HueSlider
        
        local HueCursor = Instance.new("Frame")
        HueCursor.Size = UDim2.new(0, 16, 0, 16)
        HueCursor.Position = UDim2.new(h, -8, 0.5, -8)
        HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        HueCursor.Parent = HueSlider
        
        local HueCursorCorner = Instance.new("UICorner")
        HueCursorCorner.CornerRadius = UDim.new(1, 0)
        HueCursorCorner.Parent = HueCursor
        
        local function updateColor()
            activeColor = Color3.fromHSV(h, s, v)
            PreviewBox.BackgroundColor3 = activeColor
            MiniShow.BackgroundColor3 = activeColor
            SVCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            callback(activeColor)
        end
        
        local svDragging = false
        local function updateSV(input)
            local mousePos = input.Position
            local relativeX = math.clamp((mousePos.X - SVCanvas.AbsolutePosition.X) / SVCanvas.AbsoluteSize.X, 0, 1)
            local relativeY = math.clamp((mousePos.Y - SVCanvas.AbsolutePosition.Y) / SVCanvas.AbsoluteSize.Y, 0, 1)
            
            s = relativeX
            v = 1 - relativeY
            Cursor.Position = UDim2.new(s, -6, relativeY, -6)
            updateColor()
        end
        
        SVCanvas.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                svDragging = true
                updateSV(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if svDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSV(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                svDragging = false
            end
        end)
        
        local hueDragging = false
        local function updateHue(input)
            local relativeX = math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
            h = relativeX
            HueCursor.Position = UDim2.new(h, -8, 0.5, -8)
            updateColor()
        end
        
        HueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDragging = true
                updateHue(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateHue(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDragging = false
            end
        end)
        
        Header.MouseButton1Click:Connect(function()
            isOpened = not isOpened
            Content.Visible = isOpened
            local targetHeight = isOpened and 192 or 42
            tween(PickerFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)})
        end)
    end
    
    -- Collapsible Block Element
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
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Header
        
        local Arrow = Instance.new("TextLabel")
        Arrow.Size = UDim2.new(0, 30, 0, 30)
        Arrow.Position = UDim2.new(1, -35, 0.5, -15)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "v"
        Arrow.TextColor3 = Theme.TextMuted
        Arrow.TextSize = 12
        Arrow.Font = Enum.Font.GothamSemibold
        Arrow.Parent = Header
        
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -30, 0, 0)
        Content.Position = UDim2.new(0, 15, 0, 42)
        Content.BackgroundTransparency = 1
        Content.Visible = false
        Content.Parent = CollapseFrame
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = Content
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if isOpened then
                Content.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                CollapseFrame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 55)
            end
        end)
        
        Header.MouseButton1Click:Connect(function()
            isOpened = not isOpened
            Content.Visible = isOpened
            local targetContentHeight = isOpened and ContentLayout.AbsoluteContentSize.Y or 0
            local targetFrameHeight = isOpened and (ContentLayout.AbsoluteContentSize.Y + 55) or 42
            
            tween(Content, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, targetContentHeight)})
            tween(CollapseFrame, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, targetFrameHeight)})
            Arrow.Text = isOpened and "^" or "v"
        end)
        
        local SubTab = {}
        function SubTab:AddButton(btnText, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 32)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
            Btn.Text = btnText
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 12
            Btn.Font = Enum.Font.GothamSemibold
            Btn.Parent = Content
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end
        
        function SubTab:AddLabel(labelText, tag)
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 0, 20)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = labelText
            Lbl.TextColor3 = Theme.TextMuted
            Lbl.TextSize = 11
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Content
            return Lbl
        end
        
        return SubTab
    end
    
    -- Combined Button + Input Element
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
