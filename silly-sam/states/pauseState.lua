local StateManager = require "hump.gamestate"

local PauseState = {}

function PauseState:init()
	self.pauseOptionsImage = love.graphics.newImage("assets/art/pause-screen.png")

	local source = love.filesystem.read("shaders/generalBlur.glsl")
	self.blurEffect = love.graphics.newShader(source)

	self.canvas = love.graphics.newCanvas()

	self.controls = {
		bindings = {
			restart = function() self:restart() end,
			resume = function() self:toGameState() end,
			quit = love.event.quit,
			toggleFullscreen = function() self:toggleFullscreen() end,
			toggleMusic = function() musicMuted = not musicMuted end,
		},
		keysPressed = {
		},
		keysReleased = {
			p = "resume",
			r = "restart",
			escape = "quit",
			f = "toggleFullscreen",
			m = "toggleMusic",
		},
		buttonsPressed = {
		},
		buttonsReleased = {
			b = "resume",
			start = "resume",
			y = "restart",
			back = "quit",
			dpright = "toggleFullscreen",
			dpdown = "toggleMusic",
		},
	}
end

function PauseState:getBackgroundColor() 
	return 0.9, 0.96, 0.988
end

-- Should only ever come from gamestate. Will need to make more flexable if there was ever to be other states that could lead here
function PauseState:enter(gameState)
	self.gameState = gameState
	love.graphics.setBackgroundColor(self:getBackgroundColor())

	-- Screensize may have changed since we last initiated our canvas, so re-size
	self.canvas = love.graphics.newCanvas()
end

function PauseState:toGameState()
	if not musicMuted then
		mainThemeMusic:play()
	end
	love.audio.play("assets/sounds/sfx/begin.wav", "static")

	StateManager.pop()
end

-- restart game
function PauseState:restart()
	if not musicMuted then
		mainThemeMusic:play()
	end
	
	StateManager.pop()
	reset()
end

function PauseState:toggleFullscreen()
	self.gameState:toggleFullscreen()

	-- reset canvas for new screen size
	self.canvas = love.graphics.newCanvas()
end

function PauseState:update(dt)
end

function PauseState:draw()
	-- Draw the gamestate to a canvas
	love.graphics.setCanvas( {self.canvas, stencil=true} )
		love.graphics.clear(self:getBackgroundColor())
		self.gameState:draw()
	love.graphics.setCanvas()

	-- Draw the canvas of the gamestate with the blur effect
	love.graphics.setShader(self.blurEffect)
		love.graphics.draw(self.canvas)
	love.graphics.setShader()

	-- draw image with instructions on top at the centre of the screen
	love.graphics.draw(self.pauseOptionsImage,
		love.graphics.getWidth()/2, love.graphics.getHeight()/2,
		0,
		1, 1,
		self.pauseOptionsImage:getWidth()/2, self.pauseOptionsImage:getHeight()/2)
end

return PauseState
