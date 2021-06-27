-- a simple resolution-handling library that allows you to focus on making your game with a fixed resolution. 
push = require 'push'

-- a simple lightweight object orientation library that allows you to focus on creating classes and objects 
Class = require 'class'

-- a class to create paddles
require 'Paddle'

-- a class to create a ball
require 'Ball'

-- dimensions of the main window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- game resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- speed at which paddles move
PADDLE_SPEED = 200

-- function called by LOVE2D only once at the begining of the game; used to initialize the game
function love.load()
    -- set the filter to nearest so graphics aren't blurred
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the seed of the random function to be the current time
    math.randomseed(os.time())

    -- load fonts into memory
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- use the small font
    love.graphics.setFont(smallFont)

    -- load the sound effects into memory
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- initialize the window and the resolution; initialize window properties
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- score for the players
    player1Score = 0
    player2Score = 0

    -- add two players represented by paddles
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- add a ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- state of the game
    gameState = 'start'

    -- player which serves the ball
    servingPlayer = 1

    -- player that won the game
    winningPlayer = 0
end

-- function called by LOVE2D when resizeing the window
function love.resize(w, h)
    -- let the push library handle the resize
    push:resize(w, h)
end

-- function called by LOVE2D each frame when a key is pressed
function love.keypressed(key)
    -- if the escape key is pressed 
    if key == 'escape' then
        -- terminate the game
        love.event.quit()
    -- if the enter key is pressed switch through states
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        -- if the game is done
        elseif gameState == 'done' then
            gameState = 'serve'

            -- reset the ball
            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end           
    end
end

-- function called by LOVE2D each frame; used to update the game
function love.update(dt)
    -- if the ball should be served
    if gameState == 'serve' then
        -- choose a random dy
        ball.dy = math.random(-50, 50)

        -- if the player 1 is serving
        if servingPlayer == 1 then
            -- choose a random dx towards the second player
            ball.dx = math.random(140, 200)
        else
            -- choose a random dx towards the first player
            ball.dx = -math.random(140, 200)
        end
    -- if the ball is moving and the state is play
    elseif gameState == 'play' then
        -- if the ball collides with the left paddle
        if ball:collides(player1) then
            -- make the ball move in the opposite direction and slightly increase the speed
            ball.dx = -ball.dx * 1.03
            -- make sure the ball is outside the paddle
            ball.x = player1.x + 5
            -- play a sound when the ball hits the paddle
            sounds['paddle_hit']:play() 

            -- keep the dy move up or down but randomize the speed
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 5
            sounds['paddle_hit']:play() 
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- if the ball collides with the top wall
        if ball.y <= 0 then
            -- set its position to be 0
            ball.y = 0
            -- change the dy to move in the opposite direction
            ball.dy = -ball.dy
            -- play a sound when the ball hits the wall
            sounds['wall_hit']:play() 
        end

        if ball.y >= VIRTUAL_HEIGHT - ball.height then
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- if the ball is outside the left side of the board
        if ball.x < 0 then
            -- the first players is serving
            servingPlayer = 1
            -- increase the score of the second player
            player2Score = player2Score + 1
            -- play a sound
            sounds['score']:play()

            -- if the second player has won the game
            if player2Score == 10 then
                -- set the winning player
                winningPlayer = 2
                -- set the game state as done
                gameState = 'done'
            else
                -- set the game state as serve
                gameState = 'serve'
                -- reset the ball
                ball:reset()
            end
        end
    
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    -- if the w key is pressed
    if love.keyboard.isDown('w') then
        -- set the dy so that the paddle moves upwards
        player1.dy = -PADDLE_SPEED
    -- if the s key is pressed 
    elseif love.keyboard.isDown('s') then
        -- set the dy so that the paddle moves downwards
        player1.dy = PADDLE_SPEED
    else
        -- set the dy so that the paddle doesn't move
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- if the gameState is play tha ball should move
    if gameState == 'play' then
        ball:update(dt)
    end

    -- update the paddles regardless of the state
    player1:update(dt)
    player2:update(dt)

end

-- function called by LOVE2D each frame; used to render objects to the screen after they had been updated
function love.draw()
    -- draw using the virtual resolution
    push:start()

    -- clear the screen with a specific color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- show the score 
    displayScore()
    
    -- based on the current game state, show some messages
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- render the players
    player1:render()
    player2:render()

    -- render the ball
    ball:render()

    push:finish()
end

function displayScore() 
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 50, VIRTUAL_HEIGHT / 3)
end