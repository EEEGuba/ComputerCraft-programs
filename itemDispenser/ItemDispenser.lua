--config vars
local maxExport=10*64
local minItemsToList=1000
local maxPercentExport=0.1 --1 = 100% 
--program with blacklist priority
--code below
local chatBox = peripheral.wrap("top")
local bridge = peripheral.wrap("back")
local monitor = peripheral.wrap("left")
local function listLoader(filename)
    local itemList = {}
    if not fs.exists(filename) then
        return itemList
    end
    local file = fs.open(filename, "r")
    while true do
        local line = file.readLine()
        if not line then
            break
        end
        line = line:gsub("^%s+", ""):gsub("%s+$", "")
        if line ~= "" and not line:match("^#") then
            itemList[line] = true
        end
    end
    file.close()
    return itemList
end
local whitelist = listLoader("whitelist.dat")
local blacklist = listLoader("blacklist.dat")
 
local list = {}
local function relist()
    local items = bridge.getItems()
    list = {}
    for _,item in ipairs(items) do 
        local itemName = item.name
        local isWhitelisted = whitelist[itemName]
        local isBlacklisted = blacklist[itemName] 
        if not isBlacklisted and (item.count>minItemsToList or isWhitelisted) then
            list[#list+1]=item
        end
    end
end
relist()
 
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
                    local isWhitelisted = whitelist[currentItem.name] 
                    chatBox.sendMessage("Ok, mamy "..currentItem.count.. " ile Ci trzeba?","Kabelek","[]")
                    while param1 == playerTalking do
                        event, param1, param2 = os.pullEvent("chat")
                        local currentCount = tonumber(param2) and math.floor(param2+0)
                        if currentCount and (currentCount<maxExport and currentCount<currentItem.count*maxPercentExport) or (isWhitelisted and currentCount <= currentItem.count) then
                            bridge.exportItem({name=currentItem.name, count=currentCount}, "front")
                            chatBox.sendMessage("Ok, poszlo do skrzynki, cos jeszcze?","Kabelek","[]")
                            relist()
                            break
                        else
                            if not currentCount then
                            chatBox.sendMessage("To nie jest faktyczna liczba sprobuj jeszcze raz","Kabelek","[]")
                            else 
                            chatBox.sendMessage("Sory, nie moge tyle wyciagnac, sprobuj jeszcze raz", "Kabelek", "[]")
                            end
                        end
                    end
                else
                    if blacklist[param2:lower()] then
                    chatBox.sendMessage("Sory, mam to na zablokowanej liscie, chcesz cos innego?","Kabelek","[]")
                    else
                    chatBox.sendMessage("Sory, nie mam jak Ci tego dac, chcesz cos innego?","Kabelek","[]")                    
                    end
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
