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

local Fader = require "fader"

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

	self.fader = Fader()
end

function GameState:getBackgroundColor() 
	return 0.76, 0.91, 1
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
		collectgarbage()
	end

	self.physicsWorld = love.physics.newWorld(0, 10*100, true)

	-- load the map
	self.map = Sti(mapPath, { "box2d" })
	self.map:box2d_init(self.physicsWorld)

	-- We don't use any tile objects so could just get rid of the physics from the map. May improve performance.
	--self.map = Sti(mapPath)

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

	-- There's this weird issue with STI where if you draw things without a background the transparancy looks very odd
	-- There's another weird thing where tiles are slowing down the game like crazy, so just tiling in a background isn't a solution
	-- So we have a sky layer where we draw a rectangle over the back of everything to fix it without killing performance.
	-- A bit annoying since each map needs an empty sky layer, but it'll do.
	-- Check issues #77 and #82. Would be great to fix.
	self.map.layers["sky"].draw = function()
		self.camera:detach()

		love.graphics.setColor(self:getBackgroundColor())
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(1, 1, 1)

		self.camera:attach()
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

	if self.fader.stage == "clear" then
		self.fader:toBlack()
	elseif self.fader.stage == "black" then
		self.fader:toClear()
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

	self.fader:update(dt)

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

	local body1Data, body2Data = body1:getUserData(), body2:getUserData()

	-- Bodies might not have user data set (e.g. map tiles)
	if body1Data == nil then
		body1Data = {
			type = "unknown",
			collisionSfxFolder = "generic"
		}
	end

	if body2Data == nil then
		body2Data = {
			type = "unknown",
			collisionSfxFolder = "generic"
		}
	end

	-- No sounds for sam colliding with himself
	if body1Data.type == "samBodyPart" and body2Data.type == "samBodyPart" then
		return
	end

	-- Only play sfx for impacts over a threshold.
	-- TODO: This is for the force of the collision, not the speed of objects.
	-- so, for example, if a very heavy object sits on sam it constantly collides with sam with a high impulse because of the object's weight
	-- causing this threshold to be met and an sfx to play when we don't want it to
	if linearImpulse < 25 then
		return
	end

	-- If there's any non-generic collision sfx in question, play one.
	-- If both are non-generic, we'll just play the first one (basically randomly)
	local sfxFolder = "generic"

	if body1Data.collisionSfxFolder ~= "generic" then
		sfxFolder = body1Data.collisionSfxFolder
	elseif body2Data.collisionSfxFolder ~= "generic" then
		sfxFolder = body2Data.collisionSfxFolder
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
	
	love.graphics.setColor(1, 1, 1, self.fader.alpha)

	self.map:draw(self.camera:getCameraToStiTransforms(self.map))
end

-- if the gamestate is left (popped or switched), reset it so if the same instance is returned to it's back from the start of the level
function GameState:leave()
	self:init()
end

return GameState
