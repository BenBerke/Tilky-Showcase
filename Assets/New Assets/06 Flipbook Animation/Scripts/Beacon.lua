-- Beacon.lua
-- A warning light that beeps every time it lights up.
--
-- The blinking itself needs no code: the entity's Flipbook plays
-- beacon_blink.fpk (two frames, "on" and "off", looping). The "on" frame's
-- Event Function is set to "Beep", so the flipbook calls the function below
-- each time the light comes on - the sound always stays in time with the
-- picture, whatever speed the flipbook plays at.
--
-- Attach to: an entity with a Transform, a Sprite, a Flipbook and an Audio
-- Source.
--
-- Shows: flipbook frame events, and changing a flipbook's speed.

public Key fasterKey = Key.F  -- press F near the beacon to make it blink faster
public number useRange = 40

local player

function Start()
    player = Game.FindEntity("Player")
end

-- Called by the flipbook, with the name of the frame that was reached.
function Beep(frameName)
    entity.audioSource:Play()
end

function Update()
    if player == nil then return end

    -- speed 1 = the flipbook's own timing, 2 = twice as fast. Cycle 1 -> 2 -> 4 -> 1.
    if Input.GetKeyDown(fasterKey) and entity.transform:DistanceTo(player) <= useRange then
        local speed = entity.flipbook.speed * 2
        if speed > 4 then speed = 1 end
        entity.flipbook.speed = speed
    end
end
