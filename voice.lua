-- [[ MVS DUELS: HARD LOCK + BOX ESP ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- UI SETUP
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 80)
MainFrame.Position = UDim2.new(0, 10, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    return b
end

local aimBtn = createBtn("LOCK-ON: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(100, 0, 0))
local espBtn = createBtn("ESP: OFF", UDim2.new(0, 5, 0, 40), Color3.fromRGB(100, 0, 0))

local aiming = false
local esping = false

aimBtn.MouseButton1Click:Connect(function()
    aiming = not aiming
    aimBtn.Text = aiming and "LOCK-ON: ON" or "LOCK-ON: OFF"
    aimBtn.BackgroundColor3 = aiming and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(100, 0, 0)
end)

espBtn.MouseButton1Click:Connect(function()
    esping = not esping
    espBtn.Text = esping and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = esping and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(100, 0, 0)
end)

-- GET TARGET
function getTarget()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
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

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    -- Aim Logic
    if aiming then
        local target = getTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- ESP Logic
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character then
            local highlight = v.Character:FindFirstChild("Highlight")
            if esping then
                if not highlight then
                    local hl = Instance.new("Highlight", v.Character)
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)
