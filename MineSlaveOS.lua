-- MineSlaveOS by Brendan Russell
-- Beta Release V1.0

local function Boot()
os.setComputerLabel("Mine Slave")
term.clear()
term.setCursorPos(1,1)
print("Initializing Boot Sequence")
textutils.slowPrint("Booting MS", 15)
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
textutils.slowPrint("Mine Slave \(MS\)")
print("--------------------------")
print ("Waiting For Connection")
local scrap, connection = "awaitingconnection"
repeat
term.setCursorPos(0,4)
term.clearLine()
term.setCursorPos(1,4)
textutils.slowPrint(". . . . . . . . . . .",15)
scrap, connection = rednet.receive(3)
until connection == "MCC"
rednet.broadcast("MSConnected")
print("Connection Success")
end



local function ReceiveParameters()
print("--------------------------")
textutils.slowPrint("Awaiting Parameters")
local scrap, param = rednet.receive()
if param == "sndParam" then
local scrap, front = rednet.receive()
textutils.slowPrint("distance front = "..front)
rednet.broadcast("transmissionReceived")
local scrap, side = rednet.receive()
textutils.slowPrint("side = "..side)
rednet.broadcast("transmissionReceived")
local scrap, distance = rednet.receive()
textutils.slowPrint("Distance to side = "..distance)
rednet.broadcast("transmissionReceived")
local scrap, length = rednet.receive()
textutils.slowPrint("length = "..length)
rednet.broadcast("transmissionReceived")
local scrap, width = rednet.receive()
textutils.slowPrint("width = "..width)
rednet.broadcast("transmissionReceived")
local scrap, depth = rednet.receive()
textutils.slowPrint("depth = "..depth)
rednet.broadcast("transmissionReceived")
textutils.slowPrint("Parameters Set")
return front, side, distance, length, width, depth
end
end





local function Launch()
   print("--------------------------")
   textutils.slowPrint("Awaiting Orders")
   local scrap, LaunchTime = rednet.receive()
   if LaunchTime == "launch" then
      if turtle.getFuelLevel() < MinFuel then
         rednet.broadcast("WARNING FUEL LOW")
         local scrap, proceed = rednet.receive()
         rednet.broadcast("Launch Codes Accepted")
         textutils.slowPrint("Launch Codes Accepted",10)
         local countdown = 11
         print(" ")
         local oldx, oldy = term.getCursorPos()
         local y = oldy - 1
         for i=1,11 do
         countdown = countdown - 1
         term.setCursorPos(1,y)
         term.clearLine()
         rednet.broadcast(countdown)
         print("Launching in "..countdown.." seconds")
         textutils.slowWrite("  ",2)
         end
         term.setCursorPos(1,oldy)
         term.clearLine()
         textutils.slowPrint("Launch Success")
         rednet.broadcast("launching")
      elseif turtle.getFuelLevel() >= MinFuel then
         rednet.broadcast("Launch Codes Accepted")
         textutils.slowPrint("Launch Codes Accepted",10)
         local countdown = 11
         print(" ")
         local oldx, oldy = term.getCursorPos()
         local y = oldy - 1
         for i=1,11 do
         countdown = countdown - 1
         term.setCursorPos(1,y)
         term.clearLine()
         rednet.broadcast(countdown)
         print("Launching in "..countdown.." seconds")
         textutils.slowWrite("  ",2)
         end
         term.setCursorPos(1,oldy)
         term.clearLine()
         textutils.slowPrint("Launch Success")
         rednet.broadcast("launching")
       end
   end
end


local function goToMine()
print("going to mine")
rednet.broadcast("going to mine")
for i = 1, front do
turtle.forward()
end
if side == "left" then
turtle.turnLeft()
for i = 1, distance do
turtle.forward()
end
turtle.turnRight()
elseif side == "right" then
turtle.turnRight()
for i = 1, distance do
turtle.forward()
end
turtle.turnLeft()
print("arrived at mine")
rednet.broadcast("arrived at mine")
end
end

local function returnHome()
print("going home")
rednet.broadcast("going home")
--start facing mine
turtle.turnLeft()
turtle.turnLeft()
if side == "left" then
turtle.turnLeft()
for i = 1, distance do
turtle.forward()
end
turtle.turnRight()
elseif side == "right" then
turtle.turnRight()
for i = 1, distance do
turtle.forward()
end
turtle.turnLeft()
end
for i = 1, front do
turtle.forward()
end
turtle.turnLeft()
turtle.turnLeft()
print("arrived at home")
rednet.broadcast("arrived at home")
end



local function checkFuel()
if turtle.getFuelLevel() > MinFuel then
  print("The fuel level is good")
  rednet.broadcast("the fuel level is good")
  return
else
print("Attempting to get "..MinFuel.." fuel")
rednet.broadcast("Attempting to get "..MinFuel.." fuel")
for i = 1, 16 do
  turtle.select(i)
  if turtle.refuel(0) then
     local fuelSuck = 1+((MinFuel-turtle.getFuelLevel())/80)
     if fuelSuck >= 64 then
           turtle.refuel(64)
     elseif fuelSuck < 64 then
        turtle.refuel(fuelSuck)
	 end
  end
  if turtle.getFuelLevel() >= MinFuel then
        break
  end
end
end
turtle.select(1)
print("The new fuel level is: "..turtle.getFuelLevel())
rednet.broadcast("The new fuel level is: "..turtle.getFuelLevel())
if turtle.getFuelLevel() < MinFuel then
local success = "false"
return success
else
local success = "true"
return success
end
end



local function GetFuel()
local FuelLevel = turtle.getFuelLevel()
if FuelLevel <= MinFuel then
   print("getting fuel from chest")
   rednet.broadcast("getting fuel from chest")
   turtle.turnRight()
   turtle.forward()
   turtle.forward()
   turtle.turnRight()
   while true do
      turtle.select(16)
      local fuelSuck = (MinFuel-turtle.getFuelLevel())/80*2
      if fuelSuck > 64 then
         print("running equations")
		 rednet.broadcast("running equations")
         local wholeFuelSuck = (fuelSuck/64)
	     local x = (fuelSuck/64)
		 for i = 1, wholeFuelSuck do
            x = x-1
		 end
		 local newFuelSuck = x*64
         for i = 1, wholeFuelSuck do
            turtle.suck(64)
		 end
		 turtle.suck(newFuelSuck)
      elseif fuelSuck < 2 then
         turtle.suck(2)
	  else
	     turtle.suck(fuelSuck)
	  end
	  local utoh = turtle.getFuelLevel()
      checkFuel()
      if turtle.getFuelLevel() > MinFuel then
	     break
	  end
	  if utoh == turtle.getFuelLevel() then
	     stop = "yes"
		 break
	  end
   end	  
   turtle.turnRight()
   turtle.forward()
   turtle.forward()
   turtle.turnRight()
end
turtle.select(1)
end


local function refuel()
   local FuelAvailable = checkFuel()
   if FuelAvailable == "false" then
      local FuelLevel = turtle.getFuelLevel()
      if FuelLevel < 5 then
         print("Insert Fuel")
		 rednet.broadcast("Insert Fuel")
         scrap = read()
	     checkFuel()
	     GetFuel()
      else
	     GetFuel()
      end
   end
end

local function BaseFuel()
   print("checking fuel")
   rednet.broadcast("checking fuel")
   print("The fuel level is: "..turtle.getFuelLevel())
   rednet.broadcast("The fuel level is: "..turtle.getFuelLevel())
   local FuelLevel = turtle.getFuelLevel()
   if FuelLevel <= MinFuel then
      refuel()
   end
end

local function OutsideFuel()
   print("checking fuel")
   rednet.broadcast("checking fuel")
   print("The fuel level is: "..turtle.getFuelLevel())
   rednet.broadcast("The fuel level is: "..turtle.getFuelLevel())
   local FuelLevel = turtle.getFuelLevel()
   if FuelLevel <= MinFuel then
      checkFuel()
   end
end

local function dumpInv()
   print("Dropping Inventory")
   rednet.broadcast("Dropping Inventory")
   turtle.turnLeft()
   turtle.turnLeft()
   for i = 1, 15 do
      turtle.select(i)
      turtle.drop()
   end
   turtle.select(1)
   turtle.turnLeft()
   turtle.turnLeft()
end

local function digDown()
   turtle.digDown()
   turtle.suckDown()
   turtle.down()
end

local function digForward()
   turtle.dig()
   turtle.suck()
   turtle.forward()
end   

local function newColum()
   if turningDirection == "right" then
      turtle.turnRight()
      digForward()
      turtle.turnRight()
	  turningDirection = "left"
   elseif turningDirection == "left" then
	  turtle.turnLeft()
      digForward()
      turtle.turnLeft()
	  turningDirection = "right"
   end
end

local function getOut()
   print("going to start of mine")
   rednet.broadcast("going to start of mine")
   if turningDirection == "right" then
      turtle.turnLeft()
      for i = 1, width do
        turtle.forward()
      end
      turtle.turnLeft()
      for i = 1, length do
   	     turtle.forward()
      end
      turtle.turnRight()
      turtle.turnRight()
   elseif turningDirection == "left" then
      turtle.turnRight()
      for i = 1, width do
        turtle.forward()
      end
      turtle.turnRight()
   end
   out = "true"
end

local function mineLevel()
   out = "false"
   turningDirection = "right"
   for i = 1, width do
      for i = 1, length do
         digForward()
      end
	  if i == width then
	     break
	  else
      newColum()
	  end
   end
getOut()
end

local function mine()
   print("starting mining loop")
   rednet.broadcast("starting mine loop")
   for i = 1, currentLevel do
      turtle.down()
   end
   while true do
      local currentFuelLevel = checkFuel()
	  if currentFuelLevel == "false" then
	     break
	  end
      currentLevel = currentLevel + 1
	  rednet.broadcast("Current level is: "..currentLevel)
	  rednet.broadcast("digging down")
      digDown()
	  rednet.broadcast("mining level")
      mineLevel()
	  if currentLevel == depth then
	     rednet.broadcast("stopping mine loop")
		 horray = "yes"
	     break
	  end
	  
   end
   if out == "true" then 
      print("going up")
      rednet.broadcast("going up")
      for i = 1, currentLevel do
         turtle.up()
      end
   else
      getOut()
	  print("going up")
      rednet.broadcast("going up")
	  for i = 1, currentLevel do
         turtle.up()
      end
   end
end

local function terminate()
   while true do
      
      scrap, stopMining = rednet.receive()
      if stopMining == "terminate" then
         print("Requested to return")
	     break
      end
	  if stopMining == "mineEnd" then
	     break
	  end
   end
end   

local function MineControl()
   horray = "boo"
   while true do
      if currentLevel < depth then
         goToMine()
		 mine()
	     returnHome()
	     stop = "no"
	     if stopMining == "terminate" then
	        dumpInv()
	        break
         end
		 if horray == "yes" then
		    print("Mine Finished: Shutting Down")
	        rednet.broadcast("Mine Finished: Shutting Down")
            break
	     end
	     BaseFuel()
	     dumpInv()
	     if stop == "yes" then
	        print("program terminated: lack of fuel")
		    rednet.broadcast("program terminated: lack of fuel")
	        break
	     end
	     if stopMining == "terminate" then		    
		    break
         end
	     
      end		 
   end
end

local function calculateMinFuel()
   local mineFuel = (length * width * 2)+(depth * 2)
   local pathFuel = (front + distance)*2
   if (mineFuel+pathFuel) >= 100000 then
   MinFuel = 99999
   else
   MinFuel = mineFuel + pathFuel
   end
   print("Minimum Fuel = "..MinFuel)
   rednet.broadcast("Minimum Fuel = "..MinFuel)
end

local function Main()
   Boot()
   rednet.open("left")
   Connect()
   front, side, distance, length, width, depth = ReceiveParameters()
   length = length - 1
   calculateMinFuel()
   Launch()
   refuel()
   if stop == "yes" then
	  print("program terminated: lack of fuel")
      rednet.broadcast("program terminated: lack of fuel")
      return
   end
   currentLevel = 0
   parallel.waitForAll(terminate, MineControl)
   if stopMining == "terminate" then
      print("Shutting Down")
      rednet.broadcast("Shutting Down")
   end
end

Main()


-- add extra functionality to end of mine function
-- make sure left side is fixed