-------------
-- Imports --
-------------

require "/healthmonitor/user-preferences.lua"


----------
-- Init --
----------

local old = {
  init = init,
  update = update
}

local id = {
  healthMonitorInventoryStatusChange = "healthMonitorInventoryStatusChange",
  lowHealthEffect = "healthMonitor.lowHealth"
}

local hmp = healthMonitor.preferences
local private = {}


----------
-- Main --
----------

function init(...)
  message.setHandler(
    id.healthMonitorInventoryStatusChange,
    function(_, _, hasHealthMonitor)
      self.hasHealthMonitor = hasHealthMonitor
    end
  )

  old.init(...)
end

function update(dt, ...)
  if not private.getIsLowHealthEffectEnabled(self) then
    if self.wasLowHealthEffectEnabled then
      status.clearPersistentEffects(id.lowHealthEffect)
      self.wasLowHealthEffectEnabled = false
    end
  else
    self.wasLowHealthEffectEnabled = true

    local hasLessThanConfiguredHealth = status.resourcePercentage("health") <= hmp.getActiveAtPercent()

    --
    -- Not sure why the devs don't allow us to specify a single persistent
    --   effect, i.e. we're forced to use their concept of a "category".  It'd
    --   also be nice to have a definition for "category".  The vanilla code
    --   doesn't really explain it - thus I'm stuck writing some repetitive
    --   strings (lowHealth && lowhealth)
    --
    local hasLowHealthEffect = contains(
      status.getPersistentEffects(id.lowHealthEffect),
      "lowhealth"
    )

    if hasLessThanConfiguredHealth and not hasLowHealthEffect then
      status.addPersistentEffect(id.lowHealthEffect, "lowhealth")
    elseif not hasLessThanConfiguredHealth and hasLowHealthEffect then
      status.clearPersistentEffects(id.lowHealthEffect)
    end
  end

  old.update(dt, ...)
end


----------------------
-- Helper Functions --
----------------------

function private.getIsLowHealthEffectEnabled(primaryPlayer)
  return primaryPlayer.hasHealthMonitor and hmp.getIsOn()
end
