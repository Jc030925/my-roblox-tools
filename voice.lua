-- [[ GOD MODE + COOLDOWN BYPASS + TRAIN SNIPER ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- Remote path base sa Dex mo kanina
local trainRemote = RS:WaitForChild("Remote"):WaitForChild("TrainSystem"):WaitForChild("ReqClickTrain")

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Draggable = true
MainFrame.Active = true

local function createBtn(name, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(1, -10, 0, 45)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    return b
end

local godBtn = createBtn("GOD MODE: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(150, 0, 0))
local trainBtn = createBtn("NO COOLDOWN: OFF", UDim2.new(0, 5, 0, 55), Color3.fromRGB(0, 100, 200))

-- === GOD MODE LOGIC (Anti 1-Hit) ===
local godEnabled = false
godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = godEnabled and "GOD MODE: ON" or "GOD MODE: OFF"
    godBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    task.spawn(function()
        while godEnabled do
            pcall(function()
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    -- Pinipilit nating laging 506+ ang HP
                    LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
                    -- Bawal mamatay state
                    LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end)
            task.wait()
        end
    end)
end)

-- === COOLDOWN BYPASS LOGIC ===
local noCooldown = false
trainBtn.MouseButton1Click:Connect(function()
    noCooldown = not noCooldown
    trainBtn.Text = noCooldown and "NO COOLDOWN: ON" or "NO COOLDOWN: OFF"
    trainBtn.BackgroundColor3 = noCooldown and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 100, 200)
    
    -- Ito ang "Hook" na tatanggal sa wait ng TrainSystemClient
    local oldWait
    oldWait = hookfunction(getrenv().task.wait, function(n)
        if noCooldown and n and n > 0 then
            return oldWait(0) -- Gagawing zero seconds lahat ng cooldown
        end
        return oldWait(n)
    end)

    task.spawn(function()
        while noCooldown do
            pcall(function()
                trainRemote:FireServer()
            end)
            task.wait(0.001) -- Sobrang bilis na spam
        end
    end)
end)
