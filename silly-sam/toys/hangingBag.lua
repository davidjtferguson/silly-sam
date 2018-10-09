local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

HangingBag = Class{__includes = BaseObject}

function HangingBag:init(world, xSpawn, ySpawn, ropeLength, bagWidth, bagHeight, pivotingJoint)
    self.bagWidth = bagWidth
    self.bagHeight = bagHeight

    self.ropeColour = {0.9, 0.9, 0.9}

    -- create a static anchor point
    self.anchor = {}
    self.anchor.body = love.physics.newBody(world, xSpawn, ySpawn, "static")
    self.anchor.shape = love.physics.newCircleShape(5)
    self.anchor.fixture = love.physics.newFixture(self.anchor.body, self.anchor.shape, 0.5);
    self.anchor.fixture:setFriction(0.5)
    self.anchor.color = {0.5, 0.5, 0.5}

    self.bag = {}
    self.bag.body = love.physics.newBody(world, xSpawn, ySpawn+ropeLength, "dynamic")
    self.bag.shape = love.physics.newRectangleShape(0, 0, bagWidth, bagHeight)
    self.bag.fixture = love.physics.newFixture(self.bag.body, self.bag.shape, 0.5);
    self.bag.fixture:setFriction(0.5)
    self.bag.fixture:setDensity(1)
    self.bag.color = {0.2, 0.2, 0.2}

    if pivotingJoint then
        -- create another object between the bag and the rope to allow the bag to rotate around the join to the rope
        self.bagPivotPoint = {}
        self.bagPivotPoint.body = love.physics.newBody(world, xSpawn, ySpawn+ropeLength-bagHeight/2, "dynamic")
        self.bagPivotPoint.shape = love.physics.newCircleShape(5)
        self.bagPivotPoint.fixture = love.physics.newFixture(self.bagPivotPoint.body, self.bagPivotPoint.shape, 0.5);
        self.bagPivotPoint.fixture:setFriction(0.5)
        self.bagPivotPoint.color = {0.5, 0.5, 0.5}

        -- join pivot to the anchor
        self.anchor.joint = love.physics.newRevoluteJoint(self.anchor.body, self.bagPivotPoint.body, xSpawn, ySpawn)

        -- join bag to pivot
        self.bag.joint = love.physics.newRevoluteJoint(self.bag.body, self.bagPivotPoint.body, self.bagPivotPoint.body:getX(), self.bagPivotPoint.body:getY())
    else
        -- connect the anchor to the bag directly
        self.anchor.joint = love.physics.newRevoluteJoint(self.anchor.body, self.bag.body, xSpawn, ySpawn)
    end
end

function HangingBag:draw()
    -- draw 'rope'
    love.graphics.setLineWidth(10)
    love.graphics.setColor(self.ropeColour)
    if self.bagPivotPoint then
        love.graphics.line(self.anchor.body:getX(), self.anchor.body:getY(), self.bagPivotPoint.body:getX(), self.bagPivotPoint.body:getY())

        -- some visual indicator of what type of bag it is
        self:drawCirclePhysicsObject(self.bagPivotPoint)
    else
        love.graphics.line(self.anchor.body:getX(), self.anchor.body:getY(), self.bag.body:getX(), self.bag.body:getY())
    end
    
    self:drawCirclePhysicsObject(self.anchor)
    self:drawRectPhysicsObject(self.bag)
end

return HangingBag
