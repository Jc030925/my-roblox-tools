local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlinkClient = require(ReplicatedStorage:WaitForChild("Blink").Client)
local lp = game.Players.LocalPlayer

-- Configuration 
local targetRods = {
    "NexusDivaRod", "NexusAlphaRod", "AngelRod", 
    "HoneyDipperRod", "SakuraRod", "RobuxRod", 
    "LightningRod", "GingerbreadSpatulaRod", "BamboopandaRod"
}
_G.AutoGacha = false

-- UI Setup
local sg = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "GACHA HELPER"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- PLAY BUTTON
local playBtn = Instance.new("TextButton", frame)
playBtn.Size = UDim2.new(0, 200, 0, 40)
playBtn.Position = UDim2.new(0, 10, 0, 40)
playBtn.Text = "START AUTO GACHA"
playBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
playBtn.TextColor3 = Color3.new(1, 1, 1)

-- STOP BUTTON
local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0, 200, 0, 40)
stopBtn.Position = UDim2.new(0, 10, 0, 85)
stopBtn.Text = "STOP AUTO GACHA"
stopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)

-- ADD MONEY BUTTON
local moneyBtn = Instance.new("TextButton", frame)
moneyBtn.Size = UDim2.new(0, 200, 0, 40)
moneyBtn.Position = UDim2.new(0, 10, 0, 130)
moneyBtn.Text = "ADD 5,000,000 COINS"
moneyBtn.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
moneyBtn.TextColor3 = Color3.new(1, 1, 1)

-- GACHA LOGIC
local function startGacha()
    if _G.AutoGacha then return end
    _G.AutoGacha = true
    playBtn.Text = "RUNNING..."
    
    task.spawn(function()
        while _G.AutoGacha do
            -- 1. Check Data Loaded & Inventory
            local myData = ReplicatedStorage:WaitForChild("PlayersData"):FindFirstChild(lp.Name)
            if myData then
                local rodsFolder = myData.FishingData.Rods
                for _, targetName in pairs(targetRods) do
                    local foundRod = rodsFolder:FindFirstChild(targetName)
                    if foundRod and foundRod.Value == true then
                        print("JACKPOT! Nakuha na ang: " .. targetName)
                        _G.AutoGacha = false
                        break
                    end
                end
            end

            if not _G.AutoGacha then break end

            -- 2. Blink Invoke
            local success, result = pcall(function()
                return BlinkClient.GachaFunc.Invoke("Rod")
            end)

            if success then
                print("Rolled: " .. tostring(result))
                -- Stop if result is a target
                for _, targetName in pairs(targetRods) do
                    if result == targetName then _G.AutoGacha = false break end
                end
            end
            task.wait(0.1)
        end
        playBtn.Text = "START AUTO GACHA"
    end)
end

-- MONEY LOGIC
local function addMoney()
    local COIN_AMOUNT = 5000000
    local rs = game:GetService("ReplicatedStorage")
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            obj:FireServer(COIN_AMOUNT)
            obj:FireServer("Coins", COIN_AMOUNT)
            obj:FireServer("Add", COIN_AMOUNT)
        end
    end
    print("Money Remotes Fired.")
end

-- BUTTON CONNECTIONS
playBtn.MouseButton1Click:Connect(startGacha)
stopBtn.MouseButton1Click:Connect(function()
    _G.AutoGacha = false
    print("Auto-Gacha Stopped.")
end)
moneyBtn.MouseButton1Click:Connect(addMoney)
