-- HintZone.lua (sector script)
-- Shows a hint at the bottom of the screen while the player is inside this
-- sector. Every showcase level uses it to explain what to try in each room.
--
-- Attach to: a sector, in the Scripts section of the sector inspector.
-- Needs: a UI entity named "HUD Hint" with a Text component.
--
-- Shows: sector scripts, the OnEntityEnter / OnEntityExit callbacks and
-- changing a UI entity's text from another script.

public string message = "Hello!"
public bool clearOnExit = true   -- untick to keep the hint after the player leaves

local hud -- the "HUD Hint" entity, looked up once in Start

function Start()
    -- Game.FindEntity searches the whole level, so do it once, not every frame.
    hud = Game.FindEntity("HUD Hint")

    -- Entities that are already inside when the level starts don't fire
    -- OnEntityEnter, so check for the player here as well.
    for _, e in ipairs(sector:GetEntities()) do
        if e.hasPlayerController then ShowHint() end
    end
end

-- Called when any entity walks into this sector. In a sector script the
-- parameter would hide the `entity` global, so it is called `other` here.
function OnEntityEnter(other)
    if other.hasPlayerController then ShowHint() end
end

function OnEntityExit(other)
    -- A destroyed entity also "exits", so check isValid before using it.
    if not clearOnExit or not other.isValid or not other.hasPlayerController then return end

    -- Only clear the text if it is still ours: when the player walks from one
    -- hint zone straight into another, the new zone's hint must stay.
    if hud ~= nil and hud.uiText.text == message then
        hud.uiText.text = ""
    end
end

function ShowHint()
    if hud ~= nil then hud.uiText.text = message end
end
