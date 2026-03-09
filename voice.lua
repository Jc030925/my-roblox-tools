-- [[ JOINT SCRIPT: VOICE DISTORTER + FLY (F) ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- === PART 1: VOICE DISTORTER (ANTI-AI) ===
local function applyVoiceEffects(char)
    task.wait(1)
    local mic = char:FindFirstChildOfClass("AudioDeviceInput") or char.PrimaryPart:FindFirstChildOfClass("AudioDeviceInput")
    
    if mic then
        -- Tatanggalin ang lumang effects para hindi mag-stack
        for _, v in pairs(mic:GetChildren()) do
            if v:IsA("AudioPitchShifter") or v:IsA("AudioCompressor") then v:Destroy() end
        end

        -- Random Pitch (Para malito ang AI)
        local shifter = Instance.new("AudioPitchShifter")
        shifter.Pitch = 0.94 + (math.random() * 0.12)
        shifter.Parent = mic
        
        -- Compressor (Para hindi ma-flag sa "Loud/Disruptive Audio")
        local comp = Instance.new("AudioCompressor")
        comp.Threshold = -10
        comp.Parent = mic
        
        print("Voice Distortion Active | Pitch: " .. shifter.Pitch)
    end
end

-- === PART 2: FLY SYSTEM (TOGGLE: F) ===
local flying = false
local flySpeed = 50

local function toggleFly()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    flying = not flying
    
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "XenoFlyVel"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = root
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "XenoFlyGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 9000
        bg.CFrame = root.CFrame
        bg.Parent = root
        
        hum.PlatformStand = true
        
        task.spawn(function()
            while flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
        end)
        print("Fly Enabled (F)")
    else
        if root:FindFirstChild("XenoFlyVel") then root.XenoFlyVel:Destroy() end
        if root:FindFirstChild("XenoFlyGyro") then root.XenoFlyGyro:Destroy() end
        hum.PlatformStand = false
        print("Fly Disabled (F)")
    end
end

-- === KEYBOARD DETECTION ===
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then
        toggleFly()
    end
end)

-- === INITIALIZE ===
LP.CharacterAdded:Connect(applyVoiceEffects)
if LP.Character then applyVoiceEffects(LP.Character) end

print("Script Loaded: Voice Distorter & Fly Toggle (F)")
