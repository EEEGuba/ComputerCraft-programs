--config vars
local maxExport=10*64
local minItemsToList=1000
local maxPercentExport=0.1 --1 = 100% 
--code
local chatBox = peripheral.wrap("top")
local bridge = peripheral.wrap("back")
local monitor = peripheral.wrap("left")
local items = bridge.getItems()
local list = {}
for _,item in ipairs(items) do 
    if item.count>minItemsToList then 
        list[#list+1]=item 
    end 
end
 
local function itemIsOnList(itemRequest)
    for _,item in ipairs(list) do 
        if item.name == itemRequest then
            return item
        end
    end
    return false
end
 
local function eventHandler()
    local playerTalking = "nikt"
    while true do
        event, param1, param2 = os.pullEvent("chat")
        playerTalking = param1
        if param2:lower() == "kabelku, poprosze cos" or param2:lower()=="kabelku" or param2:lower()=="kabelku poprosze cos" then
            chatBox.sendMessage("Co Ci trzeba "..param1.."? Podaj dokladna oficjalna nazwe to wyszukam czy mam","Kabelek","[]")
            while param1 ==playerTalking do
                event, param1, param2 = os.pullEvent("chat")
                local currentItem = itemIsOnList(param2:lower())
                if param2:lower()=="nic" or param2:lower()=="nie" or param2:lower()=="dziekuje" or param2:lower()=="tyle" or param2:lower()=="papa" then
                    chatBox.sendMessage("Oki, trzymaj sie","Kabelek","[]")
                    break
                end 
                if currentItem~=false then
                    chatBox.sendMessage("Ok, mam ile Ci trzeba?","Kabelek","[]")
                    while param1 == playerTalking do
                        event, param1, param2 = os.pullEvent("chat")
                        local currentCount = math.floor(param2+0)
                        if currentCount<maxExport and currentCount<currentItem.count*maxPercentExport then
                            bridge.exportItem({name=currentItem.name, count=currentCount}, "front")
                            chatBox.sendMessage("Ok, poszlo do skrzynki, cos jeszcze?","Kabelek","[]")
                            break
                        else
                            chatBox.sendMessage("Sory, nie moge az tyle wyciagnac, sprobuj mniej", "Kabelek", "[]")
                        end
                    end
                else
                    chatBox.sendMessage("Sory, nie mam jak Ci tego dac, chcesz cos innego?","Kabelek","[]")                    
                end     
            end
        end
    end 
end
local iteration = 1
local function listPrinter() 
    while true do
        if iteration<#list+1 then
            print(list[iteration].displayName,tostring(list[iteration].count))
            iteration=iteration+1
        else 
            iteration = 1
        end
        os.sleep(2)
    end
end
parallel.waitForAll(eventHandler,listPrinter)
 
