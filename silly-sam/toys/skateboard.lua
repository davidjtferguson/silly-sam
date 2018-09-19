local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

Skateboard = Class{__includes = BaseObject}

function Skateboard:init(world, xSpawn, ySpawn)
    -- board
    self.board = {}
    self.board.body = love.physics.newBody(world, xSpawn, ySpawn, "dynamic")
    self.board.shape = love.physics.newRectangleShape(0, 0, 100, 5)
    self.board.fixture = love.physics.newFixture(self.board.body, self.board.shape);
    self.board.fixture:setFriction(0.9)
    self.board.color = {1, 0.2, 0.7}

    -- Some vars for controlling wheel positions and size
    local halfDistanceBetweenWheels = 30
    local wheelRadius = 8
    local xLeftWheelSpawn, yLeftWheelSpawn = xSpawn-halfDistanceBetweenWheels, ySpawn+11
    local xRightWheelSpawn, yRightWheelSpawn = xSpawn+halfDistanceBetweenWheels, yLeftWheelSpawn

    -- left wheel
    self.leftWheel = {}
    self.leftWheel.body = love.physics.newBody(world, xLeftWheelSpawn, yLeftWheelSpawn, "dynamic")
    self.leftWheel.shape = love.physics.newCircleShape(wheelRadius)
    self.leftWheel.fixture = love.physics.newFixture(self.leftWheel.body, self.leftWheel.shape, 0.5);
    self.leftWheel.fixture:setFriction(0.5)
    self.leftWheel.color = {0.80, 0.20, 0.20}

    self.leftWheel.joint = love.physics.newRevoluteJoint(self.board.body, self.leftWheel.body, xLeftWheelSpawn, yLeftWheelSpawn)

    -- right wheel
    self.rightWheel = {}

    self.rightWheel.body = love.physics.newBody(world, xRightWheelSpawn, yRightWheelSpawn, "dynamic")
    self.rightWheel.shape = love.physics.newCircleShape(wheelRadius)
    self.rightWheel.fixture = love.physics.newFixture(self.rightWheel.body, self.rightWheel.shape, 0.5);
    self.rightWheel.fixture:setFriction(0.5)
    self.rightWheel.color = {0.80, 0.20, 0.20}

    self.rightWheel.joint = love.physics.newRevoluteJoint(self.board.body, self.rightWheel.body, xRightWheelSpawn, yRightWheelSpawn)
end

function Skateboard:draw()
    self:drawRectPhysicsObject(self.board)
    self:drawCirclePhysicsObject(self.leftWheel)
    self:drawCirclePhysicsObject(self.rightWheel)
end

return Skateboard
