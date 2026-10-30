local modem = peripheral.wrap("right")
local rdstn = peripheral.wrap("left")
 
rednet.open("right")
while true do
    local id,readout,protocol = rednet.receive("fusion",10)
    if not readout then
        rdstn.setOutput("front", true)
        os.sleep(1)
        rdstn.setOutput("front",false)
        os.sleep(3600)
    end
end
