--[[ /lua/scripts/PanicButton.lua by commodore white

Always report panic button presses. There's one in my aged relatives bedroom (panicBedroom),
one in their bathroom (panicBathroom), and another by the front door (panicFrontDoor)

If any panic button is pressed, then the "AnyPanic" device is either turned On or toggled.

--]]

    local  OVERDUE = 20 -- minutes
    local  REPORT_INTERVAL = 5 -- minutes
    local  PREFIX = "panic"
    
return {
  active = true,
	on = { 'panic*',                                             -- any panic button
         'AnyPanic',                                           -- cancel panic button
--         'fobKeyfob',
         'timer'
        },
	execute = function(domoticz, _device)
 
    local  is_timedEvent  = _device == nil and true or false
    local  is_deviceEvent = not is_timedEvent
    
    local  _anypanic = domoticz.devices["AnyPanic"]             -- Get id of AnyPanic
    
-- comment out the following once the script is working
    if _anypanic == nil then print("PanicButton.lua: Missing AnyPanic device") return end
    
    if    is_deviceEvent                                        -- handle device events
    then
          if    _device == _anypanic
          and   _anypanic.state == "Off"
          then
                domoticz.notify("Panic over!", 'Stand down')
          end

          if    _device.name:sub(1,5) == "panic"
          then
                if     _anypanic.state == "Off"
                then
                      domoticz.notify("PANIC BUTTON", _device.name:sub(6) .. ' button was pressed')
                      _anypanic.switchOn()                             -- Turn On Panic mode
                else
-- uncomment the following to have Panic buttons work in toggle (enable/disable) mode
--                    _anypanic.switchOff()

-- uncomment the following to report every panic button press
--                    domoticz.notify("PANIC BUTTON", _device.name:sub(6) .. ' button was pressed')
                end
          end -- panic* device
          
-- Uncomment the following if you want to use keyfobs or somesuch to cancel Panic alarms perhaps
-- because you use Panic butons to only set Panic mode, rather than toggle it
--          if _device.name == "fobKeyfob" then _anypanic.switchOff() end

    end -- deviceEvent
--
    if    is_timedEvent                                            -- handle periodic reminders and
    then                                                           -- and overdue handling
          if    _anypanic.state == "On" 
          then
                local anypanic_age = _anypanic.lastUpdate.minutesAgo
                if    anypanic_age > OVERDUE                        -- resolution of panic event overdue ?
                then                                               -- if so
                      _anypanic.switchOff()                        -- stop reporting
                else                                               -- if not
                      if     anypanic_age%REPORT_INTERVAL == 0     -- check reporting rate
                      and    anypanic_age ~= 0                     -- ignore first time
                      then 
                             domoticz.notify("Panic called", anypanic_age .. "m ago")
                      end
                end
          end

     end -- timedEvent
        
	end -- execute
 
}