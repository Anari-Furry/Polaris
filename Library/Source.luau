 local cloneref = cloneref or function(x)
    return x
end
local UserInputService = cloneref(game:GetService('UserInputService'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local TextService = cloneref(game:GetService('TextService'))
local RunService = cloneref(game:GetService('RunService'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIConfig = {
    Keybind = Enum.KeyCode.LeftControl,
}
local Polaris = {
    Flags = {},
    Elements = {},
}
local AllElements = {}
local Themes = {
    Default = {
        Name = 'Default',
        Main = Color3.fromRGB(20, 24, 40),
        Sidebar = Color3.fromRGB(8, 10, 18),
        Section = Color3.fromRGB(26, 30, 48),
        Text = Color3.fromRGB(242, 244, 255),
        SubText = Color3.fromRGB(170, 175, 205),
        Outline = Color3.fromRGB(85, 90, 130),
        Accent = Color3.fromRGB(135, 165, 255),
        AccentGrad = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 185, 255)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(120, 135, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(185, 115, 255)),
        },
        Hover = Color3.fromRGB(36, 38, 60),
        Transparency = 0,
        font = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        fontBold = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    },
}
local Default_Theme = Themes.Default

if not isfolder('Polaris') then
    makefolder('Polaris')
end

function Polaris:SaveConfig(name)
    local json = HttpService:JSONEncode(Polaris.Flags)

    if writefile then
        writefile('Polaris/' .. name .. '.json', json)
    end
end
function Polaris:LoadConfig(name)
    local path = 'Polaris/' .. name .. '.json'

    if not isfile or not isfile(path) then
        return
    end

    local content = readfile(path)
    local data = HttpService:JSONDecode(content)

    for flag, value in pairs(data)do
        Polaris.Flags[flag] = value

        if Polaris.Elements[flag] then
            Polaris.Elements[flag](value)
        end
    end
end
function Polaris:get_device()
    local device = 'Unknown'
    local viewportSize = workspace.CurrentCamera.ViewportSize

    if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        device = 'PC'
    elseif UserInputService.GamepadEnabled then
        device = 'Console'
    elseif UserInputService.TouchEnabled then
        local minDimension = math.min(viewportSize.X, viewportSize.Y)
        if minDimension > 600 then
            device = 'Tablet'
        else
            device = 'Mobile'
        end
    end

    self._device = device
end

Polaris:get_device()

function Polaris:get_screen_scale()
    local camera = workspace.CurrentCamera
    
    local viewportSize = camera.ViewportSize
    
    local width = 0
    local height = 0
    if self._device == 'PC' then
        width = 1920
        height = 1080
    elseif self._device == 'Tablet' then
        width = 1024
        height = 768
    elseif self._device == 'Mobile' then
        width = 1280
        height = 720
    else
        width = 1920
        height = 1080
    end
    
    local scaleX = viewportSize.X / width
    local scaleY = viewportSize.Y / height

    local scale = math.min(scaleX, scaleY)
    self._ui_scale = math.clamp(scale, 0.6, 1.4)

    return self._ui_scale
end

Polaris:get_screen_scale()

local function CreateCorner(parent, radius)
    local corner = Instance.new('UICorner')

    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent

    return corner
end
local function Tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end
local function Ripple(button)
    spawn(function()
        local ripple = Instance.new('ImageLabel')

        ripple.Name = 'Ripple'
        ripple.Parent = button
        ripple.BackgroundTransparency = 1
        ripple.BorderSizePixel = 0
        ripple.Image = 'rbxassetid://2708891598'
        ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ripple.ImageTransparency = 0.8
        ripple.ScaleType = Enum.ScaleType.Fit

        local x, y = Mouse.X - button.AbsolutePosition.X, Mouse.Y - button.AbsolutePosition.Y

        ripple.Position = UDim2.new(0, x, 0, y)

        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        Tween(ripple, tweenInfo, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(0, x - size / 2, 0, y - size / 2),
            ImageTransparency = 1,
        })
        wait(0.5)
        ripple:Destroy()
    end)
end
local function MakeDraggable(dragFrame, moveFrame, swipeCallback)
    local dragging, dragInput, dragStart, startPos
    local lastPos, lastTime, dragTime
    local velocity = Vector2.new(0, 0)

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

        local currentTime = tick()
        local deltaTime = currentTime - lastTime
        if deltaTime > 0 then
            velocity = Vector2.new(
                (input.Position.X - lastPos.X) / deltaTime,
                (input.Position.Y - lastPos.Y) / deltaTime
            )
        end
        lastPos = input.Position
        lastTime = currentTime

        Tween(moveFrame, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Position = targetPos})
    end

    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveFrame.Position
            lastPos = input.Position
            dragTime = tick()
            lastTime = tick()
            velocity = Vector2.new(0, 0)

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                    
                    local speed = 1400
                    local duration = tick() - dragTime

                    if duration <= 0.3 then
                        if (math.abs(velocity.X) > speed or math.abs(velocity.Y) > speed) then
                            if swipeCallback then
                                swipeCallback()
                            end
                        end
                    end
                end
            end)
        end
    end)
    dragFrame.InputChanged:Connect(function(input)
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

function Polaris:CustomTheme(config)
    if type(config) ~= 'table' or not config.Name then
        return
    end

    local NewTheme = {}

    for k, v in pairs(Themes.Default)do
        NewTheme[k] = v
    end
    for k, v in pairs(config)do
        NewTheme[k] = v
    end

    Themes[config.Name] = NewTheme
end
function Polaris:CreateWindow(options)
    local Title = options.Title or 'Polaris'
    local Theme = options.Theme or 'Default'
    local Icon = options.Icon or 'rbxassetid://115279747441313'
    local ConfigsFile = options.ConfigsFile or 'Default'
    local Scale = {
        Mobile = UDim2.new(0, 650, 0, 525),
        PC = UDim2.new(0, 850, 0, 600),
    }
    local FinalScale = options.Scale or Scale[Polaris._device] or Scale.PC

    if Themes[Theme] then
        Theme = Themes[Theme]
    else
        Theme = Themes.Default
    end
    if game.CoreGui:FindFirstChild('Polaris') then
        game.CoreGui.Polaris:Destroy()
    end

    local function CreateStroke(parent, color, thickness, transparency)
        local stroke = Instance.new('UIStroke')

        stroke.Color = color or Theme.Outline
        stroke.Thickness = thickness or 1
        stroke.Transparency = transparency or 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = parent

        return stroke
    end
    local function CreateGradient(parent)
        local gradient = Instance.new('UIGradient')

        gradient.Color = Theme.AccentGrad
        gradient.Rotation = 45
        gradient.Parent = parent

        return gradient
    end

    local ScreenGui = Instance.new('ScreenGui')

    ScreenGui.Name = 'Polaris'
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = CoreGui

    local UIScale = Instance.new('UIScale')

    UIScale.Scale = Polaris._ui_scale
    UIScale.Parent = ScreenGui

    local TextSize = TextService:GetTextSize(Title, 13, Enum.Font.GothamSemibold, Vector2.new(math.huge, 36)).X
    local MinWidth = 38 + TextSize + 16
    local MinimizedWidget = Instance.new('Frame')

    MinimizedWidget.Name = 'MinimizedWidget'
    MinimizedWidget.Size = UDim2.new(0, MinWidth, 0, 36)
    MinimizedWidget.AnchorPoint = Vector2.new(0.5, 0)
    MinimizedWidget.Position = UDim2.new(0.5, 0, 0, 15)
    MinimizedWidget.BackgroundColor3 = Theme.Sidebar
    MinimizedWidget.Visible = false
    MinimizedWidget.Active = true
    MinimizedWidget.ClipsDescendants = true
    MinimizedWidget.Parent = ScreenGui

    CreateCorner(MinimizedWidget, 18)

    local MinStroke = CreateStroke(MinimizedWidget, nil, 1.2, 0)

    CreateGradient(MinStroke)

    local MinIcon = Instance.new('ImageLabel')

    MinIcon.Size = UDim2.new(0, 18, 0, 18)
    MinIcon.Image = Icon
    MinIcon.Position = UDim2.new(0, 12, 0.5, -9)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Parent = MinimizedWidget

    CreateGradient(MinIcon)

    local MinLabel = Instance.new('TextLabel')

    MinLabel.Size = UDim2.new(1, -45, 1, 0)
    MinLabel.Position = UDim2.new(0, 38, 0, 0)
    MinLabel.Text = Title
    MinLabel.BackgroundTransparency = 1
    MinLabel.TextColor3 = Theme.Text
    MinLabel.FontFace = Theme.fontBold
    MinLabel.TextSize = 13
    MinLabel.TextXAlignment = Enum.TextXAlignment.Left
    MinLabel.Parent = MinimizedWidget

    local MaximizeBtn = Instance.new('TextButton')

    MaximizeBtn.Size = UDim2.new(1, 0, 1, 0)
    MaximizeBtn.BackgroundTransparency = 1
    MaximizeBtn.Text = ''
    MaximizeBtn.Parent = MinimizedWidget

    MakeDraggable(MaximizeBtn, MinimizedWidget)

    local MainFrame = Instance.new('Frame')

    MainFrame.Name = 'MainFrame'
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Main
    MainFrame.BackgroundTransparency = Theme.Transparency
    MainFrame.ZIndex = 100
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    CreateCorner(MainFrame, 12)
    CreateStroke(MainFrame, Theme.Outline, 1, 0)

    local Shadow = Instance.new('ImageLabel')

    Shadow.Name = 'Shadow'
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = 'rbxassetid://6014261993'
    Shadow.ImageTransparency = 0.4
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame

    Tween(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = FinalScale
    })

    local Topbar = Instance.new('Frame')

    Topbar.Name = 'Topbar'
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.BackgroundColor3 = Theme.Sidebar
    Topbar.BackgroundTransparency = 1
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarDivider = Instance.new('Frame')

    TopbarDivider.Size = UDim2.new(1, 0, 0, 1)
    TopbarDivider.Position = UDim2.new(0, 0, 1, 0)
    TopbarDivider.BackgroundColor3 = Theme.Main
    TopbarDivider.BackgroundTransparency = 0.5
    TopbarDivider.BorderSizePixel = 0
    TopbarDivider.Parent = Topbar

    local LogoContainer = Instance.new('Frame')

    LogoContainer.Size = UDim2.new(0, 50, 1, 0)
    LogoContainer.Position = UDim2.new(0, 10, 0, 0)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Topbar

    local LogoIcon = Instance.new('ImageLabel')

    LogoIcon.Size = UDim2.new(0, 32, 0, 32)
    LogoIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Image = Icon
    LogoIcon.Parent = LogoContainer

    CreateGradient(LogoIcon)

    local AppTitle = Instance.new('TextLabel')

    AppTitle.Text = Title
    AppTitle.FontFace = Theme.fontBold
    AppTitle.TextSize = 16
    AppTitle.TextColor3 = Theme.Text
    AppTitle.Size = UDim2.new(0, 150, 1, 0)
    AppTitle.Position = UDim2.new(0, 60, 0, 0)
    AppTitle.BackgroundTransparency = 1
    AppTitle.TextXAlignment = Enum.TextXAlignment.Left
    AppTitle.Parent = Topbar

    local SearchBar = Instance.new('Frame')

    SearchBar.Size = UDim2.new(0, 32, 0, 32)
    SearchBar.AnchorPoint = Vector2.new(1, 0.5)
    SearchBar.Position = UDim2.new(1, -15, 0.5, 0)
    SearchBar.BackgroundColor3 = Theme.Section
    SearchBar.BackgroundTransparency = 1
    SearchBar.ClipsDescendants = true
    SearchBar.Parent = Topbar

    CreateCorner(SearchBar, 12)

    local SearchStroke = CreateStroke(SearchBar, Theme.Outline, 1, 0.8)
    local SearchIcon = Instance.new('ImageLabel')

    SearchIcon.AnchorPoint = Vector2.new(1, 0.5)
    SearchIcon.Size = UDim2.new(0, 18, 0, 18)
    SearchIcon.Position = UDim2.new(1, -7, 0.5, 0)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = 'rbxassetid://115279747441313'
    SearchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    SearchIcon.Parent = SearchBar

    CreateGradient(SearchIcon)

    local SearchInput = Instance.new('TextBox')

    SearchInput.Size = UDim2.new(1, -32, 1, 0)
    SearchInput.Position = UDim2.new(0, 8, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.PlaceholderText = 'Search features...'
    SearchInput.Text = ''
    SearchInput.TextColor3 = Theme.Text
    SearchInput.PlaceholderColor3 = Theme.SubText
    SearchInput.FontFace = Theme.font
    SearchInput.TextSize = 13
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Visible = false
    SearchInput.Parent = SearchBar

    local SearchTrigger = Instance.new('TextButton')

    SearchTrigger.Size = UDim2.new(0, 32, 1, 0)
    SearchTrigger.AnchorPoint = Vector2.new(1, 0.5)
    SearchTrigger.Position = UDim2.new(1, 0, 0.5, 0)
    SearchTrigger.BackgroundTransparency = 1
    SearchTrigger.Text = ''
    SearchTrigger.Parent = SearchBar

    local SuggestList = Instance.new('ScrollingFrame')

    SuggestList.Name = 'SuggestList'
    SuggestList.Size = UDim2.new(0, 220, 0, 0)
    SuggestList.Position = UDim2.new(1, -15, 0, 52)
    SuggestList.AnchorPoint = Vector2.new(1, 0)
    SuggestList.BackgroundColor3 = Theme.Sidebar
    SuggestList.BackgroundTransparency = 0.05
    SuggestList.BorderSizePixel = 0
    SuggestList.ZIndex = 1000
    SuggestList.Visible = false
    SuggestList.ScrollBarThickness = 2
    SuggestList.ScrollBarImageColor3 = Theme.Accent
    SuggestList.Parent = MainFrame

    CreateCorner(SuggestList, 8)

    local SugStroke = CreateStroke(SuggestList, Theme.Outline, 1, 0)
    local SugLayout = Instance.new('UIListLayout')

    SugLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SugLayout.Padding = UDim.new(0, 4)
    SugLayout.Parent = SuggestList

    local SugPad = Instance.new('UIPadding')

    SugPad.PaddingTop = UDim.new(0, 6)
    SugPad.PaddingBottom = UDim.new(0, 6)
    SugPad.PaddingLeft = UDim.new(0, 6)
    SugPad.PaddingRight = UDim.new(0, 6)
    SugPad.Parent = SuggestList

    SearchTrigger.MouseButton1Click:Connect(function()
        SearchInput:CaptureFocus()
    end)
    SearchInput.Focused:Connect(function()
        SearchInput.Visible = true

        Tween(SearchStroke, TweenInfo.new(0.3), {
            Color = Theme.Accent,
            Transparency = 0,
        })
        Tween(SearchBar, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 32),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 0.2,
        })

        SearchTrigger.Visible = false
    end)
    SearchInput.FocusLost:Connect(function()
        local hasText = SearchInput.Text ~= '' and SearchInput.Text:gsub('%s+', '') ~= ''

        if hasText then
            Tween(SearchStroke, TweenInfo.new(0.3), {
                Color = Theme.Accent,
                Transparency = 0,
            })

            SearchTrigger.Visible = false
        else
            Tween(SearchStroke, TweenInfo.new(0.3), {
                Color = Theme.Outline,
                Transparency = 0.8,
            })
            Tween(SearchBar, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 32, 0, 32),
                BackgroundColor3 = Theme.Section,
                BackgroundTransparency = 1,
            })

            SearchInput.Visible = false
            SearchTrigger.Visible = true
            SuggestList.Visible = false
        end
    end)

    local Sidebar = Instance.new('Frame')

    Sidebar.Name = 'Sidebar'
    Sidebar.Size = UDim2.new(0, 130, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarDivider = Instance.new('Frame')

    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.Position = UDim2.new(1, 0, 0, 0)
    SidebarDivider.BackgroundColor3 = Theme.Main
    SidebarDivider.BackgroundTransparency = 0.5
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = Sidebar

    local TabContainer = Instance.new('ScrollingFrame')

    TabContainer.Size = UDim2.new(1, -10, 1, -70)
    TabContainer.Position = UDim2.new(0, 5, 0, 10)
    TabContainer.ScrollBarImageTransparency = 1
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar

    local TabList = Instance.new('UIListLayout')

    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Parent = TabContainer

    local Pages = Instance.new('Frame')

    Pages.Name = 'Pages'
    Pages.Size = UDim2.new(1, -130, 1, -50)
    Pages.Position = UDim2.new(0, 130, 0, 50)
    Pages.BackgroundTransparency = 1
    Pages.ClipsDescendants = true
    Pages.Parent = MainFrame

    local function ToggleMinimize()
        local AnimInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local MainStroke = MainFrame:FindFirstChildWhichIsA('UIStroke')

        if MainFrame.Visible then
            Tween(MainFrame, AnimInfo, {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
            })

            if MainStroke then
                Tween(MainStroke, AnimInfo, {Transparency = 1})
            end

            task.wait(0.1)

            MainFrame.Visible = false
            MinimizedWidget.Visible = true
            MinimizedWidget.Size = UDim2.new(0, 0, 0, 36)
            MinimizedWidget.BackgroundTransparency = 1
            MinStroke.Transparency = 1
            MinIcon.ImageTransparency = 1
            MinLabel.TextTransparency = 1

            Tween(MinimizedWidget, AnimInfo, {
                Size = UDim2.new(0, MinWidth, 0, 36),
                BackgroundTransparency = 0,
            })
            Tween(MinStroke, AnimInfo, {Transparency = 0})
            Tween(MinIcon, AnimInfo, {ImageTransparency = 0})
            Tween(MinLabel, AnimInfo, {TextTransparency = 0})
        else
            Tween(MinimizedWidget, AnimInfo, {
                Size = UDim2.new(0, 0, 0, 36),
                BackgroundTransparency = 1,
            })
            Tween(MinStroke, AnimInfo, {Transparency = 1})
            Tween(MinIcon, AnimInfo, {ImageTransparency = 1})
            Tween(MinLabel, AnimInfo, {TextTransparency = 1})
            task.wait(0.1)

            MinimizedWidget.Visible = false
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            MainFrame.BackgroundTransparency = 1

            if MainStroke then
                MainStroke.Transparency = 1
            end

            Tween(MainFrame, AnimInfo, {
                Size = FinalScale,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = Theme.Transparency,
            })

            if MainStroke then
                Tween(MainStroke, AnimInfo, {Transparency = 0.5})
            end
        end
    end

    MaximizeBtn.MouseButton1Click:Connect(ToggleMinimize)
    MakeDraggable(MainFrame, MainFrame, function()
        if MainFrame.Visible then
            ToggleMinimize()
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == UIConfig.Keybind then
                ToggleMinimize()
            end
        end
    end)

    local function UpdateSearch()
        local raw_val = SearchInput.Text
        local query_val = raw_val:lower():gsub('^%s+', ''):gsub('%s+$', '')
        local searching = (query_val ~= '')

        for _, item in pairs(SuggestList:GetChildren())do
            if item:IsA('TextButton') then
                item:Destroy()
            end
        end

        if searching then
            SuggestList.Visible = true

            local match_count = 0

            for _, element in pairs(AllElements)do
                if string.find(element.item_name:lower(), query_val, 1, true) or string.find(element.sec_name:lower(), query_val, 1, true) then
                    match_count = match_count + 1

                    local match_btn = Instance.new('TextButton')

                    match_btn.Size = UDim2.new(1, 0, 0, 40)
                    match_btn.BackgroundColor3 = Theme.Hover
                    match_btn.BackgroundTransparency = 1
                    match_btn.Text = ''
                    match_btn.AutoButtonColor = false
                    match_btn.ZIndex = SuggestList.ZIndex + 1
                    match_btn.Parent = SuggestList

                    CreateCorner(match_btn, 6)

                    local NameLabel = Instance.new('TextLabel')

                    NameLabel.Size = UDim2.new(1, -10, 0.5, 0)
                    NameLabel.Position = UDim2.new(0, 8, 0, 0)
                    NameLabel.BackgroundTransparency = 1
                    NameLabel.Text = element.is_section and ('<b>[Section]</b> ' .. element.item_name) or element.item_name
                    NameLabel.RichText = true
                    NameLabel.TextColor3 = element.is_section and Theme.Accent or Theme.Text
                    NameLabel.FontFace = Theme.fontBold
                    NameLabel.TextSize = 13
                    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    NameLabel.Parent = match_btn

                    local TabLabel = Instance.new('TextLabel')

                    TabLabel.Size = UDim2.new(1, -10, 0.5, 0)
                    TabLabel.Position = UDim2.new(0, 8, 0.5, 0)
                    TabLabel.BackgroundTransparency = 1
                    TabLabel.Text = element.is_section and ('Tab: ' .. element.tab_name) or (element.tab_name .. ' > ' .. element.sec_name)
                    TabLabel.TextColor3 = Theme.SubText
                    TabLabel.FontFace = Theme.font
                    TabLabel.TextSize = 11
                    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
                    TabLabel.Parent = match_btn

                    match_btn.MouseButton1Click:Connect(function()
                        SearchInput.Text = ''

                        SearchInput:ReleaseFocus()

                        SuggestList.Visible = false

                        element.switch_func()

                        if element.open_box_func then
                            element.open_box_func()
                        end

                        task.spawn(function()
                            RunService.RenderStepped:Wait()

                            local page = element.page_obj
                            local target_ui = element.ui_element
                            local go_y = target_ui.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 12
                            local max_scroll = math.max(0, page.AbsoluteCanvasSize.Y - page.AbsoluteSize.Y)

                            go_y = math.clamp(go_y, 0, max_scroll)

                            Tween(page, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                                CanvasPosition = Vector2.new(0, go_y),
                            })

                            local start_bg = target_ui.BackgroundColor3
                            local start_tr = target_ui.BackgroundTransparency

                            Tween(target_ui, TweenInfo.new(0.2), {
                                BackgroundColor3 = Theme.Accent,
                                BackgroundTransparency = 0.25,
                            })
                            task.delay(1, function()
                                Tween(target_ui, TweenInfo.new(0.4), {
                                    BackgroundColor3 = start_bg,
                                    BackgroundTransparency = start_tr,
                                })
                            end)
                        end)
                    end)
                end
            end

            local final_h = math.min((match_count * 34) + ((match_count - 1) * 4) + 12, 160)

            Tween(SuggestList, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 220, 0, final_h),
            })

            if match_count == 0 then
                SuggestList.Visible = false
            end
        else
            SuggestList.Visible = false

            Tween(SuggestList, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 220, 0, 0),
            })
        end
    end

    SearchInput:GetPropertyChangedSignal('Text'):Connect(UpdateSearch)

    local NotifyContainer = Instance.new('Frame')

    NotifyContainer.Name = 'NotificationContainer'
    NotifyContainer.Position = UDim2.new(1, -20, 1, -20)
    NotifyContainer.AnchorPoint = Vector2.new(1, 1)
    NotifyContainer.Size = UDim2.new(0, 300, 1, 0)
    NotifyContainer.BackgroundTransparency = 1
    NotifyContainer.ZIndex = 999
    NotifyContainer.Parent = ScreenGui

    local NotifyList = Instance.new('UIListLayout')

    NotifyList.Padding = UDim.new(0, 10)
    NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifyList.Parent = NotifyContainer

    function Polaris:Notify(cfg)
        local NTitle = cfg.Title or 'Notification'
        local NContent = cfg.Content or 'Content goes here'
        local NDuration = cfg.Duration or 5
        local NIcon = cfg.Icon or 'rbxassetid://115279747441313'
        local NotifyFrame = Instance.new('Frame')

        NotifyFrame.Name = 'NotifyFrame'
        NotifyFrame.Size = UDim2.new(1, 0, 0, 60)
        NotifyFrame.BackgroundColor3 = Theme.Main
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.Position = UDim2.new(1, 50, 0, 0)
        NotifyFrame.ZIndex = NotifyContainer.ZIndex + 1
        NotifyFrame.Parent = NotifyContainer

        CreateCorner(NotifyFrame, 8)

        local NStroke = CreateStroke(NotifyFrame, Theme.Outline, 1, 1)
        local IconImg = Instance.new('ImageLabel')

        IconImg.Size = UDim2.new(0, 24, 0, 24)
        IconImg.Position = UDim2.new(0, 12, 0.5, -15)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = NIcon
        IconImg.ImageColor3 = Theme.Accent
        IconImg.ImageTransparency = 1
        IconImg.ZIndex = NotifyFrame.ZIndex + 1
        IconImg.Parent = NotifyFrame

        local TitleLbl = Instance.new('TextLabel')

        TitleLbl.Text = NTitle
        TitleLbl.FontFace = Theme.fontBold
        TitleLbl.TextSize = 13
        TitleLbl.TextColor3 = Theme.Text
        TitleLbl.Position = UDim2.new(0, 46, 0, 10)
        TitleLbl.Size = UDim2.new(1, -56, 0, 15)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.ZIndex = NotifyFrame.ZIndex + 1
        TitleLbl.TextTransparency = 1
        TitleLbl.Parent = NotifyFrame

        local DescLbl = Instance.new('TextLabel')

        DescLbl.Text = NContent
        DescLbl.FontFace = Theme.font
        DescLbl.TextSize = 12
        DescLbl.TextColor3 = Theme.SubText
        DescLbl.Position = UDim2.new(0, 46, 0, 28)
        DescLbl.Size = UDim2.new(1, -56, 0, 15)
        DescLbl.BackgroundTransparency = 1
        DescLbl.TextXAlignment = Enum.TextXAlignment.Left
        DescLbl.ZIndex = NotifyFrame.ZIndex + 1
        DescLbl.TextTransparency = 1
        DescLbl.Parent = NotifyFrame

        local N_TimeBarBase = Instance.new('Frame')

        N_TimeBarBase.Name = 'TimeBarBase'
        N_TimeBarBase.Size = UDim2.new(1, -10, 0, 2)
        N_TimeBarBase.Position = UDim2.new(0, 1, 1, -2)
        N_TimeBarBase.BackgroundColor3 = Theme.Main
        N_TimeBarBase.BackgroundTransparency = 1
        N_TimeBarBase.ZIndex = NotifyFrame.ZIndex + 1
        N_TimeBarBase.Parent = NotifyFrame

        CreateCorner(N_TimeBarBase, 2)

        local N_TimeBar = Instance.new('Frame')

        N_TimeBar.Name = 'TimeBar'
        N_TimeBar.Size = UDim2.new(1, 0, 1, 0)
        N_TimeBar.BackgroundColor3 = Theme.Accent
        N_TimeBar.BorderSizePixel = 0
        N_TimeBar.BackgroundTransparency = 1
        N_TimeBar.ZIndex = NotifyFrame.ZIndex + 1
        N_TimeBar.Parent = N_TimeBarBase

        CreateCorner(N_TimeBar, 2)
        Tween(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1})
        Tween(NStroke, TweenInfo.new(0.5), {Transparency = 0})
        Tween(IconImg, TweenInfo.new(0.5), {ImageTransparency = 0})
        Tween(TitleLbl, TweenInfo.new(0.5), {TextTransparency = 0})
        Tween(DescLbl, TweenInfo.new(0.5), {TextTransparency = 0})
        Tween(N_TimeBar, TweenInfo.new(0.5), {BackgroundTransparency = 0})
        task.spawn(function()
            Tween(N_TimeBar, TweenInfo.new(NDuration, Enum.EasingStyle.Linear), {
                Size = UDim2.new(0, 0, 1, 0),
            })
            task.wait(NDuration)
            Tween(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
            })
            Tween(NStroke, TweenInfo.new(0.5), {Transparency = 1})
            Tween(IconImg, TweenInfo.new(0.5), {ImageTransparency = 1})
            Tween(TitleLbl, TweenInfo.new(0.5), {TextTransparency = 1})
            Tween(DescLbl, TweenInfo.new(0.5), {TextTransparency = 1})
            Tween(N_TimeBar, TweenInfo.new(0.5), {BackgroundTransparency = 1})
            task.wait(0.5)
            NotifyFrame:Destroy()
        end)
    end

    local Tabs = {}
    local First = true

    function Tabs:Tab(name, icon)
        local TabBtn = Instance.new('TextButton')

        TabBtn.Size = UDim2.new(1, 0, 0, 42)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ''
        TabBtn.Parent = TabContainer

        local TabLabel = Instance.new('TextLabel')

        TabLabel.Text = name
        TabLabel.Position = UDim2.new(0, 46, 0, 0)
        TabLabel.Size = UDim2.new(1, -46, 1, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.TextColor3 = Theme.SubText
        TabLabel.FontFace = Theme.font
        TabLabel.TextSize = 15
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        local TabIcon = Instance.new('ImageLabel')

        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabIcon.Position = UDim2.new(0, 16, 0.5, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon or 'rbxassetid://7072717926'
        TabIcon.ImageColor3 = Theme.SubText
        TabIcon.Parent = TabBtn

        local ActiveIndicator = Instance.new('Frame')

        ActiveIndicator.Size = UDim2.new(0, 3, 0, 26)
        ActiveIndicator.Position = UDim2.new(0, 0, 0.5, -13)
        ActiveIndicator.BackgroundColor3 = Theme.Accent
        ActiveIndicator.BackgroundTransparency = 1
        ActiveIndicator.Parent = TabBtn

        CreateCorner(ActiveIndicator, 4)

        local Page = Instance.new('ScrollingFrame')

        Page.Name = icon .. '_Page'
        Page.Size = UDim2.new(1, -20, 1, 0)
        Page.Position = UDim2.new(0, 10, 0, 0)
        Page.BackgroundTransparency = 1
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.ScrollBarImageTransparency = 1
        Page.ScrollBarThickness = 1
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.Visible = false
        Page.Parent = Pages

        Page:SetAttribute('Active', false)

        local LeftColumn = Instance.new('Frame')

        LeftColumn.Name = 'LeftColumn'
        LeftColumn.Size = UDim2.new(0.5, -6, 0, 0)
        LeftColumn.Position = UDim2.new(0, 0, 0, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.AutomaticSize = Enum.AutomaticSize.Y
        LeftColumn.Parent = Page

        local LeftLayout = Instance.new('UIListLayout')

        LeftLayout.Padding = UDim.new(0, 12)
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Parent = LeftColumn

        local LeftPadding = Instance.new('UIPadding')

        LeftPadding.PaddingTop = UDim.new(0, 20)
        LeftPadding.PaddingLeft = UDim.new(0, 15)
        LeftPadding.PaddingRight = UDim.new(0, 6)
        LeftPadding.PaddingBottom = UDim.new(0, 10)
        LeftPadding.Parent = LeftColumn

        local RightColumn = Instance.new('Frame')

        RightColumn.Name = 'RightColumn'
        RightColumn.Size = UDim2.new(0.5, -6, 0, 0)
        RightColumn.Position = UDim2.new(0.5, 0, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.AutomaticSize = Enum.AutomaticSize.Y
        RightColumn.Parent = Page

        local RightLayout = Instance.new('UIListLayout')

        RightLayout.Padding = UDim.new(0, 12)
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Parent = RightColumn

        local RightPadding = Instance.new('UIPadding')

        RightPadding.PaddingTop = UDim.new(0, 20)
        RightPadding.PaddingLeft = UDim.new(0, 6)
        RightPadding.PaddingRight = UDim.new(0, 15)
        RightPadding.PaddingBottom = UDim.new(0, 10)
        RightPadding.Parent = RightColumn

        local function switch_tab()
            for _, t in pairs(TabContainer:GetChildren())do
                if t:IsA('TextButton') then
                    Tween(t.TextLabel, TweenInfo.new(0.3), {
                        TextColor3 = Theme.SubText,
                    })
                    Tween(t.ImageLabel, TweenInfo.new(0.3), {
                        ImageColor3 = Theme.SubText,
                    })
                    Tween(t.Frame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
                end
            end
            for _, p in pairs(Pages:GetChildren())do
                p.Visible = false

                p:SetAttribute('Active', false)
            end

            Tween(TabLabel, TweenInfo.new(0.3), {
                TextColor3 = Theme.Accent,
            })
            Tween(TabIcon, TweenInfo.new(0.3), {
                ImageColor3 = Theme.Accent,
            })
            Tween(ActiveIndicator, TweenInfo.new(0.3), {BackgroundTransparency = 0})

            Page.Visible = true

            Page:SetAttribute('Active', true)
        end

        TabBtn.MouseButton1Click:Connect(function()
            if SearchInput.Text ~= '' then
                return
            end

            switch_tab()
        end)

        if First then
            First = false
            TabLabel.TextColor3 = Theme.Accent
            TabIcon.ImageColor3 = Theme.Accent
            ActiveIndicator.BackgroundTransparency = 0
            Page.Visible = true

            Page:SetAttribute('Active', true)
        end

        local Sections = {}

        function Sections:Section(config)
            local SecName = config.Name or config.title or 'Section'
            local DescriptionLabel = config.Description or ''
            local Type = config.Type or 'Text'
            local Default = config.Default or false
            local Side = config.Side or 'Left'
            local Flags = config.Flags or SecName
            local Callback = config.Callback or function() end
            local IsBox = (Type == 'Box')
            local Container
            local size = 0
            local ItemContainer
            local Column = Side == 'Right' and RightColumn or LeftColumn
            local force_open_box

            Container = Instance.new('Frame')
            Container.Name = SecName .. '_Container'
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.BackgroundTransparency = 1
            Container.AutomaticSize = Enum.AutomaticSize.Y
            Container.Parent = Column

            table.insert(AllElements, {
                ui_element = IsBox and SectionFrame or Container,
                item_name = SecName,
                tab_name = name,
                sec_name = SecName,
                is_section = true,
                page_obj = Page,
                switch_func = switch_tab,
                open_box_func = force_open_box,
            })

            if IsBox then
                local SectionFrame = Instance.new('Frame')

                SectionFrame.Name = SecName .. '_Section'
                SectionFrame.Size = UDim2.new(1, 0, 0, 42)
                SectionFrame.BackgroundColor3 = Theme.Section
                SectionFrame.BackgroundTransparency = 0.7
                SectionFrame.ClipsDescendants = true
                SectionFrame.Parent = Container

                local UICorner = Instance.new('UICorner')

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = SectionFrame

                local ModStroke = Instance.new('UIStroke')

                ModStroke.Transparency = 0.8
                ModStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                ModStroke.Color = Color3.fromRGB(255, 255, 255)
                ModStroke.Thickness = 1.2
                ModStroke.Parent = SectionFrame

                local StrokeGradient = Instance.new('UIGradient')

                StrokeGradient.Color = Theme.AccentGrad
                StrokeGradient.Parent = ModStroke

                local rot = 0

                RunService.RenderStepped:Connect(function(dt)
                    rot = (rot + dt * 45) % 360
                    StrokeGradient.Rotation = rot
                end)

                local UIListLayout_Mod = Instance.new('UIListLayout')

                UIListLayout_Mod.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_Mod.Parent = SectionFrame

                local HeaderBtn = Instance.new('TextButton')

                HeaderBtn.Name = 'Header'
                HeaderBtn.Size = UDim2.new(1, 0, 0, 42)
                HeaderBtn.BackgroundTransparency = 1
                HeaderBtn.Text = ''
                HeaderBtn.AutoButtonColor = false
                HeaderBtn.Parent = SectionFrame

                local HeaderSize = Instance.new('UISizeConstraint')

                HeaderSize.MinSize = Vector2.new(0, 42)
                HeaderSize.MaxSize = Vector2.new(math.huge, 42)
                HeaderSize.Parent = HeaderBtn

                local NodeContainer = Instance.new('Frame')

                NodeContainer.Name = 'NodeContainer'
                NodeContainer.Size = UDim2.new(0, 16, 0, 16)
                NodeContainer.Position = UDim2.new(0, 12, 0.5, 0)
                NodeContainer.AnchorPoint = Vector2.new(0, 0.5)
                NodeContainer.BackgroundTransparency = 1
                NodeContainer.Parent = HeaderBtn

                local DiamondNode = Instance.new('Frame')

                DiamondNode.Name = 'DiamondNode'
                DiamondNode.Size = UDim2.new(0, 8, 0, 8)
                DiamondNode.Position = UDim2.new(0.5, 0, 0.5, 0)
                DiamondNode.AnchorPoint = Vector2.new(0.5, 0.5)
                DiamondNode.BackgroundColor3 = Theme.Accent
                DiamondNode.BackgroundTransparency = 1
                DiamondNode.Rotation = 45
                DiamondNode.Parent = NodeContainer

                local DiamondCorner = Instance.new('UICorner')

                DiamondCorner.CornerRadius = UDim.new(0, 2)
                DiamondCorner.Parent = DiamondNode

                local DiamondStroke = CreateStroke(DiamondNode, Theme.SubText, 1.5, 0.5)
                local SectionName = Instance.new('TextLabel')

                SectionName.Name = 'SectionName'
                SectionName.FontFace = Theme.fontBold
                SectionName.TextColor3 = Theme.SubText
                SectionName.Text = SecName
                SectionName.Size = UDim2.new(1, -90, 0, 14)
                SectionName.AnchorPoint = Vector2.new(0, 0.5)
                SectionName.Position = UDim2.new(0, 36, 0.5, 0)
                SectionName.BackgroundTransparency = 1
                SectionName.TextXAlignment = Enum.TextXAlignment.Left
                SectionName.TextSize = 14
                SectionName.ZIndex = 2
                SectionName.Parent = HeaderBtn

                local Keybind = Instance.new('Frame')

                Keybind.Name = 'Keybind'
                Keybind.BackgroundTransparency = 0.85
                Keybind.AnchorPoint = Vector2.new(1, 0.5)
                Keybind.Position = UDim2.new(1, -10, 0.5, 0)
                Keybind.Size = UDim2.new(0, 42, 0, 20)
                Keybind.BorderSizePixel = 0
                Keybind.BackgroundColor3 = Theme.Main
                Keybind.ZIndex = 2
                Keybind.Parent = HeaderBtn

                local UICornerKey = Instance.new('UICorner')

                UICornerKey.CornerRadius = UDim.new(0, 6)
                UICornerKey.Parent = Keybind

                local KeyStroke = CreateStroke(Keybind, Theme.Outline, 1, 0.5)
                local KeybindText = Instance.new('TextLabel')

                KeybindText.Name = 'KeybindText'
                KeybindText.Size = UDim2.new(1, 0, 1, 0)
                KeybindText.BackgroundTransparency = 1
                KeybindText.TextColor3 = Theme.SubText
                KeybindText.FontFace = Theme.fontBold
                KeybindText.TextSize = 10
                KeybindText.Text = 'NONE'
                KeybindText.TextYAlignment = Enum.TextYAlignment.Center
                KeybindText.TextXAlignment = Enum.TextXAlignment.Center
                KeybindText.Parent = Keybind

                local KeybindBtn = Instance.new('TextButton')

                KeybindBtn.Size = UDim2.new(1, 0, 1, 0)
                KeybindBtn.BackgroundTransparency = 1
                KeybindBtn.Text = ''
                KeybindBtn.Parent = Keybind

                local Divider = Instance.new('Frame')

                Divider.Name = 'Divider'
                Divider.AnchorPoint = Vector2.new(0.5, 1)
                Divider.BackgroundTransparency = 1
                Divider.Position = UDim2.new(0.5, 0, 1, 0)
                Divider.Size = UDim2.new(1, -24, 0, 1)
                Divider.BackgroundColor3 = Theme.Accent
                Divider.BorderSizePixel = 0
                Divider.Parent = HeaderBtn

                local DivGradient = Instance.new('UIGradient')

                DivGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })
                DivGradient.Parent = Divider
                ItemContainer = Instance.new('Frame')
                ItemContainer.Name = 'Options'
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                ItemContainer.AutomaticSize = Enum.AutomaticSize.None
                ItemContainer.ClipsDescendants = true
                ItemContainer.Parent = SectionFrame

                local ItemList = Instance.new('UIListLayout')

                ItemList.Padding = UDim.new(0, 6)
                ItemList.SortOrder = Enum.SortOrder.LayoutOrder
                ItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ItemList.Parent = ItemContainer

                local ItemPad = Instance.new('UIPadding')

                ItemPad.PaddingTop = UDim.new(0, 8)
                ItemPad.PaddingBottom = UDim.new(0, 10)
                ItemPad.PaddingLeft = UDim.new(0, 8)
                ItemPad.PaddingRight = UDim.new(0, 8)
                ItemPad.Parent = ItemContainer

                local function GetContentSize()
                    return size + ItemPad.PaddingBottom.Offset
                end

                local OldConfigValue = Polaris.Flags[Flags]

                if type(OldConfigValue) ~= 'table' then
                    Polaris.Flags[Flags] = {
                        Enabled = (type(OldConfigValue) == 'boolean' and OldConfigValue) or Default or false,
                        Keybind = config.Keybind and config.Keybind.Name or 'None',
                    }
                end

                local Enabled = Polaris.Flags[Flags].Enabled
                local CurrentKey = nil
                local SectionUpdate = nil
                local IsListening = false
                local InitialKey = Polaris.Flags[Flags].Keybind

                if InitialKey and InitialKey ~= 'None' then
                    CurrentKey = Enum.KeyCode[InitialKey]
                    KeybindText.Text = string.upper(InitialKey)
                end

                local function Update()
                    local TweenInf = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

                    if Enabled then
                        local ContentSize = GetContentSize()
                        local OpenSize = ContentSize + 42

                        ItemContainer.Visible = true

                        Tween(SectionFrame, TweenInf, {
                            Size = UDim2.new(1, 0, 0, OpenSize),
                            BackgroundTransparency = 0.2,
                        })
                        Tween(ItemContainer, TweenInf, {
                            Size = UDim2.new(1, 0, 0, ContentSize),
                        })
                        Tween(ModStroke, TweenInf, {
                            Transparency = 0.1,
                            Thickness = 1.5,
                        })
                        Tween(Divider, TweenInf, {BackgroundTransparency = 0.2})
                        Tween(DiamondNode, TweenInf, {
                            BackgroundTransparency = 0,
                            Rotation = 225,
                            Size = UDim2.new(0, 10, 0, 10),
                        })
                        Tween(DiamondStroke, TweenInf, {
                            Color = Theme.Accent,
                            Transparency = 0,
                        })
                        Tween(SectionName, TweenInf, {
                            TextColor3 = Theme.Accent,
                        })
                        Tween(Keybind, TweenInf, {
                            BackgroundColor3 = Theme.Accent,
                        })
                        Tween(KeyStroke, TweenInf, {Transparency = 1})
                    else
                        ItemContainer.Visible = false

                        Tween(SectionFrame, TweenInf, {
                            Size = UDim2.new(1, 0, 0, 42),
                            BackgroundTransparency = 0.7,
                        })
                        Tween(ItemContainer, TweenInf, {
                            Size = UDim2.new(1, 0, 0, 0),
                        })
                        Tween(ModStroke, TweenInf, {
                            Transparency = 0.8,
                            Thickness = 1.2,
                        })
                        Tween(Divider, TweenInf, {BackgroundTransparency = 1})
                        Tween(DiamondNode, TweenInf, {
                            BackgroundTransparency = 1,
                            Rotation = 45,
                            Size = UDim2.new(0, 8, 0, 8),
                        })
                        Tween(DiamondStroke, TweenInf, {
                            Color = Theme.SubText,
                            Transparency = 0.5,
                        })
                        Tween(SectionName, TweenInf, {
                            TextColor3 = Theme.SubText,
                        })
                        Tween(Keybind, TweenInf, {
                            BackgroundColor3 = Theme.Main,
                        })
                        Tween(KeyStroke, TweenInf, {Transparency = 0.5})
                    end
                end

                SectionUpdate = Update
                force_open_box = function()
                    if IsBox and not Enabled then
                        Enabled = true
                        Polaris.Flags[Flags].Enabled = true

                        if SectionUpdate then
                            SectionUpdate()
                        end
                    end
                end

                local function SetState(state)
                    if type(state) == 'table' then
                        Enabled = state.Enabled
                    else
                        Enabled = state
                    end

                    Polaris.Flags[Flags].Enabled = Enabled

                    Update()

                    if Callback then
                        Callback(Enabled)
                    end
                end

                Polaris.Elements[Flags] = SetState

                if Enabled then
                    task.defer(function()
                        SetState(true)
                    end)
                end

                ItemList:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                    if Enabled then
                        Update()
                    end
                end)
                HeaderBtn.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    Polaris.Flags[Flags].Enabled = Enabled

                    Update()
                    Polaris:SaveConfig(ConfigsFile)

                    if Callback then
                        Callback(Enabled)
                    end
                end)
                KeybindBtn.MouseButton1Click:Connect(function()
                    if IsListening then
                        return
                    end

                    IsListening = true
                    KeybindText.Text = '...'

                    local Connection

                    Connection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                CurrentKey = nil
                                KeybindText.Text = 'NONE'
                                Polaris.Flags[Flags].Keybind = 'None'
                            else
                                CurrentKey = input.KeyCode
                                KeybindText.Text = string.upper(CurrentKey.Name)
                                Polaris.Flags[Flags].Keybind = CurrentKey.Name
                            end

                            Polaris:SaveConfig(ConfigsFile)

                            IsListening = false

                            Connection:Disconnect()
                        end
                    end)
                end)
                UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then
                        return
                    end
                    if CurrentKey and input.KeyCode == CurrentKey and not IsListening then
                        Enabled = not Enabled
                        Polaris.Flags[Flags].Enabled = Enabled

                        Update()
                        Polaris:SaveConfig(ConfigsFile)

                        if Callback then
                            Callback(Enabled)
                        end
                    end
                end)
            else
                local SectionFrame = Instance.new('Frame')

                SectionFrame.BackgroundTransparency = 1
                SectionFrame.Size = UDim2.new(1, 0, 0, 0)
                SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
                SectionFrame.Parent = Container

                local SecTitle = Instance.new('TextLabel')

                SecTitle.Text = string.upper(SecName)
                SecTitle.FontFace = Theme.fontBold
                SecTitle.TextSize = 11
                SecTitle.TextColor3 = Theme.Accent
                SecTitle.Size = UDim2.new(1, 0, 0, 20)
                SecTitle.BackgroundTransparency = 1
                SecTitle.TextXAlignment = Enum.TextXAlignment.Left
                SecTitle.Parent = SectionFrame
                ItemContainer = Instance.new('Frame')
                ItemContainer.Size = UDim2.new(1, 0, 0, 0)
                ItemContainer.Position = UDim2.new(0, 0, 0, 22)
                ItemContainer.BackgroundTransparency = 1
                ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
                ItemContainer.Parent = SectionFrame

                local ItemList = Instance.new('UIListLayout')

                ItemList.Padding = UDim.new(0, 6)
                ItemList.SortOrder = Enum.SortOrder.LayoutOrder
                ItemList.Parent = ItemContainer
                force_open_box = function() end
            end

            local Elements = {}

            function Elements:Toggle(cfg)
                size += 44

                local TName = cfg.Name or 'Toggle'
                local Def = cfg.Default or false
                local Flags = cfg.Flags or TName
                local InitialKeybind = cfg.Keybind
                local Callback = cfg.Callback or function() end
                local StrokeAlpha = IsBox and 1 or 0
                local BgAlpha = IsBox and 1 or 0.6
                local TFrame = Instance.new('TextButton')

                TFrame.Size = UDim2.new(1, 0, 0, 38)
                TFrame.BackgroundColor3 = Theme.Section
                TFrame.BackgroundTransparency = BgAlpha
                TFrame.Text = ''
                TFrame.Parent = ItemContainer
                TFrame.AutoButtonColor = false

                CreateCorner(TFrame, 6)

                local TStroke = CreateStroke(TFrame, Theme.Outline, 1, StrokeAlpha)

                TFrame.MouseEnter:Connect(function()
                    if not IsBox then
                        Tween(TStroke, TweenInfo.new(0.3), {
                            Color = Theme.Accent,
                        })
                    end
                end)
                TFrame.MouseLeave:Connect(function()
                    if not IsBox then
                        Tween(TStroke, TweenInfo.new(0.3), {
                            Color = Theme.Outline,
                        })
                    end
                end)
                table.insert(AllElements, {
                    ui_element = TFrame,
                    item_name = TName,
                    tab_name = name,
                    sec_name = SecName,
                    page_obj = Page,
                    switch_func = switch_tab,
                    open_box_func = force_open_box,
                })

                local TLab = Instance.new('TextLabel')

                TLab.Text = TName
                TLab.FontFace = Theme.font
                TLab.TextSize = 13
                TLab.TextColor3 = Theme.Text
                TLab.Size = UDim2.new(0.7, 0, 1, 0)
                TLab.Position = UDim2.new(0, 12, 0, 0)
                TLab.BackgroundTransparency = 1
                TLab.TextXAlignment = Enum.TextXAlignment.Left
                TLab.Parent = TFrame

                local TSwitch = Instance.new('Frame')

                TSwitch.Size = UDim2.new(0, 40, 0, 20)
                TSwitch.Position = UDim2.new(1, -50, 0.5, -10)
                TSwitch.BackgroundColor3 = Theme.Main
                TSwitch.Parent = TFrame

                CreateCorner(TSwitch, 20)

                local TCircle = Instance.new('Frame')

                TCircle.Size = UDim2.new(0, 16, 0, 16)
                TCircle.Position = UDim2.new(0, 2, 0.5, -8)
                TCircle.BackgroundColor3 = Theme.SubText
                TCircle.Parent = TSwitch

                CreateCorner(TCircle, 16)

                local KeybindFrame = Instance.new('Frame')

                KeybindFrame.Name = 'Keybind'
                KeybindFrame.BackgroundTransparency = 0.85
                KeybindFrame.AnchorPoint = Vector2.new(1, 0.5)
                KeybindFrame.Position = UDim2.new(1, -55, 0.5, 0)
                KeybindFrame.Size = UDim2.new(0, 16, 0, 16)
                KeybindFrame.BorderSizePixel = 0
                KeybindFrame.BackgroundColor3 = Theme.Accent
                KeybindFrame.Parent = TFrame

                local UICornerKey = Instance.new('UICorner')

                UICornerKey.CornerRadius = UDim.new(0, 4)
                UICornerKey.Parent = KeybindFrame

                local KeybindText = Instance.new('TextLabel')

                KeybindText.Name = 'KeybindText'
                KeybindText.Size = UDim2.new(1, 0, 1, 0)
                KeybindText.BackgroundTransparency = 1
                KeybindText.TextColor3 = Theme.Accent
                KeybindText.FontFace = Theme.fontBold
                KeybindText.TextSize = 10
                KeybindText.Text = '...'
                KeybindText.TextYAlignment = Enum.TextYAlignment.Center
                KeybindText.TextXAlignment = Enum.TextXAlignment.Center
                KeybindText.Parent = KeybindFrame

                local KeybindBtn = Instance.new('TextButton')

                KeybindBtn.Size = UDim2.new(1, 0, 1, 0)
                KeybindBtn.BackgroundTransparency = 1
                KeybindBtn.Text = ''
                KeybindBtn.Parent = KeybindFrame

                local Enabled = Polaris.Flags[Flags]

                if Enabled == nil then
                    Enabled = Def
                end

                Polaris.Flags[Flags] = Enabled

                local KeyFlag = Flags .. '_Keybind'
                local CurrentKey = nil
                local IsListening = false
                local SavedKey = Polaris.Flags[KeyFlag]

                if SavedKey == nil then
                    SavedKey = InitialKeybind and InitialKeybind.Name or '...'
                end

                Polaris.Flags[KeyFlag] = SavedKey

                if SavedKey and SavedKey ~= '...' then
                    CurrentKey = Enum.KeyCode[SavedKey]
                    KeybindText.Text = string.upper(SavedKey)
                end

                local function Update()
                    if Enabled then
                        Tween(TCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                            Position = UDim2.new(1, -18, 0.5, -8),
                            BackgroundColor3 = Color3.new(1, 1, 1),
                        })
                        Tween(TSwitch, TweenInfo.new(0.3), {
                            BackgroundColor3 = Theme.Accent,
                        })
                    else
                        Tween(TCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                            Position = UDim2.new(0, 2, 0.5, -8),
                            BackgroundColor3 = Theme.SubText,
                        })
                        Tween(TSwitch, TweenInfo.new(0.3), {
                            BackgroundColor3 = Theme.Main,
                        })
                    end
                end
                local function SetState(state)
                    Enabled = state
                    Polaris.Flags[Flags] = Enabled

                    Update()

                    if Callback then
                        Callback(Enabled)
                    end
                end

                Polaris.Elements[Flags] = SetState

                if Enabled then
                    SetState(true)
                end

                TFrame.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    Polaris.Flags[Flags] = Enabled

                    Update()
                    Polaris:SaveConfig(ConfigsFile)

                    if Callback then
                        Callback(Enabled)
                    end
                end)
                KeybindBtn.MouseButton1Click:Connect(function()
                    if IsListening then
                        return
                    end

                    IsListening = true
                    KeybindText.Text = '...'

                    local Connection

                    Connection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                CurrentKey = nil
                                KeybindText.Text = '...'
                                Polaris.Flags[KeyFlag] = '...'
                            else
                                CurrentKey = input.KeyCode
                                KeybindText.Text = string.upper(CurrentKey.Name)
                                Polaris.Flags[KeyFlag] = CurrentKey.Name
                            end

                            Polaris:SaveConfig(ConfigsFile)

                            IsListening = false

                            Connection:Disconnect()
                        end
                    end)
                end)
                UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then
                        return
                    end
                    if CurrentKey and input.KeyCode == CurrentKey and not IsListening then
                        Enabled = not Enabled
                        Polaris.Flags[Flags] = Enabled

                        Update()
                        Polaris:SaveConfig(ConfigsFile)

                        if Callback then
                            Callback(Enabled)
                        end
                    end
                end)
            end
            function Elements:Button(cfg)
                size += 44

                local BName = cfg.Name or 'Button'
                local Callback = cfg.Callback or function() end
                local BFrame = Instance.new('TextButton')

                BFrame.Size = UDim2.new(1, 0, 0, 38)
                BFrame.BackgroundColor3 = Theme.Section
                BFrame.BackgroundTransparency = IsBox and 1 or 0.6
                BFrame.Text = BName
                BFrame.TextColor3 = Theme.Text
                BFrame.FontFace = Theme.font
                BFrame.TextSize = 13
                BFrame.AutoButtonColor = false
                BFrame.ClipsDescendants = true
                BFrame.Parent = ItemContainer

                CreateCorner(BFrame, 6)

                local BStroke = CreateStroke(BFrame, Theme.Outline, 1, IsBox and 1 or 0)

                table.insert(AllElements, {
                    ui_element = BFrame,
                    item_name = BName,
                    tab_name = name,
                    sec_name = SecName,
                    page_obj = Page,
                    switch_func = switch_tab,
                    open_box_func = force_open_box,
                })

                local HoverTween = TweenInfo.new(0.25, Enum.EasingStyle.Quart)

                BFrame.MouseEnter:Connect(function()
                    if not IsBox then
                        Tween(BStroke, HoverTween, {
                            Color = Theme.Accent,
                        })
                        Tween(BFrame, HoverTween, {BackgroundTransparency = 0.2})
                    end
                end)
                BFrame.MouseLeave:Connect(function()
                    if not IsBox then
                        Tween(BStroke, HoverTween, {
                            Color = Theme.Outline,
                        })
                        Tween(BFrame, HoverTween, {BackgroundTransparency = 0.6})
                    end
                end)
                BFrame.MouseButton1Click:Connect(function()
                    Ripple(BFrame)
                    Callback()
                end)
            end
            function Elements:Slider(cfg)
                size += 61

                local SName = cfg.Name or 'Slider'
                local Min = cfg.Min or 0
                local Max = cfg.Max or 100
                local Increment = cfg.Increment or 1
                local Flags = cfg.Flags or SName
                local Callback = cfg.Callback or function() end
                local Def = Polaris.Flags[Flags]

                if Def == nil then
                    Def = cfg.Default or Min
                end

                local StrokeAlpha = IsBox and 1 or 0
                local BgAlpha = IsBox and 1 or 0.6
                local SFrame = Instance.new('Frame')

                SFrame.Size = UDim2.new(1, 0, 0, 55)
                SFrame.BackgroundColor3 = Theme.Section
                SFrame.BackgroundTransparency = BgAlpha
                SFrame.Parent = ItemContainer

                CreateCorner(SFrame, 6)

                local SStroke = CreateStroke(SFrame, Theme.Outline, 1, StrokeAlpha)

                table.insert(AllElements, {
                    ui_element = SFrame,
                    item_name = SName,
                    tab_name = name,
                    sec_name = SecName,
                    page_obj = Page,
                    switch_func = switch_tab,
                    open_box_func = force_open_box,
                })

                local SLabel = Instance.new('TextLabel')

                SLabel.Text = SName
                SLabel.FontFace = Theme.font
                SLabel.TextColor3 = Theme.Text
                SLabel.TextSize = 13
                SLabel.Size = UDim2.new(1, -80, 0, 20)
                SLabel.Position = UDim2.new(0, 12, 0, 8)
                SLabel.BackgroundTransparency = 1
                SLabel.TextXAlignment = Enum.TextXAlignment.Left
                SLabel.Parent = SFrame

                local SValue = Instance.new('TextLabel')

                SValue.FontFace = Theme.fontBold
                SValue.TextColor3 = Theme.Text
                SValue.TextSize = 13
                SValue.Position = UDim2.new(1, -40, 0, 8)
                SValue.Size = UDim2.new(0, 40, 0, 20)
                SValue.BackgroundTransparency = 1
                SValue.TextYAlignment = Enum.TextYAlignment.Center
                SValue.Parent = SFrame

                local BarBG = Instance.new('TextButton')

                BarBG.Text = ''
                BarBG.AutoButtonColor = false
                BarBG.Size = UDim2.new(1, -24, 0, 6)
                BarBG.Position = UDim2.new(0, 12, 0, 34)
                BarBG.BackgroundColor3 = Theme.Main
                BarBG.Parent = SFrame

                CreateCorner(BarBG, 6)

                local BarFill = Instance.new('Frame')

                BarFill.BackgroundColor3 = Theme.Accent
                BarFill.Parent = BarBG

                CreateCorner(BarFill, 6)

                local Knob = Instance.new('Frame')

                Knob.Size = UDim2.new(0, 10, 0, 10)
                Knob.AnchorPoint = Vector2.new(0, 0.5)
                Knob.Position = UDim2.new(1, -5, 0.5, 0)
                Knob.BackgroundColor3 = Color3.new(1, 1, 1)
                Knob.Parent = BarFill

                CreateCorner(Knob, 14)

                local dragging = false

                Polaris.Flags[Flags] = Def

                local decimals = 0
                local strInc = tostring(Increment)

                if string.find(strInc, '%.') then
                    decimals = #string.split(strInc, '.')[2]
                end

                local function SetValue(val)
                    if Increment == 0 then
                        val = math.clamp(math.floor(val + 0.5), Min, Max)
                    else
                        val = math.clamp(math.floor((val / Increment) + 0.5) * Increment, Min, Max)
                    end

                    Polaris.Flags[Flags] = val
                    SValue.Text = string.format('%.' .. tostring(decimals) .. 'f', val)

                    local pct = (val - Min) / (Max - Min)

                    Tween(BarFill, TweenInfo.new(0.1), {
                        Size = UDim2.new(pct, 0, 1, 0),
                    })

                    if Polaris.SaveConfig then
                        pcall(function()
                            Polaris:SaveConfig(ConfigsFile)
                        end)
                    end

                    Callback(val)
                end

                Polaris.Elements[Flags] = SetValue

                SetValue(Def)

                local function Update(input)
                    local bgPos = BarBG.AbsolutePosition.X
                    local bgSize = BarBG.AbsoluteSize.X
                    local pct = math.clamp((input.Position.X - bgPos) / bgSize, 0, 1)

                    SetValue(Min + (Max - Min) * pct)
                end

                BarBG.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true

                        Update(i)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        Update(i)
                    end
                end)
            end
            function Elements:Dropdown(cfg)
                size += 44

                local DName = cfg.Name or 'Dropdown'
                local Items = cfg.Items or {}
                local Flags = cfg.Flags or DName
                local Search = cfg.Search or false
                local Multi = cfg.Multi or false
                local Default = cfg.Default or (Multi and {} or '')
                local Callback = cfg.Callback or function() end
                local StrokeAlpha = IsBox and 1 or 0
                local BgAlpha = IsBox and 1 or 0.6
                local CurrentOption = Polaris.Flags[Flags] or Default

                if Multi and type(CurrentOption) ~= 'table' then
                    CurrentOption = type(CurrentOption) == 'string' and {CurrentOption} or {}
                end

                Polaris.Flags[Flags] = CurrentOption

                local HEADER_HEIGHT = 38
                local SEARCH_HEIGHT = 36
                local MAX_LIST_HEIGHT = 150
                local targetHeight = HEADER_HEIGHT
                local DFrame = Instance.new('Frame')

                DFrame.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
                DFrame.BackgroundColor3 = Theme.Main
                DFrame.BackgroundTransparency = BgAlpha
                DFrame.ClipsDescendants = true
                DFrame.Parent = ItemContainer

                CreateCorner(DFrame, 6)

                local DStroke = CreateStroke(DFrame, Theme.Outline, 1, StrokeAlpha)

                table.insert(AllElements, {
                    ui_element = DFrame,
                    item_name = DName,
                    tab_name = name,
                    sec_name = SecName,
                    page_obj = Page,
                    switch_func = switch_tab,
                    open_box_func = force_open_box,
                })

                local DLabel = Instance.new('TextLabel')

                DLabel.FontFace = Theme.font
                DLabel.TextColor3 = Theme.Text
                DLabel.TextSize = 13
                DLabel.Position = UDim2.new(0, 12, 0, 0)
                DLabel.Size = UDim2.new(1, -40, 0, HEADER_HEIGHT)
                DLabel.BackgroundTransparency = 1
                DLabel.TextXAlignment = Enum.TextXAlignment.Left
                DLabel.TextTruncate = Enum.TextTruncate.AtEnd

                local function UpdateLabel()
                    if Multi then
                        local selectedText = #CurrentOption > 0 and table.concat(CurrentOption, ', ') or 'None'

                        DLabel.Text = DName .. ': ' .. selectedText
                    else
                        DLabel.Text = CurrentOption ~= '' and (DName .. ': ' .. CurrentOption) or DName
                    end
                end

                UpdateLabel()

                DLabel.Parent = DFrame

                local Arrow = Instance.new('ImageLabel')

                Arrow.Image = 'rbxassetid://6031090990'
                Arrow.Size = UDim2.new(0, 20, 0, 20)
                Arrow.AnchorPoint = Vector2.new(1, 0)
                Arrow.Position = UDim2.new(1, -12, 0, 9)
                Arrow.BackgroundTransparency = 1
                Arrow.ImageColor3 = Theme.SubText
                Arrow.Rotation = 0
                Arrow.Parent = DFrame

                local Trigger = Instance.new('TextButton')

                Trigger.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
                Trigger.BackgroundTransparency = 1
                Trigger.Text = ''
                Trigger.Parent = DFrame

                local SearchBar, SearchInputSub

                if Search then
                    SearchBar = Instance.new('Frame')
                    SearchBar.Size = UDim2.new(1, -10, 0, SEARCH_HEIGHT)
                    SearchBar.Position = UDim2.new(0, 5, 0, HEADER_HEIGHT + 4)
                    SearchBar.BackgroundColor3 = Theme.Main
                    SearchBar.BackgroundTransparency = 0.5
                    SearchBar.Visible = false
                    SearchBar.Parent = DFrame

                    CreateCorner(SearchBar, 8)

                    local SearchStroke = CreateStroke(SearchBar, Theme.Outline, 1, 0)
                    local Icon = Instance.new('ImageLabel')

                    Icon.AnchorPoint = Vector2.new(0, 0.5)
                    Icon.Size = UDim2.new(0, 20, 0, 20)
                    Icon.Position = UDim2.new(0, 12, 0.5, 0)
                    Icon.BackgroundTransparency = 1
                    Icon.Image = 'rbxassetid://115279747441313'
                    Icon.ImageColor3 = Theme.SubText
                    Icon.Parent = SearchBar

                    CreateGradient(Icon)

                    SearchInputSub = Instance.new('TextBox')
                    SearchInputSub.Size = UDim2.new(1, -40, 1, 0)
                    SearchInputSub.Position = UDim2.new(0, 40, 0, 0)
                    SearchInputSub.BackgroundTransparency = 1
                    SearchInputSub.PlaceholderText = 'Search...'
                    SearchInputSub.Text = ''
                    SearchInputSub.TextColor3 = Theme.Text
                    SearchInputSub.PlaceholderColor3 = Theme.SubText
                    SearchInputSub.FontFace = Theme.font
                    SearchInputSub.TextSize = 13
                    SearchInputSub.TextXAlignment = Enum.TextXAlignment.Left
                    SearchInputSub.ClearTextOnFocus = false
                    SearchInputSub.Parent = SearchBar

                    SearchInputSub.Focused:Connect(function()
                        Tween(SearchStroke, TweenInfo.new(0.25), {
                            Color = Theme.Accent,
                        })
                    end)
                    SearchInputSub.FocusLost:Connect(function()
                        Tween(SearchStroke, TweenInfo.new(0.25), {
                            Color = Theme.Outline,
                        })
                    end)
                end

                local ItemsFrame = Instance.new('ScrollingFrame')

                ItemsFrame.Position = UDim2.new(0, 0, 0, HEADER_HEIGHT + (Search and SEARCH_HEIGHT + 8 or 2))
                ItemsFrame.Size = UDim2.new(1, 0, 0, 0)
                ItemsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                ItemsFrame.ScrollBarImageTransparency = 1
                ItemsFrame.ScrollBarThickness = 4
                ItemsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
                ItemsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
                ItemsFrame.BackgroundTransparency = 1
                ItemsFrame.Parent = DFrame

                local ILayout = Instance.new('UIListLayout')

                ILayout.Padding = UDim.new(0, 2)
                ILayout.SortOrder = Enum.SortOrder.LayoutOrder
                ILayout.Parent = ItemsFrame

                local Open = false
                local ItemButtons = {}
                local ItemsRefresh = {}

                local function SelectItem(item)
                    if Multi then
                        local index = table.find(CurrentOption, item)

                        if index then
                            table.remove(CurrentOption, index)
                        else
                            table.insert(CurrentOption, item)
                        end

                        Polaris.Flags[Flags] = CurrentOption

                        UpdateLabel()
                        task.spawn(function()
                            Callback(CurrentOption)
                        end)

                        if Polaris.SaveConfig then
                            pcall(function()
                                Polaris:SaveConfig(ConfigsFile)
                            end)
                        end

                        for btnItem, btnObj in pairs(ItemButtons)do
                            btnObj.TextColor3 = table.find(CurrentOption, btnItem) and Theme.Accent or Theme.SubText
                        end
                    else
                        CurrentOption = item
                        Polaris.Flags[Flags] = item

                        UpdateLabel()
                        task.spawn(function()
                            Callback(item)
                        end)

                        if Polaris.SaveConfig then
                            pcall(function()
                                Polaris:SaveConfig(ConfigsFile)
                            end)
                        end

                        Open = false

                        size -= (targetHeight - HEADER_HEIGHT)

                        targetHeight = HEADER_HEIGHT

                        if SectionUpdate then
                            SectionUpdate()
                        end

                        Tween(DFrame, TweenInfo.new(0.3), {
                            Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
                        })
                        Tween(ItemsFrame, TweenInfo.new(0.3), {
                            Size = UDim2.new(1, 0, 0, 0),
                        })
                        Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})

                        if SearchInputSub then
                            SearchInputSub.Text = ''
                            SearchBar.Visible = false
                        end
                    end
                end

                Polaris.Elements[Flags] = function(val)
                    CurrentOption = val
                    Polaris.Flags[Flags] = val

                    UpdateLabel()
                    Callback(val)
                end

                function ItemsRefresh:Refresh(newList)
                    ItemButtons = {}

                    for _, btn in pairs(ItemsFrame:GetChildren())do
                        if btn:IsA('TextButton') then
                            btn:Destroy()
                        end
                    end
                    for _, item in ipairs(newList)do
                        local IB = Instance.new('TextButton')

                        IB.Size = UDim2.new(1, -10, 0, 28)
                        IB.Position = UDim2.new(0, 5, 0, 0)
                        IB.BackgroundColor3 = Theme.Main
                        IB.BackgroundTransparency = 1
                        IB.Text = '  ' .. tostring(item)
                        IB.TextColor3 = (Multi and type(CurrentOption) == 'table' and table.find(CurrentOption, item)) and Theme.Accent or Theme.SubText
                        IB.FontFace = Theme.font
                        IB.TextSize = 12
                        IB.TextXAlignment = Enum.TextXAlignment.Left
                        IB.Parent = ItemsFrame

                        CreateCorner(IB, 4)
                        IB.MouseButton1Click:Connect(function()
                            SelectItem(item)
                        end)

                        ItemButtons[item] = IB
                    end

                    if Open then
                        local listHeight = math.min(ILayout.AbsoluteContentSize.Y + 6, MAX_LIST_HEIGHT)

                        Tween(ItemsFrame, TweenInfo.new(0.3), {
                            Size = UDim2.new(1, 0, 0, listHeight),
                        })
                    end
                end

                ItemsRefresh:Refresh(Items)

                if SearchInputSub then
                    SearchInputSub:GetPropertyChangedSignal('Text'):Connect(function()
                        local q = tostring(SearchInputSub.Text):lower()

                        for item, btn in pairs(ItemButtons)do
                            btn.Visible = (q == '') or (tostring(item):lower():find(q, 1, true) ~= nil)
                        end
                    end)
                end

                Trigger.MouseButton1Click:Connect(function()
                    Open = not Open

                    local listHeight = math.min(ILayout.AbsoluteContentSize.Y + 6, MAX_LIST_HEIGHT)
                    local extra = Search and (SEARCH_HEIGHT + 8) or 0
                    local newTargetHeight = Open and (HEADER_HEIGHT + extra + listHeight + 4) or HEADER_HEIGHT

                    if Open then
                        size += (newTargetHeight - HEADER_HEIGHT)
                    else
                        size -= (targetHeight - HEADER_HEIGHT)
                    end

                    targetHeight = newTargetHeight

                    if SectionUpdate then
                        SectionUpdate()
                    end
                    if SearchBar then
                        SearchBar.Visible = Open

                        if not Open then
                            SearchInputSub.Text = ''
                        end
                    end

                    Tween(DFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Size = UDim2.new(1, 0, 0, targetHeight),
                    })

                    if Open then
                        Tween(ItemsFrame, TweenInfo.new(0.3), {
                            Size = UDim2.new(1, 0, 0, listHeight),
                        })
                        Tween(Arrow, TweenInfo.new(0.3), {Rotation = 180})
                    else
                        Tween(ItemsFrame, TweenInfo.new(0.3), {
                            Size = UDim2.new(1, 0, 0, 0),
                        })
                        Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                    end
                end)
                Callback(CurrentOption)
            end
            function Elements:Divider()
                size += 26

                local DividerContainer = Instance.new('Frame')

                DividerContainer.Name = 'Divider'
                DividerContainer.Size = UDim2.new(1, 0, 0, 20)
                DividerContainer.BackgroundTransparency = 1
                DividerContainer.BorderSizePixel = 0
                DividerContainer.Parent = ItemContainer

                local MainLine = Instance.new('Frame')

                MainLine.Name = 'MainLine'
                MainLine.Size = UDim2.new(1, -20, 0, 2)
                MainLine.Position = UDim2.new(0.5, 0, 0.5, 0)
                MainLine.AnchorPoint = Vector2.new(0.5, 0.5)
                MainLine.BackgroundColor3 = Theme.Accent
                MainLine.BackgroundTransparency = 0
                MainLine.BorderSizePixel = 0
                MainLine.Parent = DividerContainer

                local Gradient = Instance.new('UIGradient')

                Gradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.1, 0.5),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(0.9, 0.5),
                    NumberSequenceKeypoint.new(1, 1),
                })
                Gradient.Parent = MainLine

                local LineGlow = Instance.new('UIStroke')

                LineGlow.Color = Theme.Accent
                LineGlow.Thickness = 0.5
                LineGlow.Transparency = 0.8
                LineGlow.Parent = MainLine
            end
            function Elements:Paragraph(cfg)
                size += 66

                local Title = cfg.Title or 'Title'
                local Content = cfg.Content or 'Content'
                local Image = cfg.Image
                local ImageSize = cfg.ImageSize or 60
                local PFrame = Instance.new('Frame')

                PFrame.AutomaticSize = Enum.AutomaticSize.Y
                PFrame.Size = UDim2.new(1, 0, 0, 0)
                PFrame.BackgroundTransparency = IsBox and 1 or 0.6
                PFrame.BackgroundColor3 = Theme.Section
                PFrame.Parent = ItemContainer

                CreateCorner(PFrame, 6)
                CreateStroke(PFrame, Theme.Outline, 1, IsBox and 1 or 0)

                local Pad = Instance.new('UIPadding')

                Pad.PaddingTop = UDim.new(0, 10)
                Pad.PaddingBottom = UDim.new(0, 10)
                Pad.PaddingLeft = UDim.new(0, 12)
                Pad.PaddingRight = UDim.new(0, 12)
                Pad.Parent = PFrame

                local Layout = Instance.new('UIListLayout')

                Layout.FillDirection = Enum.FillDirection.Horizontal
                Layout.Padding = UDim.new(0, 10)
                Layout.SortOrder = Enum.SortOrder.LayoutOrder
                Layout.VerticalAlignment = Enum.VerticalAlignment.Top
                Layout.Parent = PFrame

                if Image then
                    local Img = Instance.new('ImageLabel')

                    Img.Image = Image
                    Img.Size = UDim2.new(0, ImageSize, 0, ImageSize)
                    Img.BackgroundTransparency = 1
                    Img.ScaleType = Enum.ScaleType.Crop
                    Img.Parent = PFrame

                    CreateCorner(Img, 4)
                end

                local TextFrame = Instance.new('Frame')

                TextFrame.BackgroundTransparency = 1
                TextFrame.AutomaticSize = Enum.AutomaticSize.Y
                TextFrame.Size = Image and UDim2.new(1, -ImageSize - 10, 0, 0) or UDim2.new(1, 0, 0, 0)
                TextFrame.Parent = PFrame

                local TextLayout = Instance.new('UIListLayout')

                TextLayout.FillDirection = Enum.FillDirection.Vertical
                TextLayout.Padding = UDim.new(0, 3)
                TextLayout.Parent = TextFrame

                local T = Instance.new('TextLabel')

                T.Text = Title
                T.FontFace = Theme.fontBold
                T.TextColor3 = Theme.Text
                T.TextSize = 13
                T.Size = UDim2.new(1, 0, 0, 20)
                T.BackgroundTransparency = 1
                T.TextXAlignment = Enum.TextXAlignment.Left
                T.Parent = TextFrame

                local C = Instance.new('TextLabel')

                C.Text = Content
                C.FontFace = Theme.font
                C.TextColor3 = Theme.SubText
                C.TextSize = 12
                C.Size = UDim2.new(1, 0, 0, 0)
                C.BackgroundTransparency = 1
                C.TextWrapped = true
                C.AutomaticSize = Enum.AutomaticSize.Y
                C.TextXAlignment = Enum.TextXAlignment.Left
                C.Parent = TextFrame

                local ParagraphLib = {}

                function ParagraphLib:Update(newCfg)
                    if newCfg.Title then
                        T.Text = newCfg.Title
                    end
                    if newCfg.Content then
                        C.Text = newCfg.Content
                    end
                    if newCfg.Image and Img then
                        Img.Image = newCfg.Image
                    end
                end

                return ParagraphLib
            end
            function Elements:ColorPicker(cfg)
                size += 38

                local Name = cfg.Name or 'Color Picker'
                local Def = cfg.Default or Color3.fromRGB(255, 255, 255)
                local Flags = cfg.Flags or Name
                local Callback = cfg.Callback or function() end
                local StrokeAlpha = IsBox and 1 or 0
                local BgAlpha = IsBox and 1 or 0.6
                local CurrentColor = Polaris.Flags[Flags] or Def

                if type(CurrentColor) == 'table' then
                    CurrentColor = Color3.new(CurrentColor[1], CurrentColor[2], CurrentColor[3])
                end

                Polaris.Flags[Flags] = {
                    CurrentColor.R,
                    CurrentColor.G,
                    CurrentColor.B,
                }

                local h, s, v = CurrentColor:ToHSV()
                local ColorOpened = false
                local ParentPage = ItemContainer:FindFirstAncestorOfClass('ScrollingFrame')
                local ColorFrame = Instance.new('Frame')

                ColorFrame.Size = UDim2.new(1, 0, 0, 32)
                ColorFrame.BackgroundTransparency = BgAlpha
                ColorFrame.BackgroundColor3 = Theme.Section
                ColorFrame.ClipsDescendants = true
                ColorFrame.Parent = ItemContainer

                CreateCorner(ColorFrame, 6)

                local CStroke = CreateStroke(ColorFrame, Theme.Outline, 1, StrokeAlpha)

                table.insert(AllElements, {
                    ui_element = ColorFrame,
                    item_name = Name,
                    tab_name = name,
                    sec_name = SecName,
                    page_obj = Page,
                    switch_func = switch_tab,
                    open_box_func = force_open_box,
                })

                local Title = Instance.new('TextLabel')

                Title.Text = Name
                Title.Size = UDim2.new(1, -60, 0, 32)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1
                Title.TextColor3 = Theme.Text
                Title.FontFace = Theme.font
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.TextYAlignment = Enum.TextYAlignment.Center
                Title.Parent = ColorFrame

                local ColorDisplay = Instance.new('TextButton')

                ColorDisplay.Size = UDim2.new(0, 35, 0, 18)
                ColorDisplay.Position = UDim2.new(1, -40, 0, 7)
                ColorDisplay.BackgroundColor3 = CurrentColor
                ColorDisplay.Text = ''
                ColorDisplay.AutoButtonColor = false
                ColorDisplay.Parent = ColorFrame

                CreateCorner(ColorDisplay, 4)

                local PickerContainer = Instance.new('Frame')

                PickerContainer.Size = UDim2.new(1, -10, 0, 165)
                PickerContainer.Position = UDim2.new(0, 5, 0, 35)
                PickerContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                PickerContainer.BackgroundTransparency = 1
                PickerContainer.BorderSizePixel = 0
                PickerContainer.Parent = ColorFrame

                CreateCorner(PickerContainer, 6)

                local SatValCanvas = Instance.new('ImageLabel')

                SatValCanvas.Size = UDim2.new(1, -65, 0, 110)
                SatValCanvas.Position = UDim2.new(0, 5, 0, 5)
                SatValCanvas.Image = 'rbxassetid://4155801252'
                SatValCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                SatValCanvas.Parent = PickerContainer

                local Cursor = Instance.new('Frame')

                Cursor.Size = UDim2.new(0, 8, 0, 8)
                Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
                Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
                Cursor.BackgroundColor3 = Color3.new(1, 1, 1)
                Cursor.Parent = SatValCanvas

                CreateCorner(Cursor, 8)
                CreateStroke(Cursor, Color3.new(0, 0, 0), 1.2, 0)

                local HueSlider = Instance.new('Frame')

                HueSlider.Size = UDim2.new(0, 12, 0, 110)
                HueSlider.AnchorPoint = Vector2.new(1, 0)
                HueSlider.Position = UDim2.new(1, -38, 0, 5)
                HueSlider.Parent = PickerContainer

                local HueGrad = Instance.new('UIGradient')

                HueGrad.Rotation = 90
                HueGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.new(1, 1, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.new(0, 1, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.667, Color3.new(0, 0, 1)),
                    ColorSequenceKeypoint.new(0.833, Color3.new(1, 0, 1)),
                    ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0)),
                })
                HueGrad.Parent = HueSlider

                local HuePointer = Instance.new('Frame')

                HuePointer.Size = UDim2.new(1, 4, 0, 2)
                HuePointer.Position = UDim2.new(0.5, 0, 1 - h, 0)
                HuePointer.AnchorPoint = Vector2.new(0.5, 0.5)
                HuePointer.BackgroundColor3 = Color3.new(1, 1, 1)
                HuePointer.Parent = HueSlider

                CreateStroke(HuePointer, Color3.new(0, 0, 0), 1, 0)

                local ColorPreview = Instance.new('Frame')

                ColorPreview.Size = UDim2.new(0, 20, 0, 110)
                ColorPreview.AnchorPoint = Vector2.new(1, 0)
                ColorPreview.Position = UDim2.new(1, -8, 0, 5)
                ColorPreview.BackgroundColor3 = CurrentColor
                ColorPreview.Parent = PickerContainer

                CreateCorner(ColorPreview, 3)

                local RGBDisplay = Instance.new('TextBox')

                RGBDisplay.Size = UDim2.new(1, -10, 0, 30)
                RGBDisplay.Position = UDim2.new(0, 5, 1, -40)
                RGBDisplay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                RGBDisplay.TextColor3 = Theme.Text
                RGBDisplay.Font = Enum.Font.Code
                RGBDisplay.TextSize = 12
                RGBDisplay.ClearTextOnFocus = false
                RGBDisplay.Text = string.format('%d, %d, %d', math.floor(CurrentColor.R * 255), math.floor(CurrentColor.G * 255), math.floor(CurrentColor.B * 255))
                RGBDisplay.Parent = PickerContainer

                CreateCorner(RGBDisplay, 4)

                local function UpdateColor(skipSave)
                    local newColor = Color3.fromHSV(h, s, v)

                    CurrentColor = newColor
                    ColorDisplay.BackgroundColor3 = newColor
                    ColorPreview.BackgroundColor3 = newColor
                    SatValCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    HuePointer.Position = UDim2.new(0.5, 0, 1 - h, 0)
                    Cursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    RGBDisplay.Text = string.format('%d, %d, %d', math.floor(newColor.R * 255), math.floor(newColor.G * 255), math.floor(newColor.B * 255))
                    Polaris.Flags[Flags] = {
                        newColor.R,
                        newColor.G,
                        newColor.B,
                    }

                    if not skipSave and Polaris.SaveConfig then
                        pcall(function()
                            Polaris:SaveConfig(ConfigsFile)
                        end)
                    end

                    Callback(newColor)
                end

                RGBDisplay.FocusLost:Connect(function(enter)
                    if not enter then
                        return
                    end

                    local text = RGBDisplay.Text
                    local r, g, b = text:match('(%d+)%s*,%s*(%d+)%s*,%s*(%d+)')

                    if r and g and b then
                        r = math.clamp(tonumber(r), 0, 255)
                        g = math.clamp(tonumber(g), 0, 255)
                        b = math.clamp(tonumber(b), 0, 255)

                        local newColor = Color3.fromRGB(r, g, b)

                        h, s, v = newColor:ToHSV()

                        UpdateColor()
                    end
                end)

                Polaris.Elements[Flags] = function(val)
                    local col = type(val) == 'table' and Color3.new(val[1], val[2], val[3]) or val

                    h, s, v = col:ToHSV()

                    UpdateColor(true)
                end

                local function GetXY(obj)
                    local size = obj.AbsoluteSize
                    local pos = obj.AbsolutePosition
                    local m = UserInputService:GetMouseLocation()

                    return math.clamp((m.X - pos.X) / size.X, 0, 1), math.clamp((m.Y - pos.Y - 36) / size.Y, 0, 1)
                end
                local function StartDragging(mode)
                    if ParentPage then
                        ParentPage.ScrollingEnabled = false
                    end

                    local con

                    con = RunService.RenderStepped:Connect(function()
                        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            if ParentPage then
                                ParentPage.ScrollingEnabled = true
                            end

                            con:Disconnect()

                            return
                        end
                        if mode == 'SatVal' then
                            local x, y = GetXY(SatValCanvas)

                            s, v = x, 1 - y
                        else
                            local _, y = GetXY(HueSlider)

                            h = 1 - y
                        end

                        UpdateColor()
                    end)
                end

                SatValCanvas.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        StartDragging('SatVal')
                    end
                end)
                HueSlider.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        StartDragging('Hue')
                    end
                end)
                ColorDisplay.MouseButton1Click:Connect(function()
                    ColorOpened = not ColorOpened

                    if ColorOpened then
                        size += 178

                        if SectionUpdate then
                            SectionUpdate()
                        end

                        TweenService:Create(ColorFrame, TweenInfo.new(0.3), {
                            Size = UDim2.new(1, 0, 0, 210),
                        }):Play()
                    else
                        size -= 178

                        if SectionUpdate then
                            SectionUpdate()
                        end

                        TweenService:Create(ColorFrame, TweenInfo.new(0.3), {
                            Size = UDim2.new(1, 0, 0, 32),
                        }):Play()
                    end
                end)
                UpdateColor(true)
            end
            function Elements:Textbox(cfg)
                size += 60

                local XName = cfg.Name or 'Textbox'
                local Placeholder = cfg.Placeholder or 'Input here...'
                local Def = cfg.Default or ''
                local Flags = cfg.Flags or XName
                local Callback = cfg.Callback or function() end
                local StrokeAlpha = IsBox and 1 or 0
                local BgAlpha = IsBox and 1 or 0.6
                local CurrentValue = Polaris.Flags[Flags] or Def

                Polaris.Flags[Flags] = CurrentValue

                local XFrame = Instance.new('Frame')

                XFrame.Size = UDim2.new(1, 0, 0, 54)
                XFrame.BackgroundColor3 = Theme.Section
                XFrame.BackgroundTransparency = BgAlpha
                XFrame.Parent = ItemContainer
                XFrame.ClipsDescendants = false

                CreateCorner(XFrame, 6)

                local XStroke = CreateStroke(XFrame, Theme.Outline, 1, StrokeAlpha)

                table.insert(AllElements, {
                    ui_element = XFrame,
                    item_name = XName,
                    tab_name = name,
                    sec_name = SecName,
                    page_obj = Page,
                    switch_func = switch_tab,
                    open_box_func = force_open_box,
                })

                local XLab = Instance.new('TextLabel')

                XLab.Text = XName
                XLab.FontFace = Theme.font
                XLab.TextColor3 = Theme.Text
                XLab.TextSize = 13
                XLab.Position = UDim2.new(0, 0, 0, 0)
                XLab.Size = UDim2.new(1, 0, 0, 20)
                XLab.BackgroundTransparency = 1
                XLab.TextXAlignment = Enum.TextXAlignment.Left
                XLab.Parent = XFrame

                local Input = Instance.new('TextBox')

                Input.Size = UDim2.new(1, 0, 0, 26)
                Input.Position = UDim2.new(0, 0, 0, 26)
                Input.BackgroundColor3 = Theme.Main
                Input.Text = tostring(CurrentValue)
                Input.PlaceholderText = Placeholder
                Input.TextColor3 = Theme.Text
                Input.PlaceholderColor3 = Theme.SubText
                Input.FontFace = Theme.font
                Input.TextSize = 12
                Input.ClearTextOnFocus = false
                Input.Parent = XFrame

                CreateCorner(Input, 4)

                local Stroke = CreateStroke(Input, Theme.Outline, 1, 0)

                Polaris.Elements[Flags] = function(val)
                    local strVal = tostring(val)

                    Input.Text = strVal
                    Polaris.Flags[Flags] = strVal

                    Callback(strVal)
                end

                Input.Focused:Connect(function()
                    Tween(Stroke, TweenInfo.new(0.25), {
                        Color = Theme.Accent,
                        Transparency = 0,
                    })
                end)
                Input.FocusLost:Connect(function()
                    Tween(Stroke, TweenInfo.new(0.25), {
                        Color = Theme.Outline,
                        Transparency = 0,
                    })

                    Polaris.Flags[Flags] = Input.Text

                    if Polaris.SaveConfig then
                        pcall(function()
                            Polaris:SaveConfig(ConfigsFile)
                        end)
                    end

                    Callback(Input.Text)
                end)
                Callback(tostring(CurrentValue))
            end

            return Elements
        end

        return Sections
    end

    Polaris:LoadConfig(ConfigsFile)

    return Tabs
end
return Polaris
