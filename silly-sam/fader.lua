local Class = require "hump.class"

Fader = Class{}

function Fader:init()
	self.alpha = 1

	self.fadeTime = 0.5
	self.timer = self.fadeTime

	self.stage = "clear"
end

function Fader:update(dt)
    if self.stage == "toClear" then
      self.timer = self.timer + dt
      if self.timer > self.fadeTime then
		self.timer = self.fadeTime
        self.stage = "clear"
      end
    end
    
    if self.stage == "toBlack" then
		self.timer= self.timer - dt
		if self.timer < 0 then
			self.timer = 0
			self.stage = "black"      
		end
    end
    
    if self.timer <= self.fadeTime then
		self.alpha = self.timer / self.fadeTime
	end
	
	print(self.alpha, self.stage)
end

function Fader:toClear()
	self.stage = "toClear"
end

function Fader:toBlack()
	self.stage = "toBlack"
end

return Fader
