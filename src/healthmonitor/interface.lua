-------------
-- Imports --
-------------

require "/scripts/util.lua"
require "/healthmonitor/user-preferences.lua"


----------
-- Init --
----------

healthMonitor = healthMonitor or {}
healthMonitor.interface = {
  callback = {}
}

local hmicb = healthMonitor.interface.callback
local hmp = healthMonitor.preferences
local private = {}


----------
-- Main --
----------

function init()
  private.updateCheckboxWidget()
  private.updatePercentLabel()
end

function uninit()
  --
  -- tell our active item we've closed the interface so it doesn't
  --   interact again
  --
  world.sendEntityMessage(
    config.getParameter("ownerId"),
    "healthMonitor.activeItem"
  )
end


---------------
-- Callbacks --
---------------

function hmicb.modifyPercent(_, data)
  local min, max = 0.1, 0.8
  local newActiveAtPercent = util.clamp(
    hmp.getActiveAtPercent() + data,
    min,
    max
  )
  hmp.setActiveAtPercent(newActiveAtPercent)
  private.updatePercentLabel()
end

function hmicb.toggleIsOn()
  hmp.setIsOn(not hmp.getIsOn())
  private.updateCheckboxWidget()
end


-----------------------
-- Private Functions --
-----------------------

function private.updateCheckboxWidget()
  widget.setChecked("isOnCheckbox", hmp.getIsOn())
end
function private.updatePercentLabel()
  local label = math.floor(util.round(
    hmp.getActiveAtPercent() * 100
  )) .. "%"

  widget.setText("percentLabel", label)
end
