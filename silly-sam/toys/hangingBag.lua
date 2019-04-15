local Class = require "hump.class"

local BaseObject = require "toys/baseObject"

HangingBag = Class{__includes = BaseObject}

function HangingBag:init(world, mapObject)
	-- calculate values from map object
	local xSpawn, ySpawn = mapObject.x, mapObject.y
	local pivotingJoint = mapObject.properties.pivotingJoint
	
	-- Some details for the rope, which isn't a physics object, just a line or texture drawn from the anchor to the pivot
	self.ropeColor = {0.9, 0.9, 0.9}
	self.ropeWidth = 10
	self.ropeLength = mapObject.properties.ropeLength
	if mapObject.properties.texturePathRope then
		self.ropeImage = love.graphics.newImage(mapObject.properties.texturePathRope)
	end

	-- create a static anchor point
	self.anchor = {}
	self.anchor.body = love.physics.newBody(world, xSpawn, ySpawn, "static")
	self.anchor.body:setUserData({
		type = "hangingBagAnchor",
		collisionSfxFolder = "generic"
	})
	self.anchor.shape = love.physics.newCircleShape(5)
	self.anchor.fixture = love.physics.newFixture(self.anchor.body, self.anchor.shape, 0.5);
	self.anchor.fixture:setFriction(0.5)
	self.anchor.color = {0.5, 0.5, 0.5}

	if mapObject.properties.texturePathAnchor then
		self.anchor.image = love.graphics.newImage(mapObject.properties.texturePathAnchor)
	end

	self.bag = {}
	self.bag.width, self.bag.height = mapObject.properties.bagWidth, mapObject.properties.bagHeight
	self.bag.body = love.physics.newBody(world, xSpawn, ySpawn+self.ropeLength, "dynamic")
	self.bag.body:setUserData({
		type = "hangingBag",
		collisionSfxFolder = mapObject.properties.collisionSfxFolder or "generic"
	})
	self.bag.shape = love.physics.newRectangleShape(0, 0, self.bag.width, self.bag.height)
	self.bag.fixture = love.physics.newFixture(self.bag.body, self.bag.shape, 0.5);
	self.bag.fixture:setFriction(0.5)
	self.bag.fixture:setDensity(1)
	self.bag.color = {0.2, 0.2, 0.2}

	if mapObject.properties.texturePathBag then
		self.bag.image = love.graphics.newImage(mapObject.properties.texturePathBag)
	end

	if pivotingJoint then
		-- create another object between the bag and the rope to allow the bag to rotate around the join to the rope
		self.bagPivotPoint = {}
		self.bagPivotPoint.body = love.physics.newBody(world, xSpawn, ySpawn+self.ropeLength-self.bag.height/2, "dynamic")
		self.bagPivotPoint.body:setUserData({
			type = "bagPivotPoint",
			collisionSfxFolder = "generic"
		})
		self.bagPivotPoint.shape = love.physics.newCircleShape(5)
		self.bagPivotPoint.fixture = love.physics.newFixture(self.bagPivotPoint.body, self.bagPivotPoint.shape, 0.5);
		self.bagPivotPoint.fixture:setFriction(0.5)
		self.bagPivotPoint.color = {0.5, 0.5, 0.5}

		if mapObject.properties.texturePathPivot then
			self.bagPivotPoint.image = love.graphics.newImage(mapObject.properties.texturePathPivot)
		end
	
		-- join pivot to the anchor
		self.anchor.joint = love.physics.newRopeJoint(
			self.anchor.body, self.bagPivotPoint.body,
			xSpawn, ySpawn,
			self.bagPivotPoint.body:getX(), self.bagPivotPoint.body:getY(),
			self.ropeLength, false)

		-- join bag to pivot
		self.bag.joint = love.physics.newRevoluteJoint(self.bag.body, self.bagPivotPoint.body, self.bagPivotPoint.body:getX(), self.bagPivotPoint.body:getY())
	else
		-- connect the anchor to the bag directly
		self.anchor.joint = love.physics.newRevoluteJoint(self.anchor.body, self.bag.body, xSpawn, ySpawn)
	end
	
	-- check if we're important to the camera
	self.cameraDistance = mapObject.properties.cameraDistance
	self.cameraFocus = mapObject.properties.cameraFocus
end

function HangingBag:getPosition()
	return self.bag.body:getPosition()
end

function HangingBag:draw()
	if self.bagPivotPoint then
		-- draw the rope to the pivot point at the top of the bag
		self:drawRope(self.anchor.body:getX(), self.anchor.body:getY(), self.bagPivotPoint.body:getX(), self.bagPivotPoint.body:getY())

		-- Draw pivot point for a visual indicator of what type of bag it is
		self:drawCircleObject(self.bagPivotPoint)
	else
		-- drawing to the centre of the bag but it doesn't matter because without a pivot point it isn't rotating independently
		self:drawRope(self.anchor.body:getX(), self.anchor.body:getY(), self.bag.body:getX(), self.bag.body:getY())
	end
	
	self:drawCircleObject(self.anchor)

	self:drawRectangleObject(self.bag)
end

function HangingBag:drawRope(x1, y1, x2, y2)
	if self.ropeImage then
		-- draw the rope texture
		-- TODO: it'd be better if the texture repeated for its height, instead of stretched out for the whole rope
		local ropeXDistance = x2-x1
		local ropeYDistance = y2-y1
		
		-- soh-cah-TOA
		local angle = math.atan(ropeXDistance/ropeYDistance)

		-- not sure... why this is needed
		angle = angle*-1

		-- draw(image, xpos, ypos, angle, ratiox, ratioy, offsetx, offsety)
		love.graphics.draw(self.ropeImage,
			x1 - (self.ropeWidth/2), y1,
			angle,
			self.ropeWidth/self.ropeImage:getWidth(), self.ropeLength/self.ropeImage:getHeight(),
			0, 0)
	else
		-- If we've no texture, just use a line
		love.graphics.setLineWidth(self.ropeWidth)
		love.graphics.setColor(self.ropeColor)

		love.graphics.line(x1, y1, x2, y2)
		
		-- reset color
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return HangingBag
