-- /lua/scripts/siren.lua by commodore white

-- switches the siren off and on for as long as "Alarm" is On

return {
  active = true,
	on = { "Siren" },
	execute = function(domoticz, siren)
 
     local  alarm = domoticz.devices["Alarm"]

     if    siren.state == "All On"                          -- if siren is On
     then 
           siren.switchOff().after_sec(10)                  -- ... every 10 seconds
     else                                                    -- whilst alarms
           if    alarm.state == "On"
           then  siren.switchOn().after_sec(10)
           end                      
     end                     

	end -- execute

}