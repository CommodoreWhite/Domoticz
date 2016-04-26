--[[ /lua/scripts/IntruderAlarm.lua by commodore white

Report PIR and door/window opening/closing events unless alarm reporting is disabled
sounds a siren if security is high unless a registered phone is nearby

          disarmed or
           suspended     armed home       armed away
          +-------------------------------------------
internal  |  No              No          Notify+Siren                 
          |
perimeter |  No            Notify        Notify+Siren
          +-------------------------------------------
--]]

return {
  active = true,
	on = { 'pir*',    -- internal detectors
--        "msc*"    -- perimeter detectors
  },
	execute = function(domoticz, _detector, eventInfo)
 
local    _AnyPhone = domoticz.devices["AnyPhone"]
local    _debug = domoticz.variables["debugMotion"] if _debug == nil then debug = false else debug = _debug.bState end
local    security = domoticz.security
 
-- test mode: no alarms if someone is at home, comment out for normal operation
--    if _AnyPhone.state == "On" then return end

    if    security == domoticz.SECURITY_DISARMED then return end             -- don't report if security is DISARMED
    
    if    domoticz.devices["AlarmsEnabled"].state == "Off" then return end   -- ... or if alarms are temporarily suspended

    if    _detector.name:sub(1,3) == "pir"                                   -- ignore internal detectors in
    and   security == domoticz.SECURITY_ARMEDHOME                            -- low security mode
    then 
          return
    end

    domoticz.notify('SECURITY BREACH', _detector.name:sub(4), domoticz.PRIORITY_EMERGENCY, domoticz.SOUND_SIREN)
       
    if    security == domoticz.SECURITY_ARMEDAWAY                        -- in high security mode
-- comment out the following while testing !
    and   _AnyPhone.state == "Off"                                             -- check no one is at home
    then
          domoticz.devices["Siren"].switchOn()                                 -- then set off the siren
    end
 
	end -- execute
}