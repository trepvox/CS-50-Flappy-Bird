Bird = Class{}

function Bird:init()
    -- loading bird image from disk and assign its width and height
    self.image = love.graphics.newImage('bird.png')
    --every image
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- the position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end