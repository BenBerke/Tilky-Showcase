-- Target.lua
-- A target on a stick. It can slide from side to side, and when Shooter.lua
-- hits it, it flips to its grey back side and sinks into the floor.
--
-- Attach to: an entity with a Transform, a Sprite, an Audio Source and a
-- Collider (Sphere, NOT a trigger - raycasts only hit solid colliders).
-- Give it the "target" tag so TargetCounter.lua can count it.
--
-- Shows: a function other scripts call (Hit), moving an entity from a
-- script, and turning a collider off.

public number slideDistance = 0     -- 0 = stands still; otherwise how far it slides each way
public number slideSpeed = 1
public Texture hitTexture = nil     -- picture after being hit
public number sinkSpeed = 60

local start            -- starting position (a Vector3 copy)
local time = 0
local isDown = false
local sunk = 0

function Start()
    start = entity.transform.position
end

-- Called from Shooter.lua as target:Hit(position). The first parameter is
-- the script handle (`self`); this script doesn't need it.
function Hit(self, hitPosition)
    if isDown then return end
    isDown = true

    if hitTexture ~= nil and hitTexture ~= "" then entity.sprite.northTextureFileName = hitTexture end
    entity.audioSource:Play()

    -- Can't be hit twice: the ray passes through inactive colliders.
    entity.collider.isActive = false

    Global.targetsDown = (Global.targetsDown or 0) + 1
end

function Update()
    local dt = GameTime.deltaTime

    if isDown then
        -- Sink until it is completely under the floor (32 units), then stop.
        if sunk < 32 then
            local step = math.min(sinkSpeed * dt, 32 - sunk)
            sunk = sunk + step
            entity.transform:AddPosition(Vector3(0, -step, 0))
        end
        return
    end

    if slideDistance > 0 then
        -- Slide along the map's x axis with a sine wave.
        time = time + dt
        local offset = math.sin(time * slideSpeed) * slideDistance
        entity.transform.position = Vector3(start.x + offset, start.y, start.z)
    end
end
