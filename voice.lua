-- Force Item Generator Script
local ScreenGui = Instance.new("ScreenGui")
local GiveBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
GiveBtn.Parent = ScreenGui
GiveBtn.Size = UDim2.new(0, 200, 0, 50)
GiveBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
GiveBtn.Text = "GET UNKNOWN CRYSTAL"
GiveBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255) -- Purple Button
GiveBtn.Draggable = true

-- CONFIGURATION
local ITEM_NAME = "UnknownCrystal" -- Siguraduhin na tama ang spelling

GiveBtn.MouseButton1Click:Connect(function()
    print("Attempting to force-get item: " .. ITEM_NAME)
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- I-scan ang buong ReplicatedStorage para sa mga Events
    local allRemotes = ReplicatedStorage:GetDescendants()
    local found = false

    for _, remote in pairs(allRemotes) do
        if remote:IsA("RemoteEvent") then
            -- Susubukan nating i-fire ang remote gamit ang pangalan ng crystal
            -- Madalas ang mga event ay tumatanggap ng (ItemName, Amount) o (ItemName)
            remote:FireServer(ITEM_NAME)
            remote:FireServer(ITEM_NAME, 1)
            remote:FireServer(1, ITEM_NAME) -- Minsan baliktad ang order
            
            found = true
        end
    end

    if found then
        print("All remotes fired. Check your backpack!")
    else
        warn("No RemoteEvents found in ReplicatedStorage.")
    end
end)
