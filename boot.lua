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


version = "LYNX-1.5"

--Required files
local rf = {"/system", "/system/framework", "/system/framework/desktop.lua", "system/media/delta.nfp", "/startup", "/apis/sha256"}




os.loadAPI("/apis/kernel")
os.loadAPI("/apis/delta")
os.loadAPI("/apis/graphics")

local function init()

os.loadAPI("/apis/delta")
os.loadAPI("/apis/kernel")
os.loadAPI("/apis/graphics")


if OneOS then
    OneOS.RequestRunAtStartup()
end


local function checkForUpdates()
 local filev = fs.open("version", "r")
 local build = tonumber( filev.readAll() )
 filev.close()
 local latest = http.get("https://raw.githubusercontent.com/FlareHAX0R/deltaOS/master/version")
 if latest and latest.readAll then
	local lb = latest.readAll()
	latest.close()
	if lb == nil or lb == nll then
	return false
	end
	if tonumber(lb) > build then
		return true
	end
 end
 return false
end




graphics.reset(colors.black)
sleep(0.1)
graphics.reset(colors.gray)
sleep(0.1)
graphics.reset(colors.lightGray)
sleep(0.1)
graphics.reset(colors.white)
sleep(0.1)
os.loadAPI("/apis/kernel")
term.setCursorPos(1, h-3)
graphics.cPrint("Loading")

os.loadAPI("/apis/users")
local tApis = fs.list( "/apis" )
for k, v in pairs( tApis ) do
 if not fs.isDir(v) then
  os.loadAPI("/apis/"..v)
 end
end

local tLib = fs.list( "/lib" )
for k, v in pairs( tLib ) do
 if not fs.isDir(v) then
  dofile("/lib/"..v)
 end
end

if fs.exists("/system/.setup_trigger") then
 shell.run("/system/framework/ft-setup")
 fs.delete("/system/.setup_trigger")
end




graphics.reset(colors.white, colors.black)
--graphics.drawLine(1, colors.black)
--graphics.drawLine(kernel.y, colors.lightGray)
term.setBackgroundColor(colors.white)


if settings.getSetting("monitor", 1) == true then
 if peripheral.getType(settings.getSetting("monitor", 2)) ~= "monitor" then
    print("A monitor side has been specified, but it is an invalid redirect target!")
 else
    print("Wrapping to monitor!")
    local monitorWrap = peripheral.wrap(settings.getSetting("monitor", 2))
    term.redirect(monitorWrap)
 end
end


os.loadAPI("apis/kernel")
graphics.reset(colors.white, colors.black)
term.setCursorPos(1, kernel.y/2-2)
graphics.cPrint("DeltaOS")




if checkForUpdates() == true and _G.develop == false then
 local d = Dialog.new(nil, nil, nil, nil, "DeltaOS", {"A update is avaiable,", "update now?"}, true,true)
 local result = d:autoCaptureEvents()
 if result == "ok" then
  graphics.reset(colors.white, colors.black)
  print(" ")
  graphics.cPrint("Updating DeltaOS to the latest build...")
  shell.run("system/update")
 else
  graphics.reset(colors.white, colors.black)
  term.current().setCursorPos(1, kernel.y/2-2)
  graphics.cPrint("DeltaOS")
 end
end



if storage.totalKB() <= 25 then
 term.setCursorPos(1, kernel.y/2+1)
 term.clearLine()
 graphics.cPrint(":( We detected that you are low on storage space.")
 graphics.cPrint("You have "..tostring(storage.totalKB()).." KB left.")
end
sleep(1.5)


local function runDesktop()
 shell.run("/system/framework/desktop.lua")
end

local function monServ()
 while true do
  local event,side,x,y = os.pullEvent("monitor_touch")
  if x ~= nil and y ~= nil then
   if type(x) == "number" and type(y) == "number" then
    os.queueEvent("mouse_click", 1, x, y)
   end
  end
 end
end

parallel.waitForAll(runDesktop, monServ)
end

kernel.extendedCatnip(init)