function love.load()
    reset()
end

function reset()
    love.window.setMode(1000, 600, {fullscreen = false})
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

    love.physics.setMeter(100)
    world = love.physics.newWorld(0, 10*100, true)

    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    solids = {}

    solids.ground = {}
    solids.ground.body = love.physics.newBody(world, 1000/2, 600-50/2)
    solids.ground.shape = love.physics.newRectangleShape(0, 0, 800, 50)
    solids.ground.fixture = love.physics.newFixture(solids.ground.body, solids.ground.shape);
    solids.ground.fixture:setFriction(0.9)
    --solids.ground.fixture:setMask(2)

    solids.leftWall = {}
    solids.leftWall.body = love.physics.newBody(world, 1000/2, 600-500/2)
    solids.leftWall.shape = love.physics.newRectangleShape(-425, 0, 50, 500)
    solids.leftWall.fixture = love.physics.newFixture(solids.leftWall.body, solids.leftWall.shape);
    --solids.leftWall.fixture:setMask(2)

    solids.rightWall = {}
    solids.rightWall.body = love.physics.newBody(world, 1000/2, 600-500/2)
    solids.rightWall.shape = love.physics.newRectangleShape(400, 0, 50, 500)
    solids.rightWall.fixture = love.physics.newFixture(solids.rightWall.body, solids.rightWall.shape);
    --solids.rightWall.fixture:setMask(2)

    local samFactory = require "sam"
    sam = samFactory:create(world)

    -- find controller
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    -- state for input
    state = {
        bindings = {
            left = moveLeft,
            right = moveRight,
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

    test = ''
end

function love.update(dt)
    world:update(dt)

    sam:armForces(dt, sam.leftArm, "leftx", "lefty");
    sam:armForces(dt, sam.rightArm, "rightx", "righty");
end

-- these 3 should be moved to a state manager of some kind
function inputHandler(input)
    local action = state.bindings[input]
    if action then
        return action()
    end
end

function love.keypressed(k)
    local binding = state.keysPressed[k]
    return inputHandler(binding)
end

function love.gamepadpressed(gamepad, button)
    local binding = state.buttonsPressed[button]
    return inputHandler(binding)
end

--consolidate both after figuring out applying force at rotation if poss
function moveLeft()
    if sam.leftLeg.onGround then
        forceUpLeg(sam.leftLeg)

        sam.leftLeg.body:applyForce(-1000, 0)
    end
end

function moveRight()
    if sam.rightLeg.onGround then
        forceUpLeg(sam.rightLeg)
        
        sam.rightLeg.body:applyForce(1000, 0)
    end
end

function forceUpLeg(leg)
    -- the impulse needs to always be acting up the edge of the box, on the corner of the box
    -- so we need to find the impulse direction and the corner point of the object
    leg.body:applyLinearImpulse(rotateImpulse(leg.body:getAngle(), 0, 100));
end

function rotateImpulse(angle, xImpulse, yImpulse)
    -- can I use this instead of manual? Can only seem to apply to graphics
    --local rotateMatrix = love.math.newTransform(leg.body:getX(), leg.body:getY(), angle)

    local xResult = xImpulse*math.cos(angle) + yImpulse*math.sin(angle)
    local yResult = xImpulse*math.sin(angle) + yImpulse*-math.cos(angle)

    return xResult, yResult
end

function beginContact(body1, body2, contact)

    -- check the contact created is actually touching
    if not contact:isTouching() then
        return
    end

    -- need to be a lot smarter here - suppose to check the arguments being passed in
    for i in pairs(sam.parts) do
        sam.parts[i].onGround = sam.parts[i].body:isTouching(solids.ground.body)
    end
end

function endContact(body1, body2, contact)
    for i in pairs(sam.parts) do
        sam.parts[i].onGround = sam.parts[i].body:isTouching(solids.ground.body)
    end
end

-- what are these??
function preSolve(body1, body2, contact)

end

function postSolve(body1, body2, contact)

end

function love.draw()
    love.graphics.setColor(0.28, 0.63, 0.05)

    for i in pairs(solids) do
        love.graphics.polygon("fill", solids[i].body:getWorldPoints(solids[i].shape:getPoints()))
    end

    love.graphics.setColor(0.20, 0.20, 0.20)

    for i in pairs(sam.parts) do
        love.graphics.setColor(getColor(sam.parts[i]))
        love.graphics.polygon("fill", sam.parts[i].body:getWorldPoints(sam.parts[i].shape:getPoints()))
    end

    love.graphics.setColor(sam.head.color)

    local wx, wy = sam.head.body:getWorldPoint(sam.head.shape:getPoint())
    love.graphics.circle("fill", wx, wy, sam.head.shape:getRadius())

    love.graphics.print(test, 0, 0)
end

function getColor(obj)
 return obj.color[1], obj.color[2], obj.color[3]
end