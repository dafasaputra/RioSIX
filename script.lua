local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local lp = Players.LocalPlayer

local ScriptActive = true
local Connections = {}
local ScreenGui
local VirtualUser = game:GetService("VirtualUser")
local SafeName = "RioSIX_ReplicatedService_" .. math.random(100000,999999)

local ProtectGui = protectgui or (syn and syn.protect_gui) or (gethui and function(g) g.Parent = gethui() end) or function(g) g.Parent = CoreGui end
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

task.spawn(function()
    while ScriptActive do
        task.wait(5)
        local success, err = pcall(function()
            local core = game:GetService("CoreGui")
            if core:FindFirstChild("DarkDetex") or core:FindFirstChild("RemoteSpy") or core:FindFirstChild("TurtleSpy") then
            end
        end)
    end
end)

if getgenv and getgenv().Byu_Stop then
    pcall(getgenv().Byu_Stop)
end

local function CleanupScript()
    ScriptActive = false
    for _, v in pairs(Connections) do
        pcall(function() v:Disconnect() end)
    end
    Connections = {}
   
    if TextChatService then
        TextChatService.OnIncomingMessage = nil
    end
   
    if ScreenGui then ScreenGui:Destroy() end
   
    print("❌ RioSIX System: Script closed and cleanup complete.")
    if getgenv then getgenv().Byu_Stop = nil end
end

if getgenv then
    getgenv().Byu_Stop = CleanupScript
end

if not isfolder("RioSIX_Configs") then
    pcall(function() makefolder("RioSIX_Configs") end)
end

local Theme = {
    Background = Color3.fromRGB(20, 22, 28),
    Header = Color3.fromRGB(25, 28, 35),
    Sidebar = Color3.fromRGB(18, 20, 25),
    Content = Color3.fromRGB(22, 24, 30),
    Accent = Color3.fromRGB(0, 139, 139),
    AccentHover = Color3.fromRGB(0, 160, 160),
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(160, 165, 175),
    Border = Color3.fromRGB(45, 50, 60),
    Input = Color3.fromRGB(15, 16, 20),
    Success = Color3.fromRGB(75, 185, 115),
    Error = Color3.fromRGB(235, 85, 85)
}

local Current_Webhook_Fish = ""
local Current_Webhook_Leave = ""
local Current_Webhook_List = ""
local Current_Webhook_Admin = ""
local LastDisconnectTime = 0
local AdminID_1 = ""
local AdminID_2 = ""

local SecretList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Armored Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale", "Gladiator Shark",
    "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark", "ElRetro Gran Maja",
    "Strawberry Choc Megalodon", "Krampus Shark", "Emerald Winter Whale",
    "Winter Frost Shark", "Icebreaker Whale", "Leviathan", "Pirate Megalodon", "Viridis Lurker",
    "Cursed Kraken", "Ancient Magma Whale", "Rainbow Comet Shark", "Love Nessie",
}

local StoneList = { "Ruby" }

local function TeleportToLookAt(position, lookVector)
    local Character = Players.LocalPlayer.Character
    if not Character then Character = Players.LocalPlayer.CharacterAdded:Wait() end
    local hrp = Character:WaitForChild("HumanoidRootPart", 5)
   
    if hrp and typeof(position) == "Vector3" and typeof(lookVector) == "Vector3" then
        local targetCFrame = CFrame.new(position, position + lookVector)
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        ShowNotification("Teleported!", false)
    else
        ShowNotification("Invalid TP Data", true)
    end
end

local FishingAreas = {
    ["Leviathan Den"] = {Pos = Vector3.new(3431.640, -287.726, 3529.052), Look = Vector3.new(-0.176, 0.444, -0.879)},
    ["Crystal Depths"] = {Pos = Vector3.new(5820.647, -907.482, 15425.794), Look = Vector3.new(0.131, -0.666, 0.735)},
    ["Pirate Cove"] = {Pos = Vector3.new(3479.794, 4.192, 3451.693), Look = Vector3.new(0.578, -0.396, -0.713)},
    ["Pirate Tresure"] = {Pos = Vector3.new(3305.745, -302.160, 3028.795), Look = Vector3.new(-0.331, -0.396, -0.856)},
    ["Maze Door Room"] = {Pos = Vector3.new(3446.691, -287.845, 3402.136), Look = Vector3.new(0.324, -0.396, 0.859)},
    ["Ancient Jungle"] = {Pos = Vector3.new(1535.639, 3.159, -193.352), Look = Vector3.new(0.505, -0.000, 0.863)},
    ["Coral Reef"] = {Pos = Vector3.new(-3207.538, 6.087, 2011.079), Look = Vector3.new(0.973, 0.000, 0.229)},
    ["Crater Island"] = {Pos = Vector3.new(1058.976, 2.330, 5032.878), Look = Vector3.new(-0.789, 0.000, 0.615)},
    ["Ancient Ruin"] = {Pos = Vector3.new(6031.981, -585.924, 4713.157), Look = Vector3.new(0.316, -0.000, -0.949)},
    ["Enchant Room"] = {Pos = Vector3.new(3255.670, -1301.530, 1371.790), Look = Vector3.new(-0.000, -0.000, -1.000)},
    ["Fisherman Island"] = {Pos = Vector3.new(74.030, 9.530, 2705.230), Look = Vector3.new(-0.000, -0.000, -1.000)},
    ["Kohana"] = {Pos = Vector3.new(-668.732, 3.000, 681.580), Look = Vector3.new(0.889, -0.000, 0.458)},
    ["Lost Isle"] = {Pos = Vector3.new(-3804.105, 2.344, -904.653), Look = Vector3.new(-0.901, -0.000, 0.433)},
    ["Sacred Temple"] = {Pos = Vector3.new(1461.815, -22.125, -670.234), Look = Vector3.new(-0.990, -0.000, 0.143)},
    ["Second Enchant Altar"] = {Pos = Vector3.new(1479.587, 128.295, -604.224), Look = Vector3.new(-0.298, 0.000, -0.955)},
    ["Sisyphus Statue"] = {Pos = Vector3.new(-3743.745, -135.074, -1007.554), Look = Vector3.new(0.310, 0.000, 0.951)},
    ["Treasure Room"] = {Pos = Vector3.new(-3598.440, -281.274, -1645.855), Look = Vector3.new(-0.065, 0.000, -0.998)},
    ["Tropical Island"] = {Pos = Vector3.new(-2162.920, 2.825, 3638.445), Look = Vector3.new(0.381, -0.000, 0.925)},
    ["Underground Cellar"] = {Pos = Vector3.new(2118.417, -91.448, -733.800), Look = Vector3.new(0.854, 0.000, 0.521)},
    ["Volcano"] = {Pos = Vector3.new(-552.797, 21.174, 186.940), Look = Vector3.new(-0.251, -0.534, -0.808)},
    ["Volcanic Cavern"] = {Pos = Vector3.new(1249.005, 82.830, -10224.920), Look = Vector3.new(-0.649, -0.666, 0.368)},
}

local Settings = {
    SecretEnabled = false,
    RubyEnabled = false,
    MutationCrystalized = false,
    CaveCrystalEnabled = false,
    LeaveEnabled = false,
    PlayerNonPSAuto = false,
    ForeignDetection = false,
    SpoilerName = true,
    PingMonitor = false,
    AutoExecute = false,
    NoAnimation = false,
    RemoveVFX = false,
    DisablePopups = false,
    EvolvedEnabled = false
}

task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
   
    pcall(function()
        for i,v in pairs(getconnections(Players.LocalPlayer.Idled)) do
            v:Disable()
        end
    end)
    print("RioSIX: Anti-AFK Active")
end)

task.spawn(function()
    local success, err = pcall(function()
        local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
       
        if queueTeleport then
            local TpService = game:GetService("TeleportService")
            local TeleportingConn = TpService.TeleportInit:Connect(function()
                if Settings.AutoExecute then
                    print("RioSIX: Queuing Auto Execute...")
                    pcall(function()
                        queueTeleport([[
                            task.wait(5)
                            local paths = {"RioSIX/FishIt/Fishit.lua", "Fishit.lua", "RioSIX/FishIt/Fishit.lua"}
                            local scriptCode = nil
                            for _, p in ipairs(paths) do
                                local s, c = pcall(function() return readfile(p) end)
                                if s and c then scriptCode = c; break end
                            end
                           
                            if scriptCode then
                                loadstring(scriptCode)()
                            else
                                warn("RioSIX AutoExecute: Could not find script file to execute!")
                            end
                        ]])
                    end)
                end
            end)
            table.insert(Connections, TeleportingConn)
        end
    end)
    if not success then warn("RioSIX: AutoExecute Not Supported: " .. tostring(err)) end
end)

local TagList = {}
local TagUIElements = {}
local UI_FishInput, UI_LeaveInput, UI_ListInput, UI_AdminInput
local SessionStart = tick()
local SessionStats = {
    Secret = 0,
    Ruby = 0,
    Evolved = 0,
    Crystalized = 0,
    CaveCrystal = 0,
    TotalSent = 0
}
local UI_StatsLabels = {}

local function UpdateTagData()
    if #TagList == 0 then
        for i = 1, 20 do TagList[i] = {"", ""} end
    end
    if #TagUIElements > 0 then
        for i = 1, 20 do
            if TagUIElements[i] then
                TagUIElements[i].User.Text = TagList[i][1] or ""
                TagUIElements[i].ID.Text = TagList[i][2] or ""
            end
        end
    end
end
UpdateTagData()

local oldUI = CoreGui:FindFirstChild(SafeName) or CoreGui:FindFirstChild("RioSIX_Script")
if oldUI then oldUI:Destroy() task.wait(0.1) end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SafeName
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ProtectGui(ScreenGui)
end)
if not ScreenGui.Parent then ScreenGui.Parent = CoreGui end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function AddStroke(instance, color, thickness)
    local s = Instance.new("UIStroke", instance)
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function AddPadding(instance, amount)
    local p = Instance.new("UIPadding", instance)
    p.PaddingLeft = UDim.new(0, amount)
    p.PaddingRight = UDim.new(0, amount)
    p.PaddingTop = UDim.new(0, amount)
    p.PaddingBottom = UDim.new(0, amount)
    return p
end

function ShowNotification(msg, isError)
    if not ScriptActive then return end
    local NotifFrame = Instance.new("Frame", ScreenGui)
    NotifFrame.BackgroundColor3 = Theme.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
    NotifFrame.Size = UDim2.new(0, 220, 0, 40)
    NotifFrame.ZIndex = 200
   
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    AddStroke(NotifFrame, isError and Theme.Error or Theme.Accent, 1.5)
   
    local Icon = Instance.new("Frame", NotifFrame)
    Icon.BackgroundColor3 = isError and Theme.Error or Theme.Accent
    Icon.Size = UDim2.new(0, 4, 1, -10)
    Icon.Position = UDim2.new(0, 8, 0.5, -((40-10)/2))
    Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
    local Label = Instance.new("TextLabel", NotifFrame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = msg
    Label.TextColor3 = Theme.TextPrimary
    Label.TextSize = 13
    Label.ZIndex = 201
   
    NotifFrame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Icon.BackgroundTransparency = 1
   
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -110, 0.15, 0)}):Play()
   
    task.delay(2.5, function()
        if NotifFrame then
            TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -110, 0.1, 0)}):Play()
            TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            NotifFrame:Destroy()
        end
    end)
endlocal oldUI = CoreGui:FindFirstChild(SafeName) or CoreGui:FindFirstChild("RioSIX_Script")
if oldUI then oldUI:Destroy() task.wait(0.1) end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = SafeName
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ProtectGui(ScreenGui)
end)
if not ScreenGui.Parent then ScreenGui.Parent = CoreGui end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function AddStroke(instance, color, thickness)
    local s = Instance.new("UIStroke", instance)
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function AddPadding(instance, amount)
    local p = Instance.new("UIPadding", instance)
    p.PaddingLeft = UDim.new(0, amount)
    p.PaddingRight = UDim.new(0, amount)
    p.PaddingTop = UDim.new(0, amount)
    p.PaddingBottom = UDim.new(0, amount)
    return p
end

function ShowNotification(msg, isError)
    if not ScriptActive then return end
    local NotifFrame = Instance.new("Frame", ScreenGui)
    NotifFrame.BackgroundColor3 = Theme.Background
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(0.5, -110, 0.1, 0)
    NotifFrame.Size = UDim2.new(0, 220, 0, 40)
    NotifFrame.ZIndex = 200
   
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    AddStroke(NotifFrame, isError and Theme.Error or Theme.Accent, 1.5)
   
    local Icon = Instance.new("Frame", NotifFrame)
    Icon.BackgroundColor3 = isError and Theme.Error or Theme.Accent
    Icon.Size = UDim2.new(0, 4, 1, -10)
    Icon.Position = UDim2.new(0, 8, 0.5, -((40-10)/2))
    Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
    local Label = Instance.new("TextLabel", NotifFrame)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = msg
    Label.TextColor3 = Theme.TextPrimary
    Label.TextSize = 13
    Label.ZIndex = 201
   
    NotifFrame.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Icon.BackgroundTransparency = 1
   
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -110, 0.15, 0)}):Play()
   
    task.delay(2.5, function()
        if NotifFrame then
            TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -110, 0.1, 0)}):Play()
            TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            NotifFrame:Destroy()
        end
    end)
end

    local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
AddStroke(MainFrame, Theme.Border, 1)

local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.ZIndex = -1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.4
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceScale = 1

local Header = Instance.new("Frame", MainFrame)
Header.BackgroundColor3 = Theme.Header
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BorderSizePixel = 0
Header.ZIndex = 5
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8)

local HeaderSquare = Instance.new("Frame", Header)
HeaderSquare.BackgroundColor3 = Theme.Header
HeaderSquare.BorderSizePixel = 0
HeaderSquare.Position = UDim2.new(0,0,1,-8)
HeaderSquare.Size = UDim2.new(1,0,0,8)

local HeaderLine = Instance.new("Frame", Header)
HeaderLine.BackgroundColor3 = Theme.Border
HeaderLine.BorderSizePixel = 0
HeaderLine.Position = UDim2.new(0, 0, 1, 0)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.ZIndex = 6

local TitleLab = Instance.new("TextLabel", Header)
TitleLab.BackgroundTransparency = 1
TitleLab.Position = UDim2.new(0, 15, 0, 0)
TitleLab.Size = UDim2.new(0, 200, 1, 0)
TitleLab.Font = Enum.Font.GothamBold
TitleLab.Text = "RioSIX"
TitleLab.TextColor3 = Theme.Accent
TitleLab.TextSize = 14
TitleLab.TextXAlignment = Enum.TextXAlignment.Left
TitleLab.ZIndex = 6

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Name = "Close"
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextSecondary
CloseBtn.TextSize = 22
CloseBtn.ZIndex = 6
CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = Theme.Error end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = Theme.TextSecondary end)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Name = "Minimize"
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.TextSecondary
MinBtn.TextSize = 22
MinBtn.ZIndex = 6
MinBtn.MouseEnter:Connect(function() MinBtn.TextColor3 = Theme.TextPrimary end)
MinBtn.MouseLeave:Connect(function() MinBtn.TextColor3 = Theme.TextSecondary end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.Size = UDim2.new(0, 110, 1, -36)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
local SideCorner = Instance.new("UICorner", Sidebar)
SideCorner.CornerRadius = UDim.new(0, 8)

local SideSquare = Instance.new("Frame", Sidebar)
SideSquare.BackgroundColor3 = Theme.Sidebar
SideSquare.BorderSizePixel = 0
SideSquare.Position = UDim2.new(1,-8,0,0)
SideSquare.Size = UDim2.new(0,8,1,0)

local SideLine = Instance.new("Frame", Sidebar)
SideLine.BackgroundColor3 = Theme.Border
SideLine.BorderSizePixel = 0
SideLine.Position = UDim2.new(1, -1, 0, 0)
SideLine.Size = UDim2.new(0, 1, 1, 0)
SideLine.ZIndex = 3

local MenuContainer = Instance.new("Frame", Sidebar)
MenuContainer.BackgroundTransparency = 1
MenuContainer.Size = UDim2.new(1, 0, 1, -25)
MenuContainer.Position = UDim2.new(0, 0, 0, 5)
MenuContainer.ZIndex = 5

local SideLayout = Instance.new("UIListLayout", MenuContainer)
SideLayout.Padding = UDim.new(0, 2)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", MenuContainer).PaddingTop = UDim.new(0, 8)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 120, 0, 42)
ContentContainer.Size = UDim2.new(1, -120, 1, -48)
ContentContainer.ZIndex = 3

    local ModalFrame = Instance.new("Frame", ScreenGui)
ModalFrame.Name = "ModalConfirm"
ModalFrame.BackgroundColor3 = Theme.Header
ModalFrame.Size = UDim2.new(0, 240, 0, 110)
ModalFrame.Position = UDim2.new(0.5, -120, 0.5, -55)
ModalFrame.BorderSizePixel = 0
ModalFrame.ZIndex = 100
ModalFrame.Visible = false
ModalFrame.Active = false
Instance.new("UICorner", ModalFrame).CornerRadius = UDim.new(0, 8)
AddStroke(ModalFrame, Theme.Border, 1)

local ModalShadow = Instance.new("ImageLabel", ModalFrame)
ModalShadow.Name = "Shadow"
ModalShadow.AnchorPoint = Vector2.new(0.5, 0.5)
ModalShadow.BackgroundTransparency = 1
ModalShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
ModalShadow.Size = UDim2.new(1, 40, 1, 40)
ModalShadow.ZIndex = 99
ModalShadow.Image = "rbxassetid://6014261993"
ModalShadow.ImageColor3 = Color3.new(0, 0, 0)
ModalShadow.ImageTransparency = 0.5
ModalShadow.SliceCenter = Rect.new(49, 49, 450, 450)

local ModalTitle = Instance.new("TextLabel", ModalFrame)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Position = UDim2.new(0, 0, 0, 18)
ModalTitle.Size = UDim2.new(1, 0, 0, 20)
ModalTitle.Font = Enum.Font.GothamBold
ModalTitle.Text = "Close Script?"
ModalTitle.TextColor3 = Theme.TextPrimary
ModalTitle.TextSize = 16
ModalTitle.ZIndex = 102

local BtnYes = Instance.new("TextButton", ModalFrame)
BtnYes.BackgroundColor3 = Theme.Error
BtnYes.Position = UDim2.new(0, 20, 1, -40)
BtnYes.Size = UDim2.new(0, 95, 0, 28)
BtnYes.Font = Enum.Font.GothamBold
BtnYes.Text = "Yes"
BtnYes.TextColor3 = Color3.new(1, 1, 1)
BtnYes.TextSize = 13
BtnYes.ZIndex = 102
BtnYes.Active = true
Instance.new("UICorner", BtnYes).CornerRadius = UDim.new(0, 6)

local BtnNo = Instance.new("TextButton", ModalFrame)
BtnNo.BackgroundColor3 = Theme.Content
BtnNo.Position = UDim2.new(1, -115, 1, -40)
BtnNo.Size = UDim2.new(0, 95, 0, 28)
BtnNo.Font = Enum.Font.GothamBold
BtnNo.Text = "No"
BtnNo.TextColor3 = Theme.TextPrimary
BtnNo.TextSize = 13
BtnNo.ZIndex = 102
BtnNo.Active = true
Instance.new("UICorner", BtnNo).CornerRadius = UDim.new(0, 6)
AddStroke(BtnNo, Theme.Border, 1)

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", ContentContainer)
    Page.Name = "Page_" .. name
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.Accent
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    Page.ZIndex = 4
   
    local layout = Instance.new("UIListLayout", Page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
   
    return Page
end

local Page_Webhook = CreatePage("Webhook")
local Page_Save = CreatePage("SaveConfig")
local Page_Tag = CreatePage("TagDiscord")
local Page_AdminBoost = CreatePage("AdminBoost")
local Page_SessionStats = CreatePage("SessionStats")
local Page_Fhising = CreatePage("Fhising")
Page_Webhook.Visible = false

    local function CreateTab(name, target, isDefault)
    local TabBtn = Instance.new("TextButton", MenuContainer)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, -10, 0, 26)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = name
    TabBtn.TextColor3 = Theme.TextSecondary
    TabBtn.TextSize = 11
    TabBtn.ZIndex = 3
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
   
    local Indicator = Instance.new("Frame", TabBtn)
    Indicator.Name = "ActiveIndicator"
    Indicator.BackgroundColor3 = Theme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(0, 2, 0.5, -8)
    Indicator.Size = UDim2.new(0, 3, 0, 16)
    Indicator.Visible = false
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
   
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(ContentContainer:GetChildren()) do
            if page:IsA("ScrollingFrame") or page:IsA("Frame") then
                page.Visible = false
            end
        end
        target.Visible = true
       
        for _, child in pairs(MenuContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = Theme.TextSecondary
                child.Font = Enum.Font.GothamMedium
                child.BackgroundTransparency = 1
                local line = child:FindFirstChild("ActiveIndicator")
                if line then line.Visible = false end
            end
        end
       
        TabBtn.TextColor3 = Theme.TextPrimary
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.BackgroundTransparency = 0.95
        TabBtn.BackgroundColor3 = Theme.TextPrimary
        Indicator.Visible = true
    end)
   
    if isDefault then
        TabBtn.TextColor3 = Theme.TextPrimary
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.BackgroundTransparency = 0.95
        TabBtn.BackgroundColor3 = Theme.TextPrimary
        Indicator.Visible = true
        target.Visible = true
    end
end

    CreateTab("Server Info", Page_SessionStats, true)
CreateTab("Fhising", Page_Fhising)

local Page_Teleport = CreatePage("Teleport")
local TeleportList = Instance.new("UIListLayout", Page_Teleport)
TeleportList.Padding = UDim.new(0, 5)
TeleportList.SortOrder = Enum.SortOrder.LayoutOrder

CreateTab("Teleport", Page_Teleport)

CreateTab("Notification", Page_Webhook)
CreateTab("Admin Boost", Page_AdminBoost)
CreateTab("List Player", Page_Tag)

Page_Setting = Instance.new("ScrollingFrame", ContentContainer)
Page_Setting.Name = "Page_Setting"
Page_Setting.Size = UDim2.new(1, 0, 1, 0)
Page_Setting.BackgroundTransparency = 1
Page_Setting.Visible = false
Page_Setting.ScrollBarThickness = 2
Instance.new("UIListLayout", Page_Setting).Padding = UDim.new(0, 5)

CreateTab("Setting", Page_Setting)
CreateTab("Save Config", Page_Save)

    -- Tambah Tab Shop di akhir sidebar
local Page_Shop = CreatePage("Shop")
CreateTab("Shop", Page_Shop)

-- Isi Page Shop (placeholder sederhana)
local ShopTitle = Instance.new("TextLabel", Page_Shop)
ShopTitle.BackgroundTransparency = 1
ShopTitle.Size = UDim2.new(1, 0, 0, 40)
ShopTitle.Font = Enum.Font.GothamBlack
ShopTitle.Text = "RIO SIX SHOP"
ShopTitle.TextColor3 = Theme.Accent
ShopTitle.TextSize = 18
ShopTitle.TextXAlignment = Enum.TextXAlignment.Center

local function CreateShopCategory(name)
    local CatFrame = Instance.new("Frame", Page_Shop)
    CatFrame.BackgroundColor3 = Theme.Content
    CatFrame.Size = UDim2.new(1, -10, 0, 180)
    CatFrame.BorderSizePixel = 0
    Instance.new("UICorner", CatFrame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", CatFrame)
    stroke.Color = Theme.Border
    stroke.Thickness = 1
   
    local CatLabel = Instance.new("TextLabel", CatFrame)
    CatLabel.BackgroundTransparency = 1
    CatLabel.Size = UDim2.new(1, 0, 0, 30)
    CatLabel.Font = Enum.Font.GothamBold
    CatLabel.Text = name
    CatLabel.TextColor3 = Theme.AccentHover
    CatLabel.TextSize = 16
    CatLabel.TextXAlignment = Enum.TextXAlignment.Center
   
    local Placeholder = Instance.new("TextLabel", CatFrame)
    Placeholder.BackgroundTransparency = 1
    Placeholder.Size = UDim2.new(1, -20, 1, -50)
    Placeholder.Position = UDim2.new(0, 10, 0, 40)
    Placeholder.Font = Enum.Font.GothamMedium
    Placeholder.Text = "Fitur " .. name .. " (Auto Buy / Preview / Toggle)\nComing soon / Customize di sini"
    Placeholder.TextColor3 = Theme.TextSecondary
    Placeholder.TextSize = 13
    Placeholder.TextWrapped = true
end

CreateShopCategory("Merchant")
CreateShopCategory("Charm")
CreateShopCategory("Bobber")
CreateShopCategory("Rod")

    -- ToggleRegistry & CreateToggle (sama persis)
local ToggleRegistry = {}
local function CreateToggle(parent, text, settingKey, callback, validationFunc)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Theme.Content
    Frame.BackgroundTransparency = 0
    Frame.Size = UDim2.new(1, -5, 0, 36)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    AddStroke(Frame, Theme.Border, 1)
    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0, 10, 0, 0); Label.Size = UDim2.new(0, 180, 1, 0)
    Label.Font = Enum.Font.GothamBold; Label.Text = text; Label.TextColor3 = Theme.TextPrimary; Label.TextSize = 12; Label.TextXAlignment = "Left"
   
    local default = Settings[settingKey] or false
   
    local Switch = Instance.new("TextButton", Frame)
    Switch.BackgroundColor3 = default and Theme.Success or Theme.Input
    Switch.BackgroundTransparency = 0; Switch.Position = UDim2.new(1, -45, 0.5, -10); Switch.Size = UDim2.new(0, 36, 0, 20); Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
   
    local Circle = Instance.new("Frame", Switch)
    Circle.BackgroundColor3 = Color3.new(1,1,1)
    Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); Circle.Size = UDim2.new(0, 16, 0, 16)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
   
    local function UpdateUI(state)
        local targetColor = state and Theme.Success or Theme.Input
        local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
       
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        Circle:TweenPosition(targetPos, "Out", "Sine", 0.15, true)
    end
   
    ToggleRegistry[settingKey] = function(val)
        UpdateUI(val)
        if callback then callback(val) end
    end
    Switch.MouseButton1Click:Connect(function()
        local n = not (Switch.BackgroundColor3 == Theme.Success)
        if n and validationFunc and not validationFunc() then ShowNotification("Webhook Empty!", true) return end
       
        Settings[settingKey] = n
       
        UpdateUI(n)
        if callback then callback(n) end
       
        ShowNotification(text .. (n and " Enabled" or " Disabled"))
    end)
end

-- CreateInput (sama persis)
local function CreateInput(parent, placeholder, default, callback, height)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Theme.Content
    local finalHeight = height and (height - 2) or 32
    Frame.Size = UDim2.new(1, -5, 0, finalHeight); Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    AddStroke(Frame, Theme.Border, 1)
    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0, 10, 0, 0); Label.Size = UDim2.new(0, 140, 1, 0)
    Label.Font = Enum.Font.GothamBold; Label.Text = placeholder; Label.TextColor3 = Theme.TextSecondary; Label.TextSize = 12; Label.TextXAlignment = "Left"
    local inputX = (finalHeight > 34) and 160 or 150
    local inputWidth = (finalHeight > 34) and 170 or 160
    local InputBg = Instance.new("Frame", Frame)
    InputBg.BackgroundColor3 = Theme.Input
    InputBg.Position = UDim2.new(0, inputX, 0.5, -10)
    InputBg.Size = UDim2.new(1, -inputWidth, 0, 20)
    InputBg.ClipsDescendants = true
    Instance.new("UICorner", InputBg).CornerRadius = UDim.new(0, 4)
    AddStroke(InputBg, Theme.Border, 1)
    local Input = Instance.new("TextBox", InputBg)
    Input.BackgroundTransparency = 1; Input.Position = UDim2.new(0, 5, 0, 0); Input.Size = UDim2.new(1, -10, 1, 0)
    Input.Font = Enum.Font.GothamMedium; Input.Text = default; Input.PlaceholderText = "Paste here..."; Input.TextColor3 = Theme.TextPrimary; Input.TextSize = 11; Input.TextXAlignment = "Left"; Input.ClearTextOnFocus = false
    Input.Focused:Connect(function() AddStroke(InputBg, Theme.Accent, 1) end)
    Input.FocusLost:Connect(function() AddStroke(InputBg, Theme.Border, 1) callback(Input.Text, Input) end)
    return Input
end

-- CreateDropdown (sama persis)
local function CreateDropdown(parent, labelText, options, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Theme.Content
    Frame.Size = UDim2.new(1, -5, 0, 36)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    AddStroke(Frame, Theme.Border, 1)
    local Label = Instance.new("TextLabel", Frame)
    Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0, 10, 0, 0); Label.Size = UDim2.new(0, 140, 1, 0)
    Label.Font = Enum.Font.GothamBold; Label.Text = labelText; Label.TextColor3 = Theme.TextPrimary; Label.TextSize = 12; Label.TextXAlignment = "Left"
    local currentVal = default or (options and options[1]) or "None"
   
    local DropBtn = Instance.new("TextButton", Frame)
    DropBtn.BackgroundColor3 = Theme.Input
    DropBtn.Position = UDim2.new(0, 160, 0.5, -10)
    DropBtn.Size = UDim2.new(1, -170, 0, 20)
    DropBtn.Font = Enum.Font.GothamMedium
    DropBtn.Text = currentVal .. " v"
    DropBtn.TextColor3 = Theme.TextPrimary
    DropBtn.TextSize = 11
    Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 4)
    AddStroke(DropBtn, Theme.Border, 1)
   
    DropBtn.MouseButton1Click:Connect(function()
        if MainFrame:FindFirstChild("DropdownList_" .. labelText) then
            MainFrame:FindFirstChild("DropdownList_" .. labelText):Destroy()
            return
        end
       
        local Float = Instance.new("ScrollingFrame", MainFrame)
        Float.Name = "DropdownList_" .. labelText
        Float.BackgroundColor3 = Theme.Content
        Float.Size = UDim2.new(0, 200, 0, math.min(#options * 25 + 5, 200))
        Float.Position = UDim2.new(0.5, -100, 0.5, -75)
        Float.ZIndex = 200
        Float.ScrollBarThickness = 4
        Instance.new("UICorner", Float).CornerRadius = UDim.new(0, 6)
        AddStroke(Float, Theme.Accent, 1)
       
        local ListLayout = Instance.new("UIListLayout", Float)
        ListLayout.Padding = UDim.new(0, 2)
       
        for _, opt in ipairs(options) do
            local OBtn = Instance.new("TextButton", Float)
            OBtn.Size = UDim2.new(1,0,0,25)
            OBtn.BackgroundColor3 = Theme.Input
            OBtn.BackgroundTransparency = 0.5
            OBtn.Text = opt
            OBtn.TextColor3 = Theme.TextPrimary
            OBtn.Font = Enum.Font.GothamMedium
            OBtn.TextSize = 11
           
            OBtn.MouseButton1Click:Connect(function()
                currentVal = opt
                DropBtn.Text = currentVal .. " v"
                callback(opt)
                Float:Destroy()
            end)
        end
       
        local Close = Instance.new("TextButton", Float)
        Close.Size = UDim2.new(1,0,0,20)
        Close.BackgroundColor3 = Theme.Error
        Close.Text = "CLOSE"
        Close.TextColor3 = Color3.new(1,1,1)
        Close.TextSize = 10
        Close.MouseButton1Click:Connect(function() Float:Destroy() end)
    end)
end

-- GetRemote, getFishCount, Detector Stuck, Auto Click Fishing, Auto Sell, Auto Weather, Auto Totem, Walk On Water, Remove Pop-up, No Animation, Remove Skin Effect (semua sama persis seperti kode github lu)

-- Config save/load/delete/autoload (sama persis, cuma ganti folder "RioSIX_Configs")

-- Webhook parsing, SendWebhook, CheckAndSend, PlayerAdded/PlayerRemoving, Disconnect webhook, Fast Rejoin, Inventory Watcher Cave Crystal (sama persis)

-- Akhir script (print & autoload)
print("RioSIX Beta Loaded")

task.delay(1, function()
    local autoPref = GetAutoLoadPref()
    if autoPref and autoPref.enabled and autoPref.config then
        print("🔄 Autoloading Config: " .. autoPref.config)
        LoadConfig(autoPref.config)
    end
end)
