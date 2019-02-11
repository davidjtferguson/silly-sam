--  SILLY SAM
--  By Berd

local StateManager = require "hump.gamestate"

local GameState = require "states/gameState"

function love.load()
    love.window.setMode(1000, 600, {fullscreen = false})

    imageData = love.image.newImageData("assets/art/window_icon.png")
    love.window.setIcon(imageData)

    love.window.setTitle("Silly Sam")

    love.graphics.setBackgroundColor(1, 0.96, 0.93)
    
    -- find controller... TODO: should probs be some update check so the controller doesn't need to be in as the game boots up to find it
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    
    StateManager.registerEvents()
    reset()
end

-- This reset function is more for debugging while creating.
-- to properly reset I really want to clear everything in the StateManager queue and start a new gamestate but I'm not sure how to do that.
function reset()
    StateManager.switch(GameState)
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
