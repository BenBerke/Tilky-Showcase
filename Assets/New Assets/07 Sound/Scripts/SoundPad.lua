-- SoundPad.lua
-- A pad on the floor that plays its sound when stepped on, a little higher
-- or lower each time so it never sounds exactly the same twice.
--
-- Attach to: an entity with a Transform, a Sprite, an Audio Source (its
-- Sound File is the pad's sound) and a Collider (Sphere) with Is Trigger
-- ticked.
--
-- Shows: playing a sound from a trigger, random pitch, and making the sprite
-- flash brighter for a moment.

public number pitchVariation = 0.15   -- 0.15 = up to 15% higher or lower
public number flashSeconds = 0.3

local flashTimer = 0

function OnTriggerEnter(other)
    if not other.hasPlayerController then return end

    local audio = entity.audioSource
    audio.pitch = mathT.RandomF(1 - pitchVariation, 1 + pitchVariation)
    audio:Play()

    flashTimer = flashSeconds
end

function Update()
    -- The sprite colour multiplies the picture: show the pad a little dimmed
    -- (0.6) while idle and at full brightness (1) just after a press.
    local brightness = 0.6
    if flashTimer > 0 then
        flashTimer = flashTimer - GameTime.deltaTime
        brightness = 1
    end
    entity.sprite.color = Vector4(brightness, brightness, brightness, 1)
end
