GameState = {}
GameState.__index = GameState

local Sti = require "Simple-Tiled-Implementation/sti"
local Camera = require "hump.camera"

function GameState:create()
    local gameState = {}
    setmetatable(gameState, GameState)

    -- create a physics world
    -- maybe the physics manager should own the world?
    love.physics.setMeter(100)
    gameState.physicsWorld = love.physics.newWorld(0, 10*100, true)

    -- load the map
    gameState.map = Sti("maps/test-map-limited-level.lua", { "box2d" })

    gameState.map:box2d_init(gameState.physicsWorld)

    gameState.physicsWorld:setCallbacks(
        function(body1, body2, contact)
            gameState:beginContact(body1, body2, contact)
        end,
        function(body1, body2, contact)
            gameState:endContact(body1, body2, contact)
        end,
        function(body1, body2, contact)
            gameState:preSolve(body1, body2, contact)
        end,
        function(body1, body2, contact)
            gameState:postSolve(body1, body2, contact)
        end
    )

    -- create sam instance
    local samFactory = require "sam"
    gameState.sam = samFactory:create(gameState.physicsWorld)

    -- make camera focus on Sam
    gameState.camera = Camera(gameState.sam.chest.body:getPosition())

    gameState.controls = {
        bindings = {
            left = function() gameState.sam:moveLeft() end,
            right = function() gameState.sam:moveRight() end,
            start = reset,
        },
        keysPressed = {
            f = "left",
            j = "right",
            r = "start",
        },
        buttonsPressed = {
            leftshoulder = "left",
            rightshoulder = "right",
            start = "start",
        }
    }

    return gameState
end

function GameState:update(dt)
    self.physicsWorld:update(dt)

    self:updateCamera(dt)

    self.sam:armForces(dt, self.sam.leftArm, "leftx", "lefty");
    self.sam:armForces(dt, self.sam.rightArm, "rightx", "righty");
end

-- move to some kind of camera class?
function GameState:updateCamera(dt)

    -- move the camera to follow sam's chest position (as a quick implementation)
    local samx, samy = self.sam.chest.body:getPosition()
    local dx,dy = samx - self.camera.x, samy - self.camera.y
    self.camera:move(dx/2, dy/2)

    -- TODO: want to give camera some room where sam can move without camera
    -- and smooth it's movement
end


-- Should these should all be in a physics helper?
function GameState:beginContact(fixture1, fixture2, contact)
    -- check the contact created is actually touching
    if not contact:isTouching() then
        return
    end
    
    self:bodyOnGround(fixture1:getBody(), fixture2:getBody())
    self:bodyOnGround(fixture2:getBody(), fixture1:getBody())
end

function GameState:endContact(fixture1, fixture2, contact)
    self:bodyOnGround(fixture1:getBody(), fixture2:getBody())
    self:bodyOnGround(fixture2:getBody(), fixture1:getBody())
end

function GameState:bodyOnGround(body1, body2)
    -- if one body is a bodypart
    local isBody1Part = false

    for i in pairs(self.sam.allParts) do
        if self.sam.allParts[i].body == body1 then
            isBody1Part = true
        end
    end
    
    -- and the other body is not a body part
    local isBody2Part = false

    for i in pairs(self.sam.allParts) do
        if self.sam.allParts[i].body == body2 then
            isBody2Part = true
        end
    end

    -- then the trigger was a body part hitting a non body part so react
    if isBody1Part and not isBody2Part then
        for i in pairs(self.sam.allParts) do
            if self.sam.allParts[i].body == body1 then
                self.sam.allParts[i].onGround = self.sam.allParts[i].body:isTouching(body2)
            end
        end
    end
end

-- what are these?
function GameState:preSolve(body1, body2, contact)
end

function GameState:postSolve(body1, body2, contact)
end

function GameState:draw()
    love.graphics.setColor(1, 1, 1)

    self.map:draw(self:getCameraToStiTransforms())
    -- self.map:box2d_draw()

    self.camera:attach()
    self.sam:draw()
    self.camera:detach()
end

-- Could move to be part of the bump camera, or extend the class with my own
function GameState:getCameraToStiTransforms()

    -- Need to transform our camera info into data we can pass to sti
    -- (thanks to discussion @ https://love2d.org/forums/viewtopic.php?t=84544 !)
	local tx = self.camera.x - love.graphics.getWidth() / 2
	local ty = self.camera.y - love.graphics.getHeight() / 2

	if tx < 0 then 
		tx = 0 
	end
	if tx > self.map.width  * self.map.tilewidth  - love.graphics.getWidth()  then
		tx = self.map.width  * self.map.tilewidth  - love.graphics.getWidth()  
	end
	if ty > self.map.height * self.map.tileheight - love.graphics.getHeight() then
		ty = self.map.height * self.map.tileheight - love.graphics.getHeight()
	end

	tx = math.floor(tx)
	ty = math.floor(ty)

    return -tx, -ty, self.camera.scale, self.camera.scale
end

return GameState
