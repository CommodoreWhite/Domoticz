-- /lua/scripts/CheckDeadDevices.lua by commodore.white

-- Adapted from the original by Danny. The modification also reports devices that
-- should be tested but can't be found.

local devicesToCheck = {
--	{ ['name'] = 'Sensor1', ['threshold'] = 0},
	{ ['name'] = 'envKitchen', ['threshold'] = 30 },
	{ ['name'] = 'phonePeter', ['threshold'] = 0 }
}

return {
	active = false,
	on = {
		['timer'] = 'every 5 minutes'
	},
	execute = function(domoticz)

		local message = ""

		for i, deviceToCheck in pairs(devicesToCheck) do
			local name = deviceToCheck['name']
      local device = domoticz.devices[name]
      if device == nil then
        message = message .. 'Device ' .. name .. ' is missing.\r'
      else
			  local threshold = deviceToCheck['threshold']
			  local minutes = domoticz.devices[name].lastUpdate.minutesAgo

			  if (threshold ~= 0) and ( minutes > threshold) then
				  message = message .. 'Device ' ..
						  name .. ' seems to be dead. No heartbeat for at least ' ..
						  minutes .. ' minutes.\r'
			  end
		  end -- device == nil
    end -- for

    if (message ~= "") then
--			domoticz.email('Dead devices', message, 'me@address.nl')
      domoticz.log('Dead devices found: ' .. message, domoticz.LOG_ERROR)
    end
	end
}

