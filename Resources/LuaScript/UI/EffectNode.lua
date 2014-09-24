--[[
    创建一个具有特效的Node
--]]


require "LuaScript/Extension/class"
require "LuaScript/Extension/debug"
require "LuaScript/Extension/register"
require "LuaScript/Extension/schedule"
require "LuaScript/Extension/math"

require "LuaScript/Manager/FileManager"

require "LuaScript/resources"


--[[
    属性
--]]
EffectNode =
{
    -- 配置文件
    file = nil,
    -- 配置信息
    config = nil,

    --粒子列表
    particles = {},
    --帧动画列表
    frameAnimations = {},

    --播完一次之后的回调函数
    onFinishHandler = nil,

    -- 速度
    speed = nil,
}


--[[
    类，继承于CCNode
--]]
EffectNode = class("EffectNode", register(CCNode, CCNode.create));


--[[
    创建
--]]
function EffectNode:create()
    local instance = self:new();
    if (instance and instance:init()) then
        return instance;
    else
        error("创建EffectNode失败！");

        return nil;
    end
end


--[[
    初始化
--]]
function EffectNode:init()
    self:registerScriptHandler(register(self, self.onNodeEvent));
    self:setSpeed(1);

    return true;
end


--[[
    复制
--]]
function EffectNode:clone()
    local obj = EffectNode:create();
    obj:setSpeed(self:getSpeed());

    -- 仅当被复制的物体已经load过了才去load
    if (self.file) then
        obj:loadConfig(self.file);
    end

    return obj;
end


--[[
    场景进入时调用函数
--]]
function EffectNode:onEnter()
    return true;
end


--[[
    场景释放时调用函数
--]]
function EffectNode:onCleanup()
    CCArmatureDataManager:purge();

    return true;
end


--[[
    场景进入退出函数
--]]
function EffectNode:onNodeEvent(event)
    if (event == "enter") then
        return self:onEnter();
    elseif (event == "cleanup") then
        return self:onCleanup();
    end

    return false;
end


--[[
    载入
--]]
function EffectNode:loadConfig(config)
    if (not config) then
        error("参数错误！");

        return false;
    end

    self.file = config;
    -- 载入配置
    config = string.format(SPECIAL_EFFECT.SE_PATH, config);
    config = require(config);
    self.config = config;

    -- 重新load过
    self:stopAllActions();
    self:removeAllChildrenWithCleanup(true)

    self:initParticles();
    self:initFrameAnimations();

    --判断是否有时限
    if (config.totalTime >= 0) then
        local function removeAll(sender)
            if (not tolua.isnull(sender)) then
                sender:removeAllChildrenWithCleanup(true);
            end

            --判断是否有回调函数需要执行
            if (self.onFinishHandler) then
                self.onFinishHandler(self);
            end

            --判断是否需要循环播放
            if (config.isLoop) then
                self:loadConfig(config);
            -- 不用循环便移除自身
            -- 检查是不是被释放了
            elseif (not tolua.isnull(sender)) then
                sender:removeFromParentAndCleanup(true);
            end

            return true;
        end
        -- 延迟两帧的时间来优化
        performWithDelay(self, removeAll, (config.totalTime) / self.speed + intervalDelay());
    end

    return true;
end


--[[
    注册函数播完之后的回调函数
--]]
function EffectNode:registerOnFinishHandler(func)
    if (type(func) ~= "function") then
        error("参数错误！");

        return false;
    end

    self.onFinishHandler = func;

    return true;
end


--[[
    设置速度
    最好在载入配置之前
--]]
function EffectNode:setSpeed(speed)
    if (not speed or speed < 0) then
        error("参数错误！");

        return false;
    end

    self.speed = speed;

    -- 判断是否load过file
    if (self.file) then
        -- self:stopAllActions();
        -- self:removeAllChildrenWithCleanup(true)

        self:loadConfig(self.file);
    end

    return true;
end


--[[
    获取速度
--]]
function EffectNode:getSpeed()
    return self.speed;
end


--[[
    获取播放一次的时间
--]]
function EffectNode:getTotalTime()
    return (self.config.totalTime) / self.speed + intervalDelay()
end


--[[
    初始化粒子
--]]
function EffectNode:initParticles()
    -- 没有，跳出
    if (type(self.config.particles) ~= "table") then
        return false;
    end

    self.particles = {};

    for k, p in ipairs(self.config.particles) do
        --延迟添加
        local function addParticle()
            -- 检测文件是否存在
            local realPath = SPECIAL_EFFECT.PARTICLE_PATH .. p.plist;
            local path = CCFileUtils:sharedFileUtils():fullPathForFilename(realPath);
            local flag, msg = FileManager:getInstance():isFileExist(path);
            if (not flag) then
                error(msg);

                return false;
            end

            local particle = CCParticleSystemQuad:create(realPath);
            particle:setZOrder(p.zOrder);
            particle:setPosition(p.position);
            particle:setScale(p.scale);
            particle:setRotation(p.rotation);

            local dict = CCDictionary:createWithContentsOfFile(realPath);
            -- 读取发射速率，cocos目测有这个bug
            local emissionRate = dict:valueForKey("emissionRate"):getCString();
            if (#emissionRate > 0) then
                particle:setEmissionRate(emissionRate);
            end
            -- 读取位置模式，也是cocos的bug吧
            local posType = dict:valueForKey("positionType"):getCString();
            if (#posType > 0) then
                particle:setPositionType(posType);
            end

            -- 这里需要设置加速度
            if (self.speed ~= 1) then
                -- 通用加速度
                local duration = particle:getDuration() / self.speed;
                -- 无限长的时间
                if (duration < 0) then
                    duration = - 1;
                end
                particle:setDuration(duration);
                particle:setEmissionRate(particle:getEmissionRate() * self.speed);
                particle:setLife(particle:getLife() / self.speed);
                particle:setLifeVar(particle:getLifeVar() / self.speed);

                -- 非通用属性
                local mode = particle:getEmitterMode();
                if (mode == kCCParticleModeGravity) then
                    local gravity = particle:getGravity();
                    particle:setGravity(ccp(gravity.x * self.speed, gravity.y * self.speed));
                    particle:setRadialAccel(particle:getRadialAccel() * self.speed);
                    particle:setRadialAccelVar(particle:getRadialAccelVar() * self.speed);
                    particle:setSpeed(particle:getSpeed() * self.speed);
                    particle:setSpeedVar(particle:getSpeedVar() * self.speed);
                    particle:setTangentialAccel(particle:getTangentialAccel() * self.speed);
                    particle:setTangentialAccelVar(particle:getTangentialAccelVar() * self.speed);
                end
            end


            --判断是否需要移除节点
            if (p.endTime >= 0) then
                local function remove(sender)
                    if (not tolua.isnull(sender)) then
                        sender:removeFromParentAndCleanup(true);
                    end
                    self.particles[k] = nil;

                    return true;
                end

                -- 延迟两帧的时间来优化
                performWithDelay(particle, remove, (p.endTime - p.startTime) / self.speed + intervalDelay());
            end

            self:addChild(particle);
            self.particles[k] = particle;
        end

        if (p.startTime == 0) then
            addParticle();
        else
            performWithDelay(self, addParticle, p.startTime / self.speed);
        end
    end

    return true;
end


--[[
    初始化帧动画
--]]
function EffectNode:initFrameAnimations()
    -- 没有，跳出
    if (type(self.config.frameAnimations) ~= "table") then
        return false;
    end

    self.frameAnimations = {};

    for k, p in ipairs(self.config.frameAnimations) do
        --延迟添加
        local function addFrameAnimation()
            -- 检测文件是否存在
            local realPath = SPECIAL_EFFECT.ANIMATION_PATH .. p.exportJson;
            local path = CCFileUtils:sharedFileUtils():fullPathForFilename(realPath);
            local flag, msg = FileManager:getInstance():isFileExist(path);
            if (not flag) then
                error(msg);

                return false;
            end
            
            CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(realPath);

            local fileName = FileManager:getInstance():getFileName(realPath);
            local armature = CCArmature:create(fileName);
            armature:setZOrder(p.zOrder);
            armature:setPosition(p.position);
            armature:setScale(p.scale);
            armature:setRotation(p.rotation);

            animation = armature:getAnimation();
            animation:setSpeedScale(self.speed);
            animation:playWithIndex(0);

            --判断是否需要移除节点
            if (p.endTime >= 0) then
                local function remove(sender)
                    if (not tolua.isnull(sender)) then
                        sender:removeFromParentAndCleanup(true);
                    end
                    self.frameAnimations[k] = nil;

                    return true;
                end

                performWithDelay(armature, remove, (p.endTime - p.startTime) / self.speed + intervalDelay());
            end

            self:addChild(armature);
            self.frameAnimations[k] = armature;
        end

        if (p.startTime == 0) then
            addFrameAnimation();
        else
            performWithDelay(self, addFrameAnimation, p.startTime / self.speed);
        end
    end

    return true;
end