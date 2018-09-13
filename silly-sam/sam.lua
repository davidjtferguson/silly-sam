local Class = require "hump.class"

Sam = Class{}

function Sam:init(world)
    -- TODO: spawn should be read from the map
    local spawn = {
        x=700,
        y=300,
    }

    -- chest
    self.chest = {}
    self.chest.body = love.physics.newBody(world, spawn.x, spawn.y, "dynamic")
    self.chest.shape = love.physics.newRectangleShape(0, 0, 50, 50)
    self.chest.fixture = love.physics.newFixture(self.chest.body, self.chest.shape);
    self.chest.fixture:setFriction(0.5)
    self.chest.color = {1, 1, 1}

    self.chest.onGround = false

    -- left leg
    self.leftLeg = {}
    self.leftLeg.body = love.physics.newBody(world, spawn.x-20, spawn.y+45, "dynamic")
    self.leftLeg.shape = love.physics.newRectangleShape(0, 0, 17, 40)
    self.leftLeg.fixture = love.physics.newFixture(self.leftLeg.body, self.leftLeg.shape, 3);
    self.leftLeg.fixture:setFriction(0.5)
    self.leftLeg.color = {0.1, 0.4, 1}

    -- join to chest
    self.leftLeg.joint = love.physics.newWeldJoint(self.chest.body, self.leftLeg.body, spawn.x-20, spawn.y+25)

    self.leftLeg.onGround = false

    -- right leg
    self.rightLeg = {}
    self.rightLeg.body = love.physics.newBody(world, spawn.x+20, spawn.y+45, "dynamic")
    self.rightLeg.shape = love.physics.newRectangleShape(0, 0, 17, 40)
    self.rightLeg.fixture = love.physics.newFixture(self.rightLeg.body, self.rightLeg.shape, 3);
    self.rightLeg.fixture:setFriction(0.5)
    self.rightLeg.color = {0.7, 0.1, 0.1}

    self.rightLeg.joint = love.physics.newWeldJoint(self.chest.body, self.rightLeg.body, spawn.x+20, spawn.y+25)

    self.rightLeg.onGround = false

    -- head
    self.head = {}
    self.head.body = love.physics.newBody(world, spawn.x, spawn.y-45, "dynamic")
    self.head.shape = love.physics.newCircleShape(15)
    self.head.fixture = love.physics.newFixture(self.head.body, self.head.shape, 0.5);
    self.head.fixture:setFriction(0.5)
    --self.head.fixture:setMask(3)
    self.head.color = {0.80, 0.20, 0.20}

    self.head.joint = love.physics.newRevoluteJoint(self.chest.body, self.head.body, spawn.x, spawn.y-55)

    self.head.onGround = false

    self.leftArm = {}
    self.leftArm.width = 20
    self.leftArm.height = 35
    self.leftArm.body = love.physics.newBody(world, spawn.x-30, spawn.y, "dynamic")
    self.leftArm.shape = love.physics.newRectangleShape(0, 0, self.leftArm.width, self.leftArm.height)
    self.leftArm.fixture = love.physics.newFixture(self.leftArm.body, self.leftArm.shape, 1);
    --self.leftArm.fixture:setMask(1)
    self.leftArm.fixture:setFriction(0.5)
    self.leftArm.color = {0.1, 0.4, 1}

    self.leftArm.joint = love.physics.newRevoluteJoint(self.chest.body, self.leftArm.body, spawn.x-30, spawn.y-10)

    self.leftArm.onGround = false

    self.rightArm = {}
    self.rightArm.width = 20
    self.rightArm.height = 35
    self.rightArm.body = love.physics.newBody(world, spawn.x+30, spawn.y, "dynamic")
    self.rightArm.shape = love.physics.newRectangleShape(0, 0, self.rightArm.width, self.rightArm.height)
    self.rightArm.fixture = love.physics.newFixture(self.rightArm.body, self.rightArm.shape, 1);
    --self.rightArm.fixture:setMask(1)
    self.rightArm.fixture:setFriction(0.5)
    self.rightArm.color = {0.7, 0.1, 0.1}

    self.rightArm.joint = love.physics.newRevoluteJoint(self.chest.body, self.rightArm.body, spawn.x+30, spawn.y-10)

    self.rightArm.onGround = false

    -- this is for drawing
    self.rectParts = {
        self.chest,
        self.leftLeg,
        self.rightLeg,
        self.leftArm,
        self.rightArm,
    }

    -- for logic
    self.allParts = {
        self.head,
        self.chest,
        self.leftLeg,
        self.rightLeg,
        self.leftArm,
        self.rightArm,
    }
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
