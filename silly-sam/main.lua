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

    test = ''
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

function love.draw()
    state:draw()

    love.graphics.print(test, 0, 0)
end
