local Class = require "hump.class"
local Vector = require "hump.vector"

local BaseObject = require "toys/baseObject"

ExplodingPlatform = Class{__includes = BaseObject}

function ExplodingPlatform:init(world, mapObject)
    self.mapObject = mapObject

    -- Save all our map object values for re-spawn
    self.width, self.height = mapObject.width, mapObject.height
    
    self.xSpawn, self.ySpawn = mapObject.x + (self.width / 2), mapObject.y + (self.height / 2)
    self.bodyType = self:checkStaticBool(mapObject.properties.static)
    self.rotation = mapObject.rotation

    self:resetPhysicsObject(world, mapObject)

    if mapObject.properties.texturePath then
        self.image = love.graphics.newImage(mapObject.properties.texturePath)
    end

    -- check if we're important to the camera
    self.cameraDistance = mapObject.properties.cameraDistance
    self.cameraFocus = mapObject.properties.cameraFocus

    -- start timer
    -- TODO: randomize respawn/despawned times
    self.timer = 5

    self.state = "exists"

    -- TODO: become more red as we get closer to exploding
    self.color = {1, 1, 1, 1}
end

function ExplodingPlatform:resetPhysicsObject(world)
    -- [re]-create based on saved values
    self.body = love.physics.newBody(world, self.xSpawn, self.ySpawn, self.bodyType)
    self.shape = love.physics.newRectangleShape(0, 0, self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape);
    self.fixture:setFriction(0.9)
    self.color = {1, 0.2, 0.7}

    local centre = Vector(self.body:getPosition())

    -- get the rotation point (top left corner)
    local rotationPoint = Vector(centre.x - self.width/2, centre.y - self.height/2)

    -- move to be around rotation point
    centre = centre - rotationPoint

    -- rotate
    local new = centre:rotated(math.rad(self.rotation))

    -- move point back
    centre = new + rotationPoint

    self.body:setPosition(centre:unpack())
    self.body:setAngle(math.rad(self.rotation))
end

function ExplodingPlatform:getPosition()
    -- TODO: untested... test as camera object
    -- if self.body and not self.body:isDestroyed() then
    --     return self.body:getPosition()
    -- end

    return self.xSpawn, self.ySpawn
end

function ExplodingPlatform:getColor()
    return self.color[1], self.color[2], self.color[3], self.color[4]
end

function ExplodingPlatform:update(dt, world)
    self.timer=self.timer-dt

    if self.timer < 0 then
        if self.state=="exists" then
            -- blow up
            self.body:destroy()
            self.state = "recovering"
            self.timer = 5
        elseif self.state=="recovering" then
            -- respawn
            self:resetPhysicsObject(world)
            self.timer = 5
        end
    end
end

function ExplodingPlatform:draw()
    if self.body and not self.body:isDestroyed() then
        self:drawRectangleObject(self)
    end
end

return ExplodingPlatform
