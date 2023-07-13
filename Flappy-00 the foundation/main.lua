push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
-- all to fit compfortable on a 16 x 9 monitors resolution

-- going to create and store the backgrounds locally to start
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- on upscaling and downscaling of pictures, go nearest to allow for no blurryness of pixals

    -- setting title for project in game
    love.window.setTitle('Fifty Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    --is to allow the game to scale to fit the screen and not distort 
    push:resize(w, h)
end

-- takes in the user input
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- is to render our games
function love.draw()
    -- new way to do this as opposed to last weeks. moving forward is done this way
    push:start()
    -- draw the background at the center of the screen
    love.graphics.draw(background, 0, 0)
    -- now we draw in the center but at the bottom, taking into account the size of the png file that's being draw so it's on screen
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
    push:finish()
end
