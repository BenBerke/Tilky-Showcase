-- ColorCycle.lua (sector script)
-- Slowly fades a sector's light through a list of colours, over and over.
--
-- Attach to: any sector.
--
-- Shows: sector:FadeLight (the engine does the fading for you) and
-- sector:IsLightFading to know when a fade has finished.

public number secondsPerColor = 1.5

-- Light colours are Vector3, 0..255 per channel.
local colors = {
    Vector3(255, 70, 70),   -- red
    Vector3(255, 200, 60),  -- amber
    Vector3(70, 255, 110),  -- green
    Vector3(70, 140, 255),  -- blue
    Vector3(200, 80, 255),  -- purple
}

local index = 0

function Update()
    -- Wait for the current fade to finish before starting the next one.
    if sector:IsLightFading() then return end

    -- Next colour in the list; % wraps back to the start after the last one.
    index = index % #colors + 1
    sector:FadeLight(colors[index], secondsPerColor)
end
