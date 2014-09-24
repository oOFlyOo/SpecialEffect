#ifndef _CONFIG_H_
#define _CONFIG_H_


/** main.cpp
*/
namespace screen
{
    //������Ļ��С���
    const int FRAME_WIDTH = 960;
    const int FRAME_HEIGHT = 640;
    //������Ļ���Ŵ�С
    const float ZOOM_SCALE = 1.0f;
    //��ʾ�ĳ�������
    const std::string GAME_NAME = "SpecialEffect";
}


/** AppDelegate.cpp
*/
namespace app
{
    //������ƴ�С���
    const int DESIGN_WIDTH = 960;
    const int DESIGN_HEIGHT = 640;
    //��������ģʽ
    const ResolutionPolicy ZOOM_MODE = kResolutionShowAll;
    //����֡��
    const int FPS = 30;
    //�����Ƿ���ʾ֡�ʵ���Ϣ
    const bool DISPLAYSTATUS = true;

    //����Lua�ļ���
    const std::string LUA_START = "LuaScript/entrance.lua";
}


#endif  // _CONFIG_H_