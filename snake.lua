local Snake = {}

function Snake.new(gridSize)
    local self = {
        gridSize = gridSize,
        tile = {
            size = 20,
            color = {0.4, 0.8, 0.2}
        },
        segments = {
            {x = 3, y = 1},
            {x = 2, y = 1},
            {x = 1, y = 1}
        },
        direction = 'right',
        timer = 0,
        interval = 0.1,
        food = {x = -1, y = -1},  -- Initialize food position outside grid
        score = 0,  -- Initialize score
        baseInterval = 0.1,  -- Base interval for updates
        highScore = 0  -- Initialize high score
    }

    function self:update(dt)
        self.timer = self.timer + dt
        if self.timer >= self.interval then
            self.timer = self.timer - self.interval
            
            local headX, headY = self.segments[1].x, self.segments[1].y
            
            -- Move the snake
            if self.direction == 'right' then
                headX = headX + 1
            elseif self.direction == 'left' then
                headX = headX - 1
            elseif self.direction == 'down' then
                headY = headY + 1
            elseif self.direction == 'up' then
                headY = headY - 1
            end
            
            -- Check if out of bounds
            if headX < 1 or headX > self.gridSize or headY < 1 or headY > self.gridSize then
                love.event.quit()  -- Game over if out of bounds
            end
            
            -- Check if collides with itself
            for i = 2, #self.segments do
                if headX == self.segments[i].x and headY == self.segments[i].y then
                    love.event.quit()  -- Game over if collides with itself
                end
            end
            
            -- Update segments
            table.insert(self.segments, 1, {x = headX, y = headY})
            
            -- Check if snake eats food
            if headX == self.food.x and headY == self.food.y then
                -- Snake eats food
                self.score = self.score + 1  -- Increase score
                if self.score > self.highScore then
                    self.highScore = self.score  -- Update high score if necessary
                end
                self:adjustSpeed()  -- Adjust speed based on score
                self:generateFood()  -- Generate new food
            else
                -- Remove the tail segment
                table.remove(self.segments)
            end
        end
    end
    
    function self:draw()
        love.graphics.setColor(self.tile.color)
        for _, segment in ipairs(self.segments) do
            love.graphics.rectangle('fill', (segment.x - 1) * self.tile.size, (segment.y - 1) * self.tile.size, self.tile.size, self.tile.size)
        end
        
        -- Draw food
        love.graphics.setColor(1, 0, 0)  -- Red color for food
        love.graphics.rectangle('fill', (self.food.x - 1) * self.tile.size, (self.food.y - 1) * self.tile.size, self.tile.size, self.tile.size)
        
        -- Draw score
        love.graphics.setColor(1, 1, 1)  -- White color for score
        love.graphics.print("Score: " .. self.score, 10, 10)  -- Display score at the top-left corner
        
        -- Draw high score
        local windowWidth = love.graphics.getWidth()
        love.graphics.print("High Score: " .. self.highScore, windowWidth - 150, 10)  -- Display high score at the top-right corner
    end
    
    function self:keypressed(key)
        if key == 'right' and self.direction ~= 'left' then
            self.direction = 'right'
        elseif key == 'left' and self.direction ~= 'right' then
            self.direction = 'left'
        elseif key == 'down' and self.direction ~= 'up' then
            self.direction = 'down'
        elseif key == 'up' and self.direction ~= 'down' then
            self.direction = 'up'
        end
    end
    
    function self:generateFood()
        -- Generate random position for food within grid boundaries
        self.food.x = love.math.random(1, self.gridSize)
        self.food.y = love.math.random(1, self.gridSize)
        
        -- Ensure food does not spawn on snake
        for _, segment in ipairs(self.segments) do
            if self.food.x == segment.x and self.food.y == segment.y then
                self:generateFood()  -- Regenerate if food spawns on snake
                return
            end
        end
    end
    
    function self:adjustSpeed()
        -- Decrease the interval to increase speed
        self.interval = self.baseInterval * (0.9 ^ self.score)
    end
    
    -- Initial food generation
    self:generateFood()
    
    return self
end

return Snake
