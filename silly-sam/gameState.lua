GameState = {}
GameState.__index = GameState

local sti = require "Simple-Tiled-Implementation/sti"

function GameState:create()
    local gameState = {}
    setmetatable(gameState, GameState)

    -- create a world
    -- maybe the physics manager should own the world?
    love.physics.setMeter(100)
    gameState.world = love.physics.newWorld(0, 10*100, true)

    -- create the walls
    -- TODO: want to replace with map loading
    local solidsFactory = require "solids"
    gameState.solids = solidsFactory:create(gameState.world)

    -- load the map
    map = sti("maps/test-map-limited-level.lua", { "box2d" })

    map:box2d_init(gameState.world)

    gameState.world:setCallbacks(
        function(body1, body2, contact)
            gameState:beginContact(body1, body2, contact)
        end,
        function(body1, body2, contact)
            gameState:endContact(body1, body2, contact)
        end,
        function(body1, body2, contact)
            gameState:preSolve(body1, body2, contact)
        end,
        function(body1, body2, contact)
            gameState:postSolve(body1, body2, contact)
        end
    )

    -- create sam instance
    local samFactory = require "sam"
    gameState.sam = samFactory:create(gameState.world)

    gameState.controls = {
        bindings = {
            left = function() gameState.sam:moveLeft() end,
            right = function() gameState.sam:moveRight() end,
            start = reset,
        },
        keysPressed = {
            f = "left",
            j = "right",
            r = "start",
        },
        buttonsPressed = {
            leftshoulder = "left",
            rightshoulder = "right",
            start = "start",
        }
    }

    return gameState
end

function GameState:update(dt)
    self.world:update(dt)

    self.sam:armForces(dt, self.sam.leftArm, "leftx", "lefty", self.solids.ground);
    self.sam:armForces(dt, self.sam.rightArm, "rightx", "righty", self.solids.ground);
end

-- Should these should all be in a physics helper?
function GameState:beginContact(body1, body2, contact)
    -- check the contact created is actually touching
    if not contact:isTouching() then
        return
    end

    -- need to be a lot smarter here - supposed to check the arguments being passed in
    for i in pairs(self.sam.parts) do
        self.sam.parts[i].onGround = self.sam.parts[i].body:isTouching(self.solids.ground.body)
    end
end

function GameState:endContact(body1, body2, contact)
    for i in pairs(self.sam.parts) do
        self.sam.parts[i].onGround = self.sam.parts[i].body:isTouching(self.solids.ground.body)
    end
end

-- what are these?
function GameState:preSolve(body1, body2, contact)
end

function GameState:postSolve(body1, body2, contact)
end

function GameState:draw()
    self.solids:draw()

    love.graphics.setColor(1, 1, 1)

    -- seems like map.tiles is a table of the tiles available through the tile sheets,
    -- not a table of the active tiles on the map like I want.
    -- My current goal is to be able to check if a collision object that was created
    -- by the map has a particular attribute so I can dictate if Sam should be able to
    -- move off that tile or not.
    for i in pairs(map.tiles) do
        test = "trying"
        test = map.tiles[i].id
        if map.tiles[i].id then
            -- test = "not crash1"
            -- test = map.tiles[i].properties[1]
            -- if map.tiles[i].properties[1] == true then
            --     test = "not crash2"
            --     love.graphics.setColor(0, 0, 0)
            -- end
        end
    end

    map:draw()
    -- map:box2d_draw()

    self.sam:draw()
end

return GameState
