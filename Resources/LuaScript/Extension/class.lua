--[[
	对Cocos2d-X-Lua中的extern文件的类的创建进行了适当的修改，
	并且将类的创建单独抽取出来进行存放为Class
	
	1.父类为C++类，super应该为类的create函数
	2.父类为继承过C++类的类，super可以是类的create函数
	也可以是父类名（未尝试）
	3.新建一个Lua类，super是nil便可，或者只传入第一个参数
	4.父类为Lua类，传入父类名
	
	注意，类的函数可以通过类直接使用，
	但是可能会由于是nil值而造成错误
--]]


--2.2版本之后才有的函数，用于复制表
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


--Create an class.
function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

		--估计ctor是保留的构造函数
        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1	-- C++
		cls.__index = cls;    -- 让它可以作为metatable使用

--[[
	将.改成:，符合类函数的写法，可能到时候要改回去
    必须使用.，大意了
        function cls.new(...)
            local instance = cls.__create(...)
--]]
		function cls:new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
		if super then
		-- inherited from Lua Object
--[[
	这里的clone是用到LuaPlus库的不知道是否可用，故重写
			cls = clone(super)
            cls.super = super
	
	2.2版本之后已经具备了clone函数，不需要重写
			cls = {};
			for k, v in pairs(super) do
				cls[k] = v;
			end
--]]
			cls = clone(super)
			cls.super = super;
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

--[[
	将.改成:，符合类函数的写法，可能到时候要改回去
        function cls.new(...)
--]]
		function cls:new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end
