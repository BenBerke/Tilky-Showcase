-- TimeOfDay.lua
-- Press 1, 2 or 3 to switch between day, sunset and night. The sky's tint
-- and the courtyard's light blend smoothly to the new time of day.
--
-- Attach to: any entity (in this level, the "Sky Controller").
-- The sky itself is set up in World Settings > Rendering > Sky; this script
-- only changes it while the game runs.
--
-- Shows: the Game.SetSky... functions, blending colours over time, and
-- driving a sector's light from an entity script.

public Sector courtyard = nil     -- the sector lit by the sky
public number blendSeconds = 2
public string clickSound = "New Assets/08 Open Sky/Sounds/select.wav"

-- Each time of day: a sky tint and a sector light (both 0..255 per channel).
local times = {
    { name = "Day",    sky = Vector3(255, 255, 255), light = Vector3(255, 250, 240) },
    { name = "Sunset", sky = Vector3(255, 150, 95),  light = Vector3(230, 150, 110) },
    { name = "Night",  sky = Vector3(40, 50, 95),    light = Vector3(60, 70, 120) },
}

local fromTint            -- the tint when the current blend started
local toTint              -- the tint the blend is heading to
local blend = 1           -- 0 = just started, 1 = finished

function Start()
    fromTint = Game.GetSkyTint()
    toTint = fromTint

    -- The clouds drift slowly while the game runs.
    Game.SetSkyRotationSpeed(1.5)
end

function Choose(index)
    local t = times[index]

    -- Start a new blend from whatever the sky looks like right now.
    fromTint = Game.GetSkyTint()
    toTint = t.sky
    blend = 0

    -- Sectors can fade their own light; no blending code needed for that.
    if courtyard ~= nil then courtyard:FadeLight(t.light, blendSeconds) end

    local audio = entity.audioSource
    if audio ~= nil and clickSound ~= "" then
        audio.soundFileName = clickSound
        audio:Play()
    end

    local hud = Game.FindEntity("HUD Hint")
    if hud ~= nil then hud.uiText.text = t.name .. "  (press 1, 2 or 3)" end
end

function Update()
    if Input.GetKeyDown(Key.Alpha1) then Choose(1) end
    if Input.GetKeyDown(Key.Alpha2) then Choose(2) end
    if Input.GetKeyDown(Key.Alpha3) then Choose(3) end

    if blend >= 1 then return end

    -- Move `blend` from 0 to 1 over blendSeconds, then mix the two tints:
    -- tint = from + (to - from) * blend.
    blend = math.min(1, blend + GameTime.deltaTime / blendSeconds)
    Game.SetSkyTint(fromTint + (toTint - fromTint) * blend)
end
