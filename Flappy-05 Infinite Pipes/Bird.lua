Bird = Class{}

-- going to implement a constant for gravity
local GRAVITY = 20 

function Bird:init()
    -- loading bird image from disk and assign its width and height
    self.image = love.graphics.newImage('bird.png')
    --every image
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- the position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity or Gravity
    self.dy = 0
end

function Bird:update(dt)
    -- applying gravity to velocity
    --velocity is = to current velocity + Gravity times Deltra Time
    self.dy = self.dy + GRAVITY * dt

    --implements the jump or flap motion.
    if love.keyboard.wasPressed('space') then
        -- the negative 5 is important to not add onto the gravity already in effect.
        self.dy = -5
    end

    --Apply current velocity to Y position
    --Y axis on screen is = to Y axis on screen + velocity
    self.y = self.y + self.dy

    -- One thing to notice is that because delta y and y are both increasing, the speed at which you fall also is increasing
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end