require "LuaScript/resources"

require "LuaScript/UI/EffectNode"

require "LuaScript/Manager/FileManager"


local SceneIdx  = -1
local MAX_LAYER = 1

local emitter = nil
local background = nil

local labelAtlas = nil
local titleLabel = nil
local subtitleLabel = nil
local baseLayer_entry = nil

local item4 = nil;
local specialEffectId = nil

local s = CCDirector:sharedDirector():getWinSize()
-- 记录位置
local posX, posY = nil, nil;

local function backAction()
	SceneIdx = SceneIdx - 1
    if SceneIdx < 0 then
        SceneIdx = SceneIdx + MAX_LAYER
    end

    return CreateParticleLayer()
end

local function restartAction()
	return CreateParticleLayer()
end

local function nextAction()
	SceneIdx = SceneIdx + 1
    SceneIdx = math.mod(SceneIdx, MAX_LAYER)

    return CreateParticleLayer()
end

local function backCallback(sender)
	local scene = CCScene:create()

	scene:addChild(backAction())
	scene:addChild(CreateBackMenuItem())

	CCDirector:sharedDirector():replaceScene(scene)
end

local function restartCallback(sender)
	local scene = CCScene:create()

	scene:addChild(restartAction())
	scene:addChild(CreateBackMenuItem())

	CCDirector:sharedDirector():replaceScene(scene)
end

local function nextCallback(sender)
	local scene = CCScene:create()

	scene:addChild(nextAction())
	scene:addChild(CreateBackMenuItem())

	CCDirector:sharedDirector():replaceScene(scene)
end


local function resetTime()
    labelAtlas:setString(0);

    return true;
end


local function update(dt)
    local time = labelAtlas:getString();
    time = time + dt;

    labelAtlas:setString(string.format("%.2f", time));

    return true;
end


local function baseLayer_onEnterOrExit(tag)
    local scheduler = CCDirector:sharedDirector():getScheduler()
    if tag == "enter" then
        baseLayer_entry = scheduler:scheduleScriptFunc(update, 0, false)
    elseif tag == "exit" then
        scheduler:unscheduleScriptEntry(baseLayer_entry)
    end
end


local function getBaseLayer()
    local layer = CCLayer:create();

    if (SE_CONFIG[specialEffectId].background) then
        local back = CCSprite:create(BACKGROUND_PATH .. SE_CONFIG[specialEffectId].background);
        back:setPosition(ccp(s.width / 2, s.height / 2));
        layer:addChild(back);
    end

    --local item1 = CCMenuItemImage:create(IMAGES.s_pPathB1, IMAGES.s_pPathB2)
    local item2 = CCMenuItemImage:create(IMAGES.s_pPathR1, IMAGES.s_pPathR2)
    --local item3 = CCMenuItemImage:create(IMAGES.s_pPathF1, IMAGES.s_pPathF2)
    --item1:registerScriptTapHandler(backCallback)
    item2:registerScriptTapHandler(restartCallback)
    --item3:registerScriptTapHandler(nextCallback)

    local menu = CCMenu:create()
    --menu:addChild(item1)
    menu:addChild(item2)
    --menu:addChild(item3)

    menu:setPosition(CCPointMake(0, 0))
    --item1:setPosition(CCPointMake(s.width/2 - item2:getContentSize().width * 2, item2:getContentSize().height / 2))
    item2:setPosition(CCPointMake(s.width/2, item2:getContentSize().height / 2))
    --item3:setPosition(CCPointMake(s.width/2 + item2:getContentSize().width * 2, item2:getContentSize().height / 2))

    layer:addChild(menu, 100)

    labelAtlas = CCLabelAtlas:create("0000", IMAGES.fps, 12, 32, string.byte('.'))
    layer:addChild(labelAtlas, 100)
    labelAtlas:setPosition(ccp(s.width - 200, 60))
    labelAtlas:setScale(3);

    local function onTouchEnded(x, y)
        -- 有可能自己被释放掉了

        if emitter ~= nil and not tolua.isnull(emitter) then
            emitter:setPosition(x, y)
        end
    end

    local function onTouch(eventType, x, y)
        posX, posY = x, y;
        if eventType == "began" then
            return true
        else
            return onTouchEnded(posX, posY)
        end
    end

    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(onTouch)
    layer:registerScriptHandler(baseLayer_onEnterOrExit);

    return layer
end


local function demo()
    local path = SE_CONFIG[specialEffectId].name;
    path = string.format(SPECIAL_EFFECT.SE_PATH, path);
    --检查文件是否存在
    local pathEx = CCFileUtils:sharedFileUtils():fullPathForFilename(path);
    local flag, msg = FileManager:getInstance():isFileExist(pathEx);
    if (not flag) then
        error(msg);

        return false;
    end

    -- 热更新
    package.loaded[path] = false;
    local config = require(path);
    if (type(config) ~= "table") then
        CCMessageBox("forget to return the special effect config!", "Error:");

        error("forget to return the special effect config!");

        return false;
    end

	local layer = getBaseLayer()

    local node = EffectNode:create();
    node:loadConfig(SE_CONFIG[specialEffectId].name);
    node:registerOnFinishHandler(resetTime);

    node:setPosition(ccp(posX, posY));
    emitter = node;
    layer:addChild(node)

	return layer
end

---------------------------------
--  Particle Test
---------------------------------
function CreateParticleLayer()
	if SceneIdx == 0 then return demo()
	end
end

function SpecialEffectTest(id)
	cclog("ParticleTest")
	local scene = CCScene:create()

    specialEffectId = id;

    posX, posY = s.width / 2, s.height / 2;
	SceneIdx = -1
	scene:addChild(nextAction())
	scene:addChild(CreateBackMenuItem())

	return scene
end
