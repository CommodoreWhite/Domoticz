--[[ /lua/scripts/killalarm.lua by commodore white

Kills any alarms as soon as a registered user gets home

--]]

return { on = {"AnyPhone"}, active = true,
   
   execute = function(domoticz, _anyphone)
   
      _alarm    = domoticz.devices["Alarm"]

      if     _anyphone.state == "On"                           -- someone has arrived while
      and    _alarm.state == "On"                               -- the alarms are on?
      then
             _alarm.switchOff()                                -- if so, kill the alarm
      end
 
   end -- execute
}
