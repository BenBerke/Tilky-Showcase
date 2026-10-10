-- Radio.lua
-- A radio you can switch on and off with E. While it's on, a tune loops
-- from the radio's position: walk around it and the sound moves with you.
--
-- Attach to: an entity with a Transform, a Sprite and an Audio Source whose
-- Sound File is the tune and whose Looping box is ticked.
--
-- Shows: AudioSource:Play / Stop / IsPlaying, and changing pitch from Lua.

public number useRange = 24
public Key useKey = Key.E
public Key pitchKey = Key.R   -- R changes the playback speed

local player
local prompt
local pitches = { 1.0, 1.25, 0.8 }
local pitchIndex = 1

function Start()
    player = Game.FindEntity("Player")
    local hud = Game.FindEntity("HUD Prompt")
    if hud ~= nil then prompt = hud:GetScript("Prompt") end
end

function Update()
    if player == nil then return end
    local audio = entity.audioSource
    local inRange = entity.transform:DistanceTo(player) <= useRange

    if prompt ~= nil then
        if inRange then
            local action = audio:IsPlaying() and "switch the radio off" or "switch the radio on"
            prompt:Show(entity.name, "Press E to " .. action .. ", R to change the speed")
        else
            prompt:Hide(entity.name)
        end
    end

    if not inRange then return end

    if Input.GetKeyDown(useKey) then
        -- IsPlaying is true while the sound is playing (not paused or stopped).
        if audio:IsPlaying() then audio:Stop() else audio:Play() end
    end

    if Input.GetKeyDown(pitchKey) then
        -- Pitch above 1 plays faster and higher, below 1 slower and lower.
        pitchIndex = pitchIndex % #pitches + 1
        audio.pitch = pitches[pitchIndex]
    end
end
