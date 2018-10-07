local StateManager = require "hump.gamestate"

local PauseState = {}

function PauseState:init()
end

function PauseState:update(dt)
end

-- input handling callbacks

function PauseState:keypressed(key)
    if key == 'p' then
        return StateManager.pop() -- return to previous state
    end
end

function PauseState:gamepadpressed(gamepad, button)
    if button == "start" then
        return StateManager.pop() -- return to previous state
    end
end

function PauseState:draw()
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.print("paused", 300, 300)
end

return PauseState
