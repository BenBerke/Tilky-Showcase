-- LevelIntro.lua
-- Shows the level's title in big letters when the level starts, keeps it on
-- screen for a few seconds, then fades it out.
--
-- Attach to: a UI entity with a Text component (the "HUD Title" entity in
-- every showcase level).
--
-- Shows: public fields, changing a UI Text's text and colour, and counting
-- time with GameTime.deltaTime.

public string title = "Showcase"
public string subtitle = ""      -- second, smaller line; leave empty for none
public number holdSeconds = 4    -- how long the title stays fully visible
public number fadeSeconds = 1.5  -- how long the fade-out takes

local timer = 0

function Start()
    -- "\n" starts a new line in a UI Text.
    if subtitle ~= "" then
        entity.uiText.text = title .. "\n" .. subtitle
    else
        entity.uiText.text = title
    end
end

function Update()
    timer = timer + GameTime.deltaTime

    -- Still in the "hold" part: nothing to change yet.
    if timer <= holdSeconds then return end

    -- Goes from 1 (start of the fade) down to 0 (end of the fade).
    local alpha = 1 - (timer - holdSeconds) / fadeSeconds

    if alpha <= 0 then
        entity.uiText.text = ""
        -- Nothing left to do: disabling the entity stops this script's Update.
        entity.enabled = false
        return
    end

    -- Colours are Vector4(r, g, b, a) with every channel from 0 to 1.
    -- Keep the colour, change only the alpha (see-through amount).
    local c = entity.uiText.color
    entity.uiText.color = Vector4(c.x, c.y, c.z, alpha)
end
