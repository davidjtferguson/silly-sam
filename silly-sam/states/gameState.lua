local Class = require "hump.class"
local Camera = require "hump.camera"
local Sti = require "Simple-Tiled-Implementation/sti"
local StateManager = require "hump.gamestate"

local Sam = require "sam"
local Skateboard = require "toys/skateboard"
local HangingBag = require "toys/hangingBag"
local Ball = require "toys/ball"
local Rectangle = require "toys/rectangle"

local PauseState = require "states/pauseState"

local GameState = {}

function GameState:init()
    -- create a physics world
    -- maybe some physics manager should own the world?
    love.physics.setMeter(100)
    self.physicsWorld = love.physics.newWorld(0, 10*100, true)

    -- load the map
    self.map = Sti("maps/test-map-limited-level.lua", { "box2d" })
    self.map:box2d_init(self.physicsWorld)

    -- table of stuff to interact with
    self.toys = {}

    -- go through all the objects in the map and assign each
    for k, object in pairs(self.map.objects) do
        if object.name == "sam" then
            -- create sam instance
            self.sam = Sam(self.physicsWorld, object.x, object.y)

        elseif object.name == "skateboard" then
            table.insert(self.toys, Skateboard(self.physicsWorld, object.x, object.y))

        elseif object.name == "hangingBag" then
            local hangingBag =
                HangingBag(self.physicsWorld,
                    object.x, object.y,
                    object.properties.ropeLength,
                    object.properties.bagWidth, object.properties.bagHeight,
                    object.properties.pivotingJoint)

            table.insert(self.toys, hangingBag)

        elseif object.name == "ball" then
            local radius = (object.width + object.height) / 4
            local ball = Ball(self.physicsWorld, object.x + radius, object.y + radius, radius)

            table.insert(self.toys, ball)

        elseif object.name == "rectangle" then
            local rectangle =
                Rectangle(self.physicsWorld,
                    object.x + (object.width / 2),
                    object.y + (object.height / 2),
                    object.width, object.height,
                    object.rotation)

            table.insert(self.toys, rectangle)
        end
    end

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
    self.camera = Camera(self.sam.chest.body:getPosition())

    self.controls = {
        bindings = {
            left = function() self.sam:moveLeft() end,
            right = function() self.sam:moveRight() end,
            reset = reset,
            zoomIn = function() self.camera:zoom(1.1, self.map) end,
            zoomOut = function() self.camera:zoom(0.9, self.map) end,
            resetZoom = function() self.camera:zoomTo(1, self.map) end,
            closeGame = function() love.window.close() end,
            pause = function() StateManager.push(PauseState) end,
        },
        keysPressed = {
            c = "left",
            n = "right",
            r = "reset",
            m = "zoomIn",
            o = "zoomOut",
            f = "resetZoom",
            escape = "closeGame",
            p = "pause",
        },
        buttonsPressed = {
            leftshoulder = "left",
            rightshoulder = "right",
            dpup = "zoomIn",
            dpdown = "zoomOut",
            dpleft = "resetZoom",
            back = "closeGame",
            b = "reset",
            start = "pause",
        },
        -- clockwise arm inputs
        keysLeftArm = {
            "w",
            "d",
            "s",
            "a",
        },
        keysRightArm = {
            "i",
            "l",
            "k",
            "j",
        },
    }
end

function GameState:update(dt)
    -- throttle to 1/60 so if an update takes unusually long the game doesn't freak
    -- should maybe be in the main update? could do if I only register specific events with StateManager.registerEvents()
    if dt > 1/60 then
        dt = 1/60
    end
    
    self.physicsWorld:update(dt)

    self.camera:updateCamera(self.sam, dt)

    self.sam:armForces(dt, self.sam.leftArm, self.controls.keysLeftArm, "leftx", "lefty");
    self.sam:armForces(dt, self.sam.rightArm, self.controls.keysRightArm, "rightx", "righty");
end

-- input handling callbacks

function GameState:keypressed(k)
    local binding = self.controls.keysPressed[k]
    return inputHandler(binding)
end

function GameState:gamepadpressed(gamepad, button)
    local binding = self.controls.buttonsPressed[button]
    return inputHandler(binding)
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

    self.camera:attach()
    self.sam:draw()

    for i in pairs(self.toys) do
        self.toys[i]:draw()
    end
    self.camera:detach()
end

-- if the gamestate is left (popped or switched), reset it so if the same instance is returned to it's back from the start of the level
function GameState:leave()
    self:init()
end

return GameState
