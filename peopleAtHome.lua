--[[ /lua/scripts/peopleAtHome.lua by commodore white

This dzVents script implements an android phone presence detector using the
Domoticz System Alive Checker (Ping) feature.

It works by seeing if the phone thats just been sucesfully pinged is in a list of recent previously
sucessful pings to phones (in the last 10-minutes because stale entries in the list are flushed
auto-magically by dzVents). If the phone wasn't in the list then a notification message is sent.

Each minute the names of the phones that are currently reachable are added to the top of list to keep
the list fresh as the System Alive Checker won't do it for you.

If there are any entries in the list then we set the peopleAtHome global as true else false.

--]]

return {
  active = false,
	on = { 'timer',
         'phone*' -- my phones have names like phonePeter and phoneRita
       },
  data = {
        phones = { history = true, maxMinutes = 10 }
        },
	execute = function(domoticz, device, eventInfo)
 
---[[ remove/comment-out to announce arrival of family members
 
     if eventInfo.type == domoticz.EVENT_TYPE_DEVICE and device.state == "On" then

         local recentlySeen = domoticz.data.phones.find(function(phone)
            return (phone.data == device.name)
         end)

         if not recentlySeen then
             print(device.name:sub(6) .. "'s phone found")
             domoticz.notify( "Look busy!", device.name:sub(6) .. " has returned to the fold" )
         end
         
      end

--]]

      domoticz.devices.forEach(function(device, key)
      
          if (device.name:sub(1,5) == "phone" and device.state == "On") then
              domoticz.data.phones.add(device.name)
          end
          
      end)
    
      domoticz.globalData.peopleAtHome = domoticz.data.phones.size ~= 0 
    
  end
}