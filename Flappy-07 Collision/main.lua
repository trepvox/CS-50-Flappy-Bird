--[[
    GD50
    Flappy Bird Remake

    bird7
    "The Collision Update"

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]
push = require 'push'

-- need to require class so that you can call the bird class
Class = require 'class'

-- requires the bird class
require 'Bird'

-- class for pip
require 'Pipe'

-- class represents pair of pipes together
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
-- all to fit compfortable on a 16 x 9 monitors resolution

-- going to create and store the backgrounds locally to start
local background = love.graphics.newImage('background.png')
--need a variable to keep track of the scrolling so it doesn't go far and it knows when to repeat
local backgroundScroll = 0

-- speed of ground image and how fast it mvoes
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

local GROUND_LOOPING_POINT = 514


--create the bird locally 
local bird = Bird()

-- Table for spawning PipePairs
local pipePairs = {}

--timer is to decide when each pipe will spawn
local spawnTimer = 0 -- will run in delta time so 60dt = 1 second

-- initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20
-- done so that pipe aren't crazy and can actually be beatable

local scrolling = true

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

    --initialize input tabnle
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    --is to allow the game to scale to fit the screen and not distort 
    push:resize(w, h)
end

-- takes in the user input
function love.keypressed(key)
    -- add table of keys pressed from this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    New function used to check our global input table for keys we activated during
    this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if scrolling then
        --scrolls background by preset speed
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT
        --scroll time = scroll speed * seconds divided by the background looping point

        --ground is designed to be repeating so not noticable when it loops doing it this way but could if not designed to be looped seamlessly.
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % GROUND_LOOPING_POINT

        -- creating a spawn timer to increment every dt
        spawnTimer = spawnTimer + dt

        -- if spawn timer is greater than 2, call the table pipes, and insert a new pipe object into it.
        if spawnTimer > 2 then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y

            table.insert(pipePairs, PipePair())
            -- resetting the spawntimer to allow for space
            spawnTimer = 0
        end
        -- going to implement the update for the bird within main. All the rest is done within the bird class.
        bird:update(dt)

        --assigns the key of the k
        for k, pair in pairs(pipePairs) do
            --firstly we want to update the pipe
            pair:update(dt)
            
            -- check to see if bird collided with pipe
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    -- pause the game to show collision
                    scrolling = false
                end
            end

            -- if pipe is no longer visible past left edge, remove it from scene
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end

            -- if pipe moved beyond the width of the screen, then call the table pipes and remove that pipe with the key of k*
            for k, pair in pairs(pipePairs) do 
                if pair.remove then
                    table.remove(pipePairs, k)
                end
        end
    end
    --lastly resets the input table
    love.keyboard.keysPressed = {}
end

-- is to render our games
function love.draw()
    -- new way to do this as opposed to last weeks. moving forward is done this way
    push:start()
    -- draw the background at the center of the screen
    --changing x value to scroll for the background to be able to implement the scrolling
    love.graphics.draw(background, -backgroundScroll, 0)

    --adding pips here so the ground renders afterwards and it'll stand in from of the pipe for visual appearance. 
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    -- now we draw in the center but at the bottom, taking into account the size of the png file that's being draw so it's on screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --renders the bird in game
    bird:render()

    push:finish()
end