local StateManager = require "hump.gamestate"

local PauseState = {}

function PauseState:init()
end

function PauseState:enter(gameState)
    self.gameState = gameState
    love.graphics.setBackgroundColor(0.9, 0.96, 0.988)
end

function PauseState:update(dt)
end

function PauseState:keypressed(key)
    if key == 'p' then
        return StateManager.pop()
    end
end

function PauseState:gamepadpressed(gamepad, button)
    if button == "start" then
        return StateManager.pop()
    end
end

function PauseState:draw()
    -- draw current gamestate as a background
    self.gameState:draw()
    
    love.graphics.print("paused", 300, 300)
end

return PauseState
