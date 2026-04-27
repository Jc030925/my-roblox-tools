local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlinkClient = require(ReplicatedStorage:WaitForChild("Blink").Client)
local lp = game.Players.LocalPlayer
local target = "LightningRod"

_G.AutoGacha = true 

print("Auto-Gacha Started via Blink. Target: " .. target)

task.spawn(function()
    while _G.AutoGacha do
        -- 1. Check muna natin ang PlayersData para malaman kung nakuha na
        local myData = ReplicatedStorage:WaitForChild("PlayersData"):FindFirstChild(lp.Name)
        if myData then
            local rods = myData.FishingData.Rods
            if rods:FindFirstChild(target) and rods[target].Value == true then
                print("LIGIT! Nakuha na sa server. Stopping...")
                _G.AutoGacha = false
                break
            end
        end

        -- 2. Direct Call sa Gacha Function (Bypass Hold E & Animation)
        -- Ginamit natin ang "Rod" dahil iyon ang name ng script sa screenshot mo
        local success, result = pcall(function()
            return BlinkClient.GachaFunc.Invoke("Rod")
        end)

        if success then
            print("Rolled: " .. tostring(result))
        else
            warn("Failed to roll: " .. tostring(result))
        end

        task.wait(0.5) -- Delay para hindi ma-kick sa bilis
    end
end)
