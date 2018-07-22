Solids = {}
Solids.__index = Solids

function Solids:create(world)
    local solids = {}
    setmetatable(solids, Solids)

    -- TODO: Load in the solids from a passed in tiled scene??
    -- but for now...

    
    -- create some walls
    
    solids.ground = {}
    solids.ground.body = love.physics.newBody(world, 1000/2, 600-50/2)
    solids.ground.shape = love.physics.newRectangleShape(0, 0, 800, 50)
    solids.ground.fixture = love.physics.newFixture(solids.ground.body, solids.ground.shape);
    solids.ground.fixture:setFriction(0.9)
    --solids.ground.fixture:setMask(2)

    solids.leftWall = {}
    solids.leftWall.body = love.physics.newBody(world, 1000/2, 600-500/2)
    solids.leftWall.shape = love.physics.newRectangleShape(-425, 0, 50, 500)
    solids.leftWall.fixture = love.physics.newFixture(solids.leftWall.body, solids.leftWall.shape);
    --solids.leftWall.fixture:setMask(2)

    solids.rightWall = {}
    solids.rightWall.body = love.physics.newBody(world, 1000/2, 600-500/2)
    solids.rightWall.shape = love.physics.newRectangleShape(400, 0, 50, 500)
    solids.rightWall.fixture = love.physics.newFixture(solids.rightWall.body, solids.rightWall.shape);
    --solids.rightWall.fixture:setMask(2)

    return solids
end

function Solids:draw()
    -- draw walls
    love.graphics.setColor(0.28, 0.63, 0.05)

    for i in pairs(self) do
        love.graphics.polygon("fill", self[i].body:getWorldPoints(self[i].shape:getPoints()))
    end
end

return Solids
