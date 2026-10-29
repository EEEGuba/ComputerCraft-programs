local chatBox = peripheral.wrap("left")
local battery = peripheral.wrap("back")
 
while true do
    event,param1,param2 = os.pullEvent("chat")
    if param2 == "baza energia" then
        chatBox.sendMessage("Aktualna energia: "..math.floor(battery.getEnergyFilledPercentage()*10000)/100 .."%, "..math.floor((battery.getEnergy()/2500000000000)*100)/100 .."TFE, aktualne ladowanie: "..math.floor((battery.getLastInput()/2500000)*100)/100 .."MFE/t, aktualne rozladowanie: "..math.floor((battery.getLastOutput()/2500000)*100)/100 .."MFE/t","Baza Grzegorza","[]","&b")
    end
end
