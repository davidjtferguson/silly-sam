local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

Rectangle = Class{__includes = BaseObject}

function Rectangle:init(world, xSpawn, ySpawn, width, height, rotation)
    self.body = love.physics.newBody(world, xSpawn, ySpawn, "static")
    self.shape = love.physics.newRectangleShape(0, 0, width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape);
    self.fixture:setFriction(0.9)
    
    self.color = {1, 0.2, 0.7}

    local xCentre, yCentre = self.body:getPosition()

    -- get the rotation point (top left corner)
    local xRotation = xCentre - width/2
    local yRotation = yCentre - height/2

    -- move to be around rotation point
    xCentre = xCentre - xRotation
    yCentre = yCentre - yRotation

    local sin = math.sin(math.rad(rotation))
    local cos = math.cos(math.rad(rotation))

    local xNew = xCentre * cos - yCentre * sin
    local yNew = xCentre * sin + yCentre * cos

    -- move point back
    xCentre = xNew + xRotation
    yCentre = yNew + yRotation

    self.body:setPosition(xCentre, yCentre)
    self.body:setAngle(math.rad(rotation))
end

function Rectangle:draw()
    self:drawRectPhysicsObject(self)
end

return Rectangle
