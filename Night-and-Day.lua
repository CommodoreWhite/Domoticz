-- /lua/scripts/night-and-day.lua

return {
	active = true,
	on = { 'timer' },

	execute = function(domoticz)
 
    _IsDark = domoticz.devices["vIsDark"]
 
    IsDark = (domoticz.time.isNightTime and "On" or "Off")
    
    if _IsDark.state ~= IsDark then _IsDark.setState(IsDark) end
    
	end -- function
}