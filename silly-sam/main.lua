--  SILLY SAM
--  By Davbo and Rory~

local StateManager = require "hump.gamestate"

local GameState = require "gameState"

function love.load()
    reset()
    StateManager.registerEvents()
end

function reset()
    love.window.setMode(1000, 600, {fullscreen = false})
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

    -- find controller
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    StateManager.switch(GameState)
end

function love.update(dt)
    -- throttle to 1/60 so if an update takes unusually long the game doesn't freak
    if dt > 1/60 then
        dt = 1/60
    end

    StateManager.update(dt/6)
end

-- should be moved to a input manager of some kind?
function inputHandler(input)
    local action = StateManager.current().controls.bindings[input]
    if action then
        return action()
    end
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
    StateManager:draw()
end
