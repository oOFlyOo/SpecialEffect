--[[
	程序的入口点
--]]


require "LuaScript/Extension/debug"

require "LuaScript/mainMenu"


local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100);
    collectgarbage("setstepmul", 5000);

    local scene = CCScene:create()
    scene:addChild(CreateTestMenu())
    CCDirector:sharedDirector():runWithScene(scene)
    
    return true;
end

xpcall(main, __G__TRACKBACK__);