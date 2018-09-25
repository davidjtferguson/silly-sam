local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

HangingBag = Class{__includes = BaseObject}

function HangingBag:init(world, xSpawn, ySpawn)

    -- create a static anchor point
    self.anchor = {}
    self.anchor.body = love.physics.newBody(world, xSpawn, ySpawn, "static")
    self.anchor.shape = love.physics.newCircleShape(5)
    self.anchor.fixture = love.physics.newFixture(self.anchor.body, self.anchor.shape, 0.5);
    self.anchor.fixture:setFriction(0.5)
    self.anchor.color = {0.80, 0.20, 0.20}

    local chainLength = 200

    -- chain
    self.chain = {}
    self.chain.body = love.physics.newBody(world, xSpawn, ySpawn, "dynamic")
    self.chain.shape = love.physics.newChainShape(false, 0, 0, chainLength/2, chainLength/2, chainLength, chainLength)
    self.chain.fixture = love.physics.newFixture(self.chain.body, self.chain.shape)
    self.chain.fixture:setFriction(0.9)
    self.chain.fixture:setDensity(0.01)
    self.chain.color = {0, 1, 0.7}

    -- join to anchor
    self.anchor.joint = love.physics.newWeldJoint(self.anchor.body, self.chain.body, xSpawn, ySpawn)

    -- the actual bag
    self.bag = {}
    self.bag.body = love.physics.newBody(world, xSpawn+chainLength, ySpawn+chainLength, "dynamic")
    self.bag.shape = love.physics.newRectangleShape(0, 0, 30, 70)
    self.bag.fixture = love.physics.newFixture(self.bag.body, self.bag.shape);
    self.bag.fixture:setFriction(0.5)
    self.bag.fixture:setDensity(0.01)
    self.bag.color = {1, 1, 1}

    -- join to chain
    self.bag.joint = love.physics.newWeldJoint(self.bag.body, self.chain.body, xSpawn+chainLength, ySpawn+chainLength)
end

function HangingBag:draw()
    love.graphics.setColor(self.chain.color)
    love.graphics.setLineWidth(10)

    -- love.graphics.line(500, 500, 600, 600)
    love.graphics.line(self.chain.shape:getPoints())

    test = self.chain.shape:getPoints()
    
    self:drawCirclePhysicsObject(self.anchor)
    self:drawRectPhysicsObject(self.bag)
end

return HangingBag
