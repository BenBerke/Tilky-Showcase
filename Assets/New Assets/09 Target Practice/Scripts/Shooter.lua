-- Shooter.lua
-- Lets the player shoot: left click fires a ray through the middle of the
-- screen, and whatever it hits first is reported. Targets (Target.lua) fall
-- over when hit.
--
-- Attach to: the Player (it has the Camera). The player's Audio Source
-- plays the shot.
--
-- Shows: Input.GetMouseButtonDown, camera:Raycast, reading a raycast hit,
-- and calling a function in another entity's script.

public number range = 1000
public number shotsPerSecond = 4
public string shotSound = "New Assets/09 Target Practice/Sounds/laser.wav"

local cooldown = 0

function Update()
    cooldown = cooldown - GameTime.deltaTime
    if cooldown > 0 or not Input.GetMouseButtonDown(Input.MouseLeft) then return end
    cooldown = 1 / shotsPerSecond

    local audio = entity.audioSource
    if audio ~= nil then
        audio.soundFileName = shotSound
        audio:Play()
    end

    -- From the eye, straight through the crosshair. `true` means only
    -- entities with a solid Collider can be hit. Walls, floors and ceilings
    -- always stop the ray. Returns nil when nothing is hit within range.
    local hit = entity.camera:Raycast(range, true)
    if hit == nil or hit.entity == nil then return end

    -- GetScript never returns nil: check isValid instead.
    local target = hit.entity:GetScript("Target")
    if target.isValid then
        -- Called with a colon, so Target.lua's Hit receives `self` first.
        target:Hit(hit.position)
    end
end
