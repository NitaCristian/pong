-- push is a simple resolution-handling library that allows you to focus on making your game with a fixed resolution
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Runs when the game first starts up, only once; used to initialize the game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- load a more 'retre-looking' font
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- set the active font
    love.graphics.setFont(smallFont)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Keyboard handling function, called by LOVE2D each frame
function love.keypressed(key) 
    if key == 'escape' then
        -- terminate the application
        love.event.quit()
    end
end

-- Called each frame by LOVE2D after update for drawing things to the screen once they've changed
function love.draw()
    -- begin rendering at virtual resolution
    push:start()

    -- clear the screen with a specific color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- draw welcome text to toward the top of the screen
    love.graphics.printf(
        'Hello Pong!', -- text to render
        0, -- starting X position
        20, -- starting Y position
        VIRTUAL_WIDTH, -- number of pixels to center within
        'center' -- align mode
    );

    -- render the first paddle
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- render the second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20)

    -- end rendering at virtual resolution 
    push:finish()
end