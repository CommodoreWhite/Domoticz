--[[ /lua/scripts/phonesAtHome4.lua by commodore white

Maintains:
    a local list of phones and when they were last seen,
    a global list of phones, phonesAtHome, and whether or not they are at home, and
    a global variable, peopleAtHome, if any phone is at home
--]]

return {
  active = false,
	on = { "phone*", "timer" },
  data = {  phonesAtHome_Time = {initial={}} },
	execute = function(domoticz, device , triggerInfo)
 
    local GRACE = 12*60 -- seconds how long a phone can be away before its marked as absent
      
--[[
    domoticz.data.phonesAtHome_Time = {}
    domoticz.globalData.phonesAtHome = {}
--]]

    -- record phones that get connected
    if triggerInfo.type == domoticz.EVENT_TYPE_DEVICE and device.state == "On" then
        -- notify if phone not listed or has been away for a while
        if (domoticz.data.phonesAtHome_Time[device.name] == nil or os.time() - domoticz.data.phonesAtHome_Time[device.name] > GRACE) then
            domoticz.notify("Look busy!", device.name:sub(6) .. " is home")
        end
        domoticz.data.phonesAtHome_Time[device.name] = os.time()
    end
  
    -- for each phone listed
    local phoneAtHome = false
    for phone,timestamp in pairs(domoticz.data.phonesAtHome_Time) do
    
       -- keep phone entry fresh
       if domoticz.devices[phone].state == "On" then
           domoticz.data.phonesAtHome_Time[phone] = os.time()     
       end
       
       -- mark stale phones as absent
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