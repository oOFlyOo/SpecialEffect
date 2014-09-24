--[[
	此文件用于输出测试用等，名称暂定
--]]


require "LuaScript/IO/FileIO"


--[[
    确定是哪一个版本
--]]
local VERSION_TYPE =
{
    debug = "debug",
    release = "release,"
}
local versionType = VERSION_TYPE.release;


--[[
    记录debug信息的文件
--]]
local LOG_FILE = 
{
    fileName = CCFileUtils:sharedFileUtils():getWritablePath() .. "log.txt";
    --fileName = "E:\\Svn\\GameProject\\projects\\yzcard\\proj.win32\\Release.win32\\log.txt";
}


--[[
    for CCLuaEngine traceback
--]]
function __G__TRACKBACK__(msg)
    if (versionType == VERSION_TYPE.release) then
        CCMessageBox("LUA ERROR: " .. tostring(msg), "Error:");
        CCMessageBox(debug.traceback(), "Error:");
    end

    log("----------------------------------------");
    log("LUA ERROR: " .. tostring(msg) .. "\n");
    log(debug.traceback());
    log("----------------------------------------");

    --这个是报错之后调用的，可以报错之后退出游戏，暂时不调用
    --CCDirector:sharedDirector():endToLua();

    return true;
end


--[[
    测试输出用，将传进来的信息输出
--]]
cclog = function(...)
    return print(string.format(...));
end




-- 老是不记得 lua 里面的 cclog 是大写还是小写，干脆来个 lualog
lualog = function(...)
	print(string.format(...));
end


--[[
    将输出信息写进文件
--]]
function fileLog(...)
    FileIO:getInstance():writeToFile(LOG_FILE.fileName, os.date());

    return FileIO:getInstance():writeToFile(LOG_FILE.fileName, ...);
end


--[[
    通过在这里定义使用哪一种输出信息
--]]
log = nil;
if (versionType == VERSION_TYPE.debug) then
    log = cclog;
elseif (versionType == VERSION_TYPE.release) then
    log = cclog;
end