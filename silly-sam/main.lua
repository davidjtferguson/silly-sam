--  SILLY SAM
--  By Davbo and Rory~

local StateManager = require "hump.gamestate"

local GameState = require "gameState"

function love.load()
    
    love.window.setMode(1000, 600, {fullscreen = false})
    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)

    -- find controller
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    
    StateManager.registerEvents()
    reset()
end

function reset()

    -- TODO: Clear all states, and switch to a fresh gameState
    print(StateManager.current)
    -- while StateManager.current ~= nil do
    --     StateManager.pop()
    -- end

    StateManager.switch(GameState)
    --StateManager.current().init()
end

function love.update(dt)
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
