-- BranzzHub v1.0 Modified
-- Script completo com UI arrastável e todas as funcionalidades

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Variáveis de controle
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50
local bringConsoleEnabled = false
local bringTicketsEnabled = false
local espConsoleEnabled = false
local espTicketEnabled = false
local espPlayerEnabled = false
local vipBypassEnabled = false
local wallBypassEnabled = false

local espObjects = {}
local consoleEspObjects = {}
local ticketEspObjects = {}
local noclipConnection = nil
local flyConnection = nil
local bringConsoleConnection = nil
local bringTicketsConnection = nil
local espConsoleConnection = nil
local espTicketConnection = nil
local espPlayerConnection = nil
local vipBypassConnection = nil
local wallBypassConnection = nil

-- Criar ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BranzzHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 450)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "BranzzHub v1.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Botão Minimizar
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -100, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- Botão Maximizar (inicialmente invisível)
local MaximizeButton = Instance.new("TextButton")
MaximizeButton.Name = "MaximizeButton"
MaximizeButton.Size = UDim2.new(0, 120, 0, 40)
MaximizeButton.Position = UDim2.new(0.5, -60, 0.5, -20)
MaximizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
MaximizeButton.Text = "Maximizar"
MaximizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MaximizeButton.TextSize = 16
MaximizeButton.Font = Enum.Font.GothamBold
MaximizeButton.BorderSizePixel = 0
MaximizeButton.Visible = false
MaximizeButton.Parent = ScreenGui

local MaxCorner = Instance.new("UICorner")
MaxCorner.CornerRadius = UDim.new(0, 8)
MaxCorner.Parent = MaximizeButton

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Barra lateral de abas
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 130, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

-- Container de conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -130, 1, -40)
ContentFrame.Position = UDim2.new(0, 130, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Função para criar botão de aba
local function CreateTabButton(text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = text .. "Tab"
    button.Size = UDim2.new(1, -10, 0, 50)
    button.Position = UDim2.new(0, 5, 0, position)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    return button
end

-- Função para criar checkbox
local function CreateCheckbox(text, position, parent, callback)
    local container = Instance.new("Frame")
    container.Name = text .. "Container"
    container.Size = UDim2.new(1, -20, 0, 50)
    container.Position = UDim2.new(0, 10, 0, position)
    container.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = container
    
    local checkbox = Instance.new("TextButton")
    checkbox.Name = "Checkbox"
    checkbox.Size = UDim2.new(0, 30, 0, 30)
    checkbox.Position = UDim2.new(0, 10, 0.5, -15)
    checkbox.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    checkbox.Text = ""
    checkbox.BorderSizePixel = 0
    checkbox.Parent = container
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 6)
    checkCorner.Parent = checkbox
    
    local checkMark = Instance.new("TextLabel")
    checkMark.Size = UDim2.new(1, 0, 1, 0)
    checkMark.BackgroundTransparency = 1
    checkMark.Text = "✓"
    checkMark.TextColor3 = Color3.fromRGB(0, 255, 0)
    checkMark.TextSize = 24
    checkMark.Font = Enum.Font.GothamBold
    checkMark.Visible = false
    checkMark.Parent = checkbox
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local enabled = false
    checkbox.MouseButton1Click:Connect(function()
        enabled = not enabled
        checkMark.Visible = enabled
        if enabled then
            checkbox.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        else
            checkbox.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
        end
        callback(enabled)
    end)
    
    return container
end

-- Função para criar título de seção
local function CreateSectionTitle(text, position, parent)
    local title = Instance.new("TextLabel")
    title.Name = text .. "Title"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, position)
    title.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    title.Text = text
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    title.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = title
    
    return title
end

-- Criar abas
local MainTab = CreateTabButton("Main", 10, SideBar)
local GamerTab = CreateTabButton("Gamer Event", 70, SideBar)
local VipTab = CreateTabButton("VIP", 130, SideBar)
local EspTab = CreateTabButton("ESP Player", 190, SideBar)

-- Criar páginas de conteúdo
local MainPage = Instance.new("ScrollingFrame")
MainPage.Name = "MainPage"
MainPage.Size = UDim2.new(1, 0, 1, 0)
MainPage.BackgroundTransparency = 1
MainPage.ScrollBarThickness = 6
MainPage.Visible = true
MainPage.CanvasSize = UDim2.new(0, 0, 0, 500)
MainPage.Parent = ContentFrame

local GamerPage = Instance.new("ScrollingFrame")
GamerPage.Name = "GamerPage"
GamerPage.Size = UDim2.new(1, 0, 1, 0)
GamerPage.BackgroundTransparency = 1
GamerPage.ScrollBarThickness = 6
GamerPage.Visible = false
GamerPage.CanvasSize = UDim2.new(0, 0, 0, 400)
GamerPage.Parent = ContentFrame

local VipPage = Instance.new("Frame")
VipPage.Name = "VipPage"
VipPage.Size = UDim2.new(1, 0, 1, 0)
VipPage.BackgroundTransparency = 1
VipPage.Visible = false
VipPage.Parent = ContentFrame

local EspPage = Instance.new("Frame")
EspPage.Name = "EspPage"
EspPage.Size = UDim2.new(1, 0, 1, 0)
EspPage.BackgroundTransparency = 1
EspPage.Visible = false
EspPage.Parent = ContentFrame

-- Função para trocar de aba
local function SwitchTab(tabName)
    MainPage.Visible = (tabName == "Main")
    GamerPage.Visible = (tabName == "Gamer")
    VipPage.Visible = (tabName == "VIP")
    EspPage.Visible = (tabName == "ESP")
    
    MainTab.BackgroundColor3 = (tabName == "Main") and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(50, 50, 60)
    GamerTab.BackgroundColor3 = (tabName == "Gamer") and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(50, 50, 60)
    VipTab.BackgroundColor3 = (tabName == "VIP") and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(50, 50, 60)
    EspTab.BackgroundColor3 = (tabName == "ESP") and Color3.fromRGB(80, 80, 100) or Color3.fromRGB(50, 50, 60)
end

MainTab.MouseButton1Click:Connect(function() SwitchTab("Main") end)
GamerTab.MouseButton1Click:Connect(function() SwitchTab("Gamer") end)
VipTab.MouseButton1Click:Connect(function() SwitchTab("VIP") end)
EspTab.MouseButton1Click:Connect(function() SwitchTab("ESP") end)

-- ========== FUNÇÕES ==========

-- Função Noclip
local function Noclip(enabled)
    noclipEnabled = enabled
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- UI de controle do Fly
local FlyControlFrame = Instance.new("Frame")
FlyControlFrame.Name = "FlyControl"
FlyControlFrame.Size = UDim2.new(0, 200, 0, 100)
FlyControlFrame.Position = UDim2.new(0.5, -100, 0, 60)
FlyControlFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
FlyControlFrame.BorderSizePixel = 0
FlyControlFrame.Visible = false
FlyControlFrame.Parent = ScreenGui

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 8)
FlyCorner.Parent = FlyControlFrame

local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Size = UDim2.new(1, 0, 0, 30)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Velocidade: 50"
FlySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedLabel.TextSize = 16
FlySpeedLabel.Font = Enum.Font.GothamBold
FlySpeedLabel.Parent = FlyControlFrame

local DecreaseSpeed = Instance.new("TextButton")
DecreaseSpeed.Size = UDim2.new(0, 80, 0, 40)
DecreaseSpeed.Position = UDim2.new(0, 10, 0, 50)
DecreaseSpeed.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
DecreaseSpeed.Text = "- Diminuir"
DecreaseSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseSpeed.TextSize = 14
DecreaseSpeed.Font = Enum.Font.GothamBold
DecreaseSpeed.BorderSizePixel = 0
DecreaseSpeed.Parent = FlyControlFrame

local DecCorner = Instance.new("UICorner")
DecCorner.CornerRadius = UDim.new(0, 6)
DecCorner.Parent = DecreaseSpeed

local IncreaseSpeed = Instance.new("TextButton")
IncreaseSpeed.Size = UDim2.new(0, 80, 0, 40)
IncreaseSpeed.Position = UDim2.new(1, -90, 0, 50)
IncreaseSpeed.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
IncreaseSpeed.Text = "+ Aumentar"
IncreaseSpeed.TextColor3 = Color3.fromRGB(0, 0, 0)
IncreaseSpeed.TextSize = 14
IncreaseSpeed.Font = Enum.Font.GothamBold
IncreaseSpeed.BorderSizePixel = 0
IncreaseSpeed.Parent = FlyControlFrame

local IncCorner = Instance.new("UICorner")
IncCorner.CornerRadius = UDim.new(0, 6)
IncCorner.Parent = IncreaseSpeed

DecreaseSpeed.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    FlySpeedLabel.Text = "Velocidade: " .. flySpeed
end)

IncreaseSpeed.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    FlySpeedLabel.Text = "Velocidade: " .. flySpeed
end)

-- Função Fly Branzz
local function FlyBranzz(enabled)
    flyEnabled = enabled
    FlyControlFrame.Visible = enabled
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if enabled then
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = character.HumanoidRootPart
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.P = 10000
        bodyGyro.Parent = hrp
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                FlyBranzz(false)
                return
            end
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - (camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + (camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            bodyVelocity.Velocity = moveDirection * flySpeed
            bodyGyro.CFrame = camera.CFrame
        end)
    else
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(character.HumanoidRootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                    obj:Destroy()
                end
            end
        end
    end
end

-- Função VIP Bypass
local function VipBypass(enabled)
    vipBypassEnabled = enabled
    
    if vipBypassConnection then
        vipBypassConnection:Disconnect()
        vipBypassConnection = nil
    end
    
    if enabled then
        local function processVipWalls()
            local defaultMap = workspace:FindFirstChild("DefaultMap_SharedInstances")
            
            if defaultMap then
                local vipWalls = defaultMap:FindFirstChild("VIPWalls")
                
                if vipWalls then
                    for _, obj in pairs(vipWalls:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:match("VIP") or obj.Name:match("VIP_ULTRA")) then
                            obj.CanCollide = false
                            obj.Transparency = 0.8
                        end
                    end
                end
            end
        end
        
        processVipWalls()
        
        vipBypassConnection = RunService.Heartbeat:Connect(function()
            processVipWalls()
        end)
    else
        local defaultMap = workspace:FindFirstChild("DefaultMap_SharedInstances")
        
        if defaultMap then
            local vipWalls = defaultMap:FindFirstChild("VIPWalls")
            
            if vipWalls then
                for _, obj in pairs(vipWalls:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CanCollide = true
                        obj.Transparency = 0
                    end
                end
            end
        end
    end
end

-- Função Wall Bypass
local wallOriginalProperties = {}

local function WallBypass(enabled)
    wallBypassEnabled = enabled
    
    if wallBypassConnection then
        wallBypassConnection:Disconnect()
        wallBypassConnection = nil
    end
    
    if enabled then
        local function processWalls()
            -- Processar pasta Walls
            local walls = workspace:FindFirstChild("Walls")
            if walls then
                local wall10 = walls:FindFirstChild("10")
                if wall10 then
                    if wall10:IsA("Model") then
                        for _, part in pairs(wall10:GetDescendants()) do
                            if part:IsA("BasePart") then
                                if not wallOriginalProperties[part] then
                                    wallOriginalProperties[part] = {
                                        Transparency = part.Transparency,
                                        CanCollide = part.CanCollide
                                    }
                                end
                                part.Transparency = 1
                                part.CanCollide = false
                            end
                        end
                    elseif wall10:IsA("BasePart") then
                        if not wallOriginalProperties[wall10] then
                            wallOriginalProperties[wall10] = {
                                Transparency = wall10.Transparency,
                                CanCollide = wall10.CanCollide
                            }
                        end
                        wall10.Transparency = 1
                        wall10.CanCollide = false
                    end
                end
            end
            
            -- Processar pasta RightWalls
            local rightWalls = workspace:FindFirstChild("RightWalls")
            if rightWalls then
                for _, obj in pairs(rightWalls:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        if not wallOriginalProperties[obj] then
                            wallOriginalProperties[obj] = {
                                Transparency = obj.Transparency,
                                CanCollide = obj.CanCollide,
                                Size = obj.Size,
                                CFrame = obj.CFrame
                            }
                        end
                        obj.Transparency = 1
                        obj.CanCollide = false
                        
                        -- Esticar parte Bottom
                        if obj.Name == "Bottom" then
                            local originalSize = wallOriginalProperties[obj].Size
                            obj.Size = Vector3.new(originalSize.X * 3, originalSize.Y, originalSize.Z * 3)
                        end
                    end
                end
            end
        end
        
        processWalls()
        
        wallBypassConnection = RunService.Heartbeat:Connect(function()
            processWalls()
        end)
    else
        -- Restaurar propriedades originais
        for part, props in pairs(wallOriginalProperties) do
            if part and part.Parent then
                part.Transparency = props.Transparency
                part.CanCollide = props.CanCollide
                if props.Size then
                    part.Size = props.Size
                end
                if props.CFrame then
                    part.CFrame = props.CFrame
                end
            end
        end
        wallOriginalProperties = {}
    end
end

-- Função Bring Console
local function BringConsole(enabled)
    bringConsoleEnabled = enabled
    
    if bringConsoleConnection then
        bringConsoleConnection:Disconnect()
        bringConsoleConnection = nil
    end
    
    if enabled then
        bringConsoleConnection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = character.HumanoidRootPart
            local consoleFolder = workspace:FindFirstChild("ArcadeEventConsoles")
            
            if consoleFolder then
                for _, model in pairs(consoleFolder:GetChildren()) do
                    if model:IsA("Model") and model.Name == "Game Console" then
                        if model.PrimaryPart then
                            model:SetPrimaryPartCFrame(hrp.CFrame + Vector3.new(0, 3, 0))
                        elseif model:FindFirstChildWhichIsA("BasePart") then
                            local part = model:FindFirstChildWhichIsA("BasePart")
                            part.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end
        end)
    end
end

-- Função Bring Tickets
local function BringTickets(enabled)
    bringTicketsEnabled = enabled
    
    if bringTicketsConnection then
        bringTicketsConnection:Disconnect()
        bringTicketsConnection = nil
    end
    
    if enabled then
        bringTicketsConnection = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = character.HumanoidRootPart
            local ticketFolder = workspace:FindFirstChild("ArcadeEventTickets")
            
            if ticketFolder then
                for _, model in pairs(ticketFolder:GetChildren()) do
                    if model:IsA("Model") then
                        if model.PrimaryPart then
                            model:SetPrimaryPartCFrame(hrp.CFrame + Vector3.new(0, 3, 0))
                        elseif model:FindFirstChildWhichIsA("BasePart") then
                            local part = model:FindFirstChildWhichIsA("BasePart")
                            part.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end
        end)
    end
end

-- Função ESP otimizado com distância
local function CreateDistanceBasedESP(object, color, name, espTable)
    if not object or not object:IsA("BasePart") and not object:IsA("Model") then return end
    
    local targetPart = object:IsA("Model") and (object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")) or object
    if not targetPart then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = name .. "ESP"
    billboard.Adornee = targetPart
    billboard.AlwaysOnTop = true
    billboard.Parent = targetPart
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.6
    frame.BorderSizePixel = 3
    frame.BorderColor3 = color
    frame.Parent = billboard
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, -0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Parent = billboard
    
    table.insert(espTable, billboard)
    
    -- Atualizar tamanho baseado na distância
    spawn(function()
        while billboard and billboard.Parent do
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                local size = math.clamp(500 / distance, 50, 300)
                billboard.Size = UDim2.new(0, size, 0, size)
                label.TextSize = math.clamp(size / 10, 12, 24)
            end
            wait(0.1)
        end
    end)
    
    return billboard
end

-- Função ESP Console
local function EspConsole(enabled)
    espConsoleEnabled = enabled
    
    if espConsoleConnection then
        espConsoleConnection:Disconnect()
        espConsoleConnection = nil
    end
    
    -- Limpar ESPs anteriores
    for _, esp in pairs(consoleEspObjects) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    consoleEspObjects = {}
    
    if enabled then
        local function updateConsoleESP()
            local consoleFolder = workspace:FindFirstChild("ArcadeEventConsoles")
            
            if consoleFolder then
                local consoles = {}
                for _, model in pairs(consoleFolder:GetChildren()) do
                    if model:IsA("Model") and model.Name == "Game Console" then
                        table.insert(consoles, model)
                    end
                end
                
                -- Mostrar apenas os 3 primeiros
                for i = 1, math.min(3, #consoles) do
                    local alreadyHasESP = false
                    for _, esp in pairs(consoleEspObjects) do
                        if esp and esp.Adornee and esp.Adornee:IsDescendantOf(consoles[i]) then
                            alreadyHasESP = true
                            break
                        end
                    end
                    
                    if not alreadyHasESP then
                        CreateDistanceBasedESP(consoles[i], Color3.fromRGB(255, 150, 0), "Console", consoleEspObjects)
                    end
                end
            end
        end
        
        updateConsoleESP()
        
        espConsoleConnection = RunService.Heartbeat:Connect(function()
            -- Verificar se algum console sumiu e atualizar
            local needsUpdate = false
            for i = #consoleEspObjects, 1, -1 do
                if not consoleEspObjects[i] or not consoleEspObjects[i].Parent or not consoleEspObjects[i].Adornee then
                    table.remove(consoleEspObjects, i)
                    needsUpdate = true
                end
            end
            
            if needsUpdate or #consoleEspObjects < 3 then
                for _, esp in pairs(consoleEspObjects) do
                    if esp and esp.Parent then
                        esp:Destroy()
                    end
                end
                consoleEspObjects = {}
                updateConsoleESP()
            end
        end)
    end
end

-- Função ESP Ticket
local function EspTicket(enabled)
    espTicketEnabled = enabled
    
    if espTicketConnection then
        espTicketConnection:Disconnect()
        espTicketConnection = nil
    end
    
    -- Limpar ESPs anteriores
    for _, esp in pairs(ticketEspObjects) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    ticketEspObjects = {}
    
    if enabled then
        local function updateTicketESP()
            local ticketFolder = workspace:FindFirstChild("ArcadeEventTickets")
            
            if ticketFolder then
                local tickets = {}
                for _, model in pairs(ticketFolder:GetChildren()) do
                    if model:IsA("Model") then
                        table.insert(tickets, model)
                    end
                end
                
                -- Mostrar apenas os 3 primeiros
                for i = 1, math.min(3, #tickets) do
                    local alreadyHasESP = false
                    for _, esp in pairs(ticketEspObjects) do
                        if esp and esp.Adornee and esp.Adornee:IsDescendantOf(tickets[i]) then
                            alreadyHasESP = true
                            break
                        end
                    end
                    
                    if not alreadyHasESP then
                        CreateDistanceBasedESP(tickets[i], Color3.fromRGB(255, 215, 0), "Ticket", ticketEspObjects)
                    end
                end
            end
        end
        
        updateTicketESP()
        
        espTicketConnection = RunService.Heartbeat:Connect(function()
            -- Verificar se algum ticket sumiu e atualizar
            local needsUpdate = false
            for i = #ticketEspObjects, 1, -1 do
                if not ticketEspObjects[i] or not ticketEspObjects[i].Parent or not ticketEspObjects[i].Adornee then
                    table.remove(ticketEspObjects, i)
                    needsUpdate = true
                end
            end
            
            if needsUpdate or #ticketEspObjects < 3 then
                for _, esp in pairs(ticketEspObjects) do
                    if esp and esp.Parent then
                        esp:Destroy()
                    end
                end
                ticketEspObjects = {}
                updateTicketESP()
            end
        end)
    end
end

-- Função ESP Player Melhorado
local function EspPlayer(enabled)
    espPlayerEnabled = enabled
    
    if espPlayerConnection then
        espPlayerConnection:Disconnect()
        espPlayerConnection = nil
    end
    
    -- Limpar ESPs anteriores
    for _, esp in pairs(espObjects) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    espObjects = {}
    
    if enabled then
        local updateTick = 0
        
        local function createPlayerESP(player)
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = character.HumanoidRootPart
            local isLocalPlayer = (player == LocalPlayer)
            
            -- ESP Box melhorada com BoxHandleAdornment
            local espBox = Instance.new("BoxHandleAdornment")
            espBox.Name = "PlayerESP"
            espBox.Adornee = hrp
            espBox.Size = Vector3.new(4, 5.5, 1.5)
            espBox.Color3 = isLocalPlayer and Color3.fromRGB(160, 32, 240) or Color3.fromRGB(0, 255, 0)
            espBox.Transparency = 0.5
            espBox.AlwaysOnTop = true
            espBox.ZIndex = 5
            espBox.Parent = hrp
            
            table.insert(espObjects, espBox)
            
            -- Nome do jogador
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "PlayerESP_Name"
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 150, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 3.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = hrp
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 18
            nameLabel.TextStrokeTransparency = 0.3
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.Parent = billboard
            
            table.insert(espObjects, billboard)
            
            -- Linha melhorada para outros jogadores
            if not isLocalPlayer then
                local attach0 = Instance.new("Attachment")
                attach0.Name = "PlayerESP_Attach0"
                attach0.Parent = LocalPlayer.Character.HumanoidRootPart
                
                local attach1 = Instance.new("Attachment")
                attach1.Name = "PlayerESP_Attach1"
                attach1.Parent = hrp
                
                local beam = Instance.new("Beam")
                beam.Name = "PlayerESP_Line"
                beam.Attachment0 = attach0
                beam.Attachment1 = attach1
                beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
                beam.Width0 = 0.5
                beam.Width1 = 0.5
                beam.FaceCamera = true
                beam.Transparency = NumberSequence.new(0.2)
                beam.LightEmission = 0.5
                beam.LightInfluence = 0
                beam.Parent = hrp
                
                table.insert(espObjects, beam)
                table.insert(espObjects, attach0)
                table.insert(espObjects, attach1)
                
                -- Distância
                local distBillboard = Instance.new("BillboardGui")
                distBillboard.Name = "PlayerESP_Distance"
                distBillboard.Adornee = hrp
                distBillboard.Size = UDim2.new(0, 100, 0, 30)
                distBillboard.StudsOffset = Vector3.new(0, -3, 0)
                distBillboard.AlwaysOnTop = true
                distBillboard.Parent = hrp
                
                local distLabel = Instance.new("TextLabel")
                distLabel.Size = UDim2.new(1, 0, 1, 0)
                distLabel.BackgroundTransparency = 1
                distLabel.Text = "0m"
                distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                distLabel.Font = Enum.Font.Gotham
                distLabel.TextSize = 14
                distLabel.TextStrokeTransparency = 0.5
                distLabel.Parent = distBillboard
                
                table.insert(espObjects, distBillboard)
            end
        end
        
        espPlayerConnection = RunService.Heartbeat:Connect(function()
            updateTick = updateTick + 1
            
            -- Atualizar distâncias a cada 10 frames (otimização)
            if updateTick % 10 == 0 then
                for _, esp in pairs(espObjects) do
                    if esp and esp.Name == "PlayerESP_Distance" and esp.Parent then
                        local distLabel = esp:FindFirstChildOfClass("TextLabel")
                        if distLabel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - esp.Adornee.Position).Magnitude
                            distLabel.Text = math.floor(distance) .. "m"
                        end
                    end
                end
            end
            
            -- Verificar e criar ESPs novos a cada 30 frames
            if updateTick % 30 == 0 then
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hasESP = false
                        for _, esp in pairs(espObjects) do
                            if esp and esp.Adornee == player.Character.HumanoidRootPart then
                                hasESP = true
                                break
                            end
                        end
                        
                        if not hasESP then
                            createPlayerESP(player)
                        end
                    end
                end
            end
        end)
        
        -- ESP inicial
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                createPlayerESP(player)
            end
        end
    end
end

-- ========== CRIAR CONTEÚDO DAS PÁGINAS ==========

-- Main Page
CreateSectionTitle("Comend in money event", 10, MainPage)
CreateCheckbox("Noclip", 50, MainPage, Noclip)
CreateCheckbox("Fly Branzz", 110, MainPage, FlyBranzz)

-- Gamer Event Page
CreateCheckbox("Bring Console", 10, GamerPage, BringConsole)
CreateCheckbox("Bring Tickets", 70, GamerPage, BringTickets)
CreateCheckbox("ESP Console", 130, GamerPage, EspConsole)
CreateCheckbox("ESP Ticket", 190, GamerPage, EspTicket)

-- VIP Page
CreateCheckbox("VIP Bypass", 10, VipPage, VipBypass)
CreateCheckbox("Wall Bypass", 70, VipPage, WallBypass)

-- ESP Page
CreateCheckbox("ESP Players", 10, EspPage, EspPlayer)

-- ========== SISTEMA DE ARRASTAR ==========

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

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

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- ========== BOTÕES DE CONTROLE ==========

-- Minimizar
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MaximizeButton.Visible = true
end)

-- Maximizar
MaximizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MaximizeButton.Visible = false
end)

-- Fechar
CloseButton.MouseButton1Click:Connect(function()
    -- Desativar todas as funções
    Noclip(false)
    FlyBranzz(false)
    BringConsole(false)
    BringTickets(false)
    EspConsole(false)
    EspTicket(false)
    EspPlayer(false)
    VipBypass(false)
    WallBypass(false)
    
    -- Destruir UI
    ScreenGui:Destroy()
end)

-- Mensagem de carregamento
print("BranzzHub v1.0 Modified carregado com sucesso!")
print("Funcionalidades:")
print("- Noclip")
print("- Fly Branzz com controles de velocidade")
print("- Gamer Event: Bring Console, Bring Tickets, ESP Console, ESP Ticket")
print("- VIP Bypass")
print("- ESP Players melhorado")
