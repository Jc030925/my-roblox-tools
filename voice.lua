-- [[ ADVANCED CHARACTER SPOOF + TRAIN SNIPER ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote path base sa Dex mo
local remotePath = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("TrainSystem")
local clickRemote = remotePath:WaitForChild("ReqClickTrain")
local speedRemote = remotePath:WaitForChild("ReqUpdateTrainSpeed")

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 110)
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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

local godBtn = createBtn("GOD MODE: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(120, 0, 0))
local trainBtn = createBtn("ULTRA TRAIN: OFF", UDim2.new(0, 5, 0, 55), Color3.fromRGB(0, 80, 150))

-- === GOD MODE (PERMANENT DEATH BYPASS) ===
local godEnabled = false
godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = godEnabled and "GOD MODE: ON" or "GOD MODE: OFF"
    godBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    
    if godEnabled then
        -- Tanggalin ang "Death" connection
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            char.Humanoid.Name = "SpoofedHumanoid" -- Palitan ang pangalan para hindi mahanap ng 1-hit scripts
        end
        
        task.spawn(function()
            while godEnabled do
                pcall(function()
                    LP.Character.SpoofedHumanoid.Health = LP.Character.SpoofedHumanoid.MaxHealth
                end)
                task.wait()
            end
        end)
    end
end)

-- === ULTRA TRAIN (ALL REMOTES SPAM) ===
local training = false
trainBtn.MouseButton1Click:Connect(function()
    training = not training
    trainBtn.Text = training and "ULTRA TRAIN: ON" or "ULTRA TRAIN: OFF"
    trainBtn.BackgroundColor3 = training and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(0, 80, 150)
    
    task.spawn(function()
        while training do
            -- Sabay na if-fire ang Click at Speed para pilitin ang server na mag-update
            pcall(function()
                clickRemote:FireServer()
                speedRemote:FireServer()
            end)
            task.wait(0.05) -- Mas safe na interval para hindi maki-kick
        end
    end)
end)
