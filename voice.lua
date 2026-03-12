-- [[ GOD MODE + TRAIN SNIPER ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hanapin ang Remote sa loob ng folder structure na nakita mo sa Dex
local trainRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("TrainSystem"):WaitForChild("ReqClickTrain")

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 110)
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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

local godBtn = createBtn("God Mode: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(150, 0, 0))
local trainBtn = createBtn("ULTRA TRAIN: OFF", UDim2.new(0, 5, 0, 55), Color3.fromRGB(0, 0, 150))

-- === GOD MODE LOGIC ===
local godEnabled = false
godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = godEnabled and "God Mode: ON" or "God Mode: OFF"
    godBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    task.spawn(function()
        while godEnabled do
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
            end
            task.wait(0.1)
        end
    end)
end)

-- === ULTRA TRAIN LOGIC ===
local training = false
trainBtn.MouseButton1Click:Connect(function()
    training = not training
    trainBtn.Text = training and "ULTRA TRAIN: ON" or "ULTRA TRAIN: OFF"
    trainBtn.BackgroundColor3 = training and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 0, 150)
    
    task.spawn(function()
        while training do
            -- Dito natin "i-i-inject" yung stats direkta sa server
            trainRemote:FireServer()
            task.wait(0.01) -- Sobrang bilis na spam
        end
    end)
end)
