-- Final Hybrid Injector (Data + Auto-Refresh Visuals)
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 250, 0, 50)
MainBtn.Position = UDim2.new(0.5, -125, 0.4, 0)
MainBtn.Text = "FORCE LIGHTNING ROD (FULL)"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.Draggable = true

local function fullForceEquip()
    local target = "LightningRod"
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("ReplicatedStorage")
    local char = lp.Character or lp.CharacterAdded:Wait()
    
    -- STEP 1: Patas ang Database (Base sa Dex Screenshot mo)
    local myData = rs:WaitForChild("PlayersData"):FindFirstChild(lp.Name)
    if myData then
        local fishing = myData:FindFirstChild("FishingData")
        if fishing then
            -- Force update ang CurrentRod string
            if fishing:FindFirstChild("CurrentRod") then
                fishing.CurrentRod.Value = target
            end
            
            -- Siguraduhing 'True' ang BoolValue sa Rods folder
            local rodsFolder = fishing:FindFirstChild("Rods")
            if rodsFolder then
                local rodValue = rodsFolder:FindFirstChild(target)
                if not rodValue then
                    rodValue = Instance.new("BoolValue")
                    rodValue.Name = target
                    rodValue.Parent = rodsFolder
                end
                rodValue.Value = true
            end
        end
    end

    -- STEP 2: Auto-Unequip/Equip Trick (Ang manual trick na ginagawa mo)
    -- Ito ang magpilit sa game na i-render ang Lightning Rod model
    local tool = char:FindFirstChildOfClass("Tool") or lp.Backpack:FindFirstChildOfClass("Tool")
    
    if tool then
        -- 1. I-unequip (Itago sa backpack)
        tool.Parent = lp.Backpack
        task.wait(0.1)
        
        -- 2. Pilitin ang character na hawakan ulit (Dito mag-uupdate ang mesh)
        char.Humanoid:EquipTool(tool)
        print("Visual Refresh Triggered!")
    end
end

MainBtn.MouseButton1Click:Connect(fullForceEquip)
