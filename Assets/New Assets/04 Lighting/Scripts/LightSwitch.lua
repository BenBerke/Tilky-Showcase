-- LightSwitch.lua
-- A wall switch. Stand next to it and press E to turn a room's light on or
-- off with a short fade.
--
-- Attach to: an entity with a Transform, a Sprite and an Audio Source.
-- Needs: a "Player" entity and a "HUD Prompt" UI entity running Prompt.lua.
--
-- Shows: an entity script controlling a sector's light through a public
-- Sector field, distance checks with transform:DistanceTo, and input.

public Sector room = nil                          -- the sector whose light this switch controls
public Vector3 onColor = Vector3(255, 250, 235)
public Vector3 offColor = Vector3(12, 12, 18)
public number fadeSeconds = 0.4
public number useRange = 24
public Key useKey = Key.E
public Texture onTexture = nil                    -- switch picture when on
public Texture offTexture = nil                   -- switch picture when off

local player
local prompt
local isOn = false

function Start()
    player = Game.FindEntity("Player")
    local hud = Game.FindEntity("HUD Prompt")
    if hud ~= nil then prompt = hud:GetScript("Prompt") end
end

function Update()
    if player == nil or room == nil then return end

    local inRange = entity.transform:DistanceTo(player) <= useRange

    if prompt ~= nil then
        if inRange then
            prompt:Show(entity.name, isOn and "Press E to switch the light off" or "Press E to switch the light on")
        else
            prompt:Hide(entity.name)
        end
    end

    if inRange and Input.GetKeyDown(useKey) then Toggle() end
end

function Toggle()
    isOn = not isOn

    -- FadeLight blends from the current light to the new one over time.
    room:FadeLight(isOn and onColor or offColor, fadeSeconds)

    -- Flip the lever picture and click.
    local picture = isOn and onTexture or offTexture
    if picture ~= nil and picture ~= "" then entity.sprite.northTextureFileName = picture end
    if entity.audioSource ~= nil then entity.audioSource:Play() end
end
