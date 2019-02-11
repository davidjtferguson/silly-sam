local StateManager = require "hump.gamestate"

local PauseState = {}

function PauseState:init()
    self.controls = {
        bindings = {
            restart = function() print("restart level") end,
            resume = function() StateManager.pop() end,
            quit = function() love.event.quit() end,
            toggleFullscreen = function() self.gameState:toggleFullscreen() end,
        },
        keysPressed = {
        },
        keysReleased = {
            p = "resume",
            r = "restart",
            escape = "quit",
            f = "toggleFullscreen",
        },
        buttonsPressed = {
        },
        buttonsReleased = {
            b = "resume",
            start = "resume",
            y = "restart",
            back = "quit",
            dpright = "toggleFullscreen",
        },
    }
end

-- Should only ever come from gamestate. Will need to make more flexable if there was ever to be other states that could lead here
function PauseState:enter(gameState)
    self.gameState = gameState
    love.graphics.setBackgroundColor(0.9, 0.96, 0.988)
end

function PauseState:update(dt)
end

-- input handling callbacks
-- TODO: Duplicated from gameState. Should be generic somewhere.

function PauseState:keypressed(k)
    local binding = self.controls.keysPressed[k]
    return inputHandler(binding)
end

function PauseState:gamepadpressed(gamepad, button)
    local binding = self.controls.buttonsPressed[button]
    return inputHandler(binding)
end

function PauseState:keyreleased(k)
    local binding = self.controls.keysReleased[k]
    return inputHandler(binding)
end

function PauseState:gamepadreleased(gamepad, button)
    local binding = self.controls.buttonsReleased[button]
    return inputHandler(binding)
end

function PauseState:draw()
    -- draw current gamestate as a background
    self.gameState:draw()
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("paused", 300, 300)
end

return PauseState
