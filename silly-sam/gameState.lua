GameState = {}
GameState.__index = GameState

local sti = require "Simple-Tiled-Implementation/sti"

function GameState:create()
    local gameState = {}
    setmetatable(gameState, GameState)

    -- create a world
    -- maybe the physics manager should own the world?
    love.physics.setMeter(100)
    gameState.world = love.physics.newWorld(0, 10*100, true)

    -- load the map
    map = sti("maps/test-map-limited-level.lua", { "box2d" })

    map:box2d_init(gameState.world)

    gameState.world:setCallbacks(
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
    gameState.sam = samFactory:create(gameState.world)

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
    self.world:update(dt)

    self.sam:armForces(dt, self.sam.leftArm, "leftx", "lefty");
    self.sam:armForces(dt, self.sam.rightArm, "rightx", "righty");

    if self.sam.leftLeg.onGround then
        test = "true"
    else
        test = "false"
    end
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

    map:draw()
    -- map:box2d_draw()

    self.sam:draw()
end

return GameState
