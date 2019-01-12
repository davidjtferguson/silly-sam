local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

Skateboard = Class{__includes = BaseObject}

function Skateboard:init(world, mapObject)
    local xSpawn, ySpawn = mapObject.x, mapObject.y

    -- board
    self.board = {}
    self.board.width, self.board.height = 100, 5
    self.board.body = love.physics.newBody(world, xSpawn, ySpawn, "dynamic")
    self.board.shape = love.physics.newRectangleShape(0, 0, self.board.width, self.board.height)
    self.board.fixture = love.physics.newFixture(self.board.body, self.board.shape);
    self.board.fixture:setFriction(0.9)
    self.board.color = {1, 0.2, 0.7}

    if mapObject.properties.texturePathBoard then
        self.board.image = love.graphics.newImage(mapObject.properties.texturePathBoard)
    end

    -- Some vars for controlling wheel positions and size
    local halfDistanceBetweenWheels = 30
    local wheelRadius = 8
    local xLeftWheelSpawn, yLeftWheelSpawn = xSpawn-halfDistanceBetweenWheels, ySpawn+11
    local xRightWheelSpawn, yRightWheelSpawn = xSpawn+halfDistanceBetweenWheels, yLeftWheelSpawn

    local wheelImage = nil
    if mapObject.properties.texturePathWheel then
        wheelImage = love.graphics.newImage(mapObject.properties.texturePathWheel)
    end

    -- left wheel
    self.leftWheel = {}
    self.leftWheel.body = love.physics.newBody(world, xLeftWheelSpawn, yLeftWheelSpawn, "dynamic")
    self.leftWheel.shape = love.physics.newCircleShape(wheelRadius)
    self.leftWheel.fixture = love.physics.newFixture(self.leftWheel.body, self.leftWheel.shape, 0.5);
    self.leftWheel.fixture:setFriction(0.5)
    self.leftWheel.color = {0.80, 0.20, 0.20}

    self.leftWheel.joint = love.physics.newRevoluteJoint(self.board.body, self.leftWheel.body, xLeftWheelSpawn, yLeftWheelSpawn)

    self.leftWheel.image = wheelImage

    -- right wheel
    self.rightWheel = {}

    self.rightWheel.body = love.physics.newBody(world, xRightWheelSpawn, yRightWheelSpawn, "dynamic")
    self.rightWheel.shape = love.physics.newCircleShape(wheelRadius)
    self.rightWheel.fixture = love.physics.newFixture(self.rightWheel.body, self.rightWheel.shape, 0.5);
    self.rightWheel.fixture:setFriction(0.5)
    self.rightWheel.color = {0.80, 0.20, 0.20}

    self.rightWheel.joint = love.physics.newRevoluteJoint(self.board.body, self.rightWheel.body, xRightWheelSpawn, yRightWheelSpawn)

    self.rightWheel.image = wheelImage

    -- check if we're important to the camera
    self.cameraDistance = mapObject.properties.cameraDistance
    self.cameraFocus = mapObject.properties.cameraFocus
end

function Skateboard:getPosition()
    return self.board.body:getPosition()
end

function Skateboard:draw()
    self:drawRectangleObject(self.board)
    self:drawCircleObject(self.leftWheel)
    self:drawCircleObject(self.rightWheel)
end

return Skateboard
