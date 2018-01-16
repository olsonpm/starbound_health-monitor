----------
-- Init --
----------

local private = {}


----------
-- Main --
----------

function init()
  self.soundInterval = 1
  self.soundTimer = 0
  self.bleedingEmitters = private.createBleedingEmitters()
end

function update(dt)
  private.tickBleedingEmitters(self, dt)
  private.tickSound(self, dt)
end


-----------------------
-- Private Functions --
-----------------------

function private.tickSound(self, dt)
  local isHungry = status.resourcePercentage("food") <= 0.15
  self.soundTimer = math.max(0, self.soundTimer - dt)

  if not isHungry and self.soundTimer == 0 then
    animator.playSound("beep")
    self.soundTimer = self.soundInterval
  end
end

function private.tickBleedingEmitters(self, dt)
  for _, aBleedingEmitter in ipairs(self.bleedingEmitters) do
    local timer = aBleedingEmitter.timer
    timer = math.max(0, timer - dt)
    if timer == 0 then
      animator.burstParticleEmitter(private.pickRandomBleedingEmitter())
      aBleedingEmitter.timer = private.createRandomBleedingInterval()
    else
      aBleedingEmitter.timer = timer
    end
  end
end

function private.pickRandomBleedingEmitter()
  local leftOrRight = "left"
  if math.random(2) == 1 then leftOrRight = "right" end
  local bleedVariant = math.random(3)
  return "bleed" .. leftOrRight .. bleedVariant
end

function private.createBleedingEmitters()
  local bleedingEmitters = {}
  for i = 1, 3 do
    bleedingEmitters[i] = {
      timer = private.createRandomBleedingInterval()
    }
  end

  return bleedingEmitters
end

function private.createRandomBleedingInterval()
  local max = 3
  local min = 0.2
  return math.random() * (max - min) + min;
end
