local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

Rectangle = Class{__includes = BaseObject}

function Rectangle:init(world, xSpawn, ySpawn, width, height)
    self.body = love.physics.newBody(world, xSpawn, ySpawn, "dynamic")
    self.shape = love.physics.newRectangleShape(0, 0, width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape);
    self.fixture:setFriction(0.9)

    self.color = {1, 0.2, 0.7}
end

function Rectangle:draw()
    self:drawRectPhysicsObject(self)
end

return Rectangle
