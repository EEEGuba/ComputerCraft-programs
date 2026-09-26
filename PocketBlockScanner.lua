local geo = peripheral.wrap("back")
local sizeX, sizeY = term.getSize()
 
while true do
    local scan = geo.scan(16)
    term.clear()
    term.setTextColor(colors.blue)
    term.setCursorPos(sizeX/2,sizeY/2)
    term.write("X")
    for i, block_data in ipairs(scan) do
         if block_data.name == "minecraft:stone_bricks" or block_data.name == "minecraft:chest" then       
             term.setTextColor(colors.red)
             term.setCursorPos(1+sizeX/2-block_data.x/1.3,1+sizeY/2-block_data.z/1.6)
             if block_data.y>1 then
                 term.write("0")
             else 
                 if block_data.y<-1 then
                     term.write("o")
                 else 
                     term.write("x")
                 end
             end
             term.setTextColor(colors.white)
         end
    end
end
