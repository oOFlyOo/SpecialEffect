#ifndef _CONFIG_H_
#define _CONFIG_H_


/** main.cpp
*/
namespace screen
{
    //设置屏幕大小宽度
    const int FRAME_WIDTH = 960;
    const int FRAME_HEIGHT = 640;
    //设置屏幕缩放大小
    const float ZOOM_SCALE = 1.0f;
    //显示的程序名称
    const std::string GAME_NAME = "SpecialEffect";
}


/** AppDelegate.cpp
*/
namespace app
{
    //设置设计大小宽度
    const int DESIGN_WIDTH = 960;
    const int DESIGN_HEIGHT = 640;
    //设置缩放模式
    const ResolutionPolicy ZOOM_MODE = kResolutionShowAll;
    //设置帧率
    const int FPS = 30;
    //设置是否显示帧率等信息
    const bool DISPLAYSTATUS = true;

    //启动Lua文件名
    const std::string LUA_START = "LuaScript/entrance.lua";
}


#endif  // _CONFIG_H_