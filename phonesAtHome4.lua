-- /lua/scripts/phonesAtHome3.lua by commodore white

return {
  active = true,
	on = { "phone*", "timer" },
  data = { phonesAtHome_State = { initial = {} }, phonesAtHome_Time = {initial={}} },
	execute = function(domoticz, device , eventInfo)
 
    local GRACE = 12*60 -- seconds
      
--[[
    domoticz.data.phonesAtHome_State = {}
    domoticz.data.phonesAtHome_Time = {}
    domoticz.globalData.phonesAtHome = {}
--]]

    -- record phones that get connected
    if device ~= nil then
        if (domoticz.data.phonesAtHome_Time[device.name] == nil or os.time() - domoticz.data.phonesAtHome_Time[device.name] > GRACE)
        and device.state == "On" then
            domoticz.notify("Look busy!", device.name:sub(6) .. " has returned to the fold")
        end
        domoticz.data.phonesAtHome_Time[device.name] = os.time()
    end
  
    -- for each phone
    local phoneAtHome = false
    for phone,timestamp in pairs(domoticz.data.phonesAtHome_Time) do
    
        -- keep phone entry fresh
       if domoticz.devices[phone].state == "On" then
           domoticz.data.phonesAtHome_Time[phone] = os.time()     
       end
       
       local age = os.time() - domoticz.data.phonesAtHome_Time[phone]
       local state = "Off"
       if age < GRACE then
           state = "On"
           phoneAtHome = true
       end
       print("phonesAtHome4: " .. phone.." State="..state.."   Seen "..age.."s ago")

       if domoticz.globalData.phonesAtHome[phone] == "On" and state == "Off" then
           domoticz.notify(phone:sub(6) .. " has left the building", "")
       end
       domoticz.globalData.phonesAtHome[phone] = state
    end
    
    domoticz.globalData.peopleAtHome = phoneAtHome

   end
}