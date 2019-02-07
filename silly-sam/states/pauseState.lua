local StateManager = require "hump.gamestate"

local PauseState = {}

function PauseState:init()
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
    love.graphics.setBackgroundColor(0.9, 0.96, 0.988)
    love.graphics.setColor(0, 0, 0)
    
    love.graphics.print("paused", 300, 300)
end

return PauseState
