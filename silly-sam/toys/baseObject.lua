local Class = require "hump.class"

BaseObject = Class{}

function BaseObject:drawRectanglePhysicsObject(object)
    love.graphics.setColor(object.color)
    love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function BaseObject:drawCirclePhysicsObject(object)
    love.graphics.setColor(object.color)

    local wx, wy = object.body:getWorldPoint(object.shape:getPoint())
    love.graphics.circle("fill", wx, wy, object.shape:getRadius())
end

function BaseObject:drawRectangleTexturedObject(object, upscale)
    love.graphics.setColor(1, 1, 1, 1)

    -- draw(image, xpos, ypos, angle, ratiox, ratioy, offsetx, offsety)
    love.graphics.draw(object.image,
        object.body:getX(), object.body:getY(),
        object.body:getAngle(),
        object.width*upscale/object.image:getWidth(), object.height*upscale/object.image:getHeight(),
        object.image:getWidth()/2, object.image:getHeight()/2)
end

function BaseObject:drawCircleTexturedObject(object, upscale, xOffset, yOffset)
    xOffset = xOffset or 0
    yOffset = yOffset or 0

    love.graphics.setColor(1, 1, 1, 1)

    -- draw(image, xpos, ypos, angle, ratiox, ratioy, offsetx, offsety)
    love.graphics.draw(object.image,
        object.body:getX(), object.body:getY(),
        object.body:getAngle(),
        (object.shape:getRadius()*2*upscale)/object.image:getWidth(), (object.shape:getRadius()*2*upscale)/object.image:getHeight(),
        object.image:getWidth()/2 + xOffset, object.image:getHeight()/2 + yOffset)
end

-- doesn't really make any sense to be on the base object isntead of floating around in some helper file but whatever.
function BaseObject:checkStaticBool(static)
    if static then
        return "static"
    end
    return "dynamic"
end

return BaseObject
