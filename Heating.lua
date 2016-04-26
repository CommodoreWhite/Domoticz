--[[ /lua/scripts/heating.lua by commodore white

Averages a thermometer over a given period and compares the result against
a thermostat to turn a heater on and off.

--]]

local Thermometer = "envKitchen"
local Thermostat = "Bedroom"
local Boiler = "boiler"
local Heating = "heating"         -- heating enable/disable switch
local tolerance = 0.25            -- hysteresis to deter rapid cycling
local period = 5                  -- period over which to average out variations in temperature 

local debug = true

return {
  active = false,
	on = { 'timer', Thermometer, Heating, Thermostat},
  data = {
        temperatures = { history = true, maxMinutes = period
        },
},
	execute = function(domoticz, device, eventInfo)
 
  local boiler = domoticz.devices[Boiler]
  local heating = domoticz.devices[Heating]
  local thermostat = domoticz.devices[Thermostat]

  local printf = function(s,...) print(s:format(...)) end

  if eventInfo.type == domoticz.EVENT_TYPE_DEVICE then   
     if device == domoticz.devices[Thermometer] then
         domoticz.data.temperatures.setNew(device.temperature)
     end
  end

  local target
  if domoticz.globalData.peopleAtHome then
      target = tonumber(thermostat.rawData[1])
  else
      target = 16
  end
  
  local avgTemp = domoticz.data.temperatures.avg()
  local BoilerCommand = ""
    if avgTemp == nil and heating.state == "On" then
        avgTemp = 0
        heating.switchOff()   -- switch off heating if there's
        BoilerCommand = "Off" -- .. no temperature measurements
        domoticz.notify("Heating turned Off", "Check thermometer")
    else
        if heating.state == "Off" then
            BoilerCommand = "Off"
        else
            if avgTemp > target + tolerance then BoilerCommand = "Off" end
            if avgTemp < target - tolerance then BoilerCommand = "On" end
        end
    end
    if BoilerCommand and boiler.state ~= BoilerCommand then boiler.setState(BoilerCommand) end

    if debug then
        local tail
        local fmt = "heating.lua: target: %2.1f  avgTemp (of %d): %2.2f"
        if heating.state == "On" then
            tail = " >> boiler: %s"
        else
            tail = " -- heating: Off"
        end
        printf(fmt..tail, target, #domoticz.data.temperatures.storage, avgTemp, BoilerCommand)
    end
       
	end -- execute
 
}