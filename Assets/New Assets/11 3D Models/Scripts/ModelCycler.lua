-- ModelCycler.lua
-- A display stand: press E next to it to swap the model it shows. The model
-- also slowly spins and bobs so you can see it from every side.
--
-- Attach to: an entity with a Transform and a Model.
-- Needs: a "Player" entity and a "HUD Prompt" UI entity running Prompt.lua.
--
-- Shows: changing entity.model.fileName from a script. The new model
-- appears on the next frame; a file that isn't loaded yet is loaded then.

public string folder = "New Assets/11 3D Models/Models/Food/"
public number useRange = 28
public Key useKey = Key.E
public number degreesPerSecond = 60
public number bobHeight = 1.5

-- Model files inside `folder`, with their extension (.glb, .obj, ...).
local models = { "burger.glb", "cake-birthday.glb", "donut-sprinkles.glb", "apple.glb", "cupcake.glb" }

local player
local prompt
local index = 1
local angle = 0
local time = 0
local baseHeight = 0

function Start()
    player = Game.FindEntity("Player")
    local hud = Game.FindEntity("HUD Prompt")
    if hud ~= nil then prompt = hud:GetScript("Prompt") end

    baseHeight = entity.transform.position.y
    entity.model.fileName = folder .. models[index]
end

function Update()
    -- Spin and bob.
    local dt = GameTime.deltaTime
    angle = (angle + degreesPerSecond * dt) % 360
    time = time + dt
    entity.transform.rotation = mathT.QuaternionFromEuler(0, angle, 0)
    entity.transform.position.y = baseHeight + bobHeight * math.sin(time * 2)

    if player == nil then return end
    local inRange = entity.transform:DistanceTo(player) <= useRange

    if prompt ~= nil then
        if inRange then
            -- e.g. "Press E for the next model (burger.glb, 1 of 5)"
            prompt:Show(entity.name, string.format("Press E for the next model (%s, %d of %d)",
                models[index], index, #models))
        else
            prompt:Hide(entity.name)
        end
    end

    if inRange and Input.GetKeyDown(useKey) then
        index = index % #models + 1
        entity.model.fileName = folder .. models[index]
    end
end
