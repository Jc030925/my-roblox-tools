-- [[ FINAL STABLE: WASD FLY + VOICE DISTORTER ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- === PART 1: VOICE DISTORTER ===
local function applyVoice(char)
    task.wait(1)
    local mic = char:FindFirstChildOfClass("AudioDeviceInput") or char.PrimaryPart:FindFirstChildOfClass("AudioDeviceInput")
    if mic then
        local shifter = Instance.new("AudioPitchShifter", mic)
        shifter.Pitch = 0.95 + (math.random() * 0.1)
        local comp = Instance.new("AudioCompressor", mic)
        comp.Threshold = -10
        print("Voice Protected")
    end
end

-- === PART 2: WASD FLY SYSTEM ===
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
        
        -- BodyVelocity para sa Movement
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        
        -- BodyGyro para hindi tumumba ang character
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 15000
        bg.CFrame = root.CFrame

        task.spawn(function()
            while flying do
                -- WASD Logic
                local direction = Vector3.new(0,0,0)
                local cam = workspace.CurrentCamera.CFrame
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + cam.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - cam.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - cam.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + cam.RightVector
                end
                
                bv.Velocity = direction.Unit * speed
                if direction.Magnitude == 0 then bv.Velocity = Vector3.new(0,0.1,0) end -- Para hindi mahulog pag walang pinipindot
                
                bg.CFrame = cam
                task.wait()
            end
            -- Clean up pag OFF
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            hum.PlatformStand = false
        end)
        print("Fly ON (WASD Active)")
    else
        print("Fly OFF")
    end
end

-- Toggle Key: F
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then toggleFly() end
end)

LP.CharacterAdded:Connect(applyVoice)
if LP.Character then applyVoice(LP.Character) end
