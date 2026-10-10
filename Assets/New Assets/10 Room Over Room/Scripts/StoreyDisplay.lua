-- StoreyDisplay.lua (sector script)
-- Shows which storey of a multi-storey sector the player is on.
--
-- A sector can hold several floor/ceiling pairs ("intervals") stacked on top
-- of each other. The tower in this level is ONE sector with two of them:
--     interval 1: floor 0,  ceiling 40   (the ground-floor room)
--     interval 2: floor 56, ceiling 104  (the room above it)
-- The 16 units between ceiling 1 and floor 2 are solid: the ground room's
-- ceiling is the upper room's floor seen from below. Add intervals in the
-- sector inspector with "Add Floor".
--
-- Attach to: the multi-storey sector.
-- Needs: a "Player" entity and a "HUD Hint" UI entity with a Text.
--
-- Shows: sector.floorCount, sector:GetFloor(i) and its floorHeight /
-- ceilingHeight, and sector:ContainsEntity.

local player
local hud
local shownStorey = nil   -- storey number currently on screen, nil = none
local shownText = ""

function Start()
    player = Game.FindEntity("Player")
    hud = Game.FindEntity("HUD Hint")
end

-- Which interval is the player standing in? Height decides it: the one whose
-- floor is at or below the player's feet and whose ceiling is above them.
function StoreyOf(height)
    for i = 1, sector.floorCount do
        local interval = sector:GetFloor(i)
        if height >= interval.floorHeight - 1 and height < interval.ceilingHeight then
            return i, interval
        end
    end
    return nil
end

function Update()
    if player == nil or hud == nil then return end

    -- ContainsEntity only looks at the map position (x, z): it is true on
    -- every storey. The height tells the storeys apart.
    if not sector:ContainsEntity(player) then
        -- Left the tower: clear our text (but not someone else's hint).
        if shownStorey ~= nil and hud.uiText.text == shownText then hud.uiText.text = "" end
        shownStorey = nil
        return
    end

    local storey, interval = StoreyOf(player.transform.position.y)
    if storey == nil or storey == shownStorey then return end
    shownStorey = storey

    shownText = string.format("Storey %d of %d: floor %d, ceiling %d. Same sector, different height!",
        storey, sector.floorCount, math.floor(interval.floorHeight), math.floor(interval.ceilingHeight))
    hud.uiText.text = shownText
end
