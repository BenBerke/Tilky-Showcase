-- Prompt.lua
-- The "Press E to ..." message in the middle of the screen. Doors, switches,
-- levers and radios call this script instead of each changing the text
-- themselves:
--
--     local prompt = Game.FindEntity("HUD Prompt"):GetScript("Prompt")
--     prompt:Show("door 3", "Press E to open")
--     prompt:Hide("door 3")
--
-- Every caller passes its own key ("door 3" above). Hide only clears the
-- text if the same key showed it, so one object walking out of range never
-- erases the prompt of another object the player is standing next to.
--
-- Attach to: the "HUD Prompt" UI entity (it has a Text component).
--
-- Shows: functions that other scripts call through GetScript. Because they
-- are called with a colon (prompt:Show(...)), the first parameter is the
-- script handle itself, named `self` by convention.

local owner = nil -- key of whoever is showing the prompt right now

function Show(self, key, text)
    owner = key
    entity.uiText.text = text
end

function Hide(self, key)
    if owner ~= key then return end
    owner = nil
    entity.uiText.text = ""
end
