local greetInterval = 100
local speaker = peripheral.wrap("right")
local chatBox = peripheral.wrap("left")
local playerDet = peripheral.wrap("back")
local greetedPlayers = {}
local playerTable = {}
 
local function greetingLoop()
    while true do
        playerTable = playerDet.getPlayersInRange(4)
        
        for key, player in pairs(playerTable) do
            if greetedPlayers[player] == nil then
                speaker.playSound("mekanism:gui.digital_beep_on")
                os.sleep(0.3)
                speaker.playSound("mekanism:gui.digital_beep_off")
                chatBox.sendMessageToPlayer("Witaj "..player, player,"Kabelek","[]") -- S
                greetedPlayers[player] = greetInterval
                os.sleep(1)
                speaker.playSound("create:clipboard_check")
                os.sleep(1)
            end
        end
        for player, interval in pairs(greetedPlayers) do
            if greetedPlayers[player] < 0 then
                greetedPlayers[player] = nil
                os.sleep(1)
                speaker.playSound("create:clipboard_erase")
                os.sleep(1)
            else
                greetedPlayers[player] = greetedPlayers[player]-1
                for key, username in pairs(playerTable) do
                    if username == player then 
                       greetedPlayers[player] = greetedPlayers[player]+1 
                end
            end
        end
    end
        os.sleep(1)
 
    end
end
 
local function typewriterLoop()
    while true do
        if #playerTable == 0 then
            local tapCount = math.random(2, 8)
            for i = 1, tapCount do
                if (i/tapCount)%3==0 then 
                    speaker.playSound("candlelight:typewriter")
                    os.sleep(math.random(5,20)/50)
                else
                    speaker.playSound("simulated:block.linked_typewriter.tap",1,math.random(90, 110) / 100)
                    os.sleep(math.random(5,20)/50)
                    if i==tapCount and tapCount%4 == 1 then
                        speaker.playSound("simulated:block.docking_connector.extend")
                        os.sleep(0.3)
                        speaker.playSound("simulated:block.linked_typewriter.ding")
                        os.sleep(0.5)
                    end
                end
            end
        else 
            os.sleep(os.sleep(0.4))
        end
    end
end
 
parallel.waitForAll(greetingLoop, typewriterLoop)            
