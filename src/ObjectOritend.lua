---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Jeyi.
--- DateTime: 2020/1/13 9:42
---



--[[
       0.0 simple meta table based class

local MyClass01={} ---@class MyClass01
MyClass01.__index=MyClass01

---new
---@param init any
---@return MyClass01
function MyClass01.new(init)
    local self=setmetatable({},MyClass01)
    self.value=init
    return self
end

function MyClass01.setValue(self,value)
    self.value=value
end

function MyClass01.getValue(self)
    return self.value
end

local a=MyClass01.new(1)

print(a:getValue())
a:setValue(10)
print(a:getValue())



]]--

--[[
   0.1 .simple meta table based class
   (improvement)


local MyClass01={} ---@class MyClass01
MyClass01.__index=MyClass01

setmetatable(MyClass01,{
    __call=function(cls,...)
        return cls.new(...)
    end
})


---new
---@param init any
---@return MyClass01
function MyClass01.new(init)
    local self=setmetatable({},MyClass01)
    self.value=init
    return self
end

function MyClass01:setValue(value)
    self.value=value
end

function MyClass01:getValue()
    return self.value
end

local instance=MyClass01(5)

print(instance:getValue())
instance:setValue(10)
print(instance:getValue())

]]--

--[[
    0.2 Inheritance


local BaseClass = {}
BaseClass.__index = BaseClass

setmetatable(BaseClass, {
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        cls:_init(...)
        return self
    end
})

function BaseClass:_init(init)
    self.value = init
end

function BaseClass:set_value(newval)
    self.value = newval
end

function BaseClass:get_value()
    return self.value
end

local DerivedClass = {}
DerivedClass.__index = DerivedClass

setmetatable(DerivedClass, {
    __index = BaseClass, --that is what makes inheritance work
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        cls:_init(...)
        return self
    end
})

function DerivedClass:_init(init1, init2)
    BaseClass._init(self, init1)
    self.value2 = init2
end

local i = DerivedClass(1, 2)
print(i:get_value())
i:set_value(5)
print(i:get_value())
]]--

--[[
    0.3 a convenience function to create class,that can inheriting from other classes

function class(...)
    local cls, bases = {}, { ... }

    --copy base class contents into the new class
    for i, base in ipairs(bases) do
        for k, v in pairs(base) do
            cls[k] = v
        end
    end


    --implement "instance of" function
    cls.__index, cls.is_a = cls, { [cls] = true }
    for i, base in ipairs(bases) do
        for c in pairs(base.is_a) do
            cls.is_a[c] = true
        end
        cls.is_a[base] = true
    end

    setmetatable(cls, {
        __call = function(c, ...)
            local instance = setmetatable({}, c)
            local init = instance._init
            if init then
                init(instance, ...)
            end
            return instance
        end
    })
    return cls
end

]]--

--[[
    0.4 closure based objects

    Instance are slower and use more memory,But faster instance field access




local function Myclass(init)

    local self={
        public_field=0
    }

    local private_filed=init

    function self.foo()
        return self.public_field+private_filed
    end

    function self.bar()
        private_filed=private_filed+1
    end

    return self
end


local i=Myclass(5)
print(i.foo())
print(i.public_field)
i.bar()
print(i.foo())
]]--

--[[
    0.5 closure based class inheritance implementation



local function BaseClass(init)
    local self = {}

    local private_field = init

    function self.foo()
        return private_field
    end

    function self.bar()
        private_field = private_field + 1
    end

    -- return the instance
    return self
end

local function DerivedClass(init,init2)
    local self=BaseClass(init)

    self.public_field=init2
    local private_field = init2
    local base_foo = self.foo

    function self.foo()
        return private_field+self.public_field+base_foo()
    end

    return self
end

local instance=DerivedClass(1,2)
print(instance.foo())
]]--


--[[
        Table vs Closure-based class
    advantages of table-based:
        *.Creating instance is faster,you only create the instance table and its fields
         the methods are shared by all instances.
        *.Table-based instances use less memory, since the methods are not duplicated for each instance.
        *.Many Lua developers might find : for method calls more consistent with the vast majority of object-oriented Lua code.

    advantages of closure-based:
        * can have truly private fields
        * Access to private fields is faster with closure-based classes, since they're upvalues, not table lookups.
        * Method calls are faster, since they don't have to go through an __index metamethod.
        * Many developers from other languages may find the . method call syntax more familiar.

]]--