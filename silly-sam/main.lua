--[[
    SILLY SAM
    By Davbo and Rory~
]]

function love.load()
    reset()
end

function reset()
    love.window.setMode(1000, 600, {fullscreen = false})
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

    -- find controller
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    -- should be as simple as swapping out a state to change situation
    local gameStateFactory = require "gameState"
    state = gameStateFactory:create()

    test = 'hello'
    xTest = 0
    yTest = 0
end

function love.update(dt)
    state:update(dt)
end

-- these 3 should be moved to a state manager of some kind?
function inputHandler(input)
    local action = state.controls.bindings[input]
    if action then
        return action()
    end
end

function love.keypressed(k)
    local binding = state.controls.keysPressed[k]
    return inputHandler(binding)
end

function love.gamepadpressed(gamepad, button)
    local binding = state.controls.buttonsPressed[button]
    return inputHandler(binding)
end

-- should have some kinda 'physics helper' class for stuff like this
function rotateImpulse(angle, xImpulse, yImpulse)
    -- can I use this instead of manual? Can only seem to apply to graphics
    --local rotateMatrix = love.math.newTransform(leg.body:getX(), leg.body:getY(), angle)

    local xResult = xImpulse*math.cos(angle) + yImpulse*math.sin(angle)
    local yResult = xImpulse*math.sin(angle) + yImpulse*-math.cos(angle)

    return xResult, yResult
end

function love.draw()
    state:draw()

    -- for debugging
    love.graphics.print(test, xTest, yTest)
end
