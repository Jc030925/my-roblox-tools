-- [[ XENO ALL-IN-ONE: VOICE + WASD FLY + INVISIBLE UI ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- === PART 1: UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "XenoTools"

local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 150, 0, 50)
MainButton.Position = UDim2.new(0, 10, 0.5, 0)
MainButton.Text = "Invisible: OFF"
MainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Draggable = true -- Pwede mong i-move ang button

-- === PART 2: INVISIBLE LOGIC ===
local isInvisible = false
local storedCFrame

MainButton.MouseButton1Click:Connect(function()
    local char = LP.Character
    if not char or not char:FindFirstChild("LowerTorso") then return end
    
    isInvisible = not isInvisible
    
    if isInvisible then
        MainButton.Text = "Invisible: ON"
        MainButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Itatago ang character sa ilalim ng map
        storedCFrame = char.LowerTorso.RootIt.C0
        char.LowerTorso.RootIt.C0 = char.LowerTorso.RootIt.C0 * CFrame.new(0, 5000, 0)
    else
        MainButton.Text = "Invisible: OFF"
        MainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        -- Ibabalik ang character
        char.LowerTorso.RootIt.C0 = storedCFrame
    end
end)

-- === PART 3: VOICE DISTORTER (RE-APPLY ON SPAWN) ===
local function applyVoice(char)
    task.wait(1)
    local mic = char:FindFirstChildOfClass("AudioDeviceInput") or char:WaitForChild("HumanoidRootPart"):FindFirstChildOfClass("AudioDeviceInput")
    if mic then
        local shifter = Instance.new("AudioPitchShifter", mic)
        shifter.Pitch = 0.95 + (math.random() * 0.1)
    end
end

-- === PART 4: WASD FLY (TOGGLE: F) ===
local flying = false
local speed = 50
local bv, bg

local function toggleFly()
    local char = LP.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    flying = not flying
    if flying then
        hum.PlatformStand = true
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 15000
        task.spawn(function()
            while flying do
                local dir = Vector3.new(0,0,0)
                local cam = workspace.CurrentCamera.CFrame
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                bv.Velocity = dir.Unit * speed
                if dir.Magnitude == 0 then bv.Velocity = Vector3.new(0,0.1,0) end
                bg.CFrame = cam
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            hum.PlatformStand = false
        end)
    end
end

Mouse.KeyDown:Connect(function(key) if key:lower() == "f" then toggleFly() end end)
LP.CharacterAdded:Connect(applyVoice)
if LP.Character then applyVoice(LP.Character) end
