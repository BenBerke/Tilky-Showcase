-- Lift.lua (sector script)
-- A lift: step onto it and, after a short pause, its floor carries you up to
-- the top. Step on it at the top and it takes you back down. When you get off
-- at the top, it returns to the bottom by itself so it's ready for next time.
--
-- How to build one: draw a sector with its floor at the bottom height and
-- its ceiling high enough for the top (at least Top Height + the player's
-- height). Attach this script.
--
-- Shows: OnEntityEnter / OnEntityExit, moving a floor with MoveFloorTo and
-- checking whether it is still moving with IsFloorMoving.

public number topHeight = 48     -- floor height at the top stop
public number speed = 40         -- units per second
public number waitSeconds = 0.8  -- pause before the lift starts moving

local bottomHeight = 0
local waitTimer = 0
local target = nil   -- height the lift will move to once the pause is over

function Start()
    -- The height the lift was built at is its bottom stop.
    bottomHeight = sector.floorHeight
end

function IsAtTop()
    return math.abs(sector.floorHeight - topHeight) < 0.5
end

-- Wait `waitSeconds`, then move to `height`.
function MoveAfterPause(height)
    target = height
    waitTimer = waitSeconds
end

function OnEntityEnter(other)
    if not other.hasPlayerController then return end
    if sector:IsFloorMoving(1) then return end -- already on its way

    -- Ride to the other end.
    if IsAtTop() then MoveAfterPause(bottomHeight) else MoveAfterPause(topHeight) end
end

function OnEntityExit(other)
    if not other.isValid or not other.hasPlayerController then return end

    -- Got off at the top: go back down once nobody is on board.
    if IsAtTop() and sector:IsEmpty() then MoveAfterPause(bottomHeight) end
end

function Update()
    if target == nil then return end

    waitTimer = waitTimer - GameTime.deltaTime
    if waitTimer > 0 then return end

    -- Start the move. The engine carries on moving the floor every frame
    -- on its own, and anything standing on it rides along.
    sector:MoveFloorTo(1, target, speed)
    target = nil
end
