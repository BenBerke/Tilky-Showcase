-- FlickerLight.lua (sector script)
-- Makes a sector's light flicker like a broken fluorescent tube: mostly on,
-- with short random drop-outs.
--
-- Attach to: any sector.
--
-- Shows: setting sector.light directly, and random timing with mathT.RandomF.

public Vector3 onColor = Vector3(255, 245, 220)   -- light while the tube works (0..255 per channel)
public Vector3 offColor = Vector3(30, 30, 40)     -- light during a drop-out
public number minOnSeconds = 0.1
public number maxOnSeconds = 1.2
public number maxOffSeconds = 0.12                -- drop-outs are short

local isOn = true
local timer = 0

function Update()
    timer = timer - GameTime.deltaTime
    if timer > 0 then return end

    -- Flip between on and off, then pick a random time until the next flip.
    isOn = not isOn
    if isOn then
        sector.light = onColor
        timer = mathT.RandomF(minOnSeconds, maxOnSeconds)
    else
        sector.light = offColor
        timer = mathT.RandomF(0.03, maxOffSeconds)
    end
end
