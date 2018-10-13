local Class = require "hump.class"
local Vector = require "hump.vector"

local BaseObject = require "toys/baseObject"

Rectangle = Class{__includes = BaseObject}

function Rectangle:init(world, xSpawn, ySpawn, width, height, rotation, bodyType)
    self.body = love.physics.newBody(world, xSpawn, ySpawn, bodyType)
    self.shape = love.physics.newRectangleShape(0, 0, width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape);
    self.fixture:setFriction(0.9)
    self.color = {1, 0.2, 0.7}

    local centre = Vector(self.body:getPosition())

    -- get the rotation point (top left corner)
    local rotationPoint = Vector(centre.x - width/2, centre.y - height/2)

    -- move to be around rotation point
    centre = centre - rotationPoint

    -- rotate
    local new = centre:rotated(math.rad(rotation))

    -- move point back
    centre = new + rotationPoint

    self.body:setPosition(centre:unpack())
    self.body:setAngle(math.rad(rotation))
end

function Rectangle:draw()
    self:drawRectPhysicsObject(self)
end

return Rectangle
