--[[
    提供读写文件的功能
--]]


require "LuaScript/Extension/class"


--[[
    成员变量
--]]
FileIO =
{
    --自身实例
    instance = nil;
}


--[[
    类
--]]
FileIO = class("FileIO");


--[[
    初始化
--]]
function FileIO:init()
    self.instance = nil;

    return true;
end


--[[
    获取实例
--]]
function FileIO:getInstance()
    --判断实例是否存在，不存在则新建
    if (not self.instance) then
        local instance = self:new();
        if (instance and instance:init()) then
            self.instance = instance;
        else
            error("创建FileIO单例失败！");

            self.instance = nil;
        end
    end

    return self.instance;
end


--[[
    删除单例
--]]
function FileIO:destroyInstance()
    local instance = self.instance;
    instance = nil;

    return true;
end


--[[
    写入数据，需要给出地址
--]]
function FileIO:writeToFile(path, ...)
    --检查参数
    if (not path or not ...) then
        error("参数错误！");

        return false;
    end

    --获取path的完整路径
    path = CCFileUtils:sharedFileUtils():fullPathForFilename(path);

    --以添加模式打开文件，并且写入数据
    local file = assert(io.open(path, "a"));
    file:write(string.format(...) .. "\n");
    file:close();

    return true;
end


--[[
    擦除现有数据
    如果没有改文件将会创建一个空文件
--]]
function FileIO:erase(path)
    --检查参数
    if (not path) then
        error("参数错误！");

        return false;
    end

    --获取path的完整路径
    path = CCFileUtils:sharedFileUtils():fullPathForFilename(path);

    --以擦除模式打开文件，然后关闭
    local file = assert(io.open(path, "w"));
    file:close();

    return true;
end