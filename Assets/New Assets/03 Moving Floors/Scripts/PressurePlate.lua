-- PressurePlate.lua
-- A button on the floor. Stepping on it raises (or lowers) the floor of
-- another sector, for example to turn a pit into a bridge or to make a step
-- appear. It works once.
--
-- Attach to: an entity with a Transform, a Sprite, an Audio Source and a
-- Collider (Sphere) with Is Trigger ticked.
--
-- Shows: a public Sector field (an entity script controlling a sector),
-- MoveFloorTo, and swapping the button's picture when it is pressed.

public Sector target = nil          -- the sector whose floor moves
public number targetHeight = 14     -- floor height to move it to
public number speed = 20            -- units per second
public Texture pressedTexture = nil -- picture of the pushed-in button
public string message = ""          -- optional hint shown on "HUD Hint" when pressed

local pressed = false

function OnTriggerEnter(other)
    if pressed or not other.hasPlayerController then return end
    pressed = true

    -- Show the pressed-in button and play the click.
    if pressedTexture ~= nil and pressedTexture ~= "" then
        entity.sprite.northTextureFileName = pressedTexture
    end
    if entity.audioSource ~= nil then entity.audioSource:Play() end

    -- A Sector field is nil when nothing is picked in the inspector.
    if target ~= nil and target.isValid then
        target:MoveFloorTo(1, targetHeight, speed)
    else
        Debug.LogWarning(entity.name .. ": no target sector picked")
    end

    if message ~= "" then
        local hud = Game.FindEntity("HUD Hint")
        if hud ~= nil then hud.uiText.text = message end
    end
end
