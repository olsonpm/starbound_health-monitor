--
-- README
--   The following is a hack around the lack of 'storage' limitation in the
--   player_primary.lua script.  We use getPersistentEffects to store data
--   across gaming sessiosn.
--

-------------
-- Imports --
-------------

require "/scripts/util.lua"


----------
-- Init --
----------

healthMonitor = healthMonitor or {}
healthMonitor.preferences = {}

local hmp = healthMonitor.preferences
local private = {}

local id = {
  prefs = "healthMonitor.preferences",
  activeAtPercent = "healthMonitor.preferences.activeAtPercent",
  isOn = "healthMonitor.preferences.isOn",
}

local defaults = {
  activeAtPercent = 0.4,
  --
  -- because 0 is the default return value for stat and for some reason stat
  --   seems to be an unsigned float, 1 = off 2 = on
  --
  isOn = 1
}


----------
-- Main --
----------

--
-- These could be generated via a function bu two props isn't worth
--   the abstraction
--
function hmp.getIsOn()
  local isOn = status.stat(id.isOn)
  if isOn == 0 then
    private.setPrefs(defaults)
    return defaults.isOn
  else
    return isOn == 2
  end
end
function hmp.setIsOn(isOn)
  private.setPrefs({ isOn = isOn })
end

function hmp.getActiveAtPercent()
  local activeAtPercent = status.stat(id.activeAtPercent)
  if activeAtPercent == 0 then
    private.setPrefs(defaults)
    return defaults.activeAtPercent
  else
    return activeAtPercent
  end
end
function hmp.setActiveAtPercent(activeAtPercent)
  private.setPrefs({ activeAtPercent = activeAtPercent })
end


----------------------
-- Helper Functions --
----------------------

--
-- Because I doubt we can modify existing persistent effects by modifying the
--   array returned by 'get', I'm just going to clear and re-set the array every
--   time a setting is modified.
--
function private.setPrefs(newPrefs)
  local activeAtPercent = newPrefs.activeAtPercent or hmp.getActiveAtPercent()
  local isOn = newPrefs.isOn

  if isOn == nil then
    isOn = hmp.getIsOn()
  end

  status.clearPersistentEffects(id.prefs)
  status.addPersistentEffects(
    id.prefs,
    {
      {
        stat = id.activeAtPercent,
        amount = activeAtPercent
      },
      {
        stat = id.isOn,
        amount = isOn and 2 or 1
      }
    }
  )
end
