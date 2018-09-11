local Class = require "hump.class"

CameraHelper = Class{}

function CameraHelper:updateCamera(state, dt)
    -- move the camera to follow sam's chest position (as a quick implementation)
    local samx, samy = state.sam.chest.body:getPosition()
    local dx,dy = samx - state.camera.x, samy - state.camera.y
    state.camera:move(dx/2, dy/2)

    -- TODO: want to give camera some room where sam can move without camera
    -- and smooth it's movement
end

-- is there such a thing as static classes in lua?
-- Could move to be part of the bump camera, or extend the class with my own
-- if i could figure out bloody inheritance that is
function CameraHelper:getCameraToStiTransforms(state)

    -- Need to transform our camera info into data we can pass to sti
    -- (thanks to discussion @ https://love2d.org/forums/viewtopic.php?t=84544 !)
	local tx = state.camera.x - love.graphics.getWidth() / 2
	local ty = state.camera.y - love.graphics.getHeight() / 2

	if tx < 0 then 
		tx = 0 
	end
	if tx > state.map.width  * state.map.tilewidth  - love.graphics.getWidth()  then
		tx = state.map.width  * state.map.tilewidth  - love.graphics.getWidth()  
	end
	if ty > state.map.height * state.map.tileheight - love.graphics.getHeight() then
		ty = state.map.height * state.map.tileheight - love.graphics.getHeight()
	end

	tx = math.floor(tx)
	ty = math.floor(ty)

    return -tx, -ty, state.camera.scale, state.camera.scale
end

return CameraHelper