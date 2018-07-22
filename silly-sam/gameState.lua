
GameState = {}

-- need to investigate this -- something to do with hooking up the metatable
GameState.__index = GameState

function GameState:create()
    local gameState = {}

    setmetatable(gameState, GameState)

    -- create a world
    love.physics.setMeter(100)
    gameState.world = love.physics.newWorld(0, 10*100, true)

    gameState.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

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

    self.sam:armForces(dt, self.sam.leftArm, "leftx", "lefty");
    self.sam:armForces(dt, self.sam.rightArm, "rightx", "righty");
end

-- should have some kinda 'physics helper' class for stuff like this
function rotateImpulse(angle, xImpulse, yImpulse)
    -- can I use this instead of manual? Can only seem to apply to graphics
    --local rotateMatrix = love.math.newTransform(leg.body:getX(), leg.body:getY(), angle)

    local xResult = xImpulse*math.cos(angle) + yImpulse*math.sin(angle)
    local yResult = xImpulse*math.sin(angle) + yImpulse*-math.cos(angle)

    return xResult, yResult
end

-- these should all be in a physics helper
function beginContact(body1, body2, contact)
    -- check the contact created is actually touching
    if not contact:isTouching() then
        return
    end

    -- need to be a lot smarter here - suppose to check the arguments being passed in
    -- and NEED to not refer to state. How do I make it this?? Need to pass in class functions to call back
    for i in pairs(state.sam.parts) do
        state.sam.parts[i].onGround = state.sam.parts[i].body:isTouching(state.solids.ground.body)
    end
end

function endContact(body1, body2, contact)
    for i in pairs(state.sam.parts) do
        state.sam.parts[i].onGround = state.sam.parts[i].body:isTouching(state.solids.ground.body)
    end
end

-- what are these??
function preSolve(body1, body2, contact)

end

function postSolve(body1, body2, contact)

end

function GameState:draw()
    self.solids:draw()

    self.sam:draw()
end

return GameState