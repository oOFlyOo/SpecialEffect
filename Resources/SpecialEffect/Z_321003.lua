--[[
    混和特效，用于测试
--]]


--[[
    特效资源
    涉及到时间的，-1代表无限
    请不要给startTime赋值-1谢谢

    注意，如果帧动画为空的话，只需要frameAnimations = {} 就可以了啦

    mix不一定是mix，可以使用特效名称，或者全部同意叫config也行
    只要注意最后return的名字必须和这里的名字一致便好
--]]
local Z_321003_START =
{
    --粒子
    particles =
    {
        {
            --资源路径
            plist = "Z_321001_01.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 2,
            --层级
            zOrder = 5,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = 1,
            --旋转角度
            rotation = 0,
        },
        {
            --资源路径
            plist = "Z_321001_02.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 2,
            --层级
            zOrder = 1,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = .5,
            --旋转角度
            rotation = 0,
        },
        {
            --资源路径
            plist = "Z_321001_01.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 2,
            --层级
            zOrder = 5,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = 1,
            --旋转角度
            rotation = 0,
        },
        {
            --资源路径
            plist = "Z_321001_02.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 2,
            --层级
            zOrder = 1,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = .5,
            --旋转角度
            rotation = 0,
        },

        {
            --资源路径
            plist = "Z_321001_03.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 2,
            --层级
            zOrder = 1,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = 1,
            --旋转角度
            rotation = 0,
        },
    },

    --特效的总时间
    totalTime = 2,
    --是否循环播放
    isLoop = false,
}


-- 返回配置文件，请不要遗漏
return Z_321003_START;