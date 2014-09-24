/*
** Lua binding: LuaCocos2dEx
** Generated automatically by tolua++-1.0.92 on 05/26/14 16:17:27.
*/

/****************************************************************************
 Copyright (c) 2011 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

extern "C" {
#include "tolua_fix.h"
}




#include "cocos2d.h"
USING_NS_CC;
#include "LuaCocos2dEx.h"

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CCObject");
 tolua_usertype(tolua_S,"CCDictionary");
 tolua_usertype(tolua_S,"CCFileUtils");
}

/* method: writeToFile of class  CCDictionary */
#ifndef TOLUA_DISABLE_tolua_LuaCocos2dEx_CCDictionary_writeToFile00
static int tolua_LuaCocos2dEx_CCDictionary_writeToFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCDictionary",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCDictionary* self = (CCDictionary*)  tolua_tousertype(tolua_S,1,0);
  const char* fullPath = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'writeToFile'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->writeToFile(fullPath);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'writeToFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: isFileExist of class  CCFileUtils */
#ifndef TOLUA_DISABLE_tolua_LuaCocos2dEx_CCFileUtils_isFileExist00
static int tolua_LuaCocos2dEx_CCFileUtils_isFileExist00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCFileUtils",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCFileUtils* self = (CCFileUtils*)  tolua_tousertype(tolua_S,1,0);
  const std::string strFilePath = ((const std::string)  tolua_tocppstring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'isFileExist'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->isFileExist(strFilePath);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
   tolua_pushcppstring(tolua_S,(const char*)strFilePath);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'isFileExist'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_LuaCocos2dEx_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"CCDictionary","CCDictionary","CCObject",NULL);
  tolua_beginmodule(tolua_S,"CCDictionary");
   tolua_function(tolua_S,"writeToFile",tolua_LuaCocos2dEx_CCDictionary_writeToFile00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"CCFileUtils","CCFileUtils","",NULL);
  tolua_beginmodule(tolua_S,"CCFileUtils");
   tolua_function(tolua_S,"isFileExist",tolua_LuaCocos2dEx_CCFileUtils_isFileExist00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_LuaCocos2dEx (lua_State* tolua_S) {
 return tolua_LuaCocos2dEx_open(tolua_S);
};
#endif

