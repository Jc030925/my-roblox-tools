-- Force Visual Refresh
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rs = game:GetService("ReplicatedStorage")

-- 1. I-locate ang LightningRod Model mula sa resources na nakita natin sa Dex
local rodModel = rs.FishingResources.Rods:FindFirstChild("LightningRod")

local function refreshEquip()
    print("Force spawning LightningRod model...")
    
    -- I-delete ang lumang hawak na rod para hindi mag-conflict
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then tool:Destroy() end
    end
    if character:FindFirstChildOfClass("Tool") then
        character:FindFirstChildOfClass("Tool"):Destroy()
    end

    -- 2. I-clone ang LightningRod direkta sa Backpack mo
    if rodModel then
        local newRod = rodModel:Clone()
        newRod.Parent = player.Backpack
        
        -- Pilitin ang character na i-equip ito
        character.Humanoid:EquipTool(newRod)
        print("Equip successful!")
    else
        print("LightningRod model not found in FishingResources!")
    end
end

refreshEquip()
