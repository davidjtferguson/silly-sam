local Class = require "hump.class"
local Camera = require "hump.camera"
local Sti = require "Simple-Tiled-Implementation/sti"
local StateManager = require "hump.gamestate"

local Sam = require "sam"
local Skateboard = require "toys/skateboard"
local HangingBag = require "toys/hangingBag"
local Ball = require "toys/ball"
local Rectangle = require "toys/rectangle"
local ExplodingPlatform = require "toys/explodingPlatform" 

local CameraPoint = require "helpers/cameraPoint"
local NewLevelPoint = require "helpers/newLevelPoint"

local PauseState = require "states/pauseState"

local GameState = {}

local function checkStaticBool(static)
    if static then
        return "static"
    end
    return "dynamic"
end

function GameState:init()
    self:loadMap("maps/intro-map.lua")
    --self:loadMap("maps/survival-map.lua")
    --self:loadMap("maps/cliff.lua")
    --self:loadMap("maps/swinging.lua")
    --self:loadMap("maps/bonus.lua")
    --self:loadMap("maps/rory-level.lua")
    
    --self:loadMap("maps/test-map-limited-level.lua")

    self.controls = {
        bindings = {
            left = function() self.sam:moveLeft() end,
            right = function() self.sam:moveRight() end,
            leftGrab = function() self.sam:leftGrab() end,
            rightGrab = function() self.sam:rightGrab() end,
            leftRelease = function() self.sam:leftRelease() end,
            rightRelease = function() self.sam:rightRelease() end,
            
            toggleFullscreen = function() self:toggleFullscreen() end,
            toggleMusic = function() self:toggleMusic() end,
            pause = function() self:toPauseState() end,
        },
        keysPressed = {
            c = "left",
            n = "right",
            e = "leftGrab",
            u = "rightGrab",
        },
        keysReleased = {
            e = "leftRelease",
            u = "rightRelease",
            
            f = "toggleFullscreen",
            m = "toggleMusic",
            escape = "pause",
            p = "pause",
        },
        buttonsPressed = {
            -- legs done via update with triggers
            leftshoulder = "leftGrab",
            rightshoulder = "rightGrab",
        },
        buttonsReleased = {
            leftshoulder = "leftRelease",
            rightshoulder = "rightRelease",

            dpright = "toggleFullscreen",
            back = "toggleFullscreen",
            dpdown = "toggleMusic",
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

function GameState:getBackgroundColor() 
    return 1, 0.96, 0.93
end

function GameState:enter()
    love.graphics.setBackgroundColor(self:getBackgroundColor())
end

function GameState:resume()
    love.graphics.setBackgroundColor(self:getBackgroundColor())
end

function GameState:toPauseState()
    mainThemeMusic:pause()

    love.audio.play("assets/sounds/sfx/weird-sound.wav", "static")
    
    StateManager.push(PauseState, self)
end

-- Everything that needs reset on loading a new map
function GameState:loadMap(mapPath)
    -- Remember where we are for level re-starting
    self.currentLevelPath = mapPath

    -- [re]create a physics world
    -- TECHDEBT: (Pretty inefficient. Would be better to create the world once and re-set everything inside it. Then maybe level loading would be smoother)
    -- maybe some physics manager should own the world?
    love.physics.setMeter(100)
    if self.physicsWorld then
        self.physicsWorld:destroy()
    end

    self.physicsWorld = love.physics.newWorld(0, 10*100, true)

    -- load the map
    self.map = Sti(mapPath, { "box2d" })

    self.map:box2d_init(self.physicsWorld)

    -- Clear all info that might be hanging around from a prev. map
    -- and update the tables with our new map.

    -- table of stuff to interact with
    self.toys = {}

    -- tables for camera focus points
    -- (should be in camera but cba figuring out metatables rn)
    self.cameraFocusPoints = {}
    self.cameraInfluencePoints = {}

    -- table for level change points
    self.changeLevelPoints = {}

    -- go through all the objects in the map and assign each
    for k, object in pairs(self.map.objects) do
        if object.name == "cameraFocus" then
            table.insert(self.cameraFocusPoints, CameraPoint(object))

        elseif object.name == "cameraInfluence" then
            table.insert(self.cameraInfluencePoints, CameraPoint(object))

        elseif object.name == "changeLevel" then
            table.insert(self.changeLevelPoints, NewLevelPoint(object))

        elseif object.name == "sam" then
            -- create sam instance
            self.sam = Sam(self.physicsWorld, object)

        elseif object.name == "skateboard" then
            local skateboard = Skateboard(self.physicsWorld, object)
            table.insert(self.toys, skateboard)

        elseif object.name == "hangingBag" then
            table.insert(self.toys, HangingBag(self.physicsWorld, object))

        elseif object.name == "ball" then
            table.insert(self.toys, Ball(self.physicsWorld, object))

        elseif object.name == "rectangle" then
            table.insert(self.toys, Rectangle(self.physicsWorld, object))
        
        elseif object.name == "explodingPlatform" then
            table.insert(self.toys, ExplodingPlatform(self.physicsWorld, object))
        end
    end

    -- go through all objects and assign to a camera table if nessessary
    for _, toy in pairs(self.toys) do
        self:assignObjectToCameraTable(toy)
    end

    -- all the info for the toys should be in a layer called 'objects'
    -- TODO: rename to toys in all maps... or, just, anything that's not 'objects'
    -- Instead of drawing the objects/toys layer as normal, replace the draw function with drawing all the toy physics objects instead
    self.map.layers["objects"].draw = function()
        for i in pairs(self.toys) do
            self.toys[i]:draw()
        end
        
        -- bool: draw physics shapes, bool: draw sprites
        self.sam:draw(false, true)
    end

    -- make camera focus on Sam
    self.camera = Camera(self.sam.chest.body:getPosition())

    -- [re]initialise callbacks
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
        function(body1, body2, contact, normalImpulse)
            self:postSolve(body1, body2, contact, normalImpulse)
        end
    )
end

function GameState:assignObjectToCameraTable(object)
    if object.cameraDistance then

        -- check for focus/influence flag and add to focus or influence
        if object.cameraFocus then
            table.insert(self.cameraFocusPoints, object)
        else
            table.insert(self.cameraInfluencePoints, object)
        end
    end
end

function GameState:toggleFullscreen()
    love.window.setFullscreen(not love.window.getFullscreen())

    -- need to reset the map's scale.
    self.camera:zoomTo(self.camera.scale, self.map)
end

function GameState:toggleMusic()
    if mainThemeMusic:isPlaying() then
        mainThemeMusic:pause()
        musicMuted = true
    else
        mainThemeMusic:play()
        musicMuted = false
    end
end

function GameState:update(dt)
    -- throttle to 1/60 so if an update takes unusually long the game doesn't freak
    -- should maybe be in the main update? could do if I only register specific events with StateManager.registerEvents()
    if dt > 1/60 then
        dt = 1/60
    end
    
    self.physicsWorld:update(dt)

    self.camera:gamestateUpdate(self.sam, self.cameraInfluencePoints, self.cameraFocusPoints, self.map, dt)

    for _, toy in pairs(self.toys) do
        if toy.update then
            toy:update(dt, self.physicsWorld)
        end
    end

    self.sam:update(dt, self.controls)

    self:checkNewLevelPoints()
end

function GameState:checkNewLevelPoints()
    -- Go through all our new level points, and if any within cameraDistance load the new level
    for _, levelChanger in ipairs(self.changeLevelPoints) do
        -- find out how far away sam and the object are
        local xsam, ysam = self.sam.chest.body:getPosition()

        local xfocus, yfocus = levelChanger:getPosition()

        -- if the object is within distance, re-load to that level
        if levelChanger.cameraDistance and math.abs(xsam - xfocus) < levelChanger.cameraDistance and math.abs(ysam - yfocus) < levelChanger.cameraDistance then
            self:loadMap(levelChanger.newLevelPath)
        end
    end
end

-- input handling callbacks
-- TECHDEBT: Duplicated in pauseState. Should be generic somewhere.

function GameState:keypressed(k)
    local binding = self.controls.keysPressed[k]
    return inputHandler(binding)
end

function GameState:gamepadpressed(gamepad, button)
    local binding = self.controls.buttonsPressed[button]
    return inputHandler(binding)
end

function GameState:keyreleased(k)
    local binding = self.controls.keysReleased[k]
    return inputHandler(binding)
end

function GameState:gamepadreleased(gamepad, button)
    local binding = self.controls.buttonsReleased[button]
    return inputHandler(binding)
end

-- Should these should all be in a physics helper?
function GameState:beginContact(fixture1, fixture2, contact)
    -- If anything was done here, first check the contact created is actually touching
    -- if not contact:isTouching() then
    --     return
    -- end
end

function GameState:endContact(fixture1, fixture2, contact)
    -- make sure garbage is collected properly: https://love2d.org/forums/viewtopic.php?t=9643
    collectgarbage()
end

function GameState:preSolve(fixture1, fixture2, contact)
end

function GameState:postSolve(fixture1, fixture2, contact, linearImpulse)
    local body1, body2 = fixture1:getBody(), fixture2:getBody()

    if body1:getUserData().type == "samBodyPart" and body2:getUserData().type == "samBodyPart" then
        return
    end

    -- Only play sfx for impacts over a threshold.
    if linearImpulse < 25 then
        return
    end

    -- If there's any non-generic collision sfx in question, play one.
    -- If both are non-generic, we'll just play the first one (basically randomly)
    local sfxFolder = "generic"

    if body1:getUserData().collisionSfxFolder ~= "generic" then
        sfxFolder = body1:getUserData().collisionSfxFolder
    elseif body2:getUserData().collisionSfxFolder ~= "generic" then
        sfxFolder = body2:getUserData().collisionSfxFolder
    end

    -- pick a random sfx to play from within the specified folder
    local filenames = love.filesystem.getDirectoryItems("assets/sounds/sfx/collisions/" .. sfxFolder)

    local collisionSfx = love.audio.play("assets/sounds/sfx/collisions/" .. sfxFolder .. "/" .. filenames[math.floor(love.math.random(#filenames))], "static")
    
    -- For some reason a contact can have two positions... I'm going to assume they're always close to eachother and just grab the first one
    x1, y1 = contact:getPositions()

    collisionSfx:setPosition(x1, y1, 0)
    collisionSfx:setAttenuationDistances(50, 1500)

    -- volume, scaled by impulse of impact
    collisionSfx:setVolume(linearImpulse/100)
end

function GameState:draw()
    self.map:draw(self.camera:getCameraToStiTransforms(self.map))
end

-- if the gamestate is left (popped or switched), reset it so if the same instance is returned to it's back from the start of the level
function GameState:leave()
    self:init()
end

return GameState
