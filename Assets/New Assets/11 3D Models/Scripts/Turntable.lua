-- Turntable.lua
-- Spins an entity around its vertical axis, like a car on a showroom
-- turntable. Works for anything, but you only see it turn on 3D models
-- (and 4- or 8-direction sprites): a plain sprite always faces the camera.
--
-- Attach to: an entity with a Transform and a Model.
--
-- Shows: building a rotation with mathT.QuaternionFromEuler and assigning
-- it to transform.rotation.

public number degreesPerSecond = 45
public number startAngle = 0       -- where the model starts, in degrees

local angle = 0

function Start()
    angle = startAngle
end

function Update()
    angle = (angle + degreesPerSecond * GameTime.deltaTime) % 360

    -- QuaternionFromEuler takes the same X / Y / Z degrees the inspector
    -- shows. Turning around Y is turning left / right.
    entity.transform.rotation = mathT.QuaternionFromEuler(0, angle, 0)
end
