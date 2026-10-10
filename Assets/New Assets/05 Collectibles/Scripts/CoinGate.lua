-- CoinGate.lua (sector script)
-- A gate (a door sector) that opens by itself once every coin in the level
-- has been collected.
--
-- Attach to: a door sector whose ceiling starts just above its floor.
-- Needs: CoinCounter.lua somewhere in the level (it sets Global.coinTotal).
--
-- Shows: a sector script reacting to state that other scripts put in the
-- Global table.

public number openHeight = 48
public number speed = 30
public Entity speaker = nil    -- optional: an entity whose Audio Source plays when the gate opens

local opened = false

function Update()
    if opened or Global.coinTotal == nil then return end

    if (Global.coins or 0) >= Global.coinTotal then
        opened = true
        sector:MoveCeilingTo(1, sector.floorHeight + openHeight, speed)

        if speaker ~= nil and speaker.audioSource ~= nil then speaker.audioSource:Play() end

        local hud = Game.FindEntity("HUD Hint")
        if hud ~= nil then hud.uiText.text = "The gate is open!" end
    end
end
