Pipe = Class{}

-- creating a local variable, and only one copy to save memory
local PIPE_IMAGE = love.graphics.newImage('pipe.png' )

--negative 60 
local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH

    -- VIRTUAL_HEIGH - 4 to cover the top and VIRTUAL_HEIGHT - 10 to cover the bottom.
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

    -- setting width of a graphics object
    self.width = PIPE_IMAGE:getWidth()
end

--need the update so the pipe will scroll now across the screen
function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

--needs to draw the pipe so it can be created within the class instead of in main.
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end