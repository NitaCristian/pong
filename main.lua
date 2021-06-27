-- push is a simple resolution-handling library that allows you to focus on making your game with a fixed resolution
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

-- Runs when the game first starts up, only once; used to initialize the game
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- load a more 'retre-looking' font
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- larger font for drawing the score on the screen
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set the active font
    love.graphics.setFont(smallFont)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

-- Keyboard handling function, called by LOVE2D each frame
function love.keypressed(key) 
    if key == 'escape' then
        -- terminate the application
        love.event.quit()
    end
end

-- Runs every frame, dt is the time since the last frame
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

-- Called each frame by LOVE2D after update for drawing things to the screen once they've changed
function love.draw()
    -- begin rendering at virtual resolution
    push:start()

    -- clear the screen with a specific color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    -- draw welcome text to toward the top of the screen
    love.graphics.printf(
        'Hello Pong!', -- text to render
        0, -- starting X position
        20, -- starting Y position
        VIRTUAL_WIDTH, -- number of pixels to center within
        'center' -- align mode
    );

    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 50, VIRTUAL_HEIGHT / 3)

    -- render the first paddle
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- render the second paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, 5, 20)

    -- end rendering at virtual resolution 
    push:finish()
end