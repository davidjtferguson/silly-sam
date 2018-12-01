local Class = require "hump.class"
local Vector = require "hump.vector"

local BaseObject = require "toys/baseObject"

Rectangle = Class{__includes = BaseObject}

function Rectangle:init(world, mapObject)
    -- calculate values from map object
    self.width, self.height = mapObject.width, mapObject.height

    local xSpawn, ySpawn = mapObject.x + (self.width / 2), mapObject.y + (self.height / 2)
    local bodyType = self:checkStaticBool(mapObject.properties.static)

    self.body = love.physics.newBody(world, xSpawn, ySpawn, bodyType)
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
    local new = centre:rotated(math.rad(mapObject.rotation))

    -- move point back
    centre = new + rotationPoint

    self.body:setPosition(centre:unpack())
    self.body:setAngle(math.rad(mapObject.rotation))
    
    if mapObject.properties.texturePath then
        self.image = love.graphics.newImage(mapObject.properties.texturePath)
    end
end

function Rectangle:draw()
    if self.image then
        self:drawRectangleTexturedObject(self, 1)
    else
        self:drawRectanglePhysicsObject(self)
    end
end

return Rectangle
