-------------
-- Imports --
-------------

require "/scripts/util.lua"
require "/healthmonitor/user-preferences.lua"


----------
-- Init --
----------

local playerPrimaryHooks = luaHooks.vanilla["/stats/player_primary.lua"]
local questScopeHooks = luaHooks.questScopeHook["/quests/scripts/questscopehook.lua"]

local id = {
  healthMonitorInventoryStatusChange = "healthMonitorInventoryStatusChange",
  healthMonitorIsOnChange = "healthMonitorIsOnChange",
  lowHealthEffect = "healthMonitor.lowHealth"
}

local hmp = healthMonitor.preferences
local private = {}


----------
-- Main --
----------

function private.onPlayerInit(primaryPlayer)
  message.setHandler(
    id.healthMonitorInventoryStatusChange,
    function(_, _, hasHealthMonitor)
      primaryPlayer.hasHealthMonitor = hasHealthMonitor
    end
  )
end

function private.getIsLowHealthEffectEnabled(primaryPlayer)
  return primaryPlayer.hasHealthMonitor and hmp.getIsOn()
end

function private.onPlayerUpdate(primaryPlayer, dt)
  if not private.getIsLowHealthEffectEnabled(primaryPlayer) then
    if primaryPlayer.wasLowHealthEffectEnabled then
      status.clearPersistentEffects(id.lowHealthEffect)
      primaryPlayer.wasLowHealthEffectEnabled = false
    end
    return
  end
  primaryPlayer.wasLowHealthEffectEnabled = true

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

function private.onQuestScopeHookUpdate(questInstance)
  local hasHealthMonitor = player.hasItem("healthmonitor")
  local didHaveHealthMonitor = storage.hasHealthMonitor
  local hasSentInitialStatus = questInstance.hasSentInitialStatus

  if (
    hasHealthMonitor ~= didHaveHealthMonitor
    or not hasSentInitialStatus
  ) then
    storage.hasHealthMonitor = hasHealthMonitor

    world.sendEntityMessage(
      player.id(),
      id.healthMonitorInventoryStatusChange,
      hasHealthMonitor
    )

    if not hasSentInitialStatus then
      questInstance.hasSentInitialStatus = true
    end
  end
end


table.insert(playerPrimaryHooks.onInit, private.onPlayerInit)
table.insert(playerPrimaryHooks.onUpdate, private.onPlayerUpdate)
table.insert(questScopeHooks.onUpdate, private.onQuestScopeHookUpdate)
