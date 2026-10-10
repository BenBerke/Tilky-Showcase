-- CoinCounter.lua
-- The "Coins: 2 / 6" label on the HUD. It counts the coins in the level when
-- the level starts, then shows how many have been collected.
--
-- Attach to: a UI entity with a Text component.
--
-- Shows: finding entities by tag, the Global table, and only updating a
-- UI Text when the number actually changes.

public string tagName = "coin"

local shown = -1  -- the number currently on screen

function Start()
    -- Global keeps its contents between levels, so reset the count here.
    -- This runs before any coin can be picked up.
    Global.coins = 0

    -- Every entity tagged "coin" (tags are added in the entity inspector).
    Global.coinTotal = #Game.FindEntitiesWithTag(tagName)
end

function Update()
    local collected = Global.coins or 0
    if collected == shown then return end -- nothing new: leave the text alone
    shown = collected

    if collected >= Global.coinTotal then
        entity.uiText.text = "Coins: " .. collected .. " / " .. Global.coinTotal .. "  - all found!"
        entity.uiText.color = Vector4(1, 0.85, 0.2, 1) -- gold
    else
        entity.uiText.text = "Coins: " .. collected .. " / " .. Global.coinTotal
    end
end
