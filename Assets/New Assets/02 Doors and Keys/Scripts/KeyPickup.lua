-- KeyPickup.lua
-- A key lying on the floor. Walking into it picks it up: the key disappears,
-- a sound plays, the key icon appears on the HUD, and every door whose
-- Required Key matches can now be opened.
--
-- Attach to: an entity with a Transform, a Sprite, an Audio Source and a
-- Collider (Sphere) with Is Trigger ticked.
--
-- Shows: the Global table (shared by every script), turning a sprite and a
-- collider off, and a slow spin-and-bob animation.

public string keyName = "blue"       -- must match the door's Required Key
public Entity hudIcon = nil          -- optional: a UI entity with an Image, hidden until picked up
public number bobHeight = 2          -- how far the key floats up and down
public number bobSpeed = 3

local baseHeight = 0
local time = 0
local taken = false

function Start()
    -- Global keeps its contents when a level changes, so start this level
    -- with no keys. (Every key does this in Start, before anything can be
    -- picked up, so it is safe to do more than once.)
    Global.keys = {}

    baseHeight = entity.transform.position.y
    if hudIcon ~= nil then hudIcon.uiSprite.isActive = false end
end

function Update()
    if taken then return end

    -- Float up and down. Writing one component of a vector property, like
    -- position.y, moves the entity straight away.
    time = time + GameTime.deltaTime
    entity.transform.position.y = baseHeight + bobHeight * (0.5 + 0.5 * math.sin(time * bobSpeed))
end

function OnTriggerEnter(other)
    if taken or not other.hasPlayerController then return end
    taken = true

    Global.keys[keyName] = true

    -- Hide the key instead of destroying it, so its Audio Source can finish
    -- playing the pickup sound.
    entity.sprite.isActive = false
    entity.collider.isActive = false
    if entity.audioSource ~= nil then entity.audioSource:Play() end

    if hudIcon ~= nil then hudIcon.uiSprite.isActive = true end
end
