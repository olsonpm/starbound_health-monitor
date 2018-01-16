function init()
  self.isActive = false

  message.setHandler(
    "healthMonitor.activeItem",
    function() self.isActive = false end
  )
end

function activate()
  if not self.isActive then
    self.isActive = true
    local interfaceConfig = root.assetJson("/healthmonitor/interface.json")
    interfaceConfig.ownerId = activeItem.ownerEntityId()
    activeItem.interact("ScriptPane", interfaceConfig)
  end
end
