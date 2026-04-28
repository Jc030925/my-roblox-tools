local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local lp = game.Players.LocalPlayer

-- Siguraduhin nating mahanap ang GachaClient folder base sa Dex screenshot mo 
local GachaClient = ReplicatedStorage:WaitForChild("GachaClient", 10)
if not GachaClient then 
    warn("GachaClient folder not found in ReplicatedStorage!")
    return 
end

-- Targets
local targetRods = {"NexusDivaRod", "NexusAlphaRod", "AngelRod", "SakuraRod", "LightningRod"}
local targetWings = {"NexusAlphaWings", "NexusDivaWings", "LightningWings", "SakuraWings", "QueenFloraWings"}
local targetSwords = {"SakuraKatana", "NexusAlphaSword", "NexusDivaSword"}

_G.AutoGacha = false

-- UI SETUP
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "GachaMasterV8"
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 310)
frame.Position = UDim2.new(0.5, -120, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true; frame.Draggable = true

local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 220, 0, 35); btn.Position = pos
    btn.Text = name; btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    return btn
end

local rodBtn = createBtn("AUTO ROD GACHA", UDim2.new(0, 10, 0, 40), Color3.fromRGB(0, 100, 200))
local wingBtn = createBtn("AUTO WINGS GACHA", UDim2.new(0, 10, 0, 80), Color3.fromRGB(100, 0, 150))
local swordBtn = createBtn("AUTO SWORD GACHA", UDim2.new(0, 10, 0, 120), Color3.fromRGB(180, 50, 0))
local moneyBtn = createBtn("ADD COINS (STEALTH)", UDim2.new(0, 10, 0, 170), Color3.fromRGB(218, 165, 32))
local stopBtn = createBtn("STOP ALL GACHA", UDim2.new(0, 10, 0, 220), Color3.fromRGB(150, 0, 0))

-- Dito natin aayusin ang Logic base sa ModuleScripts
local function startUniversalGacha(moduleName, targets)
    if _G.AutoGacha then return end
    _G.AutoGacha = true
    
    local moduleScript = GachaClient:FindFirstChild(moduleName)
    if not moduleScript then warn(moduleName .. " not found!") return end
    
    -- Susubukan nating i-require ang module at hanapin ang Gacha function
    local module = require(moduleScript)
    
    task.spawn(function()
        while _G.AutoGacha do
            local success, result = pcall(function()
                -- Karaniwan sa ganitong setup, may function silang 'Gacha' o 'Roll'
                -- Susubukan natin ang common patterns
                if module.Gacha then return module:Gacha()
                elseif module.Roll then return module:Roll()
                elseif typeof(module) == "function" then return module()
                end
            end)

            if success and result then
                for _, t in pairs(targets) do
                    if tostring(result):find(t) then _G.AutoGacha = false break end
                end
            end
            task.wait(0.8 + math.random() * 0.4)
        end
    end)
end

-- CONNECTIONS
rodBtn.MouseButton1Click:Connect(function() startUniversalGacha("Rod", targetRods) end)
wingBtn.MouseButton1Click:Connect(function() startUniversalGacha("Wings", targetWings) end)
swordBtn.MouseButton1Click:Connect(function() startUniversalGacha("Sword", targetSwords) end)

moneyBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        -- Nilagyan ng check para hindi mag-error ang nil
        if obj and obj.ClassName == "RemoteEvent" then
            pcall(function() obj:FireServer(5000000) end)
        end
    end
end)

stopBtn.MouseButton1Click:Connect(function() _G.AutoGacha = false end)
