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
local Z_311005 =
{
    --粒子
    particles =
    {
        {
            --资源路径
            plist = "Z_311005_par002.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 5,
            --层级
            zOrder = 10,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = 1,
            --旋转角度
            rotation = 0,
        },
                {
            --资源路径
            plist = "Z_311005_par002.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 5,
            --层级
            zOrder = 10,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = 1,
            --旋转角度
            rotation = 0,
        },
                {
            --资源路径
            plist = "Z_311005_par002.plist",
            --开始时间
            startTime = 0,
            --结束时间
            endTime = 5,
            --层级
            zOrder = 10,
            --相对屏幕中心的位置
            position = ccp(0, 0),
            --缩放大小
            scale = 1,
            --旋转角度
            rotation = 0,
        },
        {
            plist = "Z_311005_par003.plist",
            startTime = 0,
            endTime = 2,
            zOrder = 20,
            position = ccp(0, 0),
            scale = 1,
            rotation = 0,
        },
            {
            plist = "Z_311005_par001.plist",
            startTime = 1.5,
            endTime = 5,
            zOrder = 5,
            position = ccp(0, 50),
            scale = 1,
            rotation = 0,
        },
    },

    --帧动画
    frameAnimations =
    {
        {
            exportJson = "Blood_Sp.ExportJson",
            startTime = 0,
            endTime = .5,
            zOrder = 0,
            position = ccp(0, 0),
            scale = 2,
            rotation = 0,
        },

                {
            exportJson = "Blood_Sp.ExportJson",
            startTime = 1,
            endTime = 1.5,
            zOrder = 0,
            position = ccp(20, 50),
            scale = 1.5,
            rotation = 45,
        },



                {
            exportJson = "Blood_Sp.ExportJson",
            startTime = 1.3,
            endTime = 1.8,
            zOrder = 0,
            position = ccp(-30, -80),
            scale = 2,
            rotation = -45,
        },
    },

    --特效的总时间
    totalTime = 5,
    --是否循环播放
    isLoop = false,
}


-- 返回配置文件，请不要遗漏
return Z_311005;