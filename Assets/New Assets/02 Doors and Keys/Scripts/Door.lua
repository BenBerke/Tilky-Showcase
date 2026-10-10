-- Door.lua (sector script)
-- Turns a sector into a door. Walk up to it and press E: the door slides up,
-- stays open for a few seconds and closes again. A door can also be locked
-- until the player has picked up a key (see KeyPickup.lua).
--
-- How to build a door: draw a thin sector between two rooms and give it a
-- ceiling height just above its floor height, so it starts closed. Attach
-- this script in the sector's Scripts section.
--
-- Needs: a "Player" entity and a "HUD Prompt" UI entity running Prompt.lua.
--
-- Shows: sector scripts, moving a ceiling with MoveCeilingTo, keyboard input,
-- the distance from an entity to a sector, and sharing state through Global.

public number openHeight = 40       -- how far above its floor the door opens
public number speed = 60            -- opening / closing speed in units per second
public number useRange = 20         -- how close the player has to be to use the door
public number stayOpenSeconds = 3   -- time before it closes again; 0 = stays open
public string requiredKey = ""      -- e.g. "blue". Empty = no key needed
public Key useKey = Key.E
public Entity speaker = nil         -- optional: an entity with an Audio Source near the door
public string openSound = ""
public string closeSound = ""
public string lockedSound = ""

local player
local prompt
local promptKey     -- our own key for the shared prompt (see Prompt.lua)
local isOpen = false
local closeTimer = 0

function Start()
    player = Game.FindEntity("Player")

    local hud = Game.FindEntity("HUD Prompt")
    if hud ~= nil then prompt = hud:GetScript("Prompt") end

    -- sector.id is unique, so two doors never share a prompt key.
    promptKey = "door " .. sector.id
end

-- True when no key is needed, or the player has picked up the right one.
-- KeyPickup.lua writes picked-up keys into the shared Global table.
function HasKey()
    if requiredKey == "" then return true end
    return Global.keys ~= nil and Global.keys[requiredKey] == true
end

function PlaySound(fileName)
    if speaker == nil or fileName == "" then return end
    local audio = speaker.audioSource
    if audio == nil then return end
    audio.soundFileName = fileName
    audio:Play()
end

function Open()
    isOpen = true
    closeTimer = stayOpenSeconds

    -- Fire and forget: the engine moves the ceiling a little every frame
    -- until it reaches the target height. No Update code needed for that.
    sector:MoveCeilingTo(1, sector.floorHeight + openHeight, speed)
    PlaySound(openSound)
end

function Close()
    isOpen = false

    -- Lower the ceiling back down until it nearly touches the floor.
    sector:MoveCeilingToFloor(1, speed)
    PlaySound(closeSound)
end

function Update()
    if player == nil or not player.isValid then return end

    -- 0 while the player stands inside the door sector, otherwise the
    -- distance to its nearest edge.
    local inRange = sector:DistanceToSector(player) <= useRange

    -- Show the right prompt while the player is close to a closed door.
    if prompt ~= nil and prompt.isValid then
        if inRange and not isOpen then
            if HasKey() then
                prompt:Show(promptKey, "Press E to open the door")
            else
                prompt:Show(promptKey, "Locked: you need the " .. requiredKey .. " key")
            end
        else
            prompt:Hide(promptKey)
        end
    end

    -- Pressing the key opens the door, or plays the "locked" buzz.
    if inRange and not isOpen and Input.GetKeyDown(useKey) then
        if HasKey() then Open() else PlaySound(lockedSound) end
    end

    -- Close again after a while, but never on top of someone standing in
    -- the doorway: IsEmpty() is false while any entity is inside the sector.
    if isOpen and stayOpenSeconds > 0 then
        closeTimer = closeTimer - GameTime.deltaTime
        if closeTimer <= 0 and sector:IsEmpty() then Close() end
    end
end
