--[[ /lua/scripts/Notify.lua by commodore white


--]]

return {
   on = {
      ['timer'] = 'every 5 minutes',
      "Alarm"
   },
   active = true,
   execute = function(domoticz, _device)
   
      local DURATION = 20
      
      local  timedEvent = _device == nil and true or false
      local  deviceEvent = not timedEvent
      
      local  _alarm = domoticz.devices["Alarm"]
      local  _siren = domoticz.devices["Siren"]
      
      if    deviceEvent
      then
      
            if    _device == _alarm 
            and   _alarm.state == "Off"                          -- alarm just got cancelled
            then
                  domoticz.devices["Siren"].switchOff()
                  domoticz.notify("Alarm cancelled",' ')
            end

      end -- deviceEvent
      
      if    timedEvent
      then
          
          _alarm = domoticz.devices["Alarm"]
          m_alarm = _alarm.lastUpdate.minutesAgo
          
          if     _alarm.state == "On"                            -- Alarm still active ?
          then                                                   -- If so, ...
                  if    m_alarm < DURATION
                  then
                        domoticz.notify ("Alarm raised " .. m_alarm .. "m ago", "Visit Control Panel to clear")
                  else
                        _alarm.switchOff()
                  end
           end

       end -- end if alarm
      
   end -- execute
}

 -- commandArray["OpenURL"]="http://192.168.1.22:8080/json.htm?type=command&param=resetsecuritystatus&idx=86&switchcmd=Normal"
            
