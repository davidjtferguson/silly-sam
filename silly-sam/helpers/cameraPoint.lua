local Class = require "hump.class"

CameraPoint = Class{}

function CameraPoint:init(mapObject)
    self.x = mapObject.x
    self.y = mapObject.y
    self.cameraDistance = mapObject.properties.cameraDistance
end

-- so all objects that can be in the camera tables are uniform
function CameraPoint:getPosition()
    return self.x, self.y
end

return CameraPoint
