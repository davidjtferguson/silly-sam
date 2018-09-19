local Class = require "hump.class"

BaseObject = Class{}

function BaseObject:drawRectPhysicsObject(object)
    love.graphics.setColor(self:getColor(object))
    love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function BaseObject:drawCirclePhysicsObject(object)
    love.graphics.setColor(object.color)

    local wx, wy = object.body:getWorldPoint(object.shape:getPoint())
    love.graphics.circle("fill", wx, wy, object.shape:getRadius())
end

-- Remove once everything's textured
function BaseObject:getColor(obj)
    return obj.color[1], obj.color[2], obj.color[3]
end

return BaseObject