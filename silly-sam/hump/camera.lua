--[[
Copyright (c) 2010-2015 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local _PATH = (...):match('^(.*[%./])[^%.%/]+$') or ''
local cos, sin = math.cos, math.sin

local camera = {}
camera.__index = camera

-- Movement interpolators (for camera locking/windowing)
camera.smooth = {}

function camera.smooth.none()
	return function(dx,dy) return dx,dy end
end

function camera.smooth.linear(speed)
	assert(type(speed) == "number", "Invalid parameter: speed = "..tostring(speed))
	return function(dx,dy, s)
		-- normalize direction
		local d = math.sqrt(dx*dx+dy*dy)
		local dts = math.min((s or speed) * love.timer.getDelta(), d) -- prevent overshooting the goal
		if d > 0 then
			dx,dy = dx/d, dy/d
		end

		return dx*dts, dy*dts
	end
end

function camera.smooth.damped(stiffness)
	assert(type(stiffness) == "number", "Invalid parameter: stiffness = "..tostring(stiffness))
	return function(dx,dy, s)
		local dts = love.timer.getDelta() * (s or stiffness)
		return dx*dts, dy*dts
	end
end

local function new(x,y, zoom, rot, smoother)
	x,y  = x or love.graphics.getWidth()/2, y or love.graphics.getHeight()/2
	zoom = zoom or 1
	rot  = rot or 0
	smoother = smoother or camera.smooth.none() -- for locking, see below
	return setmetatable({x = x, y = y, scale = zoom, rot = rot, smoother = smoother}, camera)
end

function camera:lookAt(x,y)
	self.x, self.y = x, y
	return self
end

function camera:move(dx,dy)
	self.x, self.y = self.x + dx, self.y + dy
	return self
end

function camera:position()
	return self.x, self.y
end

function camera:rotate(phi)
	self.rot = self.rot + phi
	return self
end

function camera:rotateTo(phi)
	self.rot = phi
	return self
end

local function resizeMapForZoom(camera, map)
	if map then
		map:resize(love.graphics.getWidth() * (1/camera.scale), love.graphics.getHeight() * (1/camera.scale))
	end
end

local function setScale(camera, scale)
	camera.scale = scale

	-- cap to prevent crash in the map
	if camera.scale < 0.07 then
		camera.scale = 0.07
	end
end

function camera:zoom(mul, map)
	setScale(self, self.scale * mul)
	resizeMapForZoom(self, map)
	return self
end

function camera:zoomTo(zoom, map)
	setScale(self, zoom)
	resizeMapForZoom(self, map)
	return self
end

function camera:attach(x,y,w,h, noclip)
	x,y = x or 0, y or 0
	w,h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

	self._sx,self._sy,self._sw,self._sh = love.graphics.getScissor()
	if not noclip then
		love.graphics.setScissor(x,y,w,h)
	end

	local cx,cy = x+w/2, y+h/2
	love.graphics.push()
	love.graphics.translate(cx, cy)
	love.graphics.scale(self.scale)
	love.graphics.rotate(self.rot)
	love.graphics.translate(-self.x, -self.y)
end

function camera:detach()
	love.graphics.pop()
	love.graphics.setScissor(self._sx,self._sy,self._sw,self._sh)
end

function camera:draw(...)
	local x,y,w,h,noclip,func
	local nargs = select("#", ...)
	if nargs == 1 then
		func = ...
	elseif nargs == 5 then
		x,y,w,h,func = ...
	elseif nargs == 6 then
		x,y,w,h,noclip,func = ...
	else
		error("Invalid arguments to camera:draw()")
	end

	self:attach(x,y,w,h,noclip)
	func()
	self:detach()
end

-- world coordinates to camera coordinates
function camera:cameraCoords(x,y, ox,oy,w,h)
	ox, oy = ox or 0, oy or 0
	w,h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

	-- x,y = ((x,y) - (self.x, self.y)):rotated(self.rot) * self.scale + center
	local c,s = cos(self.rot), sin(self.rot)
	x,y = x - self.x, y - self.y
	x,y = c*x - s*y, s*x + c*y
	return x*self.scale + w/2 + ox, y*self.scale + h/2 + oy
end

-- camera coordinates to world coordinates
function camera:worldCoords(x,y, ox,oy,w,h)
	ox, oy = ox or 0, oy or 0
	w,h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

	-- x,y = (((x,y) - center) / self.scale):rotated(-self.rot) + (self.x,self.y)
	local c,s = cos(-self.rot), sin(-self.rot)
	x,y = (x - w/2 - ox) / self.scale, (y - h/2 - oy) / self.scale
	x,y = c*x - s*y, s*x + c*y
	return x+self.x, y+self.y
end

function camera:mousePosition(ox,oy,w,h)
	local mx,my = love.mouse.getPosition()
	return self:worldCoords(mx,my, ox,oy,w,h)
end

-- camera scrolling utilities
function camera:lockX(x, smoother, ...)
	local dx, dy = (smoother or self.smoother)(x - self.x, self.y, ...)
	self.x = self.x + dx
	return self
end

function camera:lockY(y, smoother, ...)
	local dx, dy = (smoother or self.smoother)(self.x, y - self.y, ...)
	self.y = self.y + dy
	return self
end

function camera:lockPosition(x,y, smoother, ...)
	return self:move((smoother or self.smoother)(x - self.x, y - self.y, ...))
end

function camera:lockWindow(x, y, x_min, x_max, y_min, y_max, smoother, ...)
	-- figure out displacement in camera coordinates
	x,y = self:cameraCoords(x,y)
	local dx, dy = 0,0
	if x < x_min then
		dx = x - x_min
	elseif x > x_max then
		dx = x - x_max
	end
	if y < y_min then
		dy = y - y_min
	elseif y > y_max then
		dy = y - y_max
	end

	-- transform displacement to movement in world coordinates
	local c,s = cos(-self.rot), sin(-self.rot)
	dx,dy = (c*dx - s*dy) / self.scale, (s*dx + c*dy) / self.scale

	-- move
	self:move((smoother or self.smoother)(dx,dy,...))
end

-- SILLY SAM SPECIFIC FUNCTIONS

-- named as such incase we want different updates for different states.
function camera:gamestateUpdate(sam, influencers, focusses, map, dt)
	-- all the positions we want the camera to focus on
	-- this is the focusses that are within range
	local activeFocusses = {}

    for _, focus in ipairs(focusses) do
        -- find out how far away sam and the object are
        local xsam, ysam = sam.chest.body:getPosition()

        local xfocus, yfocus = focus:getPosition()

        -- if the object is within distance, add it to the influencers
        if focus.cameraDistance and math.abs(xsam - xfocus) < focus.cameraDistance and math.abs(ysam - yfocus) < focus.cameraDistance then
            table.insert(activeFocusses, { focus:getPosition() } )
        end
	end
	
	if #activeFocusses > 0 then
		-- we don't interpolate between all inrange focusses. We just use the first one. Should only be one in range at a time.
		-- (could change if needed)
		self:lockPosition(activeFocusses[1][1], activeFocusses[1][2])
		return
	end

	-- if no focusses are within range, we want to use the influencers
    local activeInfluencers = {
        {
            sam.chest.body:getPosition(),
        },
    }

    for _, influencer in ipairs(influencers) do
        -- find out how far away sam and the object are
        local xsam, ysam = sam.chest.body:getPosition()

        local xinfluence, yinfluence = influencer:getPosition()

        -- if the object is within distance, add it to the influencers
        if influencer.cameraDistance and math.abs(xsam - xinfluence) < influencer.cameraDistance and math.abs(ysam - yinfluence) < influencer.cameraDistance then
            table.insert(activeInfluencers, { influencer:getPosition() } )
        end
	end
	
	-- find centre of all activeInfluencers to focus camera on
	local xtotal, ytotal = 0, 0

	-- for scaling the camera. Set to whatever to default
	local xmin, xmax, ymin, ymax = math.abs(activeInfluencers[1][1]), math.abs(activeInfluencers[1][1]), math.abs(activeInfluencers[1][2]), math.abs(activeInfluencers[1][2])

    for i in pairs(activeInfluencers) do
		xtotal = xtotal + activeInfluencers[i][1]
		ytotal = ytotal + activeInfluencers[i][2]

		if math.abs(activeInfluencers[i][1]) < xmin then
			xmin = math.abs(activeInfluencers[i][1])
		end
		
		if math.abs(activeInfluencers[i][1]) > xmax then
			xmax = math.abs(activeInfluencers[i][1])
		end
		
		if math.abs(activeInfluencers[i][2]) < ymin then
			ymin = math.abs(activeInfluencers[i][2])
		end
		
		if math.abs(activeInfluencers[i][2]) > ymax then
			ymax = math.abs(activeInfluencers[i][2])
		end
	end

	-- find distance to move and move to
	local xcenter, ycenter = xtotal / #activeInfluencers, ytotal / #activeInfluencers

    local dx, dy = xcenter - self.x, ycenter - self.y
	self:move(dx/2, dy/2)

	if #activeInfluencers > 1 then
		-- find scale of farthest parts and zoom in or out accordingly
		xdiff, ydiff = xmax-xmin, ymax-ymin

		-- need to scale properly so each object can't leave the screen no matter how far away they are from eachother
		-- as long as they're within cameraDistance of eachother
		local zoomFactor = 1.5-((xdiff + ydiff)/2 / 500)

		self:zoomTo(zoomFactor, map)
	else
		-- TODO: Should 'snap back' to sam a little more smoothly instead of chunking in the zoom in a onner.
		self:zoomTo(1.1, map)
	end
	
    -- TODO: want to give camera some room where sam can move without camera
    -- and/or smooth it's movement
end

function camera:getCameraToStiTransforms(map)
    -- Need to transform our camera info into data we can pass to sti
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	-- Transform from the camera's position to the top left corner to tell the camera where to draw from
	local tx = self.x - (width / self.scale) / 2
	local ty = self.y - (height / self.scale)  / 2

	return -tx, -ty, self.scale, self.scale
end

-- the module
return setmetatable({new = new, smooth = camera.smooth},
	{__call = function(_, ...) return new(...) end})
