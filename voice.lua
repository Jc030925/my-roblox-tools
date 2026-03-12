-- [[ CUSTOM CHAR GOD MODE + ADAPTIVE TRAIN ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- Remote path
local trainRemote = RS:WaitForChild("Remote"):WaitForChild("TrainSystem"):WaitForChild("ReqClickTrain")

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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

local godBtn = createBtn("FORCE GOD: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(100, 0, 0))
local trainBtn = createBtn("AUTO TRAIN: OFF", UDim2.new(0, 5, 0, 55), Color3.fromRGB(0, 80, 180))

-- === CUSTOM GOD MODE LOGIC ===
local godActive = false
godBtn.MouseButton1Click:Connect(function()
    godActive = not godActive
    godBtn.Text = godActive and "FORCE GOD: ON" or "FORCE GOD: OFF"
    godBtn.BackgroundColor3 = godActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
    
    task.spawn(function()
        while godActive do
            pcall(function()
                local char = LP.Character
                if char then
                    -- 1. I-refill lahat ng posibleng Health values
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("IntValue") then
                            if v.Name:lower():find("health") or v.Name:lower():find("hp") then
                                v.Value = 999999 -- Gawing overkill ang HP value
                            end
                        end
                    end
                    -- 2. I-disable ang joints breaking
                    if char:FindFirstChildOfClass("Humanoid") then
                        char.Humanoid.Health = char.Humanoid.MaxHealth
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- === AUTO TRAIN (Safe Loop) ===
local training = false
trainBtn.MouseButton1Click:Connect(function()
    training = not training
    trainBtn.Text = training and "AUTO TRAIN: ON" or "AUTO TRAIN: OFF"
    trainBtn.BackgroundColor3 = training and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 80, 180)
    
    task.spawn(function()
        while training do
            pcall(function()
                trainRemote:FireServer()
            end)
            task.wait(0.1) -- Binagalan natin para hindi ma-kick ng server-side anticheat
        end
    end)
end)
