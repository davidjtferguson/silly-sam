local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

Ball = Class{__includes = BaseObject}

function Ball:init(world, xSpawn, ySpawn, radius, bodyType)
    self.body = love.physics.newBody(world, xSpawn, ySpawn, bodyType)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape, 0.5);
    self.fixture:setFriction(0.5)
    self.color = {0.80, 0.20, 0.20}
end

function Ball:draw()
    self:drawCirclePhysicsObject(self)
end

return Ball
