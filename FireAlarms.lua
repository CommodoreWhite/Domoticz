--[[ /lua/scripts/fire.lua by commodore white

Notifies which alarm has been triggered

All fire alarms have names that begin with the characters "fire", for example, fireLounge, fireGarage, etc

--]]

return {
	active = true,
	on = { "fire*" },

	execute = function(domoticz, _sounder)
 
    if _sounder.state == "On" then        
 
       local DURATION = 40
     
       domoticz.notify("FIRE ALARM: " .. _sounder.name, '',
          domoticz.PRIORITY_EMERGENCY,
          domoticz.SOUND_SIREN)
          
       domoticz.devices["Alarm"].switchOn()    -- turn on the notify system
       
    end -- if sounder On

	end -- function
}