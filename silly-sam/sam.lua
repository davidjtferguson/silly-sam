local Class = require "hump.class"
local BaseObject = require "toys/baseObject"

Sam = Class{__includes = BaseObject}

function Sam:init(world, xSpawn, ySpawn)
    local spawn = {
        x=xSpawn,
        y=ySpawn,
    }

    -- 'statics' to control Sam's movements
    self.statics = {}

    -- force to move sam horizontally when using leg forces
    self.statics.sidewardsLegForce = 1000

    -- force going along sam's leg
    self.statics.upwardsLegForce = 100

    -- hand force from sticks
    self.statics.armForce = 100

    -- multiplier when arm on ground and 'push up'
    self.statics.pushForce = 4000

    -- chest
    self.chest = {}
    self.chest.width = 50
    self.chest.height = 60
    self.chest.image = love.graphics.newImage("assets/art/sam-textures/chest.png")
    self.chest.body = love.physics.newBody(world, spawn.x, spawn.y, "dynamic")
    self.chest.shape = love.physics.newRectangleShape(self.chest.width, self.chest.height)
    self.chest.fixture = love.physics.newFixture(self.chest.body, self.chest.shape);
    self.chest.fixture:setFriction(0.5)
    self.chest.color = {1, 1, 1}

    self.chest.onGround = false

    -- left leg
    self.leftLeg = {}
    self.leftLeg.width = 17
    self.leftLeg.height = 45
    self.leftLeg.image = love.graphics.newImage("assets/art/sam-textures/leg-left.png")
    self.leftLeg.body = love.physics.newBody(world, spawn.x-20, spawn.y+60, "dynamic")
    self.leftLeg.shape = love.physics.newRectangleShape(self.leftLeg.width, self.leftLeg.height)
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
    self.rightLeg.width = 17
    self.rightLeg.height = 45
    self.rightLeg.image = love.graphics.newImage("assets/art/sam-textures/leg-right.png")
    self.rightLeg.body = love.physics.newBody(world, spawn.x+20, spawn.y+60, "dynamic")
    self.rightLeg.shape = love.physics.newRectangleShape(self.rightLeg.width, self.rightLeg.height)
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
    self.head.image = love.graphics.newImage("assets/art/sam-textures/face.png")
    self.head.body = love.physics.newBody(world, spawn.x, spawn.y-55, "dynamic")
    self.head.shape = love.physics.newCircleShape(15)
    self.head.fixture = love.physics.newFixture(self.head.body, self.head.shape, 0.5);
    self.head.fixture:setFriction(0.5)
    self.head.color = {0.80, 0.20, 0.20}

    self.head.joint = love.physics.newRevoluteJoint(self.chest.body, self.head.body, spawn.x, spawn.y-65)

    self.head.onGround = false

    -- chin (not visible, for weighting)
    self.chin = {}
    self.chin.body = love.physics.newBody(world, spawn.x, spawn.y-35, "dynamic")
    self.chin.shape = love.physics.newCircleShape(4)
    self.chin.body:setMass(1000)
    self.chin.fixture = love.physics.newFixture(self.chin.body, self.chin.shape, 0.5);
    self.chin.fixture:setFriction(0.5)
    self.chin.color = {0.80, 0.20, 0.20}

    self.chin.joint = love.physics.newWeldJoint(self.head.body, self.chin.body, spawn.x, spawn.y-65)

    self.chin.onGround = false

    -- toupee
    self.toupee = {}
    self.toupee.width = 15
    self.toupee.height = 7
    self.toupee.image = love.graphics.newImage("assets/art/sam-textures/toupee.png")
    self.toupee.body = love.physics.newBody(world, spawn.x, spawn.y-76, "dynamic")
    self.toupee.body:setMass(0)
    self.toupee.shape = love.physics.newRectangleShape(self.toupee.width, self.toupee.height)
    self.toupee.fixture = love.physics.newFixture(self.toupee.body, self.toupee.shape, 1);
    self.toupee.fixture:setFriction(0.5)
    self.toupee.color = {0.1, 0.4, 1}

    self.toupee.joint = love.physics.newRevoluteJoint(self.toupee.body, self.head.body, spawn.x-3, spawn.y-76)

    self.toupee.onGround = false

    -- left eye
    self.leftEye = {}
    self.leftEye.image = love.graphics.newImage("assets/art/sam-textures/eye-left.png")
    self.leftEye.body = love.physics.newBody(world, spawn.x-7, spawn.y-59, "dynamic")
    self.leftEye.shape = love.physics.newCircleShape(2)
    self.leftEye.fixture = love.physics.newFixture(self.leftEye.body, self.leftEye.shape, 0.5);
    self.leftEye.fixture:setFriction(0.5)
    self.leftEye.color = {0.20, 0.70, 0.20}

    self.leftEye.joint = love.physics.newRevoluteJoint(self.leftEye.body, self.head.body, spawn.x-7, spawn.y-59)

    self.leftEye.onGround = false

    -- right eye
    self.rightEye = {}
    self.rightEye.image = love.graphics.newImage("assets/art/sam-textures/eye-right.png")
    self.rightEye.body = love.physics.newBody(world, spawn.x+7, spawn.y-55, "dynamic")
    self.rightEye.shape = love.physics.newCircleShape(2)
    self.rightEye.fixture = love.physics.newFixture(self.rightEye.body, self.rightEye.shape, 0.5);
    self.rightEye.fixture:setFriction(0.5)
    self.rightEye.color = {0.20, 0.70, 0.20}

    self.rightEye.joint = love.physics.newRevoluteJoint(self.rightEye.body, self.head.body, spawn.x+7, spawn.y-56)

    self.rightEye.onGround = false

    -- nose
    self.nose = {}
    self.nose.width = 5
    self.nose.height = 20
    self.nose.image = love.graphics.newImage("assets/art/sam-textures/nose.png")
    self.nose.body = love.physics.newBody(world, spawn.x, spawn.y-60, "dynamic")
    self.nose.shape = love.physics.newRectangleShape(self.nose.width, self.nose.height)
    self.nose.fixture = love.physics.newFixture(self.nose.body, self.nose.shape, 1);
    self.nose.fixture:setFriction(0.5)
    self.nose.color = {0.1, 0.4, 1}

    self.nose.joint = love.physics.newRevoluteJoint(self.nose.body, self.head.body, spawn.x, spawn.y-66)

    self.nose.onGround = false

    -- left arm
    self.leftArm = {}
    self.leftArm.width = 20
    self.leftArm.height = 35
    self.leftArm.image = love.graphics.newImage("assets/art/sam-textures/arm-left.png")
    self.leftArm.body = love.physics.newBody(world, spawn.x-30, spawn.y-5, "dynamic")
    self.leftArm.shape = love.physics.newRectangleShape(self.leftArm.width, self.leftArm.height)
    self.leftArm.fixture = love.physics.newFixture(self.leftArm.body, self.leftArm.shape, 1);
    self.leftArm.fixture:setFriction(0.5)
    self.leftArm.color = {0.1, 0.4, 1}

    self.leftArm.joint = love.physics.newRevoluteJoint(self.chest.body, self.leftArm.body, spawn.x-30, spawn.y-15)

    self.leftArm.onGround = false

    -- right arm
    self.rightArm = {}
    self.rightArm.width = 20
    self.rightArm.height = 35
    self.rightArm.image = love.graphics.newImage("assets/art/sam-textures/arm-right.png")
    self.rightArm.body = love.physics.newBody(world, spawn.x+30, spawn.y-5, "dynamic")
    self.rightArm.shape = love.physics.newRectangleShape(self.rightArm.width, self.rightArm.height)
    self.rightArm.fixture = love.physics.newFixture(self.rightArm.body, self.rightArm.shape, 1);
    self.rightArm.fixture:setFriction(0.5)
    self.rightArm.color = {0.7, 0.1, 0.1}

    self.rightArm.joint = love.physics.newRevoluteJoint(self.chest.body, self.rightArm.body, spawn.x+30, spawn.y-15)

    self.rightArm.onGround = false

    -- this is for drawing
    self.rectParts = {
        self.leftLeg,
        self.rightLeg,
        self.chest,
        self.leftArm,
        self.rightArm,
        self.nose,
        self.toupee,
    }

    self.circParts = {
        self.head,
        self.leftEye,
        self.rightEye,
        self.chin,
    }

    -- for logic
    self.allParts = {
        self.head,
        self.chest,
        self.leftLeg,
        self.rightLeg,
        self.leftArm,
        self.rightArm,
        self.chin,
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
    local forceFactor = self.statics.armForce*dt

    -- minimum required difference in previous stick location and current stick location to apply strong upwards force
    -- makes pushing oneself up need to be a deliberate move, isntead of trying to drag Sam around then ending up flinging them into the air
    local pushThreshold = -20*dt

    if xaxis == "leftx" then
        if arm.onGround and (yFactor - self.yPrevLeftFactor) < pushThreshold then
            forceFactor = self.statics.pushForce*dt
    
            -- don't want any horizontal
            xFactor = 0
        end
    
        self.yPrevLeftFactor = yFactor
    elseif xaxis == "rightx" then
        if arm.onGround and (yFactor - self.yPrevRightFactor) < pushThreshold then
            forceFactor = self.statics.pushForce*dt
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
        self.leftLeg.body:applyForce(-self.statics.sidewardsLegForce, 0)
    end
end

function Sam:moveRight()
    if self.rightLeg.onGround then
        self:forceUpLeg(self.rightLeg)
        
        -- shove a little bit right as well to help travelling
        self.rightLeg.body:applyForce(self.statics.sidewardsLegForce, 0)
    end
end

function Sam:forceUpLeg(leg)
    -- the impulse needs to always be acting up the edge of the box, on the corner of the box
    -- so we need to find the impulse direction and the corner point of the object
    leg.body:applyLinearImpulse(rotateImpulse(leg.body:getAngle(), 0, self.statics.upwardsLegForce));
end

function Sam:draw(drawShapes, drawSprites)
    -- default if no info given
    drawShapes = drawShapes or false
    drawSprites = drawSprites or false

    if drawShapes then
        for i in pairs(self.rectParts) do
            self:drawRectPhysicsObject(self.rectParts[i])
        end

        for i in pairs(self.circParts) do
            self:drawCirclePhysicsObject(self.circParts[i])
        end
    end

    if drawSprites then
        love.graphics.setColor(1, 1, 1, 1)
        
        -- draw(image, xpos, ypos, angle, ratiox, ratioy, offsetx, offsety)
        love.graphics.draw(self.leftLeg.image,
            self.leftLeg.body:getX(), self.leftLeg.body:getY(),
            self.leftLeg.body:getAngle(),
            self.leftLeg.width*1.25/self.leftLeg.image:getWidth(), self.leftLeg.height*1.25/self.leftLeg.image:getHeight(),
            self.leftLeg.image:getWidth()/2, self.leftLeg.image:getHeight()/2)

        love.graphics.draw(self.rightLeg.image,
            self.rightLeg.body:getX(), self.rightLeg.body:getY(),
            self.rightLeg.body:getAngle(),
            self.rightLeg.width*1.25/self.rightLeg.image:getWidth(), self.rightLeg.height*1.25/self.rightLeg.image:getHeight(),
            self.rightLeg.image:getWidth()/2, self.rightLeg.image:getHeight()/2)

        love.graphics.draw(self.leftArm.image,
            self.leftArm.body:getX(), self.leftArm.body:getY(),
            self.leftArm.body:getAngle(),
            self.leftArm.width*1.25/self.leftArm.image:getWidth(), self.leftArm.height*1.25/self.leftArm.image:getHeight(),
            self.leftArm.image:getWidth()/2, self.leftArm.image:getHeight()/2)

        love.graphics.draw(self.rightArm.image,
            self.rightArm.body:getX(), self.rightArm.body:getY(),
            self.rightArm.body:getAngle(),
            self.rightArm.width*1.25/self.rightArm.image:getWidth(), self.rightArm.height*1.25/self.rightArm.image:getHeight(),
            self.rightArm.image:getWidth()/2, self.rightArm.image:getHeight()/2)

        love.graphics.draw(self.chest.image,
            self.chest.body:getX(), self.chest.body:getY(),
            self.chest.body:getAngle(),
            self.chest.width*1.25/self.chest.image:getWidth(), self.chest.height*1.25/self.chest.image:getHeight(),
            self.chest.image:getWidth()/2, self.chest.image:getHeight()/2)

        -- just drawing statically - should put into head sprite
        local hairImage = love.graphics.newImage("assets/art/sam-textures/hair.png")

        love.graphics.draw(hairImage,
            self.head.body:getX(), self.head.body:getY(),
            self.head.body:getAngle(),
            (self.head.shape:getRadius()*3.5)/hairImage:getWidth(), (self.head.shape:getRadius()*3.5)/hairImage:getHeight(),
            hairImage:getWidth()/2, hairImage:getHeight()/2)

        love.graphics.draw(self.head.image,
            self.head.body:getX(), self.head.body:getY(),
            self.head.body:getAngle(),
            (self.head.shape:getRadius()*4)/self.head.image:getWidth(), (self.head.shape:getRadius()*4)/self.head.image:getHeight(),
            self.head.image:getWidth()/2, self.head.image:getHeight()/2-35)

        love.graphics.draw(self.leftEye.image,
            self.leftEye.body:getX(), self.leftEye.body:getY(),
            self.leftEye.body:getAngle(),
            (self.leftEye.shape:getRadius()*4)/self.leftEye.image:getWidth(), (self.leftEye.shape:getRadius()*4)/self.leftEye.image:getHeight(),
            self.leftEye.image:getWidth()/2, self.leftEye.image:getHeight()/2)

        love.graphics.draw(self.rightEye.image,
            self.rightEye.body:getX(), self.rightEye.body:getY(),
            self.rightEye.body:getAngle(),
            (self.rightEye.shape:getRadius()*4)/self.rightEye.image:getWidth(), (self.rightEye.shape:getRadius()*4)/self.rightEye.image:getHeight(),
            self.rightEye.image:getWidth()/2, self.rightEye.image:getHeight()/2)

        love.graphics.draw(self.nose.image,
            self.nose.body:getX(), self.nose.body:getY(),
            self.nose.body:getAngle(),
            self.nose.width*1.25/self.nose.image:getWidth(), self.nose.height*1.25/self.nose.image:getHeight(),
            self.nose.image:getWidth()/2, self.nose.image:getHeight()/2)

        love.graphics.draw(self.toupee.image,
            self.toupee.body:getX(), self.toupee.body:getY(),
            self.toupee.body:getAngle(),
            self.toupee.width*2.5/self.toupee.image:getWidth(), self.toupee.height*2.5/self.toupee.image:getHeight(),
            self.toupee.image:getWidth()/2, self.toupee.image:getHeight()/2)

    end
end

return Sam
