--[[
    提供读写XML的功能
    读取文件有个缺陷，如果文件非要求的XML格式，将会产生错误，这点没法修改
    存储的key和value都是lua的string类型
--]]


require "LuaScript/Extension/class"
require "LuaScript/Extension/debug"

require "LuaScript/Manager/FileManager"


--[[
    成员变量
--]]
DictionaryXML =
{
    --CCDictionary实例
    ccDict = nil,
    --保存的路径
    path = nil,
}


--[[
    类
--]]
DictionaryXML = class("DictionaryXML")


--[[
    创建DictionaryXML实例
    可以不给出完整路径，但至少给出相对路径
--]]
function DictionaryXML:createWithXML(path)
    if (type(path) ~= "string") then
        error("参数错误！");

        return false;
    end

    local instance = self:new();
    if instance and instance:init(path) then
        return instance;
    else
        --新建失败
        error("DictionaryXML实例创建失败！");

        instance = nil;

        return nil;
    end
end


--初始化
function DictionaryXML:init(path)
    if (type(path) ~= "string") then
        error("参数错误！");

        return false;
    end

    --先获取完整的路径
    path = CCFileUtils:sharedFileUtils():fullPathForFilename(path);

    --判断XML文件是否存在，是的话从文件新建，否的话则保存路径，只需新建一个空的CCDictionary即可
    if (FileManager:getInstance():isFileExist(path)) then
        self.ccDict = CCDictionary:createWithContentsOfFile(path);
    else
        self.ccDict = CCDictionary:create();
    end

    self.path = path;

    return true;
end


--[[
    持有
--]]
function DictionaryXML:retain()
    self.ccDict:retain();

    return true;
end


--[[
    因为有retain，所以必须手动调用release来删除
--]]
function DictionaryXML:release()
    self.ccDict:release();

    return true;
end


--根据key获取value
function DictionaryXML:valueForKey(key)
    if (type(key) ~= "string") then
        error("参数错误！");

        return false;
    end

    --获取到的是一个CCString
    local value = self.ccDict:valueForKey(key);

    return value:getCString();
end


--设置值
function DictionaryXML:setValue(value, key)
    if (not value or type(key) ~= "string") then
        error("参数错误！");

        return false;
    end

    local ccValue = CCString:create(value);

    return self.ccDict:setObject(ccValue, key);
end


--移除值
function DictionaryXML:removeValueForKey(key)
    if (type(key) ~= "string") then
        error("参数错误！");

        return false;
    end
    
    self.ccDict:removeObjectForKey(key);
end


--移除所有的值
function DictionaryXML:removeAllValues()
    return self.ccDict:removeAllObjects();
end


--保存为XML
function DictionaryXML:writeToXML()
    return self.ccDict:writeToFile(self.path);
end