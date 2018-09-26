local Class = require "hump.class"

BaseObject = Class{}

function BaseObject:drawRectPhysicsObject(object)
    love.graphics.setColor(object.color)
    love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function BaseObject:drawCirclePhysicsObject(object)
    love.graphics.setColor(object.color)

    local wx, wy = object.body:getWorldPoint(object.shape:getPoint())
    love.graphics.circle("fill", wx, wy, object.shape:getRadius())
end

return BaseObject
