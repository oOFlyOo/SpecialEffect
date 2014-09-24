@echo off
setlocal EnableDelayedExpansion

::均使用相对路径
set res=Resources
set resBack=Resources.back
set luaScript=Resources.back\LuaScript
set luajit=..\..\scripting\lua\luajit\LuaJIT-2.0.1\src

::强制删除文件夹，减少自己删除的麻烦
rd %resBack% /s /q
::复制文件夹
@echo d| xcopy %res% %resBack% /e /y

set change=1
::遍历文件夹
for /r %luaScript% %%i in (*.lua) do (
    ::转换到luajit的目录下
    if !change!==1 (
        cd %luajit%
        set change=2
    )

    luajit -b %%i %%i
    @echo %%i
)

pause
exit