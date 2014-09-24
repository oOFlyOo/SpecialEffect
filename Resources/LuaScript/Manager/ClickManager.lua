--[[
    用于管理按钮的点击
--]]


require "LuaScript/Extension/class"
require "LuaScript/Extension/debug"


--[[
    使用到的一些参数
--]]
local CLICK_PARAMETER =
{
    --按钮的再次点击延迟
    buttonDelay = 0.25,
    --点击允许的超时时间
    clickDelay = 1,
    --移动超过一定范围算作拖动
    moveDistance = 36,
}


--[[
    属性
--]]
ClickManager =
{
    --单例
    instance = nil,
    --注册按钮句柄的存储，使用字段作为区分
    buttonTimes = {},
    --记录开始按下的时间
    touchBeganTime = nil,
    --记录开始按下的位置
    touchBeganPosition = nil,
}


--[[
    类
--]]
ClickManager = class("ClickManager");


--[[
    获取单例
--]]
function ClickManager:getInstance()
    if (not self.instance) then
        local instance = self:new();

        if (instance and instance:init()) then
            self.instance = instance;
        else
            error("创建ClickManager单例失败！");

            instance = nil;
        end
    end

    return self.instance;
end


--[[
    删除单例
--]]
function ClickManager:destroyInstance()
    self.instance = nil;

    return true;
end


--[[
    初始化
--]]
function ClickManager:init()
    self.instance = nil;
    self.buttonTimes = {};
    self.touchBeganTime = 0;
    self.touchBeganPosition = ccp(0, 0);

    return true;
end


--[[
    按钮按下判断是否可以点击
    参数应该是字符串
--]]
function ClickManager:canClick(btn, delay)
    --如果没将延迟时间传进来，则使用默认的时间
    delay = delay or CLICK_PARAMETER.buttonDelay;

    if ((type(btn) ~= "string" and type(btn) ~= "number")or type(delay) ~= "number") then
        error("参数错误！");

        return false;
    end

    --获取程序运行时间
    local sec = os.clock();

    --并没有记录数据
    if (not self.buttonTimes[btn]) then
        self.buttonTimes[btn] = sec;

        return true;
    else
        if (sec - self.buttonTimes[btn] > delay) then
            self.buttonTimes[btn] = sec;

            return true;
        else
            log("Clicking too fast!");

            return false;
        end
    end
end


--[[
    设置按下时间
--]]
function ClickManager:setTouchBegan(pos)
    --进行重载
    pos = pos or ccp(0, 0);

    self.touchBeganTime = os.clock();
    self.touchBeganPosition = pos;

    return true;
end


--[[
    判断点击是否超时
--]]
function ClickManager:isClick()
    local sec = os.clock();
    if (sec - self.touchBeganTime > CLICK_PARAMETER.clickDelay) then
        log("Clicking too slow!");

        return false;
    else
        return true;
    end
end


--[[
    判断拖动是否有效
--]]
function ClickManager:isMoved(pos)
    if (not pos) then
        error("参数错误！");

        return false;
    end

    if (ccpDistance(pos, self.touchBeganPosition) > CLICK_PARAMETER.moveDistance) then
        return true;
    else
        --log("Moving too short!");

        return false;
    end
end