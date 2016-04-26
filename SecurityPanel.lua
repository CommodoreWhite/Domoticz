--[[ /lua/scripts/security.lua by commodore white

This script handles the Security Panel. When security is enabled it first checks if any doors or windows
are alarmed and reports it via messaging.

Shortly after security is enabled, the alarms are enabled and disabled immediately security is disabled.

You'll need to create a virtual device called AlarmsEnabled to use this script.

--]]

return {
	active = true,
	on = { "Security Panel", "AlarmsEnabled",
         "timer" },

	execute = function(domoticz,_device)
  
    DELAY = 30
    _AlarmsEnabled = domoticz.devices["AlarmsEnabled"]
    
    -- If the Security Panel has changed state

    if    _device == domoticz.devices["Security Panel"]
    then
         if    domoticz.security == domoticz.SECURITY_DISARMED
         then         
             if    _AlarmsEnabled.state == "On"      -- prevent spurious disarm events
             then  _AlarmsEnabled.switchOff() end
         else
         
         -- check if any doors or windows are alarmed

              openings = 0
--[[ Mine are not working at present
              domoticz.devices.forEach(function(_sensor)
                if    (_sensor.name:sub(1,3) == "msc")
                and   _sensor.state == "Alarm"
                then  openings = openings + 1 end
              end) -- for each
--]]
              if    _AlarmsEnabled.state == "On"
              then  message = "Alarms already enabled"
              else  message = "Alarms enabled in " .. DELAY .. "s" end
              
              if    openings == 0
              then  domoticz.notify("Property seems secure", message)
              else  domoticz.notify(openings .. " openings need securing", message) end
      
              -- schedule alarms to be enabled in DELAY seconds if its not already On
      
              if    _AlarmsEnabled.state ~= "On"
              then  _AlarmsEnabled.switchOn().after_sec(DELAY) end

          end -- security panel state is disarmed
      
    end -- if security panel state changed
    
    -- If the Security Panel state was changed to DISARMED while the alarms are waiting
    -- to be enabled, switch Off the alarms. Shame there's not a cancel function.
    
    if     _AlarmsEnabled.state == "On"
    and    domoticz.security == domoticz.SECURITY_DISARMED
    then   _AlarmsEnabled.switchOff() end
    
    -- Notify everyone when alarms have been enabled or disabled
    
    if    _device == _AlarmsEnabled
    then
          if    _device.state == "On"
          then  domoticz.notify("Alarms enabled", '')
          else  domoticz.notify("Alarms disabled", '') end
    end

  end -- function
}
