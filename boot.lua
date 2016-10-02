os.pullEvent = os.pullEventRaw

local w, h = term.getSize()

--ik this isn't needed, but I hate putting the desktop env in startup.
_G.deltaOS = true
--for programs who would like to know that is deltaOS or not installed

term.redirect( term.native() )

_G.develop = false


if shell then
 _G.shell = shell
end










local function init()


local tLib = fs.list( "/lib" )
for k, v in pairs( tLib ) do
 if not fs.isDir(v) then
  dofile("/lib/"..v)
 end
end

--[[
if settings.getSetting("monitor", 1) == true then
 if peripheral.getType(settings.getSetting("monitor", 2)) ~= "monitor" then
    print("A monitor side has been specified, but it is an invalid redirect target!")
 else
    print("Wrapping to monitor!")
    local monitorWrap = peripheral.wrap(settings.getSetting("monitor", 2))
    term.redirect(monitorWrap)
 end
end]]--

  shell.run("/system/launchpad.lua")
end

init()
