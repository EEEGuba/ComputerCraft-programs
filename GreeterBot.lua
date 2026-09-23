local greetInterval = 100
local speaker = peripheral.wrap("right")
local chatBox = peripheral.wrap("left")
local playerDet = peripheral.wrap("back")
local greetedPlayers = {}
 
while true do
    local playerTable = playerDet.getPlayersInRange(6)
    if #playerTable > 0 then
        for key, player in pairs(playerTable) do
            if greetedPlayers[player] == nil then
                speaker.playSound("mekanism:gui.digital_beep_on")
                os.sleep(0.3)
                speaker.playSound("mekanism:gui.digital_beep_off")
                chatBox.sendMessageToPlayer("Witaj "..player, player,"Kabelek","[]") -- S
                greetedPlayers[player] = greetInterval
            end
        end
    end
    for player, interval in pairs(greetedPlayers) do
        if greetedPlayers[player] < 0 then
            greetedPlayers[player] = nil
            speaker.playSound("simulated:block.linked_typewriter.ding")
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
