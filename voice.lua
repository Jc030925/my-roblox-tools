-- Randomized Pitch Shifter para malito ang AI
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function applyVoiceEffects(character)
    task.wait(1) -- Hintayin muna mag-load ang character
    
    -- Hanapin ang mic input
    local audioInput = character:FindFirstChildOfClass("AudioDeviceInput") or character.PrimaryPart:FindFirstChildOfClass("AudioDeviceInput")
    
    if audioInput then
        -- Tatanggalin ang lumang effects kung meron man
        for _, effect in pairs(audioInput:GetChildren()) do
            if effect:IsA("AudioPitchShifter") then effect:Destroy() end
        end

        local pitchShifter = Instance.new("AudioPitchShifter")
        -- Mag-iiba ang tono (0.93 to 1.07) 
        -- Sapat para malito ang AI, pero normal pa rin sa pandinig ng tao
        pitchShifter.Pitch = 0.93 + (math.random() * 0.14) 
        pitchShifter.Parent = audioInput
        
        print("AI Distortion Active. Pitch: " .. tostring(pitchShifter.Pitch))
    end
end

-- I-run pagka-inject
if localPlayer.Character then
    applyVoiceEffects(localPlayer.Character)
end

-- I-run tuwing mag-re-respawn
localPlayer.CharacterAdded:Connect(applyVoiceEffects)