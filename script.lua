--[[
    ================================================================
    [ SCRIPT INFORMATION ]
    Project: Custom Script
    Author: OYB
    YouTube: https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ
    
    [ TERMS AND CONDITIONS ]
    - You ARE allowed to use and modify this script for your own games.
    - You ARE NOT allowed to re-upload, redistribute, or claim 
      ownership of this script.
    - Removing or altering these credits is strictly prohibited.
    
    Copyright (c) 2026 OYB. All rights reserved.
    ================================================================
]]

-- ⚠️ IMPORTANT: Put this code at the VERY TOP of your Main Script (before obfuscating) ⚠️

local ProtectionConfig = {
    -- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
    -- If your Key System has: Secret = "Test"
    -- Then this must also be: SecretKey = "Test"
    SecretKey = "1972",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "ROBLIUX 2.0"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!")

-- ROBLIUX 2.0 Hub Script (Con Movimiento Unificado)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Evitar duplicados
if PlayerGui:FindFirstChild("RobliuxHub") then
    PlayerGui.RobliuxHub:Destroy()
end

-- Variables Globales de Estado
local noclipEnabled = false
local espEnabled = false
local espV2Enabled = false
local savedLocation = nil
local infJumpEnabled = false
local connections = {}

-- [[ CREACIÓN DE LA INTERFAZ ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobliuxHub"
ScreenGui.Parent = PlayerGui

-- Posición inicial predeterminada
local defaultPosition = UDim2.new(0.5, -250, 0.5, -175)

-- Marco Principal (Todo el Hub)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = defaultPosition
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 15, 60)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Barra Superior (De donde se agarra para mover)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(75, 20, 100)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ROBLIUX 2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Botones de Control (X y Cuadrado)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 130)
MinimizeBtn.Text = "⬜"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

-- Marco de Confirmación de Cierre
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmFrame.BackgroundTransparency = 0.2
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 10
ConfirmFrame.Parent = MainFrame

local ConfirmBox = Instance.new("Frame")
ConfirmBox.Size = UDim2.new(0, 300, 0, 150)
ConfirmBox.Position = UDim2.new(0.5, -150, 0.5, -75)
ConfirmBox.BackgroundColor3 = Color3.fromRGB(60, 20, 80)
ConfirmBox.ZIndex = 11
ConfirmBox.Parent = ConfirmFrame

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0, 80)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "¿Quieres cerrar este hub permanentemente?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.TextWrapped = true
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextSize = 16
ConfirmText.ZIndex = 12
ConfirmText.Parent = ConfirmBox

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 100, 0, 40)
YesBtn.Position = UDim2.new(0, 30, 1, -60)
YesBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
YesBtn.Text = "Sí"
YesBtn.TextColor3 = Color3.fromRGB(255,255,255)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 12
YesBtn.Parent = ConfirmBox

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 100, 0, 40)
NoBtn.Position = UDim2.new(1, -130, 1, -60)
NoBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 130)
NoBtn.Text = "No"
NoBtn.TextColor3 = Color3.fromRGB(255,255,255)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 12
NoBtn.Parent = ConfirmBox

-- Icono Minimizado
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0, 20, 0, 20)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(75, 20, 100)
MinimizedIcon.Text = "R 2.0"
MinimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedIcon.Font = Enum.Font.GothamBold
MinimizedIcon.Visible = false
MinimizedIcon.Parent = ScreenGui

-- Fases (Pestañas)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 40)
TabsFrame.BackgroundColor3 = Color3.fromRGB(60, 15, 80)
TabsFrame.Parent = MainFrame

local function createTab(name, posConfig)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.33, 0, 1, 0)
    tab.Position = posConfig
    tab.BackgroundColor3 = Color3.fromRGB(75, 20, 100)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.Font = Enum.Font.GothamBold
    tab.Parent = TabsFrame
    return tab
end

local Tab1 = createTab("Fase 1: Player", UDim2.new(0, 0, 0, 0))
local Tab2 = createTab("Fase 2: X-RAY", UDim2.new(0.33, 0, 0, 0))
local Tab3 = createTab("Fase 3: TP", UDim2.new(0.66, 0, 0, 0))

-- Contenedores de Fases
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -70)
ContentFrame.Position = UDim2.new(0, 0, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Phase1 = Instance.new("Frame", ContentFrame)
local Phase2 = Instance.new("Frame", ContentFrame)
local Phase3 = Instance.new("Frame", ContentFrame)

for _, phase in ipairs({Phase1, Phase2, Phase3}) do
    phase.Size = UDim2.new(1, 0, 1, 0)
    phase.BackgroundTransparency = 1
    phase.Visible = false
end
Phase1.Visible = true

-- Lógica de Pestañas
Tab1.MouseButton1Click:Connect(function() Phase1.Visible = true; Phase2.Visible = false; Phase3.Visible = false end)
Tab2.MouseButton1Click:Connect(function() Phase1.Visible = false; Phase2.Visible = true; Phase3.Visible = false end)
Tab3.MouseButton1Click:Connect(function() Phase1.Visible = false; Phase2.Visible = false; Phase3.Visible = true end)

-- Sistema Draggable (Movimiento del Hub en una sola pieza)
local function makeDraggable(dragElement, moveElement)
    local dragging, dragInput, dragStart, startPos
    
    dragElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveElement.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                end
            end)
        end
    end)
    
    dragElement.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            moveElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(TopBar, MainFrame)
makeDraggable(MinimizedIcon, MinimizedIcon)

-- [[ FUNCIONES DE LOS BOTONES SUPERIORES ]]
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedIcon.Visible = true
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    MainFrame.Position = defaultPosition
    MainFrame.Visible = true
    MinimizedIcon.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)

NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

YesBtn.MouseButton1Click:Connect(function()
    for _, conn in ipairs(connections) do conn:Disconnect() end
    ScreenGui:Destroy()
end)

-- [[ UTILIDAD PARA CREAR ELEMENTOS ]]
local function createUIElement(type, text, parent, position)
    local el = Instance.new(type)
    el.Size = UDim2.new(0, 200, 0, 35)
    el.Position = position
    el.BackgroundColor3 = Color3.fromRGB(100, 30, 130)
    el.TextColor3 = Color3.fromRGB(255,255,255)
    el.Font = Enum.Font.Gotham
    el.Text = text
    el.Parent = parent
    return el
end

-- ==============================================
-- FASE 1: PLAYER
-- ==============================================
local WalkSpeedBox = createUIElement("TextBox", "Velocidad: 16", Phase1, UDim2.new(0, 20, 0, 20))
WalkSpeedBox.ClearTextOnFocus = false
local JumpPowerBox = createUIElement("TextBox", "Altura de salto: 50", Phase1, UDim2.new(0, 20, 0, 70))
JumpPowerBox.ClearTextOnFocus = false
local InfJumpBtn = createUIElement("TextButton", "Infinito Jump: OFF", Phase1, UDim2.new(0, 20, 0, 120))
local NoclipBtn = createUIElement("TextButton", "Noclip: OFF", Phase1, UDim2.new(0, 20, 0, 170))

WalkSpeedBox.FocusLost:Connect(function()
    local num = tonumber(WalkSpeedBox.Text)
    if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = num
        WalkSpeedBox.Text = "Velocidad: " .. num
    end
end)

JumpPowerBox.FocusLost:Connect(function()
    local num = tonumber(JumpPowerBox.Text)
    if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = num
        JumpPowerBox.Text = "Altura de salto: " .. num
    end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    InfJumpBtn.Text = "Infinito Jump: " .. (infJumpEnabled and "ON" or "OFF")
end)

table.insert(connections, UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        local block = Instance.new("Part")
        block.Size = Vector3.new(5, 1, 5)
        block.CFrame = hrp.CFrame * CFrame.new(0, -3.5, 0)
        block.Anchored = true
        block.Transparency = 1
        block.Parent = workspace
        Debris:AddItem(block, 0.1)
    end
end))

NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipBtn.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
end)

table.insert(connections, RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end))

-- ==============================================
-- FASE 2: X-RAY
-- ==============================================
local EspBtn = createUIElement("TextButton", "ESP: OFF", Phase2, UDim2.new(0, 20, 0, 20))
local EspV2Btn = createUIElement("TextButton", "ESP V2 (Líneas): OFF", Phase2, UDim2.new(0, 20, 0, 70))

local function clearESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("Hub_ESP")
            if hl then hl:Destroy() end
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local a0 = root:FindFirstChild("Hub_Att")
                if a0 then a0:Destroy() end
            end
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local a1 = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Hub_LocalAtt")
        if a1 then a1:Destroy() end
    end
end

local function updateESP()
    if not espEnabled and not espV2Enabled then clearESP() return end
    
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local localAtt = nil
    
    if espV2Enabled and localRoot then
        localAtt = localRoot:FindFirstChild("Hub_LocalAtt") or Instance.new("Attachment", localRoot)
        localAtt.Name = "Hub_LocalAtt"
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hl = p.Character:FindFirstChild("Hub_ESP")
            if not hl then
                hl = Instance.new("Highlight", p.Character)
                hl.Name = "Hub_ESP"
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
            
            local targetRoot = p.Character.HumanoidRootPart
            local targetAtt = targetRoot:FindFirstChild("Hub_Att")
            
            if espV2Enabled and localAtt then
                if not targetAtt then
                    targetAtt = Instance.new("Attachment", targetRoot)
                    targetAtt.Name = "Hub_Att"
                    local beam = Instance.new("Beam", targetRoot)
                    beam.Name = "Hub_Beam"
                    beam.Attachment0 = localAtt
                    beam.Attachment1 = targetAtt
                    beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                    beam.FaceCamera = true
                    beam.Width0 = 0.1
                    beam.Width1 = 0.1
                end
            else
                if targetAtt then targetAtt:Destroy() end
                local beam = targetRoot:FindFirstChild("Hub_Beam")
                if beam then beam:Destroy() end
            end
        end
    end
end

EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then espV2Enabled = false; EspV2Btn.Text = "ESP V2 (Líneas): OFF" end
    EspBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)

EspV2Btn.MouseButton1Click:Connect(function()
    espV2Enabled = not espV2Enabled
    if espV2Enabled then espEnabled = true; EspBtn.Text = "ESP: ON" end
    EspV2Btn.Text = "ESP V2 (Líneas): " .. (espV2Enabled and "ON" or "OFF")
end)

table.insert(connections, RunService.RenderStepped:Connect(updateESP))

-- ==============================================
-- FASE 3: TP
-- ==============================================
local SaveLocBtn = createUIElement("TextButton", "Guardar Ubicación", Phase3, UDim2.new(0, 20, 0, 20))
local GoLocBtn = createUIElement("TextButton", "Ir a ubicación", Phase3, UDim2.new(0, 20, 0, 70))
local ObTpBtn = createUIElement("TextButton", "Recibir OB TP (Herramienta)", Phase3, UDim2.new(0, 20, 0, 120))

SaveLocBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedLocation = LocalPlayer.Character.HumanoidRootPart.CFrame
        SaveLocBtn.Text = "Ubicación Guardada!"
        task.wait(1)
        SaveLocBtn.Text = "Guardar Ubicación"
    end
end)

GoLocBtn.MouseButton1Click:Connect(function()
    if savedLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:SetPrimaryPartCFrame(savedLocation)
    end
end)

ObTpBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "OB TP"
    tool.RequiresHandle = false
    
    local mouse = LocalPlayer:GetMouse()
    tool.Activated:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = mouse.Hit.Position
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPos + Vector3.new(0, 3, 0)))
        end
    end)
    
    tool.Parent = LocalPlayer.Backpack
    ObTpBtn.Text = "OB TP Entregado"
    task.wait(1)
    ObTpBtn.Text = "Recibir OB TP (Herramienta)"
end)

-- Iniciar validación de stats base
task.spawn(function()
    while task.wait(1) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and not WalkSpeedBox:IsFocused() then
            WalkSpeedBox.Text = "Velocidad: " .. LocalPlayer.Character.Humanoid.WalkSpeed
        end
    end
end)
