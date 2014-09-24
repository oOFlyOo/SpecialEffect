require "LuaScript/helper"
require "LuaScript/resources"

require "LuaScript/Test/SpecialEffectTest"


local LINE_SPACE = 80

local CurPos = {x = 0, y = 0}
local BeginPos = {x = 0, y = 0}




-- create scene
local function CreateTestScene(nIdx)
    local scene = SpecialEffectTest(nIdx)
    -- CCDirector:sharedDirector():purgeCachedData()
    return scene
end
-- create menu
function CreateTestMenu()
    require "specialEffect"
    local TESTS_COUNT = table.getn(SE_CONFIG)

    local menuLayer = CCLayer:create()

    local function closeCallback()
        CCDirector:sharedDirector():endToLua()
    end

    local function menuCallback(tag)
        print(tag)
        local Idx = tag - 10000
        local testScene = CreateTestScene(Idx)
        if testScene then
            CCDirector:sharedDirector():replaceScene(testScene)
        end
    end

    -- add close menu
    local s = CCDirector:sharedDirector():getWinSize()
    local CloseItem = CCMenuItemImage:create(IMAGES.s_pPathClose, IMAGES.s_pPathClose)
    CloseItem:registerScriptTapHandler(closeCallback)
    CloseItem:setPosition(ccp(s.width - 30, s.height - 30))
    CloseItem:setAnchorPoint(ccp(1, 1));
    CloseItem:setScale(3);

    local CloseMenu = CCMenu:create()
    CloseMenu:setPosition(0, 0)
    CloseMenu:addChild(CloseItem)
    menuLayer:addChild(CloseMenu)

    -- add menu items for tests
    local MainMenu = CCMenu:create()
    local index = 0
    local obj = nil
    for index, obj in pairs(SE_CONFIG) do
        local testLabel = CCLabelTTF:create(obj.name, "Arial", 50)
        local testMenuItem = CCMenuItemLabel:create(testLabel)
        testMenuItem:registerScriptTapHandler(menuCallback)
        testMenuItem:setPosition(ccp(s.width / 2, (s.height - (index) * LINE_SPACE)))
        MainMenu:addChild(testMenuItem, index + 10000, index + 10000)
    end

    MainMenu:setContentSize(CCSizeMake(s.width, (TESTS_COUNT + 1) * (LINE_SPACE)))
    MainMenu:setPosition(CurPos.x, CurPos.y)
    menuLayer:addChild(MainMenu)

    -- handling touch events
    local function onTouchBegan(x, y)
        BeginPos = {x = x, y = y}
        -- CCTOUCHBEGAN event must return true
        return true
    end

    local function onTouchMoved(x, y)
        local nMoveY = y - BeginPos.y
        local curPosx, curPosy = MainMenu:getPosition()
        local nextPosy = curPosy + nMoveY
        local winSize = CCDirector:sharedDirector():getWinSize()
        if nextPosy < 0 then
            MainMenu:setPosition(0, 0)
            return
        end

        if nextPosy > ((TESTS_COUNT + 1) * LINE_SPACE - winSize.height) then
            MainMenu:setPosition(0, ((TESTS_COUNT + 1) * LINE_SPACE - winSize.height))
            return
        end

        MainMenu:setPosition(curPosx, nextPosy)
        BeginPos = {x = x, y = y}
        CurPos = {x = curPosx, y = nextPosy}
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        end
    end

    menuLayer:setTouchEnabled(true)
    menuLayer:registerScriptTouchHandler(onTouch)

    return menuLayer
end
