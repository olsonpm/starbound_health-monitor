----------
-- Init --
----------

local questScopeHooks = luaHooks.questScopeHook["/quests/scripts/questscopehook.lua"]

local id = {
  healthMonitorInventoryStatusChange = "healthMonitorInventoryStatusChange"
}

local private = {}


----------
-- Main --
----------

function private.onQuestScopeHookUpdate(questInstance)
  local hasHealthMonitor = player.hasItem("healthmonitor")
  local didHaveHealthMonitor = storage.hasHealthMonitor
  local hasSentInitialStatus = questInstance.hasSentInitialStatus

  if (
    hasSentInitialStatus
    and hasHealthMonitor == didHaveHealthMonitor
  ) then
    return
  end


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

table.insert(questScopeHooks.onUpdate, private.onQuestScopeHookUpdate)
