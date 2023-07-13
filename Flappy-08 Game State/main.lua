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

-- all code related to the game state and state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

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


local scrolling = true

function love.load()
    -- on upscaling and downscaling of pictures, go nearest to allow for no blurryness of pixals
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- setting title for project in game
    love.window.setTitle('Fifty Bird')

    -- creating nice text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    -- note that the g at the start is to indicate that this is a global module
    gStateMachine = StateMachine {
        --takes a table with keys mapped to functions that will return our states
        ['title'] = function() return TitleScreenState() end,
        --title function returns to title screen whereas play returns to the Play state screen.
        ['play'] = function() return PlayState() end,
    }
    --change some value in statemachince to reference key 'title' and return that.
    gStateMachine:change('title')

    --initialize input table
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
    --scrolls background by preset speed
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) %
            BACKGROUND_LOOPING_POINT
        --scroll time = scroll speed * seconds divided by the background looping point

        --ground is designed to be repeating so not noticable when it loops doing it this way but could if not designed to be looped seamlessly.
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    -- now we update the state machine, which defers to the right state
    gStateMachine:update(dt)
    -- gonna look for current state, and then update said state.

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
    gStateMachine:render()

    -- now we draw in the center but at the bottom, taking into account the size of the png file that's being draw so it's on screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    --renders the bird in game
    bird:render()

    push:finish()
end