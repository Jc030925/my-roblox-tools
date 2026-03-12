-- [[ VIRTUAL CLICKER + AUTO-TRAIN ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local VU = game:GetService("VirtualUser")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainBtn = Instance.new("TextButton", ScreenGui)
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.8, 0)
MainBtn.Text = "START VIRTUAL TRAIN"
MainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainBtn.TextColor3 = Color3.new(1, 1, 1)

local active = false
MainBtn.MouseButton1Click:Connect(function()
    active = not active
    MainBtn.Text = active and "STOPPING..." or "START VIRTUAL TRAIN"
    
    task.spawn(function()
        while active do
            -- 1. Gagayahin ang left click sa screen
            VU:CaptureController()
            VU:ClickButton1(Vector2.new(0, 0))
            
            -- 2. Isasabay natin ang Remote signal para double speed
            pcall(function()
                game:GetService("ReplicatedStorage").Remote.TrainSystem.ReqClickTrain:FireServer()
            end)
            
            task.wait(0.05) -- Tamang bilis lang para hindi ma-kick
        end
    end)
end)
