-- Inventory Lag/Glitch Script Template
-- Purpose: Simulate network lag while spamming item events

local Settings = {
    LagAmount = 99999, -- Amount of lag to simulate
    ItemName = "UnknownCrystal", -- Palitan mo base sa hawak mong item
    SpamCount = 50 -- Ilang beses susubukan i-dupe
}

local NetworkClient = game:GetService("NetworkClient")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

-- Function para mag-create ng artificial lag
local function toggleLag(state)
    if state then
        settings().Network.IncomingReplicationLag = Settings.LagAmount
        print("Lag Enabled: Network throttled.")
    else
        settings().Network.IncomingReplicationLag = 0
        print("Lag Disabled: Syncing with server...")
    end
end

-- Dito mo hahanapin ang RemoteEvent ng Game (Halimbawa lang ito)
-- Kadalasan nasa ReplicatedStorage ito under names like "Remotes", "Events", o "Functions"
local targetRemote = ReplicatedStorage:FindFirstChild("RemoteEventName", true) 

if targetRemote then
    print("Target Remote Found. Starting glitch process...")
    
    toggleLag(true) -- Unahin ang lag para hindi agad mabasa ng server
    
    for i = 1, Settings.SpamCount do
        -- Sinusubukang i-fire ang event nang paulit-ulit habang lag
        targetRemote:FireServer(Settings.ItemName) 
        task.wait(0.01)
    end
    
    task.wait(1) -- Sandaling hinto bago i-sync
    toggleLag(false) -- I-reconnect sa server para makita kung pumasok ang dupe
else
    warn("Hindi mahanap ang RemoteEvent. Check the game's ReplicatedStorage.")
end
