-- Coin.lua
-- A coin that floats up and down. Walking into it collects it: the shared
-- coin count goes up, a sound plays and the coin is removed from the level.
--
-- Attach to: an entity with a Transform, a Sprite and a Collider (Sphere)
-- with Is Trigger ticked. Give it the "coin" tag so CoinCounter.lua can
-- count how many coins the level has.
--
-- Shows: triggers, the Global table, playing a sound on another entity and
-- removing an entity with entity:Destroy().

public int value = 1
public number bobHeight = 2
public number bobSpeed = 3
public string pickupSound = "New Assets/05 Collectibles/Sounds/coin.wav"

local baseHeight = 0
local time = 0

function Start()
    baseHeight = entity.transform.position.y
    -- Start every coin at a different point of its bob, so they don't all
    -- move in sync.
    time = mathT.RandomF(0, 6.28)
end

function Update()
    time = time + GameTime.deltaTime
    entity.transform.position.y = baseHeight + bobHeight * (0.5 + 0.5 * math.sin(time * bobSpeed))
end

function OnTriggerEnter(other)
    if not other.hasPlayerController then return end

    -- Global is one table shared by every script, so CoinCounter.lua and
    -- CoinGate.lua see the new count straight away.
    Global.coins = (Global.coins or 0) + value

    -- The coin is about to be destroyed, and its sounds would stop with it,
    -- so play the pickup sound on the player's own Audio Source instead.
    local audio = other.audioSource
    if audio ~= nil then
        audio.soundFileName = pickupSound
        audio:Play()
    end

    -- Removed at the end of this frame.
    entity:Destroy()
end
