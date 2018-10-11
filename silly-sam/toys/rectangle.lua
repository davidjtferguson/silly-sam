local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

Rectangle = Class{__includes = BaseObject}

function Rectangle:init(world, xSpawn, ySpawn, width, height, rotation)
    self.body = love.physics.newBody(world, xSpawn, ySpawn, "static")
    self.shape = love.physics.newRectangleShape(0, 0, width, height)
    self.fixture = love.physics.newFixture(self.body, self.shape);
    self.fixture:setFriction(0.9)
    
    self.color = {1, 0.2, 0.7}

    -- get the rotation point (top left corner)
    local originalX, originalY = self.body:getPosition()

    originalX = originalX - width/2
    originalY = originalY - height/2

    local originalWorldX, originalWorldY = self.body:getWorldPoint(originalX, originalY)

    -- rotate
    self.body:setAngle(math.rad(rotation))

    -- TODO find the new position of the top left corner 
    local originalX, originalY = self.body:getPosition()

    -- need to use some trig to find the now rotated point
    originalX = originalX - width/2
    originalY = originalY - height/2
    
    local afterWorldX, afterWorldY = self.body:getWorldPoint(originalX, originalY)

    -- find the difference of the original point and the rotated way, and take it away
    -- to make the new position
    local afterX, afterY = self.body:getPosition()

    local endX = afterX + (originalWorldX - afterWorldX)

    local endY = afterY + (originalWorldY - afterWorldY)

    self.body:setPosition(endX, endY)
end

function Rectangle:draw()
    self:drawRectPhysicsObject(self)
end

return Rectangle
 
-- b2Vec2 vertexLocalPos;//fulcrum vertex in local (body) coords

-- b2Vec2 vertexBeforeWorldPos = body->GetWorldPoint( vertexLocalPos );

-- body->SetTransform( body->GetPosition(), body->GetAngle() + angleChange );

-- b2Vec2 vertexAfterWorldPos =  body->GetWorldPoint( vertexLocalPos );

-- body->SetTransform( body->GetPosition() + vertexBeforePos - vertexAfterPos, body->GetAngle() );