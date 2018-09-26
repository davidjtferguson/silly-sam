local Class = require "hump.class"
local BaseObject = require "toys/baseObject"

HangingBag = Class{__includes = BaseObject}

function HangingBag:init(world, xSpawn, ySpawn, chainLength)
    -- create a static anchor point
    self.anchor = {}
    self.anchor.body = love.physics.newBody(world, xSpawn, ySpawn, "static")
    self.anchor.shape = love.physics.newCircleShape(5)
    self.anchor.fixture = love.physics.newFixture(self.anchor.body, self.anchor.shape, 0.5);
    self.anchor.fixture:setFriction(0.5)
    self.anchor.color = {0.80, 0.20, 0.20}

    self.ropeColour = {0.9, 0.9, 0.9}

    local bagHeight = 70
    self.bag = {}
    self.bag.body = love.physics.newBody(world, xSpawn, ySpawn+chainLength, "dynamic")
    self.bag.shape = love.physics.newRectangleShape(0, 0, 30, bagHeight)
    self.bag.fixture = love.physics.newFixture(self.bag.body, self.bag.shape, 0.5);
    self.bag.fixture:setFriction(0.5)
    self.bag.fixture:setDensity(1)
    self.bag.color = {0.2, 0.2, 0.2}

    -- connect the anchor to the bag
    self.bag.joint = love.physics.newRevoluteJoint(self.bag.body, self.anchor.body, xSpawn, ySpawn+bagHeight/2)
end

function HangingBag:draw()
    love.graphics.setLineWidth(10)

    love.graphics.setColor(self.ropeColour)
    love.graphics.line(self.anchor.body:getX(), self.anchor.body:getY(), self.bag.body:getX(), self.bag.body:getY())

    self:drawCirclePhysicsObject(self.anchor)
    self:drawRectPhysicsObject(self.bag)
end

return HangingBag
