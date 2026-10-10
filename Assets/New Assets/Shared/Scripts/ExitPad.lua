-- ExitPad.lua
-- The glowing exit at the end of every showcase level. Walking into it loads
-- the next level.
--
-- Attach to: an entity with a Transform, a Sprite and a Collider (Sphere)
-- with Is Trigger ticked.
--
-- Shows: OnTriggerEnter, Game.LoadLevel and animating a sprite's colour.

public string nextLevel = ""   -- level file name without ".bson"; empty = back to the first showcase
public number pulseSpeed = 3   -- how fast the glow "breathes"

local FIRST_LEVEL = "Showcase 01 - First Steps"

local time = 0
local leaving = false

function Update()
    -- math.sin goes smoothly between -1 and 1, so the alpha goes between
    -- 0.5 and 1: the glow slowly fades in and out.
    time = time + GameTime.deltaTime
    local alpha = 0.75 + 0.25 * math.sin(time * pulseSpeed)

    local c = entity.sprite.color
    entity.sprite.color = Vector4(c.x, c.y, c.z, alpha)
end

function OnTriggerEnter(other)
    -- Triggers fire for anything that touches them, so only react to the
    -- player, and only once.
    if leaving or not other.hasPlayerController then return end
    leaving = true

    -- LoadLevel only queues the switch; it happens at the end of this frame.
    if nextLevel ~= "" then
        Game.LoadLevel(nextLevel)
    else
        Game.LoadLevel(FIRST_LEVEL)
    end
end
