-- Class implementation extracted from Farming Simulator 25 source code
function Class(p1_, p_u_2_)
    local v_u_3_ = p1_ or {}
    local v_u_4_ = {
        __metatable = v_u_3_,
        __index = v_u_3_,
    }
    if p_u_2_ ~= nil then
        setmetatable(v_u_3_, { __index = p_u_2_ })
    end
    function v_u_3_.class(_)
        return v_u_3_
    end
    function v_u_3_.superClass(_)
        return p_u_2_
    end
    function v_u_3_.isa(_, p5_)
        local v6_ = v_u_3_
        while v6_ ~= nil do
            if v6_ == p5_ then
                return true
            end
            v6_ = v6_:superClass()
        end
        return false
    end
    v_u_3_.new = v_u_3_.new or function(_, p7_)
        local v8_ = v_u_4_
        return setmetatable(p7_ or {}, v8_)
    end
    v_u_3_.copy = v_u_3_.copy or function(p9_, ...)
        local v10_ = p9_.new(...)
        for v11_, v12_ in pairs(p9_) do
            v10_[v11_] = v12_
        end
        return v10_
    end
    return v_u_4_
end

return Class
