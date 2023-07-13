--[[
    PipePair Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used to represent a pair of pipes that stick together as they scroll, providing an opening
    for the player to jump through in order to score a point.
]]

PipePair = Class{}

-- size of the gap between pipes
--local GAP_HEIGHT = 90
--changed it out to be random down below

function PipePair:init(y)
    -- keep track if has been scored or flown through yet
    self.scored = false

    --initialize pipes past the end of screen
    self.x = VIRTUAL_WIDTH + 32

    --y value is for the top pipe
    self.y = y 

    --instantiate two pipes that belong to this pairing
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random(100, 160))
    }

    --whetheer this pipe is ready to be removed from scene
    self.remove = false
end

function PipePair:update(dt)
    --removes the pipe from the scene if it's before the left edge
    --else moves from right to left
    if scrolling then
        if self.x > -PIPE_WIDTH then
            self.x = self.x - PIPE_SPEED * dt
            self.pipes['lower'].x = self.x 
            self.pipes['upper'].x = self.x 
        else
            self.remove = true
        end
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end