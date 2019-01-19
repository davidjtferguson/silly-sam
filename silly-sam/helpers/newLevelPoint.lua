local Class = require "hump.class"

NewLevelPoint = Class{}

function NewLevelPoint:init(mapObject)
    self.x = mapObject.x
    self.y = mapObject.y
    self.cameraDistance = mapObject.properties.cameraDistance
    self.newLevelPath = mapObject.properties.newLevelPath
end

function NewLevelPoint:getPosition()
    return self.x, self.y
end

return NewLevelPoint
