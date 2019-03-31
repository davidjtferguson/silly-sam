local Class = require "hump.class"
local BaseObject = require "toys/baseObject"

Sam = Class{__includes = BaseObject}

function Sam:init(world, mapObject)
    local spawn = {
        x = mapObject.x,
        y = mapObject.y,
    }

    -- 'statics' to control Sam's movements
    self.statics = {}

    -- force to move sam horizontally when using leg forces
    self.statics.sidewardsLegForce = 1000

    -- force going along sam's leg
    self.statics.upwardsLegForce = 120

    -- hand force from sticks
    self.statics.armForce = 100

    -- multiplier when arm on ground and 'push up'
    self.statics.pushForce = 10000

    -- chest
    self.chest = {}
    self.chest.width = 50
    self.chest.height = 60
    self.chest.image = love.graphics.newImage("assets/art/sam-textures/chest.png")
    self.chest.body = love.physics.newBody(world, spawn.x, spawn.y, "dynamic")
    self.chest.body:setUserData("samBodyPart")
    self.chest.shape = love.physics.newRectangleShape(self.chest.width, self.chest.height)
    self.chest.fixture = love.physics.newFixture(self.chest.body, self.chest.shape);
    self.chest.fixture:setFriction(0.5)
    self.chest.color = {1, 1, 1}

    -- left leg
    self.leftLeg = {}
    self.leftLeg.width = 17
    self.leftLeg.height = 45
    self.leftLeg.image = love.graphics.newImage("assets/art/sam-textures/leg-left.png")
    self.leftLeg.body = love.physics.newBody(world, spawn.x-20, spawn.y+60, "dynamic")
    self.leftLeg.body:setUserData("samBodyPart")
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

    -- right leg
    self.rightLeg = {}
    self.rightLeg.width = 17
    self.rightLeg.height = 45
    self.rightLeg.image = love.graphics.newImage("assets/art/sam-textures/leg-right.png")
    self.rightLeg.body = love.physics.newBody(world, spawn.x+20, spawn.y+60, "dynamic")
    self.rightLeg.body:setUserData("samBodyPart")
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

    -- head
    self.head = {}
    self.head.image = love.graphics.newImage("assets/art/sam-textures/face.png")
    self.head.body = love.physics.newBody(world, spawn.x, spawn.y-45, "dynamic")
    self.head.body:setUserData("samBodyPart")
    self.head.shape = love.physics.newCircleShape(15)
    self.head.fixture = love.physics.newFixture(self.head.body, self.head.shape, 0.5);
    self.head.fixture:setFriction(0.5)
    self.head.color = {0.80, 0.20, 0.20}

    self.head.joint = love.physics.newRevoluteJoint(self.chest.body, self.head.body, spawn.x, spawn.y-57)

    -- chin (not visible, for weighting)
    self.chin = {}
    self.chin.body = love.physics.newBody(world, spawn.x, spawn.y-35, "dynamic")
    self.chin.body:setUserData("samBodyPart")
    self.chin.shape = love.physics.newCircleShape(4)
    self.chin.body:setMass(1000)
    self.chin.fixture = love.physics.newFixture(self.chin.body, self.chin.shape, 0.5);
    self.chin.fixture:setFriction(0.5)
    self.chin.color = {0.80, 0.20, 0.20}

    self.chin.joint = love.physics.newWeldJoint(self.head.body, self.chin.body, spawn.x, spawn.y-65)

    -- toupee
    self.toupee = {}
    self.toupee.width = 20
    self.toupee.height = 7.3
    self.toupee.image = love.graphics.newImage("assets/art/sam-textures/game-empty-texture.png")
    self.toupee.body = love.physics.newBody(world, spawn.x, spawn.y-74, "dynamic")
    self.toupee.body:setUserData("samBodyPart")
    self.toupee.body:setMass(0)
    self.toupee.shape = love.physics.newRectangleShape(self.toupee.width, self.toupee.height)
    self.toupee.fixture = love.physics.newFixture(self.toupee.body, self.toupee.shape, 1);
    self.toupee.fixture:setFriction(1)
    self.toupee.color = {0.1, 0.4, 1}

    self.toupee.joint = love.physics.newRevoluteJoint(self.toupee.body, self.head.body, spawn.x+1, spawn.y-74+self.toupee.height)
    
    -- self.toupee.joint:enableLimit(enable) trying to enable limit on joint - rory

    -- left eye
    self.leftEye = {}
    self.leftEye.radius = 2
    self.leftEye.image = love.graphics.newImage("assets/art/sam-textures/game-empty-texture.png")
    self.leftEye.body = love.physics.newBody(world, spawn.x-10, spawn.y-60, "dynamic")
    self.leftEye.body:setUserData("samBodyPart")
    self.leftEye.shape = love.physics.newCircleShape(self.leftEye.radius)
    self.leftEye.fixture = love.physics.newFixture(self.leftEye.body, self.leftEye.shape, 0.5);
    self.leftEye.fixture:setFriction(0.9)
    self.leftEye.color = {0.20, 0.70, 0.20}

    self.leftEye.joint = love.physics.newRevoluteJoint(self.leftEye.body, self.head.body, spawn.x-7, spawn.y-60)

    -- right eye
    self.rightEye = {}
    self.rightEye.radius = 2
    self.rightEye.image = love.graphics.newImage("assets/art/sam-textures/game-empty-texture.png")
    self.rightEye.body = love.physics.newBody(world, spawn.x+10, spawn.y-50, "dynamic")
    self.rightEye.body:setUserData("samBodyPart")
    self.rightEye.shape = love.physics.newCircleShape(self.rightEye.radius)
    self.rightEye.fixture = love.physics.newFixture(self.rightEye.body, self.rightEye.shape, 0.5);
    self.rightEye.fixture:setFriction(0.9)
    self.rightEye.color = {0.20, 0.70, 0.20}

    self.rightEye.joint = love.physics.newRevoluteJoint(self.rightEye.body, self.head.body, spawn.x+7, spawn.y-56)

    -- nose
    self.nose = {}
    self.nose.width = 13
    self.nose.height = 26
    self.nose.image = love.graphics.newImage("assets/art/sam-textures/nose.png")
    self.nose.body = love.physics.newBody(world, spawn.x+1, spawn.y-55, "dynamic")
    self.nose.body:setUserData("samBodyPart")
    self.nose.shape = love.physics.newRectangleShape(self.nose.width, self.nose.height)
    self.nose.fixture = love.physics.newFixture(self.nose.body, self.nose.shape, 1);
    self.nose.fixture:setFriction(.8)
    self.nose.color = {0.20, 0.30, 0.80}

    self.nose.joint = love.physics.newRevoluteJoint(self.nose.body, self.head.body, spawn.x+1, spawn.y-66)

    -- left arm
    self.leftArm = {}
    self.leftArm.width = 20
    self.leftArm.height = 35
    self.leftArm.image = love.graphics.newImage("assets/art/sam-textures/arm-left.png")
    self.leftArm.body = love.physics.newBody(world, spawn.x-30, spawn.y, "dynamic")
    self.leftArm.body:setUserData("samBodyPart")
    self.leftArm.shape = love.physics.newRectangleShape(self.leftArm.width, self.leftArm.height)
    self.leftArm.fixture = love.physics.newFixture(self.leftArm.body, self.leftArm.shape, 1);
    self.leftArm.fixture:setFriction(0.5)
    self.leftArm.color = {0.1, 0.4, 1}

    self.leftArm.joint = love.physics.newRevoluteJoint(self.chest.body, self.leftArm.body, spawn.x-30, spawn.y-10)

    local handToArmDistance = -8

    -- left hand
    self.leftHand = {}
    self.leftHand.image = love.graphics.newImage("assets/art/sam-textures/hand-left-open.png")
    self.leftHand.body = love.physics.newBody(world, spawn.x-30, spawn.y+self.leftArm.height+handToArmDistance, "dynamic")
    self.leftHand.body:setUserData("samBodyPart")
    self.leftHand.shape = love.physics.newCircleShape(8)
    self.leftHand.fixture = love.physics.newFixture(self.leftHand.body, self.leftHand.shape, 1);
    self.leftHand.color = {0.8, 0.4, 1}

    self.leftHand.joint = love.physics.newWeldJoint(self.leftHand.body, self.leftArm.body, spawn.x-30, spawn.y-self.leftArm.height+handToArmDistance)

    -- physics not applied - for checking collisions on 'grabbing'
    self.leftHand.fixture:setSensor(true)

    -- right arm
    self.rightArm = {}
    self.rightArm.width = 20
    self.rightArm.height = 35
    self.rightArm.image = love.graphics.newImage("assets/art/sam-textures/arm-right.png")
    self.rightArm.body = love.physics.newBody(world, spawn.x+30, spawn.y, "dynamic")
    self.rightArm.body:setUserData("samBodyPart")
    self.rightArm.shape = love.physics.newRectangleShape(self.rightArm.width, self.rightArm.height)
    self.rightArm.fixture = love.physics.newFixture(self.rightArm.body, self.rightArm.shape, 1);
    self.rightArm.fixture:setFriction(0.5)
    self.rightArm.color = {0.7, 0.1, 0.1}

    self.rightArm.joint = love.physics.newRevoluteJoint(self.chest.body, self.rightArm.body, spawn.x+30, spawn.y-10)

    -- left hand
    self.rightHand = {}
    self.rightHand.image = love.graphics.newImage("assets/art/sam-textures/hand-right-open.png")
    self.rightHand.body = love.physics.newBody(world, spawn.x+30, spawn.y+self.rightArm.height+handToArmDistance, "dynamic")
    self.rightHand.body:setUserData("samBodyPart")
    self.rightHand.shape = love.physics.newCircleShape(8)
    self.rightHand.fixture = love.physics.newFixture(self.rightHand.body, self.rightHand.shape, 1);
    self.rightHand.color = {0.8, 0.4, 1}

    self.rightHand.joint = love.physics.newWeldJoint(self.rightHand.body, self.rightArm.body, spawn.x+30, spawn.y-self.rightArm.height+handToArmDistance)

    -- physics not applied - for checking collisions on 'grabbing'
    self.rightHand.fixture:setSensor(true)

    -- These are for drawing
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
        self.leftHand,
        self.rightHand,
    }

    self.yPrevLeftFactor = 0
    self.yPrevRightFactor = 0

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

        if self:partHasGroundContact(arm) and (yFactor - self.yPrevLeftFactor) < pushThreshold then
            forceFactor = self.statics.pushForce*dt
    
            -- don't want any horizontal
            xFactor = 0
        end
    
        self.yPrevLeftFactor = yFactor
    elseif xaxis == "rightx" then

        if self:partHasGroundContact(arm) and (yFactor - self.yPrevRightFactor) < pushThreshold then
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
    if joystick then
        if joystick:getGamepadAxis("triggerleft") < 1 and self.leftTriggerDown == true then
            self.leftTriggerDown = false
        end

        if joystick:getGamepadAxis("triggerleft") >= 1 and self.leftTriggerDown == false then
            self:moveLeft()

            self.leftTriggerDown = true
        end
    end
end
 
function Sam:rightLegForces()
    if joystick then
        if joystick:getGamepadAxis("triggerright") < 1 and self.rightTriggerDown == true then
            self.rightTriggerDown = false
        end

        if joystick:getGamepadAxis("triggerright") >= 1 and self.rightTriggerDown == false then
            self:moveRight()

            self.rightTriggerDown = true
        end
    end
end

function Sam:moveLeft()
    if self:partHasGroundContact(self.leftLeg) then
        self:forceUpLeg(self.leftLeg)

        -- shove a little bit left as well to help travelling
        self.leftLeg.body:applyForce(-self.statics.sidewardsLegForce, 0)
    end
end

function Sam:moveRight()
    if self:partHasGroundContact(self.rightLeg) then
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

function Sam:leftGrab()
    self.leftHand.image = love.graphics.newImage("assets/art/sam-textures/hand-left-closed.png")
    self:handGrab(self.leftHand)
end

function Sam:rightGrab()
    self.rightHand.image = love.graphics.newImage("assets/art/sam-textures/hand-right-closed.png")

    self:handGrab(self.rightHand)
end

-- Grab onto anything we've overlapping
function Sam:handGrab(hand)
    if #hand.body:getContacts() > 0 then
        for _, contact in ipairs(hand.body:getContacts()) do
            if contact:isTouching() then
                -- great, find the correct body to join to the hand
                fixture1, fixture2 = contact:getFixtures()

                if fixture1 == hand.fixture then
                    hand.worldJoint = love.physics.newRevoluteJoint(hand.body, fixture2:getBody(), hand.body:getX(), hand.body:getY())
                else
                    hand.worldJoint = love.physics.newRevoluteJoint(hand.body, fixture1:getBody(), hand.body:getX(), hand.body:getY())
                end

                break
            end
        end
    end
end

function Sam:leftRelease()
    self.leftHand.image = love.graphics.newImage("assets/art/sam-textures/hand-left-open.png")
    self:handRelease(self.leftHand)
end

function Sam:rightRelease()
    self.rightHand.image = love.graphics.newImage("assets/art/sam-textures/hand-right-open.png")
    self:handRelease(self.rightHand)
end

-- if we'd grabbed anything, release it
function Sam:handRelease(hand)
    if hand.worldJoint and not hand.worldJoint:isDestroyed() then
        hand.worldJoint:destroy()
    end
end

function Sam:partHasGroundContact(samPart)
    -- Check through fixture's contacts and see if any of them are non-sam's bodies
    
    local groundContactExists = false
    local contacts = samPart.body:getContacts()

    for contactIndex in pairs(contacts) do
        if contacts[contactIndex]:isTouching() then
            fixture1, fixture2 = contacts[contactIndex]:getFixtures()

            -- Only want to check as long as we haven't found a contact
            if not groundContactExists then
                if fixture1:getBody() ~= samPart.body then
                    groundContactExists = fixture1:getBody():getUserData() ~= "samBodyPart"
                end

                if fixture2:getBody() ~= samPart.body then
                    groundContactExists = fixture2:getBody():getUserData() ~= "samBodyPart"
                end
            end
        end
    end

    return groundContactExists
end

function Sam:draw(drawShapes, drawSprites)
    -- default if no info given
    drawShapes = drawShapes or false
    drawSprites = drawSprites or false

    if drawShapes then
        for i in pairs(self.circParts) do
            self:drawCirclePhysicsObject(self.circParts[i])
        end

        for i in pairs(self.rectParts) do
            self:drawRectanglePhysicsObject(self.rectParts[i])
        end
    end

    if drawSprites then
        self:drawRectangleTexturedObject(self.leftLeg, 1.55, 1.4)
        self:drawRectangleTexturedObject(self.rightLeg, 1.55, 1.4)
        
        self:drawRectangleTexturedObject(self.chest, 1.5, 1.8, 1, 30)

        -- just drawing statically - should put into head sprite
        -- local hairImage = love.graphics.newImage("assets/art/sam-textures/hair.png")
        --love.graphics.draw(hairImage,
        --    self.head.body:getX(), self.head.body:getY(),
        --    self.head.body:getAngle(),
        --    (self.head.shape:getRadius()*3.5)/hairImage:getWidth(), (self.head.shape:getRadius()*4.5)/hairImage:getHeight(),
        --    hairImage:getWidth()/2, hairImage:getHeight()/1.75) 

        -- shadows of arms across the body
        -- I dunno how to make it just check the non-transparant pixels of the texture so drawing two circles that
        -- roughly cover the body. doesn't match well when Sam falls over but w/e
        love.graphics.stencil(
            function()
                love.graphics.circle("fill", self.chest.body:getX()-2, self.chest.body:getY()-7, self.chest.width/1.6)
                love.graphics.circle("fill", self.chest.body:getX()-1, self.chest.body:getY()+10, self.chest.width/1.7)
            end,
            "increment"
        )
        love.graphics.setStencilTest("gequal", 1)
    
        -- Draw arm shadows
        -- colar color, slightly bigger than we're going to draw the arm over it
        love.graphics.setColor(0.5, 0.5, 0.7, 0.8)
        self:drawRectangleTexturedObject(self.leftArm, 1.35, 1.35, 1, -30)
        self:drawRectangleTexturedObject(self.rightArm, 1.35, 1.35, 1, -30)

        love.graphics.setStencilTest()

        love.graphics.setColor(1, 1, 1, 1)

        -- Face parts
        self:drawCircleTexturedObject(self.head, 2.2, 2, 80)
        
        self:drawCircleTexturedObject(self.leftEye, 3, 0, 30)
        self:drawCircleTexturedObject(self.rightEye, 3, -10, 30)

        self:drawRectangleTexturedObject(self.nose, 4.2, .8, 10, 10)
        self:drawRectangleTexturedObject(self.toupee, 3, 3)

        -- arm parts
        self:drawCircleTexturedObject(self.leftHand, 1.5)
        self:drawCircleTexturedObject(self.rightHand, 1.5)
    
        self:drawRectangleTexturedObject(self.leftArm, 1.25, 1.4, 1, -30)
        self:drawRectangleTexturedObject(self.rightArm, 1.25, 1.4, 1 , -30)

    end
end

return Sam
