local StateManager = require "hump.gamestate"

local PauseState = {}

function PauseState:init()
    self.pauseOptionsImage = love.graphics.newImage("assets/art/pause-screen.png")

    self.controls = {
        bindings = {
            restart = self.restart,
            resume = StateManager.pop,
            quit = love.event.quit,
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

-- TODO: Currently resets whole game, just want to restart the level... OR DO WE??
function PauseState:restart()
    StateManager.pop()
    reset()
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

    -- draw image with instructions on top at the centre of the screen
    love.graphics.draw(self.pauseOptionsImage,
        love.graphics.getWidth()/2, love.graphics.getHeight()/2,
        0,
        1, 1,
        self.pauseOptionsImage:getWidth()/2, self.pauseOptionsImage:getHeight()/2)
end

return PauseState
