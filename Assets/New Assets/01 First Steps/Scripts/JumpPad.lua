-- JumpPad.lua
-- A springboard that launches whatever steps on it high into the air.
--
-- Attach to: an entity with a Transform, a Sprite, an Audio Source and a
-- Collider (Sphere) with Is Trigger ticked.
--
-- Shows: OnTriggerEnter, changing another entity's Rigidbody velocity, and
-- swapping a sprite's picture for a moment.

public number launchSpeed = 160     -- upward speed given to whoever steps on the pad
public Texture sprungTexture = nil  -- picture shown right after a launch (the spring stretched out)
public number sprungSeconds = 0.4   -- how long that picture stays

local restingTexture = ""  -- the picture the sprite starts with
local sprungTimer = 0

function Start()
    -- Remember the starting picture so we can switch back to it later.
    restingTexture = entity.sprite.northTextureFileName
end

function OnTriggerEnter(other)
    -- Only things with a Rigidbody can be launched (the player has one).
    local body = other.rigidbody
    if body == nil then return end

    -- Keep the sideways speed and replace the upward speed. velocity is a
    -- copy, so read it, build a new vector and assign the whole thing back.
    local v = body.velocity
    body.velocity = Vector3(v.x, launchSpeed, v.z)

    -- Show the stretched spring and play the boing.
    if sprungTexture ~= nil and sprungTexture ~= "" then
        entity.sprite.northTextureFileName = sprungTexture
    end
    sprungTimer = sprungSeconds

    if entity.audioSource ~= nil then entity.audioSource:Play() end
end

function Update()
    if sprungTimer <= 0 then return end

    -- Count down, then put the resting picture back.
    sprungTimer = sprungTimer - GameTime.deltaTime
    if sprungTimer <= 0 then
        entity.sprite.northTextureFileName = restingTexture
    end
end
