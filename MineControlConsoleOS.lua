-- MineControlConsoleOS by Brendan Russell
-- Beta Release V1.0 

local function Boot()
os.setComputerLabel("Mine Control Console")
term.clear()
term.setCursorPos(1,1)
print("Initializing Boot Sequence")
textutils.slowPrint("Booting MCC", 15)
local booting = 0
for i=1,100 do
booting = booting + 1
term.setCursorPos(0,3)
term.clearLine()
term.setCursorPos(1,3)
print(booting.."%")
textutils.slowWrite("  ",40)
end
end

local function Connect()
term.clear()
term.setCursorPos(1,1)
textutils.slowPrint("Mine Control Console \(MCC\)")
print("--------------------------")
textutils.slowPrint("Connecting to MineSlave",10)
textutils.slowPrint("Sending signal",10)
textutils.slowPrint("Waiting for connection",10)
local scrap, connection = "waitingforconnection"
repeat
term.setCursorPos(1,6)
term.clearLine()
textutils.slowPrint(". . . . . . . . . . .")
rednet.broadcast("MCC")
scrap, connection = rednet.receive(2)
until connection == "MSConnected"
print("Connection Success")
print("--------------------------")
end

local function SendParameters()
term.clear()
term.setCursorPos(1,1)
textutils.slowPrint("Sending Parameters")
textutils.slowPrint("Enter values")
rednet.broadcast("sndParam")
textutils.slowWrite("Distance forward: ")
local front = tonumber(read())
sending = "waiting"
local oldx, oldy = term.getCursorPos()
repeat
term.setCursorPos(1,oldy)
term.clearLine()
textutils.slowPrint("transmitting")
rednet.broadcast(front)
scrap, sending = rednet.receive(5)
until sending == "transmissionReceived"
textutils.slowPrint("Transmission Success")
textutils.slowWrite("left or right: ")
local side = read()
sending = "waiting"
local oldx, oldy = term.getCursorPos()
repeat
term.setCursorPos(1,oldy)
term.clearLine()
textutils.slowPrint("transmitting")
rednet.broadcast(side)
scrap, sending = rednet.receive(5)
until sending == "transmissionReceived"
textutils.slowPrint("Transmission Success")
textutils.slowWrite("distance to the side: ")
local distance = tonumber(read())
sending = "waiting"
local oldx, oldy = term.getCursorPos()
repeat
term.setCursorPos(1,oldy)
term.clearLine()
textutils.slowPrint("transmitting")
rednet.broadcast(distance)
scrap, sending = rednet.receive(5)
until sending == "transmissionReceived"
textutils.slowPrint("Transmission Success")
textutils.slowWrite("Length: ")
local length = tonumber(read())
local scrap, sending = "waiting"
local oldx, oldy = term.getCursorPos()
repeat
term.setCursorPos(1,oldy)
term.clearLine()
textutils.slowPrint("transmitting")
rednet.broadcast(length)
scrap, sending = rednet.receive(5)
until sending == "transmissionReceived"
textutils.slowPrint("Transmission Success")
textutils.slowWrite("Width: ")
local width = tonumber(read())
sending = "waiting"
local oldx, oldy = term.getCursorPos()
repeat
term.setCursorPos(1,oldy)
term.clearLine()
textutils.slowPrint("transmitting")
rednet.broadcast(width)
scrap, sending = rednet.receive(5)
until sending == "transmissionReceived"
textutils.slowPrint("Transmission Success")
textutils.slowWrite("Depth: ")
local depth = tonumber(read())
sending = "waiting"
local oldx, oldy = term.getCursorPos()
repeat
term.setCursorPos(1,oldy)
term.clearLine()
textutils.slowPrint("transmitting")
rednet.broadcast(depth)
scrap, sending = rednet.receive(5)
until sending == "transmissionReceived"
textutils.slowPrint("Transmission Success")
textutils.slowPrint("Parameters Set")
end

local function Launch()
textutils.slowPrint("Engage Launch Sequence")
scrap = read()
textutils.slowPrint("Sending Launch Codes")
rednet.broadcast("launch")
local scrap, validation = rednet.receive()
textutils.slowPrint(validation)
if validation == "WARNING FUEL LOW" then
scrap = read()
rednet.broadcast("launch")
local scrap, validation = rednet.receive()
print(" ")
local oldx, oldy = term.getCursorPos()
for i=1,11 do
local scrap, countdown = rednet.receive()
term.setCursorPos(1,oldy)
term.clearLine()
print("Launching in "..countdown.." seconds")
end
local scrap, launched = rednet.receive()
if launched == "launching" then
textutils.slowPrint("Launch Success")
end
else
print(" ")
local oldx, oldy = term.getCursorPos()
for i=1,11 do
local scrap, countdown = rednet.receive()
term.setCursorPos(1,oldy)
term.clearLine()
print("Launching in "..countdown.." seconds")
end
local scrap, launched = rednet.receive()
if launched == "launching" then
textutils.slowPrint("Launch Success")
end
end
end


local function Menu()
textutils.slowPrint("Initialize Parameters")
scrap = read()
SendParameters()
end

local function HomeScreen()
term.clear()
term.setCursorPos(1,1)
print("Mine Control Console \(MCC\)")
print("--------------------------")
print("Connecting to MineSlave")
print("Sending signal")
print("Waiting for connection")
print(". . . . . . . . . . .")
print("Connection Success")
print("--------------------------")
print("Initialize Parameters")
print("Parameters Set")
print("--------------------------")

end

local function Title()
term.setCursorPos(1,3)
term.clearLine()
term.setCursorPos(1,2)
term.clearLine()
term.setCursorPos(1,1)
term.clearLine()
print("Mine Control Console \(MCC\)")
print("--------------------------")
print("Monitoring MineSlave:")
end


local function terminate()
   while true do
      stopMining = read()
      if stopMining == "return" then
         print("Sending Signal")
         rednet.broadcast("terminate")
	     break
      elseif  stopProgram == "yes" then
	     break
	  end
	    
   end
end   

local function monitorRednet()
   term.clear()
   Title()
   term.setCursorPos(1,4)
   stopProgram = "no"
   while true do
      local scrap, data = rednet.receive()
      print(data)
	  local oldx, oldy = term.getCursorPos()
	  Title()
	  term.setCursorPos(oldx,oldy)
      if data == "Shutting Down" then
         break
      end
      if data == "Mine Finished: Shutting Down" then
	     rednet.broadcast("mineEnd")
	     stopProgram = "yes"
         break
      end		 
   end
end


local function main()
   Boot()
   rednet.open("back")
   Connect()
   Menu()
   HomeScreen()
   Launch()
   parallel.waitForAll(terminate, monitorRednet)
end

main()