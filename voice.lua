-- Improved Rod Injector
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.3, 0)
MainBtn.Text = "FORCE LIGHTNING ROD"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.Draggable = true

local function attemptUnlock()
    local targetName = "Lightning Rod"
    local rs = game:GetService("ReplicatedStorage")
    
    print("Searching for game remotes...")

    -- STEP 1: Hanapin ang actual na item object sa game
    local rodObject = nil
    for _, obj in pairs(rs:GetDescendants()) do
        if obj.Name == targetName then
            rodObject = obj
            print("Found Rod Object in ReplicatedStorage!")
            break
        end
    end

    -- STEP 2: I-fire ang lahat ng Remotes pero gagamit tayo ng mas malawak na arguments
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            -- Minsan kailangan ang Object mismo, hindi lang yung Name
            remote:FireServer(targetName)
            if rodObject then remote:FireServer(rodObject) end
            
            -- Subukan ang mga common paths
            remote:FireServer("EquipRod", targetName)
            remote:FireServer("SetRod", targetName)
            remote:FireServer("PurchaseItem", targetName, 0) -- 0 para libre
        end
    end
end

MainBtn.MouseButton1Click:Connect(attemptUnlock)
