-- Lever.lua
-- A lever that opens the exit door. Press E next to it: its flipbook plays
-- the lever being pulled, and when the animation reaches its last frame
-- (named "down"), that frame's event calls LeverPulled below, which opens
-- the door.
--
-- Attach to: an entity with a Transform, a Sprite, a Flipbook and TWO Audio
-- Sources: the first plays the lever click, the second (moved over to the
-- door with its Offset) plays the door sound.
-- The flipbook file (lever_pull.fpk) has Play On Start turned off and its
-- last frame's Event Function set to "LeverPulled".
--
-- Shows: starting a flipbook from a script, flipbook frame events, and an
-- entity with more than one component of the same type.

public Sector door = nil
public number doorOpenHeight = 40
public number doorSpeed = 40
public number useRange = 24
public Key useKey = Key.E

local player
local prompt
local pulled = false

function Start()
    player = Game.FindEntity("Player")
    local hud = Game.FindEntity("HUD Prompt")
    if hud ~= nil then prompt = hud:GetScript("Prompt") end
end

function Update()
    if pulled or player == nil then return end

    local inRange = entity.transform:DistanceTo(player) <= useRange
    if prompt ~= nil then
        if inRange then prompt:Show(entity.name, "Press E to pull the lever") else prompt:Hide(entity.name) end
    end

    if inRange and Input.GetKeyDown(useKey) then
        pulled = true
        if prompt ~= nil then prompt:Hide(entity.name) end

        -- Plays the flipbook from its first frame. It is a "Once" flipbook,
        -- so it stops on its last frame.
        entity.flipbook:Play()

        -- entity.audioSource is always the FIRST Audio Source: the click.
        entity.audioSource:Play()
    end
end

-- Not an engine callback: the flipbook calls it because the "down" frame's
-- Event Function box says "LeverPulled". It receives the frame's name.
function LeverPulled(frameName)
    if door == nil then return end
    door:MoveCeilingTo(1, door.floorHeight + doorOpenHeight, doorSpeed)

    -- GetComponents lists every Audio Source on the entity, in order.
    -- The second one sits next to the door and plays the door sound.
    local sources = entity:GetComponents(Component.AudioSource)
    if sources[2] ~= nil then sources[2]:Play() end
end
