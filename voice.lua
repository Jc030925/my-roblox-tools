-- [[ GOD MODE + SPEED TRAIN INJECTOR ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Target Remote based sa Dex screenshot mo
local speedRemote = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("TrainSystem"):WaitForChild("ReqUpdateTrainSpeed")

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 110)
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Draggable = true
MainFrame.Active = true

local function createBtn(name, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(1, -10, 0, 45)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    return b
end

local godBtn = createBtn("God Mode: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(150, 0, 0))
local speedBtn = createBtn("MAX SPEED: OFF", UDim2.new(0, 5, 0, 55), Color3.fromRGB(0, 100, 200))

-- === GOD MODE ===
local godEnabled = false
godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = godEnabled and "God Mode: ON" or "God Mode: OFF"
    godBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    task.spawn(function()
        while godEnabled do
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
            end
            task.wait(0.1)
        end
    end)
end)

-- === TRAIN SPEED INJECTOR ===
local speedGlitch = false
speedBtn.MouseButton1Click:Connect(function()
    speedGlitch = not speedGlitch
    speedBtn.Text = speedGlitch and "MAX SPEED: ON" or "MAX SPEED: OFF"
    speedBtn.BackgroundColor3 = speedGlitch and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 100, 200)
    
    task.spawn(function()
        while speedGlitch do
            -- I-fire ang Speed Remote para laging "Max" ang Train Speed bar mo
            pcall(function()
                speedRemote:FireServer() 
            end)
            task.wait(0.01) -- Spam speed updates
        end
    end)
end)
