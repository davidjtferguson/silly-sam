local Class = require "hump.class"

GameState = Class{}

function GameState:init()

    -- create a physics world
    -- maybe the physics manager should own the world?
    love.physics.setMeter(100)
    self.physicsWorld = love.physics.newWorld(0, 10*100, true)

    -- create sam instance
    local Sam = require "sam"
    self.sam = Sam(self.physicsWorld)

    -- load the map
    local Sti = require "Simple-Tiled-Implementation/sti"
    self.map = Sti("maps/test-map-limited-level.lua", { "box2d" })

    self.map:box2d_init(self.physicsWorld)

    self.physicsWorld:setCallbacks(
        function(body1, body2, contact)
            self:beginContact(body1, body2, contact)
        end,
        function(body1, body2, contact)
            self:endContact(body1, body2, contact)
        end,
        function(body1, body2, contact)
            self:preSolve(body1, body2, contact)
        end,
        function(body1, body2, contact)
            self:postSolve(body1, body2, contact)
        end
    )

    -- make camera focus on Sam
    local Camera = require "hump.camera"
    self.camera = Camera(self.sam.chest.body:getPosition())

    self.controls = {
        bindings = {
            left = function() self.sam:moveLeft() end,
            right = function() self.sam:moveRight() end,
            start = reset,
            zoomIn = function() self.camera:zoom(1.1, self.map) end,
            zoomOut = function() self.camera:zoom(0.9, self.map) end,
        },
        keysPressed = {
            f = "left",
            j = "right",
            r = "start",
            i = "zoomIn",
            o = "zoomOut",
        },
        buttonsPressed = {
            leftshoulder = "left",
            rightshoulder = "right",
            start = "start",
            dpup = "zoomIn",
            dpdown = "zoomOut",
        }
    }
end

function GameState:update(dt)
    self.physicsWorld:update(dt)

    self.camera:updateCamera(self.sam, dt)

    self.sam:armForces(dt, self.sam.leftArm, "leftx", "lefty");
    self.sam:armForces(dt, self.sam.rightArm, "rightx", "righty");
end

-- Should these should all be in a physics helper?
function GameState:beginContact(fixture1, fixture2, contact)
    -- check the contact created is actually touching
    if not contact:isTouching() then
        return
    end
    
    self:bodyOnGround(fixture1:getBody(), fixture2:getBody())
    self:bodyOnGround(fixture2:getBody(), fixture1:getBody())
end

function GameState:endContact(fixture1, fixture2, contact)
    self:bodyOnGround(fixture1:getBody(), fixture2:getBody())
    self:bodyOnGround(fixture2:getBody(), fixture1:getBody())
end

function GameState:bodyOnGround(body1, body2)
    -- if one body is a bodypart
    local isBody1Part = false

    for i in pairs(self.sam.allParts) do
        if self.sam.allParts[i].body == body1 then
            isBody1Part = true
        end
    end
    
    -- and the other body is not a body part
    local isBody2Part = false

    for i in pairs(self.sam.allParts) do
        if self.sam.allParts[i].body == body2 then
            isBody2Part = true
        end
    end

    -- then the trigger was a body part hitting a non body part so react
    if isBody1Part and not isBody2Part then
        for i in pairs(self.sam.allParts) do
            if self.sam.allParts[i].body == body1 then
                self.sam.allParts[i].onGround = self.sam.allParts[i].body:isTouching(body2)
            end
        end
    end
end

-- what are these?
function GameState:preSolve(body1, body2, contact)
end

function GameState:postSolve(body1, body2, contact)
end

function GameState:draw()
    love.graphics.setColor(1, 1, 1)

    self.map:draw(self.camera:getCameraToStiTransforms(self.map))
    -- self.map:box2d_draw()

    self.camera:attach()
    self.sam:draw()
    self.camera:detach()
end

return GameState
