--[[
    对DictionaryXML进行封装，变成单例
--]]


require "LuaScript/Extension/class"
require "LuaScript/Extension/debug"

require "LuaScript/IO/DictionaryXML"


--[[
    存放文件名称
--]]
local USER_FILE = 
{
    fileName = "user.xml",
}


--[[
    成员变量
--]]
UserXML =
{
    --自身实例
    instance = nil;
    --Dictionary实例
    dictXML = nil,
}


--[[
    非继承
--]]
UserXML = class("UserXML");


--[[
    初始化
--]]
function UserXML:init()
    self.instance = nil;
    self.dictXML = nil;

    return true;
end


--[[
    获取实例
--]]
function UserXML:getInstance()
    --判断实例是否存在，不存在则新建
    if (not self.instance) then
        local instance = self:new();

        if (instance and instance:init()) then
            local path = CCFileUtils:sharedFileUtils():getWritablePath() .. USER_FILE.fileName;
            instance.dictXML = DictionaryXML:createWithXML(path);

            -- 持有
            instance.dictXML:retain();

            self.instance = instance;
        else
            assert(false, "创建UserDefault单例失败！");

            self.instance = nil;
        end
    end

    return self.instance;
end


--[[
    删除实例
--]]
function UserXML:destroyInstance()
    local instance = self.instance;
    if (instance.dictXML and not tolua.isnull(instance.dictXML)) then
        instance.dictXML:release();
    end

    instance = nil;

    return true;
end


--[[
    根据key获取value
--]]
function UserXML:valueForKey(key)
    if (type(key) ~= "string") then
        error("参数错误！");

        return false;
    end

   return self.dictXML:valueForKey(key);
end


--[[
    设置值
--]]
function UserXML:setValue(value, key)
    if (not value or type(key) ~= "string") then
        error("参数错误！");

        return false;
    end

    self.dictXML:setValue(value, key);

    --默认保存值，就不需要再其它地方flush了
    return self:flush();
end


--[[
    移除值
--]]
function UserXML:removeValueForKey(key)
    if (type(value) ~= "string") then
        error("参数错误！");

        return false;
    end

    return self.dictXML:removeValueForKey(value, key);
end


--[[
    移除所有的值
--]]
function UserXML:removeAllValues()
    return self.dictXML:removeAllValues(value, key);
end


--[[
    保存值，在调用这个之前，值还是未保存的
--]]
function UserXML:flush()
    return self.dictXML:writeToXML();
end