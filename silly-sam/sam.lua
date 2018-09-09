Sam = {}
Sam.__index = Sam

function Sam:create(world)
    local sam = {}
    setmetatable(sam, Sam)

    -- TODO: spawn should be read from the map
    local spawn = {
        x=700,
        y=300,
    }

    -- chest
    sam.chest = {}
    sam.chest.body = love.physics.newBody(world, spawn.x, spawn.y, "dynamic")
    sam.chest.shape = love.physics.newRectangleShape(0, 0, 50, 50)
    sam.chest.fixture = love.physics.newFixture(sam.chest.body, sam.chest.shape);
    sam.chest.fixture:setFriction(0.5)
    sam.chest.color = {1, 1, 1}

    sam.chest.onGround = false

    -- left leg
    sam.leftLeg = {}
    sam.leftLeg.body = love.physics.newBody(world, spawn.x-20, spawn.y+45, "dynamic")
    sam.leftLeg.shape = love.physics.newRectangleShape(0, 0, 17, 40)
    sam.leftLeg.fixture = love.physics.newFixture(sam.leftLeg.body, sam.leftLeg.shape, 3);
    sam.leftLeg.fixture:setFriction(0.5)
    sam.leftLeg.color = {0.1, 0.4, 1}

    -- join to chest
    sam.leftLeg.joint = love.physics.newWeldJoint(sam.chest.body, sam.leftLeg.body, spawn.x-20, spawn.y+25)

    sam.leftLeg.onGround = false

    -- right leg
    sam.rightLeg = {}
    sam.rightLeg.body = love.physics.newBody(world, spawn.x+20, spawn.y+45, "dynamic")
    sam.rightLeg.shape = love.physics.newRectangleShape(0, 0, 17, 40)
    sam.rightLeg.fixture = love.physics.newFixture(sam.rightLeg.body, sam.rightLeg.shape, 3);
    sam.rightLeg.fixture:setFriction(0.5)
    sam.rightLeg.color = {0.7, 0.1, 0.1}

    sam.rightLeg.joint = love.physics.newWeldJoint(sam.chest.body, sam.rightLeg.body, spawn.x+20, spawn.y+25)

    sam.rightLeg.onGround = false

    -- head
    sam.head = {}
    sam.head.body = love.physics.newBody(world, spawn.x, spawn.y-45, "dynamic")
    sam.head.shape = love.physics.newCircleShape(15)
    sam.head.fixture = love.physics.newFixture(sam.head.body, sam.head.shape, 0.5);
    sam.head.fixture:setFriction(0.5)
    --sam.head.fixture:setMask(3)
    sam.head.color = {0.80, 0.20, 0.20}

    sam.head.joint = love.physics.newRevoluteJoint(sam.chest.body, sam.head.body, spawn.x, spawn.y-55)

    sam.head.onGround = false

    sam.leftArm = {}
    sam.leftArm.width = 20
    sam.leftArm.height = 35
    sam.leftArm.body = love.physics.newBody(world, spawn.x-30, spawn.y, "dynamic")
    sam.leftArm.shape = love.physics.newRectangleShape(0, 0, sam.leftArm.width, sam.leftArm.height)
    sam.leftArm.fixture = love.physics.newFixture(sam.leftArm.body, sam.leftArm.shape, 1);
    --sam.leftArm.fixture:setMask(1)
    sam.leftArm.fixture:setFriction(0.5)
    sam.leftArm.color = {0.1, 0.4, 1}

    sam.leftArm.joint = love.physics.newRevoluteJoint(sam.chest.body, sam.leftArm.body, spawn.x-30, spawn.y-10)

    sam.leftArm.onGround = false

    sam.rightArm = {}
    sam.rightArm.width = 20
    sam.rightArm.height = 35
    sam.rightArm.body = love.physics.newBody(world, spawn.x+30, spawn.y, "dynamic")
    sam.rightArm.shape = love.physics.newRectangleShape(0, 0, sam.rightArm.width, sam.rightArm.height)
    sam.rightArm.fixture = love.physics.newFixture(sam.rightArm.body, sam.rightArm.shape, 1);
    --sam.rightArm.fixture:setMask(1)
    sam.rightArm.fixture:setFriction(0.5)
    sam.rightArm.color = {0.7, 0.1, 0.1}

    sam.rightArm.joint = love.physics.newRevoluteJoint(sam.chest.body, sam.rightArm.body, spawn.x+30, spawn.y-10)

    sam.rightArm.onGround = false

    -- this is for drawing
    sam.rectParts = {
        sam.chest,
        sam.leftLeg,
        sam.rightLeg,
        sam.leftArm,
        sam.rightArm,
    }

    -- for logic
    sam.allParts = {
        sam.head,
        sam.chest,
        sam.leftLeg,
        sam.rightLeg,
        sam.leftArm,
        sam.rightArm,
    }

    return sam
end

function Sam:armForces(dt, arm, xaxis, yaxis)
    -- can this even have keyboard support? The whole point is it's twinstick.
    -- Maybe should figure something out to integrate into the controlls table.
    -- Prevent nil crash regardless
    if not joystick then
        return
    end

    -- apply force to hands based on controller axis
    local forceFactor = 100*dt

    local xFactor = joystick:getGamepadAxis(xaxis)

    if math.abs(xFactor) < 0.2 then
        xFactor = 0
    end

    local yFactor = joystick:getGamepadAxis(yaxis)

    if math.abs(yFactor) < 0.2 then
        yFactor = 0
    end

    -- onGround calculated on collision callbacks
    if arm.onGround then
        forceFactor = 3000*dt
        xFactor = 0
    end

    -- why is the box2D angle and the math angle misaligned?! How annoying.
    -- or am I doing something stupid?
    local angle = arm.body:getAngle()+3.14/2

    local xMove = arm.body:getX() + (math.cos(angle) * (arm.width*0.6))
    local yMove = arm.body:getY() + (math.sin(angle) * (arm.height*0.6))

    arm.body:applyLinearImpulse(xFactor*forceFactor, yFactor*forceFactor, xMove, yMove);

    -- if any force is being applied arms are 'tense' so apply no gravity
    if math.abs(xFactor) > 0 or math.abs(yFactor) > 0 then
        arm.body:setGravityScale(0)
        arm.body:setAngularDamping(5)
    else
        arm.body:setGravityScale(1)
        arm.body:setAngularDamping(0)
    end
end

function Sam:moveLeft()
    if self.leftLeg.onGround then
        self:forceUpLeg(self.leftLeg)

        self.leftLeg.body:applyForce(-1000, 0)
    end
end

function Sam:moveRight()
    if self.rightLeg.onGround then
        self:forceUpLeg(self.rightLeg)
        
        self.rightLeg.body:applyForce(1000, 0)
    end
end

function Sam:forceUpLeg(leg)
    -- the impulse needs to always be acting up the edge of the box, on the corner of the box
    -- so we need to find the impulse direction and the corner point of the object
    leg.body:applyLinearImpulse(rotateImpulse(leg.body:getAngle(), 0, 100));
end

function Sam:draw()
    love.graphics.setColor(0.20, 0.20, 0.20)

    for i in pairs(self.rectParts) do
        love.graphics.setColor(self:getColor(self.rectParts[i]))
        love.graphics.polygon("fill", self.rectParts[i].body:getWorldPoints(self.rectParts[i].shape:getPoints()))
    end

    love.graphics.setColor(self.head.color)

    local wx, wy = self.head.body:getWorldPoint(self.head.shape:getPoint())
    love.graphics.circle("fill", wx, wy, self.head.shape:getRadius())
end

-- can remove once we texture sam
function Sam:getColor(obj)
    return obj.color[1], obj.color[2], obj.color[3]
end

return Sam
