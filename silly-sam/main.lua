--  SILLY SAM
--  By Berd

local StateManager = require "hump.gamestate"

local GameState = require "states/gameState"

function love.load()
	love.window.setMode(1000, 600, {fullscreen = false})

	imageData = love.image.newImageData("assets/art/window_icon.png")
	love.window.setIcon(imageData)

	love.window.setTitle("Silly Sam")

	-- find controller... TODO: should probs be some update check so the controller doesn't need to be in as the game boots up to find it
	local joysticks = love.joystick.getJoysticks()
	joystick = joysticks[1]
	
	-- set up a wee sound manager https://love2d.org/wiki/Minimalist_Sound_Manager
	do
		-- will hold the currently playing sources
		local sources = {}
	
		-- check for sources that finished playing and remove them
		-- add to love.update
		function love.audio.update()
			local remove = {}
			for _,s in pairs(sources) do
				if s:isStopped() then
					remove[#remove + 1] = s
				end
			end
	
			for i,s in ipairs(remove) do
				sources[s] = nil
			end
		end
	
		-- overwrite love.audio.play to create and register source if needed
		local play = love.audio.play
		function love.audio.play(what, how, loop)
			local src = what
			if type(what) ~= "userdata" or not what:typeOf("Source") then
				src = love.audio.newSource(what, how)
				src:setLooping(loop or false)
			end
	
			play(src)
			sources[src] = src
			return src
		end
	
		-- stops a source
		local stop = love.audio.stop
		function love.audio.stop(src)
			if not src then return end
			stop(src)
			sources[src] = nil
		end
	end

	love.audio.setDistanceModel("linear")

	-- play the main theme
	mainThemeMusic = love.audio.play("assets/sounds/music/sam-theme.mp3", "stream", true)
	musicMuted = false

	StateManager.registerEvents()
	reset()
end

-- This reset function is more for debugging while creating.
-- to properly reset I really want to clear everything in the StateManager queue and start a new gamestate but I'm not sure how to do that.
function reset()
	StateManager.switch(GameState)
end

-- should be moved to a input manager of some kind?
function inputHandler(input)
	local action = StateManager.current().controls.bindings[input]
	if action then
		return action()
	end
end

-- should have some kinda 'physics helper' class for stuff like this
function rotateImpulse(angle, xImpulse, yImpulse)
	-- can I use this instead of manual? Can only seem to apply to graphics
	--local rotateMatrix = love.math.newTransform(leg.body:getX(), leg.body:getY(), angle)

	local xResult = xImpulse*math.cos(angle) + yImpulse*math.sin(angle)
	local yResult = xImpulse*math.sin(angle) + yImpulse*-math.cos(angle)

	return xResult, yResult
end
