-- =============================================
-- SCRIPT: MAGIC HUB (MAX SPEED 10X)
-- =============================================

local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- 1. KHỞI TẠO SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MagicHubOptimizer"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- UI MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 275)
MainFrame.Position = UDim2.new(0.5, -170, 0.4, -137)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ZIndex = 99999
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(75, 75, 75)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- =============================================
-- KHUNG TIÊU ĐỀ & KÉO THẢ MƯỢT MÀ
-- =============================================

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundTransparency = 1
TitleBar.ZIndex = 100000
TitleBar.Parent = MainFrame

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local FullTitleText = Instance.new("TextLabel")
FullTitleText.Position = UDim2.new(0, 15, 0, 0)
FullTitleText.Size = UDim2.new(1, -105, 1, 0)
FullTitleText.RichText = true
FullTitleText.Text = "<b><font color=\"#F0F0F0\">Magic Hub</font></b> <font color=\"#969696\">   discord.gg/rTfPchWrta</font>"
FullTitleText.TextSize = 13
FullTitleText.Font = Enum.Font.SourceSans
FullTitleText.TextXAlignment = Enum.TextXAlignment.Left
FullTitleText.BackgroundTransparency = 1
FullTitleText.ZIndex = 100001
FullTitleText.Parent = TitleBar

-- Container 3 nút Windows góc phải
local WindowControls = Instance.new("Frame")
WindowControls.Position = UDim2.new(1, -85, 0, 7)
WindowControls.Size = UDim2.new(0, 78, 0, 24)
WindowControls.BackgroundTransparency = 1
WindowControls.ZIndex = 100001
WindowControls.Parent = TitleBar

-- --- NÚT 1: THU NHỎ (-) ---
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = ""
MinimizeBtn.ZIndex = 100002
MinimizeBtn.Parent = WindowControls

local MinIcon = Instance.new("Frame")
MinIcon.Size = UDim2.new(0, 9, 0, 1.5)
MinIcon.Position = UDim2.new(0.5, -4.5, 0.5, 0)
MinIcon.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
MinIcon.BorderSizePixel = 0
MinIcon.ZIndex = 100003
MinIcon.Parent = MinimizeBtn

-- --- NÚT 2: PHÓNG TO / THU NHỎ ---
local MaximizeBtn = Instance.new("TextButton")
MaximizeBtn.Size = UDim2.new(0, 24, 0, 24)
MaximizeBtn.Position = UDim2.new(0, 26, 0, 0)
MaximizeBtn.BackgroundTransparency = 1
MaximizeBtn.Text = ""
MaximizeBtn.ZIndex = 100002
MaximizeBtn.Parent = WindowControls

local MaxIcon = Instance.new("Frame")
MaxIcon.Size = UDim2.new(0, 8, 0, 8)
MaxIcon.Position = UDim2.new(0.5, -4, 0.5, -4)
MaxIcon.BackgroundTransparency = 1
MaxIcon.BorderSizePixel = 0
MaxIcon.ZIndex = 100003
MaxIcon.Parent = MaximizeBtn

local MaxStroke = Instance.new("UIStroke")
MaxStroke.Color = Color3.fromRGB(200, 200, 200)
MaxStroke.Thickness = 1.2
MaxStroke.Parent = MaxIcon

local MaxIconBack = Instance.new("Frame")
MaxIconBack.Size = UDim2.new(0, 6, 0, 6)
MaxIconBack.Position = UDim2.new(1, -4, 0, -3)
MaxIconBack.BackgroundTransparency = 1
MaxIconBack.BorderSizePixel = 0
MaxIconBack.Visible = false
MaxIconBack.ZIndex = 100002
MaxIconBack.Parent = MaxIcon

local MaxStrokeBack = Instance.new("UIStroke")
MaxStrokeBack.Color = Color3.fromRGB(200, 200, 200)
MaxStrokeBack.Thickness = 1.2
MaxStrokeBack.Parent = MaxIconBack

-- --- NÚT 3: ĐÓNG / XÓA (✕) ---
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(0, 52, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = ""
CloseBtn.ZIndex = 100002
CloseBtn.Parent = WindowControls

local Cross1 = Instance.new("Frame")
Cross1.Size = UDim2.new(0, 9, 0, 1.5)
Cross1.Position = UDim2.new(0.5, -4.5, 0.5, -0.75)
Cross1.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Cross1.BorderSizePixel = 0
Cross1.Rotation = 45
Cross1.ZIndex = 100003
Cross1.Parent = CloseBtn

local Cross2 = Instance.new("Frame")
Cross2.Size = UDim2.new(0, 9, 0, 1.5)
Cross2.Position = UDim2.new(0.5, -4.5, 0.5, -0.75)
Cross2.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Cross2.BorderSizePixel = 0
Cross2.Rotation = -45
Cross2.ZIndex = 100003
Cross2.Parent = CloseBtn

local function SetupHover(btn, elements, isClose)
    btn.MouseEnter:Connect(function()
        local color = isClose and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(255, 170, 0)
        for _, elem in ipairs(elements) do
            if elem:IsA("UIStroke") then elem.Color = color else elem.BackgroundColor3 = color end
        end
    end)
    btn.MouseLeave:Connect(function()
        local color = Color3.fromRGB(200, 200, 200)
        for _, elem in ipairs(elements) do
            if elem:IsA("UIStroke") then elem.Color = color else elem.BackgroundColor3 = color end
        end
    end)
end
SetupHover(MinimizeBtn, {MinIcon}, false)
SetupHover(MaximizeBtn, {MaxStroke, MaxStrokeBack}, false)
SetupHover(CloseBtn, {Cross1, Cross2}, true)

local menuVisible = true
local function ToggleMainFrame()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end
MinimizeBtn.MouseButton1Click:Connect(ToggleMainFrame)

local isMaximized = false
local normalSize = UDim2.new(0, 340, 0, 275)
local maximizedSize = UDim2.new(0, 440, 0, 275)

MaximizeBtn.MouseButton1Click:Connect(function()
    isMaximized = not isMaximized
    local targetSize = isMaximized and maximizedSize or normalSize
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    MaxIconBack.Visible = isMaximized
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =============================================
-- LOGIC LOGO MC TRÒN NỔI
-- =============================================

local LogoToggleBtn = Instance.new("ImageButton")
LogoToggleBtn.Name = "MC_Logo_Toggle"
LogoToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
LogoToggleBtn.Size = UDim2.new(0, 50, 0, 50)
LogoToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
LogoToggleBtn.Image = "rbxassetid://83952349800959" 
LogoToggleBtn.Active = true
LogoToggleBtn.ZIndex = 1000000
LogoToggleBtn.Parent = ScreenGui

local lDragging, lDragStart, lStartPos
LogoToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lDragging = true
        lDragStart = input.Position
        lStartPos = LogoToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                lDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if lDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - lDragStart
        LogoToggleBtn.Position = UDim2.new(lStartPos.X.Scale, lStartPos.X.Offset + delta.X, lStartPos.Y.Scale, lStartPos.Y.Offset + delta.Y)
    end
end)

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoToggleBtn

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Color3.fromRGB(255, 170, 0)
LogoStroke.Thickness = 2
LogoStroke.Parent = LogoToggleBtn

LogoToggleBtn.MouseButton1Click:Connect(ToggleMainFrame)

-- --- HÀM TẠO NÚT CHECKBOX ---
local function CreateCheckboxToggle(name, text, positionY)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Position = UDim2.new(0, 15, 0, positionY)
    Button.Size = UDim2.new(1, -30, 0, 42)
    Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Button.BackgroundTransparency = 0.2
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.ZIndex = 100000
    Button.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(75, 75, 75)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(1, -75, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.ZIndex = 100001
    Label.Parent = Button

    local CheckBox = Instance.new("Frame")
    CheckBox.Position = UDim2.new(1, -35, 0.5, -9)
    CheckBox.Size = UDim2.new(0, 18, 0, 18)
    CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CheckBox.ZIndex = 100001
    CheckBox.Parent = Button

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0.15, 0)
    BoxCorner.Parent = CheckBox

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(255, 170, 0)
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = CheckBox

    local isOn = false
    local function ToggleState(state)
        isOn = state
        local targetBg = isOn and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(45, 45, 45)
        TweenService:Create(CheckBox, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetBg}):Play()
    end

    return Button, ToggleState
end

-- --- HÀM TẠO DROPDOWN MƯỢT MÀ ---
local function CreateDropdown(titleText, options, positionY, onSelect)
    local Frame = Instance.new("Frame")
    Frame.Position = UDim2.new(0, 15, 0, positionY)
    Frame.Size = UDim2.new(1, -30, 0, 42)
    Frame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Frame.BackgroundTransparency = 0.2
    Frame.ZIndex = 100000
    Frame.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Frame

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(75, 75, 75)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Frame

    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(1, 0, 1, 0)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. titleText .. ": Select..."
    MainBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    MainBtn.Font = Enum.Font.SourceSans
    MainBtn.TextSize = 14
    MainBtn.ZIndex = 100001
    MainBtn.Parent = Frame

    local ArrowImg = Instance.new("ImageButton")
    ArrowImg.Position = UDim2.new(1, -32, 0.5, -8)
    ArrowImg.Size = UDim2.new(0, 16, 0, 16)
    ArrowImg.BackgroundTransparency = 1
    ArrowImg.Image = "rbxassetid://6034818372"
    ArrowImg.ImageColor3 = Color3.fromRGB(180, 180, 180)
    ArrowImg.ZIndex = 100001
    ArrowImg.Parent = Frame

    local DropList = Instance.new("ScrollingFrame")
    DropList.Position = UDim2.new(0, 0, 1, 5)
    DropList.Size = UDim2.new(1, 0, 0, 0)
    DropList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropList.ClipsDescendants = true
    DropList.Visible = false
    DropList.ZIndex = 100005
    DropList.CanvasSize = UDim2.new(0, 0, 0, #options * 32)
    DropList.ScrollBarThickness = 4
    DropList.ScrollBarImageColor3 = Color3.fromRGB(255, 170, 0)
    DropList.Parent = Frame

    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 8)
    ListCorner.Parent = DropList

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = DropList

    local isOpen = false
    local targetHeight = math.min(#options * 32, 130)

    local function ToggleDrop()
        isOpen = not isOpen
        if isOpen then
            DropList.Visible = true
            TweenService:Create(DropList, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
            TweenService:Create(ArrowImg, TweenInfo.new(0.2), {Rotation = 180, ImageColor3 = Color3.fromRGB(255, 170, 0)}):Play()
        else
            local tween = TweenService:Create(DropList, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)})
            tween:Play()
            tween.Completed:Connect(function()
                if not isOpen then DropList.Visible = false end
            end)
            TweenService:Create(ArrowImg, TweenInfo.new(0.15), {Rotation = 0, ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play()
        end
    end

    MainBtn.MouseButton1Click:Connect(ToggleDrop)
    ArrowImg.MouseButton1Click:Connect(ToggleDrop)

    local itemButtons = {}
    for _, opt in ipairs(options) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Size = UDim2.new(1, 0, 0, 32)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        ItemBtn.Text = "  " .. tostring(opt)
        ItemBtn.TextColor3 = Color3.fromRGB(210, 210, 210)
        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
        ItemBtn.Font = Enum.Font.SourceSans
        ItemBtn.TextSize = 14
        ItemBtn.ZIndex = 100006
        ItemBtn.Parent = DropList

        ItemBtn.MouseEnter:Connect(function()
            if ItemBtn.BackgroundColor3 ~= Color3.fromRGB(115, 80, 0) then
                ItemBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end
        end)
        ItemBtn.MouseLeave:Connect(function()
            if ItemBtn.BackgroundColor3 ~= Color3.fromRGB(115, 80, 0) then
                ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
        end)

        ItemBtn.MouseButton1Click:Connect(function()
            for _, btn in ipairs(itemButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            ItemBtn.BackgroundColor3 = Color3.fromRGB(115, 80, 0)

            MainBtn.Text = "  " .. titleText .. ": " .. tostring(opt)
            ToggleDrop()
            onSelect(opt)
        end)

        table.insert(itemButtons, ItemBtn)
    end
end

local WhiteBtn, UpdateWhiteToggle = CreateCheckboxToggle("WhiteScreenBtn", "White Screen", 48)
local BlackBtn, UpdateBlackToggle = CreateCheckboxToggle("BlackScreenBtn", "Black Screen", 98)

-- =============================================
-- LOGIC FIX LAG TỐC ĐỘ CAO (X10)
-- =============================================

local originalState = {}
local isInitialized = false

local function InitObjectCache(onReady)
    if isInitialized then 
        if onReady then onReady() end
        return 
    end
    
    task.spawn(function()
        local char = LocalPlayer.Character
        local descendants = Workspace:GetDescendants()
        for i, obj in ipairs(descendants) do
            if not (char and obj:IsDescendantOf(char)) 
               and not obj:IsA("BillboardGui") 
               and not obj:IsA("SurfaceGui") 
               and not obj:IsA("Camera") 
               and not obj:IsA("Terrain") then
                
                if obj:IsA("BasePart") then
                    originalState[obj] = {Material = obj.Material, CastShadow = obj.CastShadow, Transparency = obj.Transparency}
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    originalState[obj] = {Transparency = obj.Transparency}
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    originalState[obj] = {Enabled = obj.Enabled}
                end
            end
            if i % 30000 == 0 then
                task.wait()
            end
        end
        isInitialized = true
        if onReady then onReady() end
    end)
end

local percentList = {"0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"}

CreateDropdown("Fix Lag Level", percentList, 155, function(val)
    InitObjectCache(function()
        task.spawn(function()
            local percent = tonumber(val:match("%d+")) or 0
            
            if percent == 0 then
                Lighting.GlobalShadows = true
                Lighting.FogEnd = 100000
                local count = 0
                for obj, data in pairs(originalState) do
                    if obj and obj.Parent then
                        if obj:IsA("BasePart") then
                            obj.Material = data.Material
                            obj.CastShadow = data.CastShadow
                            obj.Transparency = data.Transparency
                        elseif obj:IsA("Decal") or obj:IsA("Texture") then
                            obj.Transparency = data.Transparency
                        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                            obj.Enabled = data.Enabled
                        end
                    end
                    count = count + 1
                    if count % 20000 == 0 then task.wait() end
                end
                return
            end

            local objectList = {}
            for obj, _ in pairs(originalState) do
                if obj and obj.Parent then table.insert(objectList, obj) end
            end

            local total = #objectList
            local processCount = math.floor(total * (percent / 100))

            if percent >= 90 then
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
            end

            for i = 1, total do
                local obj = objectList[i]
                local data = originalState[obj]
                
                if i <= processCount then
                    if obj:IsA("BasePart") then
                        obj.CastShadow = false
                        obj.Transparency = 1
                        if percent >= 50 then obj.Material = Enum.Material.SmoothPlastic end
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = 1
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    end
                else
                    if obj:IsA("BasePart") then
                        obj.Material = data.Material
                        obj.CastShadow = data.CastShadow
                        obj.Transparency = data.Transparency
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = data.Transparency
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        obj.Enabled = data.Enabled
                    end
                end

                if i % 20000 == 0 then
                    task.wait()
                end
            end
        end)
    end)
end)

local fpsList = {"Unlimited", "10 FPS", "20 FPS", "30 FPS", "40 FPS", "50 FPS", "60 FPS", "70 FPS", "80 FPS", "90 FPS", "100 FPS"}
CreateDropdown("Target FPS", fpsList, 208, function(val)
    if val == "Unlimited" then
        if setfpscap then setfpscap(999) end
    else
        local fpsNum = tonumber(val:match("%d+")) or 60
        if setfpscap then setfpscap(fpsNum) end
    end
end)

-- =============================================
-- LOGIC PURE WHITE & PURE BLACK SCREEN (TỐC ĐỘ CAO X10)
-- =============================================

local isWhiteOn = false
local isBlackOn = false
local originalColors = {}

local origOutdoorAmbient = Lighting.OutdoorAmbient
local origAmbient = Lighting.Ambient
local origFogColor = Lighting.FogColor
local origFogStart = Lighting.FogStart
local origFogEnd = Lighting.FogEnd
local origGlobalShadows = Lighting.GlobalShadows

local colorEffect = Instance.new("ColorCorrectionEffect")
colorEffect.Name = "ScreenModeEffect"
colorEffect.Enabled = false
colorEffect.Parent = Lighting

local function ApplyScreenMode(mode)
    task.spawn(function()
        if mode == "White" then
            if next(originalColors) == nil then
                local count = 0
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        originalColors[part] = part.Color 
                        count = count + 1
                        if count % 25000 == 0 then task.wait() end
                    end
                end
            end

            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Lighting.FogStart = 0
            Lighting.FogEnd = 0

            local count = 0
            for part, _ in pairs(originalColors) do
                if part and part.Parent then 
                    part.Color = Color3.fromRGB(255, 255, 255) 
                    count = count + 1
                    if count % 20000 == 0 then task.wait() end
                end
            end
            colorEffect.Brightness = 2
            colorEffect.Contrast = -0.5
            colorEffect.Enabled = true

        elseif mode == "Black" then
            if next(originalColors) == nil then
                local count = 0
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        originalColors[part] = part.Color 
                        count = count + 1
                        if count % 25000 == 0 then task.wait() end
                    end
                end
            end

            Lighting.GlobalShadows = false
            Lighting.ClockTime = 0
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.FogColor = Color3.fromRGB(0, 0, 0)
            Lighting.FogStart = 0
            Lighting.FogEnd = 0

            local count = 0
            for part, _ in pairs(originalColors) do
                if part and part.Parent then 
                    part.Color = Color3.fromRGB(0, 0, 0) 
                    count = count + 1
                    if count % 20000 == 0 then task.wait() end
                end
            end
            colorEffect.Brightness = -1
            colorEffect.Contrast = 0
            colorEffect.Enabled = true

        else
            colorEffect.Enabled = false
            Lighting.OutdoorAmbient = origOutdoorAmbient
            Lighting.Ambient = origAmbient
            Lighting.FogColor = origFogColor
            Lighting.FogStart = origFogStart
            Lighting.FogEnd = origFogEnd
            Lighting.GlobalShadows = origGlobalShadows

            local count = 0
            for part, color in pairs(originalColors) do
                if part and part.Parent then 
                    part.Color = color 
                    count = count + 1
                    if count % 20000 == 0 then task.wait() end
                end
            end
        end
    end)
end

WhiteBtn.MouseButton1Click:Connect(function()
    isWhiteOn = not isWhiteOn
    if isWhiteOn then
        isBlackOn = false
        UpdateBlackToggle(false)
        UpdateWhiteToggle(true)
        ApplyScreenMode("White")
    else
        UpdateWhiteToggle(false)
        ApplyScreenMode("Off")
    end
end)

BlackBtn.MouseButton1Click:Connect(function()
    isBlackOn = not isBlackOn
    if isBlackOn then
        isWhiteOn = false
        UpdateWhiteToggle(false)
        UpdateBlackToggle(true)
        ApplyScreenMode("Black")
    else
        UpdateBlackToggle(false)
        ApplyScreenMode("Off")
    end
end)
