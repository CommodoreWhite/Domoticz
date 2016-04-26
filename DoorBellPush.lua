--[[ /lua/scripts/doorbellpush.lua by commodore white

Notify if any door bell was pressed
Ignore multiple presses within a few seconds

--]]

return {
  active = true,
	on = { 'bell*' },
  data = { whenPreviouslyPressed = { initial = 0 }},
	execute = function(domoticz, bellpush)
  
    if os.time() - domoticz.data.whenPreviouslyPressed > 10 then
        domoticz.notify("DOOR BELL", bellpush.name:sub(5) .. ' bell was pressed')
    end   

    domoticz.data.whenPreviouslyPressed = os.time()                                            
      
	end -- execute
}
