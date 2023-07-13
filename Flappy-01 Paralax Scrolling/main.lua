push = require 'push'

-- screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
-- all to fit compfortable on a 16 x 9 monitors resolution

-- going to create and store the backgrounds locally to start
local background = love.graphics.newImage('background.png')
--need a variable to keep track of the scrolling so it doesn't go far and it knows when to repeat
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

--need to set a speed for the scrolls
--standard practice to write in all caps is something is going to be constant.
local BACKGROUND_SCROLL_SPEED = 30
-- to create the paralax scrolling, we need the ground going must faster than the background
local GROUND_SCROLL_SPEED = 60


--establishing the looping effect for the images.
--can be done a few ways having multiple of the same image just start over, or telling it the end point and to start again
local BACKGROUND_LOOPING_POINT = 413



function love.load()
    -- on upscaling and downscaling of pictures, go nearest to allow for no blurryness of pixals
    love.graphics.setDefaultFilter('nearest', 'nearest')

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


function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
    --scroll time = scroll speed * seconds divided by the background looping point

    --ground is designed to be repeating so not noticable when it loops doing it this way but could if not designed to be looped seamlessly.
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH
end

-- is to render our games
function love.draw()
    -- new way to do this as opposed to last weeks. moving forward is done this way
    push:start()
    -- draw the background at the center of the screen
    --changing x value to scroll for the background to be able to implement the scrolling
    love.graphics.draw(background, -backgroundScroll, 0)
    -- now we draw in the center but at the bottom, taking into account the size of the png file that's being draw so it's on screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end
