-- [[ MVS DUELS: SMOOTH AIM + TEAM CHECK + FOV ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- === CONFIG ===
local Settings = {
    Aiming = false,
    ESP = false,
    TeamCheck = true,
    Smoothness = 0.15, -- Mas mababa, mas mabilis ang tutok (0.1 to 0.5)
    FOV = 200
}

-- === FOV CIRCLE ===
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Visible = true
FOVCircle.Radius = Settings.FOV

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Position = UDim2.new(0, 10, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    return b
end

local aimBtn = createBtn("SMOOTH AIM: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(100, 0, 0))
local espBtn = createBtn("ESP: OFF", UDim2.new(0, 5, 0, 50), Color3.fromRGB(100, 0, 0))

aimBtn.MouseButton1Click:Connect(function()
    Settings.Aiming = not Settings.Aiming
    aimBtn.Text = Settings.Aiming and "SMOOTH AIM: ON" or "SMOOTH AIM: OFF"
    aimBtn.BackgroundColor3 = Settings.Aiming and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(100, 0, 0)
end)

espBtn.MouseButton1Click:Connect(function()
    Settings.ESP = not Settings.ESP
    espBtn.Text = Settings.ESP and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = Settings.ESP and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(100, 0, 0)
end)

-- === FUNCTIONS ===
function getTarget()
    local closest = nil
    local dist = Settings.FOV

    for _, v in pairs(Players:GetPlayers()) do
        -- Team Check: Kung Sheriff ka, target ay Murderer (and vice versa)
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
            if Settings.TeamCheck and v.Team == LP.Team then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    closest = v.Character.Head
                    dist = mag
                end
            end
        end
    end
    return closest
end

-- === MAIN LOOP ===
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle Position
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    -- Aim Logic
    if Settings.Aiming and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Lock lang kapag naka-Right Click (Aim)
        local target = getTarget()
        if target then
            local targetPos = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetPos, Settings.Smoothness)
        end
    end

    -- ESP Logic
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character then
            local highlight = v.Character:FindFirstChild("Highlight")
            if Settings.ESP then
                if not highlight then
                    local hl = Instance.new("Highlight", v.Character)
                    hl.FillColor = (v.Team == LP.Team) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)
