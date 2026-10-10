-- TargetCounter.lua
-- Shows "Targets: 3 / 6" on the HUD and opens the exit gate once every
-- target is down.
--
-- Attach to: a UI entity with a Text component.
--
-- Shows: counting tagged entities, an entity script opening a door sector
-- through a public Sector field, and Global as a scoreboard.

public string tagName = "target"
public Sector gate = nil
public number gateOpenHeight = 48
public Entity speaker = nil   -- plays when the gate opens

local total = 0
local shown = -1
local opened = false

function Start()
    Global.targetsDown = 0
    total = #Game.FindEntitiesWithTag(tagName)
end

function Update()
    local down = Global.targetsDown or 0
    if down == shown then return end
    shown = down

    entity.uiText.text = "Targets: " .. down .. " / " .. total

    if down >= total and not opened then
        opened = true
        entity.uiText.text = "All targets down! The gate is open."
        if gate ~= nil then gate:MoveCeilingTo(1, gate.floorHeight + gateOpenHeight, 40) end
        if speaker ~= nil and speaker.audioSource ~= nil then speaker.audioSource:Play() end
    end
end
