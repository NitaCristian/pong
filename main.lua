-- push is a simple resolution-handling library that allows you to focus on making your game with a fixed resolution
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Runs when the game first starts up, only once; used to initialize the game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

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

    -- Print function that can align text left, right, or center on the screen.
    love.graphics.printf(
        'Hello Pong!', -- text to render
        0, -- starting X position
        VIRTUAL_HEIGHT / 2 - 6, -- starting Y position
        VIRTUAL_WIDTH, -- number of pixels to center within
        'center' -- align mode
    );

    -- end rendering at virtual resolution 
    push:finish()
end