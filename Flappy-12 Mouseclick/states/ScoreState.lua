--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--creating the medals to load
local bronze = love.graphics.newImage('bronze.png')
local silver = love.graphics.newImage('silver.png')
local gold = love.graphics.newImage('gold.png')
local platinum = love.graphics.newImage('platinum.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score >= 10 then
        love.graphics.draw(platinum, VIRTUAL_WIDTH / 2 - platinum:getWidth() / 2, 120)
    elseif self.score >= 7 then
        love.graphics.draw(gold, VIRTUAL_WIDTH / 2 - platinum:getWidth() / 2, 120)
    elseif self.score >= 4 then
        love.graphics.draw(silver, VIRTUAL_WIDTH / 2 - platinum:getWidth() / 2, 120)
    elseif self.score >= 2 then
        love.graphics.draw(bronze, VIRTUAL_WIDTH / 2 - platinum:getWidth() / 2, 120)
    else 
        love.graphics.printf('No one is good their first time after all', 0, 200, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end