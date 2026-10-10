SHOWCASE LEVELS
===============

Eleven short levels, each introducing one Tilky feature. Each level's exit
loads the next one; the last goes back to the first. Every level has its own
folder with its level file (.bson), scripts and art. "Shared" holds the
textures and the scripts every level uses.

  01 First Steps          Player Controller: walk, run, stairs, jump, a springboard
                          Scripts: JumpPad.lua (trigger + Rigidbody velocity)
  02 Doors and Keys       Doors as sectors that move their ceiling, a locked door, a key
                          Scripts: Door.lua (sector script), KeyPickup.lua (Global table)
  03 Moving Floors        A lift and a pressure plate that raises a step
                          Scripts: Lift.lua (sector script), PressurePlate.lua (public Sector field)
  04 Lighting             Flickering, switchable and colour-cycling sector lights
                          Scripts: FlickerLight.lua, ColorCycle.lua, LightSwitch.lua
  05 Collectibles         Tagged coins, a HUD counter, a gate that opens when all are found
                          Scripts: Coin.lua, CoinCounter.lua, CoinGate.lua
  06 Flipbook Animation   Animated torches, spinning coins, a beeping beacon, a lever
                          Scripts: Beacon.lua and Lever.lua (flipbook frame events)
                          Animations: the .fpk files in "Animations"
  07 Sound                3D positional hum, a radio, sound pads
                          Scripts: Radio.lua, SoundPad.lua
  08 Open Sky             Equirectangular skybox, time of day, parent sectors
                          Scripts: TimeOfDay.lua
  09 Target Practice      Mouse input and raycast shooting
                          Scripts: Shooter.lua, Target.lua, TargetCounter.lua
  10 Room Over Room       One sector with two storeys stacked on top of each other
                          Scripts: StoreyDisplay.lua (sector:GetFloor(i), floorCount)
  11 3D Models            Furniture, cars on turntables, a model swapper, a garden
                          Scripts: Turntable.lua, ModelCycler.lua
                          Models: the .glb files in "Models"

Shared scripts (Shared/Scripts):
  LevelIntro.lua   fades the level title out after a few seconds
  HintZone.lua     sector script: shows a hint while the player is in the sector
  Prompt.lua       the "Press E to ..." message other scripts call into
  ExitPad.lua      loads the next level

How to play and export: README.lua

Controls: WASD move, mouse look, Shift run, Space jump, E use,
F (beacon in 06), R (radio speed in 07), 1/2/3 (time of day in 08),
left mouse button (shoot in 09).

Art and sound credits: CREDITS.txt
