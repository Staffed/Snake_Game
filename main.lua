-- main.lua

-- Include Snake module
local Snake = require('snake')

-- Initialize game variables
local tileSize = 20
local gridSize = 20
local snake

function love.load()
    love.window.setTitle("Snake Game")
    love.window.setMode(gridSize * tileSize, gridSize * tileSize)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    
    -- Initialize Snake
    snake = Snake.new(gridSize)
end

function love.update(dt)
    -- Update Snake
    snake:update(dt)
end

function love.draw()
    -- Draw Snake
    snake:draw()
end

function love.keypressed(key)
    -- Pass input to Snake
    snake:keypressed(key)
end
