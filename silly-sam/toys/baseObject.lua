local Class = require "hump.class"

BaseObject = Class{}

-- draws textured object if possible, otherwise defaults to the shape
function BaseObject:drawRectangleObject(object)
    if object.image then
        self:drawRectangleTexturedObject(object, 1, 1)
    else
        self:drawRectanglePhysicsObject(object)
    end
end

function BaseObject:drawRectanglePhysicsObject(object)
    love.graphics.setColor(object.color)
    love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function BaseObject:drawRectangleTexturedObject(object, xUpscale, yUpscale, xOffset, yOffset)
    xUpscale = xUpscale or 1
    yUpscale = yUpscale or 1
    xOffset = xOffset or 0
    yOffset = yOffset or 0

    -- draw(image, xpos, ypos, angle, ratiox, ratioy, offsetx, offsety)
    love.graphics.draw(object.image,
        object.body:getX(), object.body:getY(),
        object.body:getAngle(),
        object.width*xUpscale/object.image:getWidth(), object.height*yUpscale/object.image:getHeight(),
        object.image:getWidth()/2 + xOffset, object.image:getHeight()/2 + yOffset)
end

-- draws textured object if possible, otherwise defaults to the shape
function BaseObject:drawCircleObject(object)
    if object.image then
        self:drawCircleTexturedObject(object, 1)
    else
        self:drawCirclePhysicsObject(object)
    end
end

function BaseObject:drawCirclePhysicsObject(object)
    love.graphics.setColor(object.color)

    local wx, wy = object.body:getWorldPoint(object.shape:getPoint())
    love.graphics.circle("fill", wx, wy, object.shape:getRadius())
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
