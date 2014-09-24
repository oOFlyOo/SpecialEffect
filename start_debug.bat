@echo off

::游戏路径
set gamePath=proj.win32\Debug.win32\

::转到该路径下
cd %gamePath%

::遍历文件夹
for /r %%i in (*.exe) do (
    ::找到exe，运行
    start %%i
    exit
)