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
local J_007_B =
{
    --粒子
    particles =
    {
    {
            plist = "J_0070.plist",
            startTime = 0,
            endTime = 100000000,
            zOrder = 10,
            position = ccp(0, 0),
            scale = 1,
            rotation = 0,
        },
    },

    --特效的总时间
    totalTime = - 1,
    --是否循环播放
    isLoop = true,
}


-- 返回配置文件，请不要遗漏
return J_007_B;