WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Runs when the game first starts up, only once; used to initialize the game
function love.load()
    -- Used to initialize the window's dimensions and to set parameters like vsync, whether we're fullscreen or not, and whether the window is resizable after startup.
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    });
end

-- Called each frame by LOVE2D after update for drawing things to the screen once they've changed
function love.draw()
    -- Print function that can align text left, right, or center on the screen.
    love.graphics.printf(
        'Hello Pong!', -- text to render
        0, -- starting X position
        WINDOW_HEIGHT / 2 - 6, -- starting Y position
        WINDOW_WIDTH, -- number of pixels to center within
        'center' -- align mode
    );
end