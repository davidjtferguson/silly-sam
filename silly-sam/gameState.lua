GameState = {}
GameState.__index = GameState

function GameState:create()
    local gameState = {}
    setmetatable(gameState, GameState)

    -- create a world
    -- maybe the physics manager should own the world?
    love.physics.setMeter(100)
    gameState.world = love.physics.newWorld(0, 10*100, true)

    -- really want to pass in the class' functions for the call back instead of these global ones
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

    -- create the walls
    local solidsFactory = require "solids"
    gameState.solids = solidsFactory:create(gameState.world)

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

    self.sam:armForces(dt, self.sam.leftArm, "leftx", "lefty", self.solids.ground);
    self.sam:armForces(dt, self.sam.rightArm, "rightx", "righty", self.solids.ground);
end

-- Should these should all be in a physics helper?
function GameState:beginContact(body1, body2, contact)
    -- check the contact created is actually touching
    if not contact:isTouching() then
        return
    end

    -- need to be a lot smarter here - supposed to check the arguments being passed in
    for i in pairs(self.sam.parts) do
        self.sam.parts[i].onGround = self.sam.parts[i].body:isTouching(self.solids.ground.body)
    end
end

function GameState:endContact(body1, body2, contact)
    for i in pairs(self.sam.parts) do
        self.sam.parts[i].onGround = self.sam.parts[i].body:isTouching(self.solids.ground.body)
    end
end

-- what are these?
function GameState:preSolve(body1, body2, contact)
end

function GameState:postSolve(body1, body2, contact)
end

function GameState:draw()
    self.solids:draw()

    self.sam:draw()
end

return GameState
