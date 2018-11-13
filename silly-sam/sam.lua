local Class = require "hump.class"
local BaseObject = require "toys/baseObject"

Sam = Class{__includes = BaseObject}

function Sam:init(world, xSpawn, ySpawn)
    local spawn = {
        x=xSpawn,
        y=ySpawn,
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

    -- join to chest with a little wiggle room
    self.leftLeg.joint = love.physics.newPrismaticJoint(
        self.chest.body, self.leftLeg.body,
        spawn.x+20, spawn.y+20,
        spawn.x+20, spawn.y+20,
        0, 1, true, 0)

    self.leftLeg.joint:setLimitsEnabled(true)
    self.leftLeg.joint:setLimits(-5, 5)

    self.leftLeg.onGround = false

    -- right leg
    self.rightLeg = {}
    self.rightLeg.body = love.physics.newBody(world, spawn.x+20, spawn.y+45, "dynamic")
    self.rightLeg.shape = love.physics.newRectangleShape(0, 0, 17, 40)
    self.rightLeg.fixture = love.physics.newFixture(self.rightLeg.body, self.rightLeg.shape, 3);
    self.rightLeg.fixture:setFriction(0.5)
    self.rightLeg.color = {0.7, 0.1, 0.1}

    self.rightLeg.joint = love.physics.newPrismaticJoint(
        self.chest.body, self.rightLeg.body,
        spawn.x+20, spawn.y+20,
        spawn.x+20, spawn.y+20,
        0, 1, true, 0)

    self.rightLeg.joint:setLimitsEnabled(true)
    self.rightLeg.joint:setLimits(-5, 5)

    self.rightLeg.onGround = false

    -- head
    self.head = {}
    self.head.image = love.graphics.newImage("assets/art/window_icon.png")
    self.head.body = love.physics.newBody(world, spawn.x, spawn.y-45, "dynamic")
    self.head.shape = love.physics.newCircleShape(15)
    self.head.fixture = love.physics.newFixture(self.head.body, self.head.shape, 0.5);
    self.head.fixture:setFriction(0.5)
    self.head.color = {0.80, 0.20, 0.20}

    self.head.joint = love.physics.newRevoluteJoint(self.chest.body, self.head.body, spawn.x, spawn.y-55)

    self.head.onGround = false

    self.leftArm = {}
    self.leftArm.width = 20
    self.leftArm.height = 35
    self.leftArm.body = love.physics.newBody(world, spawn.x-30, spawn.y, "dynamic")
    self.leftArm.shape = love.physics.newRectangleShape(0, 0, self.leftArm.width, self.leftArm.height)
    self.leftArm.fixture = love.physics.newFixture(self.leftArm.body, self.leftArm.shape, 1);
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
    self.rightArm.fixture:setFriction(0.5)
    self.rightArm.color = {0.7, 0.1, 0.1}

    self.rightArm.joint = love.physics.newRevoluteJoint(self.chest.body, self.rightArm.body, spawn.x+30, spawn.y-10)

    self.rightArm.onGround = false

    -- this is for drawing
    self.rectParts = {
        self.leftLeg,
        self.rightLeg,
        self.chest,
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

    self.yPrevLeftFactor = 0
    self.yPrevRightFractor = 0

    self.leftTriggerDown = false
    self.rightTriggerDown = false
end

function Sam:update(dt, controls)
    self:armForces(dt, self.leftArm, controls.keysLeftArm, "leftx", "lefty");
    self:armForces(dt, self.rightArm, controls.keysRightArm, "rightx", "righty");
    
    self:leftLegForces()
    self:rightLegForces()
end

function Sam:armForces(dt, arm, keyboardInputs, xaxis, yaxis)
    local xFactor, yFactor = 0, 0

    -- check joystick inputs if joystick
    if joystick then
        xFactor = joystick:getGamepadAxis(xaxis)

        if math.abs(xFactor) < 0.2 then
            xFactor = 0
        end

        yFactor = joystick:getGamepadAxis(yaxis)

        if math.abs(yFactor) < 0.2 then
            yFactor = 0
        end
    end
    
    -- check keyboard inputs
    local tempXFactor, tempYFactor = self:getKeyboardArmAngle(keyboardInputs)
    
    -- if there are any keyboard inputs, override controller input
    if tempXFactor ~= 0 or tempYFactor ~= 0 then
        xFactor = tempXFactor
        yFactor = tempYFactor
    end

    -- apply force to hands based on axis
    local forceFactor = 100*dt

    -- minimum required difference in previous stick location and current stick location to apply strong upwards force
    -- makes pushing oneself up need to be a deliberate move, isntead of trying to drag Sam around then ending up flinging them into the air
    local pushThreshold = -20 * dt

    if xaxis == "leftx" then
        if arm.onGround and (yFactor - self.yPrevLeftFactor) < pushThreshold then
            forceFactor = 3000*dt
    
            -- don't want any horizontal
            xFactor = 0
        end
    
        self.yPrevLeftFactor = yFactor
    elseif xaxis == "rightx" then
        if arm.onGround and (yFactor - self.yPrevRightFactor) < pushThreshold then
            forceFactor = 3000*dt
            xFactor = 0
        end
    
        self.yPrevRightFactor = yFactor
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

function Sam:getKeyboardArmAngle(keyboardInputs)
    local xFactor, yFactor = 0, 0

    if love.keyboard.isDown(keyboardInputs[1]) then
        yFactor = -1
    end
    if love.keyboard.isDown(keyboardInputs[2]) then
        xFactor = 1
    end
    if love.keyboard.isDown(keyboardInputs[3]) then
        yFactor = 1
    end
    if love.keyboard.isDown(keyboardInputs[4]) then
        xFactor = -1
    end

    return xFactor, yFactor
end

function Sam:leftLegForces()
    if joystick:getGamepadAxis("triggerleft") < 1 and self.leftTriggerDown == true then
        self.leftTriggerDown = false
    end

    if joystick:getGamepadAxis("triggerleft") >= 1 and self.leftTriggerDown == false then
        self:moveLeft()

        self.leftTriggerDown = true
    end
end
 
function Sam:rightLegForces()
    if joystick:getGamepadAxis("triggerright") < 1 and self.rightTriggerDown == true then
        self.rightTriggerDown = false
    end

    if joystick:getGamepadAxis("triggerright") >= 1 and self.rightTriggerDown == false then
        self:moveRight()

        self.rightTriggerDown = true
    end
end

function Sam:moveLeft()
    if self.leftLeg.onGround then
        self:forceUpLeg(self.leftLeg)

        -- shove a little bit left as well to help travelling
        self.leftLeg.body:applyForce(-1000, 0)
    end
end

function Sam:moveRight()
    if self.rightLeg.onGround then
        self:forceUpLeg(self.rightLeg)
        
        -- shove a little bit right as well to help travelling
        self.rightLeg.body:applyForce(1000, 0)
    end
end

function Sam:forceUpLeg(leg)
    -- the impulse needs to always be acting up the edge of the box, on the corner of the box
    -- so we need to find the impulse direction and the corner point of the object
    leg.body:applyLinearImpulse(rotateImpulse(leg.body:getAngle(), 0, 100));
end

function Sam:draw(drawShapes, drawSprites)
    -- default if no info given
    drawShapes = drawShapes or false
    drawSprites = drawSprites or true

    if drawShapes then
        for i in pairs(self.rectParts) do
            self:drawRectPhysicsObject(self.rectParts[i])
        end

        self:drawCirclePhysicsObject(self.head)
    end

    if drawSprites then
        love.graphics.setColor(1, 1, 1, 1)
        
        -- draw(image, xpos, ypos, angle, ratiox, ratioy, offsetx, offsety)
        love.graphics.draw(self.head.image,
            self.head.body:getX(), self.head.body:getY(),
            self.head.body:getAngle(),
            (self.head.shape:getRadius()*2)/self.head.image:getWidth(), (self.head.shape:getRadius()*2)/self.head.image:getHeight(),
            self.head.image:getWidth()/2, self.head.image:getWidth()/2)
    end
end

return Sam
