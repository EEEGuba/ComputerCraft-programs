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
local iteration = 1
 
while true do
    --event,param1,param2 = os.pullEvent("chat")
    if iteration<#list+1 then
        print(list[iteration].displayName,tostring(list[iteration].count))
        iteration=iteration+1
    else 
        iteration = 1
    end
    os.sleep(2)
end
 
