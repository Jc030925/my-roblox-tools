local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlinkClient = require(ReplicatedStorage:WaitForChild("Blink").Client)
local lp = game.Players.LocalPlayer

-- Configurations
local targetRods = {"AngelRod", "SakuraRod", "LightningRod"}
local targetWings = {"LightningWings", "SakuraWings", "QueenFloraWings"}
local targetSwords = {"SakuraKatana", "NexusAlphaSword", "NexusDivaSword"}
local targetPickaxes = {"AngelPickaxe", "SakuraPickaxe"} -- Dagdag targets para sa Pickaxe

_G.AutoGacha = false

-- UI Setup (In-adjust ang height para sa bagong button)
local sg = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 360) -- Mula 310, ginawang 360
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "GACHA HELPER V4"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Function para sa Button creation
local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    return btn
end

-- Buttons Setup
local rodBtn = createBtn("AUTO ROD GACHA", UDim2.new(0, 10, 0, 40), Color3.fromRGB(0, 100, 200))
local wingBtn = createBtn("AUTO WINGS GACHA", UDim2.new(0, 10, 0, 80), Color3.fromRGB(100, 0, 150))
local swordBtn = createBtn("AUTO SWORD GACHA", UDim2.new(0, 10, 0, 120), Color3.fromRGB(180, 50, 0))
local pickBtn = createBtn("AUTO PICKAXE GACHA", UDim2.new(0, 10, 0, 160), Color3.fromRGB(0, 150, 100)) -- Bagong Button
local moneyBtn = createBtn("ADD 5,000,000 COINS", UDim2.new(0, 10, 0, 210), Color3.fromRGB(218, 165, 32))
local stopBtn = createBtn("STOP ALL GACHA", UDim2.new(0, 10, 0, 255), Color3.fromRGB(150, 0, 0))
local stealthBtn = createBtn("STEALTH: OFF", UDim2.new(0, 10, 0, 300), Color3.fromRGB(60, 60, 60))

-- Stealth Logic (Anti-Log)
local isStealth = false
stealthBtn.MouseButton1Click:Connect(function()
    isStealth = not isStealth
    stealthBtn.Text = isStealth and "STEALTH: ON" or "STEALTH: OFF"
    stealthBtn.BackgroundColor3 = isStealth and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- Unified Gacha Function
local function startGacha(mode, targetList)
    if _G.AutoGacha then return end
    _G.AutoGacha = true
    
    task.spawn(function()
        while _G.AutoGacha do
            local success, result = pcall(function()
                return BlinkClient.GachaFunc.Invoke(mode) -- Gagamitin ang "Pickaxe" mode
            end)

            if success and result then
                print(mode .. " Rolled: " .. tostring(result))
                for _, target in pairs(targetList) do
                    if tostring(result):find(target) then 
                        print("JACKPOT: " .. target)
                        _G.AutoGacha = false 
                        break 
                    end
                end
            end
            
            if isStealth then
                task.wait(0.7 + math.random() * 0.5)
            else
                task.wait(0)
            end
        end
    end)
end

-- Money Logic
local function addMoney()
    local COIN_AMOUNT = 5000000
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                obj:FireServer(COIN_AMOUNT)
                obj:FireServer("Coins", COIN_AMOUNT)
                obj:FireServer("Add", COIN_AMOUNT)
            end)
        end
    end
end

-- Connections
rodBtn.MouseButton1Click:Connect(function() startGacha("Rod", targetRods) end)
wingBtn.MouseButton1Click:Connect(function() startGacha("Wings", targetWings) end)
swordBtn.MouseButton1Click:Connect(function() startGacha("Sword", targetSwords) end)
pickBtn.MouseButton1Click:Connect(function() startGacha("Pickaxe", targetPickaxes) end) -- Connection para sa Pickaxe
moneyBtn.MouseButton1Click:Connect(addMoney)
stopBtn.MouseButton1Click:Connect(function() _G.AutoGacha = false end)
