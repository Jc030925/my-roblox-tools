-- Ultimate Database Injector
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 250, 0, 50)
MainBtn.Position = UDim2.new(0.5, -125, 0.4, 0)
MainBtn.Text = "FORCE LIGHTNING DATA"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MainBtn.Draggable = true

local function forceData()
    local target = "LightningRod"
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("ReplicatedStorage")
    
    -- Hanapin ang folder mo sa PlayersData
    local myData = rs:WaitForChild("PlayersData"):FindFirstChild(lp.Name)
    
    if myData then
        local fishing = myData:FindFirstChild("FishingData")
        if fishing then
            print("FishingData Found! Patching values...")
            
            -- 1. Force Change CurrentRod (Ang nakita natin sa Dex)
            local currentRodValue = fishing:FindFirstChild("CurrentRod")
            if currentRodValue then
                currentRodValue.Value = target
                print("CurrentRod updated to LightningRod!")
            end
            
            -- 2. Add to Inventory (Ang Rods folder sa Dex)
            local rodsFolder = fishing:FindFirstChild("Rods")
            if rodsFolder then
                if not rodsFolder:FindFirstChild(target) then
                    local newRod = Instance.new("BoolValue")
                    newRod.Name = target
                    newRod.Value = true
                    newRod.Parent = rodsFolder
                    print("LightningRod added to owned inventory!")
                end
            end
        end
    end
    
    -- 3. Trigger Server Sync
    -- Hahanapin natin ang remote na nag-se-save ng data para pumasok sa server
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") and (remote.Name:find("Save") or remote.Name:find("Update")) then
            remote:FireServer()
        end
    end
end

MainBtn.MouseButton1Click:Connect(forceData)
