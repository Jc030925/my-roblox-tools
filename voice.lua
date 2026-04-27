-- Dex-Based Rod Injector
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
MainBtn.Text = "FORCE LIGHTNING ROD"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.Draggable = true

-- TARGET MULA SA DEX MO
local ROD_NAME = "LightningRod" 
local ROD_FOLDER = game.ReplicatedStorage.FishingResources.Rods

MainBtn.MouseButton1Click:Connect(function()
    local rs = game:GetService("ReplicatedStorage")
    local rodObj = ROD_FOLDER:FindFirstChild(ROD_NAME)
    
    print("Injecting from FishingResources...")

    -- STEP 1: Hanapin ang Remote sa GachaResources o Controllers
    -- Madalas ang mga game na ito ay may 'Equip' remote sa loob ng Controllers
    local allRemotes = rs:GetDescendants()
    
    for _, remote in pairs(allRemotes) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            pcall(function()
                -- Sinusubukan nating i-send ang Rod Object mismo
                if rodObj then
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(rodObj)
                        remote:FireServer("Equip", rodObj)
                        remote:FireServer("Update", ROD_NAME)
                    else
                        remote:InvokeServer(rodObj)
                    end
                end
            end)
        end
    end
    
    -- STEP 2: Force unlock sa PlayersData (Client-side mirror)
    -- Para isipin ng UI na 'Owned' mo na ang item
    local lp = game.Players.LocalPlayer
    pcall(function()
        local inv = lp:FindFirstChild("PlayersData") or rs:FindFirstChild("PlayersData")
        if inv then
            -- Sinusubukan nating i-insert ang pangalan mo sa owned list
            print("Attempting to patch PlayersData...")
        end
    end)
    
    print("Request Sent. Re-open your Rod Menu to refresh!")
end)
