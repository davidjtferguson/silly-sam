local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

Ball = Class{__includes = BaseObject}

function Ball:init(world, mapObject)
    local radius = (mapObject.width + mapObject.height) / 4
    
    local xSpawn, ySpawn = mapObject.x + radius, mapObject.y + radius
    local bodyType = self:checkStaticBool(mapObject.properties.static)

    self.body = love.physics.newBody(world, xSpawn, ySpawn, bodyType)
    self.body:setUserData("ball")
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape, 0.5);
    self.fixture:setFriction(0.5)
    self.color = {0.80, 0.20, 0.20}

    if mapObject.properties.texturePath then
        self.image = love.graphics.newImage(mapObject.properties.texturePath)
    end
    
    -- check if we're important to the camera
    self.cameraDistance = mapObject.properties.cameraDistance
    self.cameraFocus = mapObject.properties.cameraFocus
end

function Ball:getPosition()
    return self.body:getPosition()
end

function Ball:draw()
    self:drawCircleObject(self)
end

return Ball
