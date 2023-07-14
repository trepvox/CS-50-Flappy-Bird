--[[
    Pipe Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Pipe class represents the pipes that randomly spawn in our game, which act as our primary obstacles.
    The pipes can stick out a random distance from the top or bottom of the screen. When the player collides
    with one of them, it's game over. Rather than our bird actually moving through the screen horizontally,
    the pipes themselves scroll through the game to give the illusion of player movement.
]]

Pipe = Class{}

-- creating a local variable, and only one copy to save memory
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- speed pipe will scroll from right o left
PIPE_SPEED = 60

-- gloabl height and width of pipe
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

-- this one is asking if the pipe is normal or upside down
function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    -- setting width of a graphics object
    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

--need the update so the pipe will scroll now across the screen
function Pipe:update(dt)

end

--needs to draw the pipe so it can be created within the class instead of in main.
-- when you flip a sprite like this, you perform a mirror and shifts it up by pipe_height
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, -- rotation 
        1, -- X scale
        self.orientation == 'top' and -1 or 1) -- Y scale
                                    -- when you set a spirte scale factor to -1, that's how you flip it
end