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

    -- start timer (seconds)
    self.timer = 3 + love.math.random(9)

    self.state = "exists"

    -- Becomes more red as we get closer to exploding
    self.color = {1, 1, 1, 1}

    -- keep track of to gradually get more difficult
    self.timesExploded = 0
end

function ExplodingPlatform:resetPhysicsObject(world)
    -- [re]-create based on saved values
    self.body = love.physics.newBody(world, self.xSpawn, self.ySpawn, self.bodyType)
    self.body:setUserData("explodingPlatform")
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
    if self.body and not self.body:isDestroyed() then
        return self.body:getPosition()
    end

    -- if body doesn't exist, return where it's about to be
    return self.xSpawn, self.ySpawn
end

function ExplodingPlatform:getColor()
    return self.color[1], self.color[2], self.color[3], self.color[4]
end

function ExplodingPlatform:update(dt, world)
    self.timer=self.timer-dt

    if self.timer < 3 then
        -- normalize (kinda (not really lol)) timer from 3 - 0 to 1 - 0.3
        local newGB = (self.timer/3) + 0.3

        self.color = {1, newGB, newGB, 1}
    end

    if self.timer < 0 then
        if self.state=="exists" then
            -- blow up
            love.audio.play("assets/sounds/sfx/box-disappear.wav", "static")

            self.state = "recovering"
            self.timer = 1.5
            self.timesExploded = self.timesExploded + 1

            self.body:destroy()
        elseif self.state=="recovering" then
            -- respawn
            love.audio.play("assets/sounds/sfx/box-reappear.wav", "static")

            self.state = "exists"
            
            -- timer has a shorter potental maximum each time. Goes down to a mimimum of 3 seconds, which probably isn't survivable.
            -- GOOD. They're not supposed to survive. muahahaha. Should just survive long enough to find it funny, then move onto the next level.
            -- Might be annoying if it's unfair though? But only if people care about getting a 'high score'.
            -- and the game doesn't even track score. So, I dunno. Hmm. This game's all about the ride, mmaann
            -- and if we want to use this exploding object somewhere else should make fuse shortening a tiled attribute...
            -- ... Should chat to Rory about it.
            self.timer = (3 + love.math.random(9)) - (self.timesExploded * 0.5)

            if self.timer < 3 then
                self.timer = 3
            end

            self:resetPhysicsObject(world)
            self.color = {1, 1, 1, 1}
        end
    end
end

function ExplodingPlatform:draw()
    love.graphics.setColor(self:getColor())
    if self.body and not self.body:isDestroyed() then
        self:drawRectangleObject(self)
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

return ExplodingPlatform
