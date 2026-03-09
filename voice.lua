-- [[ XENO ALL-IN-ONE: VOICE + WASD FLY + FE INVISIBLE ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- === PART 1: UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 150, 0, 50)
MainButton.Position = UDim2.new(0, 10, 0.5, 0)
MainButton.Text = "Invisible: OFF"
MainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Active = true
MainButton.Draggable = true 

-- === PART 2: FE INVISIBLE LOGIC ===
local isInvisible = false

MainButton.MouseButton1Click:Connect(function()
    local char = LP.Character
    if not char then return end
    
    isInvisible = not isInvisible
    
    if isInvisible then
        MainButton.Text = "Invisible: ON"
        MainButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Ginagawang transparent lahat ng parte ng katawan
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        end
        -- Tinatago ang Face at Accessories
        if char:FindFirstChild("Head") and char.Head:FindFirstChild("face") then
            char.Head.face.Transparency = 1
        end
    else
        MainButton.Text = "Invisible: OFF"
        MainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        -- Binabalik sa normal
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        if char:FindFirstChild("Head") and char.Head:FindFirstChild("face") then
            char.Head.face.Transparency = 0
        end
    end
end)

-- === PART 3: VOICE DISTORTER ===
local function applyVoice(char)
    task.wait(1)
    local mic = char:FindFirstChildOfClass("AudioDeviceInput") or char.PrimaryPart:FindFirstChildOfClass("AudioDeviceInput")
    if mic then
        local shifter = Instance.new("AudioPitchShifter", mic)
        shifter.Pitch = 0.94 + (math.random() * 0.12)
    end
end

-- === PART 4: WASD FLY (F) ===
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
