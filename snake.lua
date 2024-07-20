-- snake.lua

local Snake = {}
-- snake functionality
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
        interval = 0.1
    }
    --timer for updating on snake
    function self:update(dt)
        self.timer = self.timer + dt
        if self.timer >= self.interval then
            self.timer = self.timer - self.interval
            
            -- Move the snake
            local headX, headY = self.segments[1].x, self.segments[1].y
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
                -- Game over
                love.event.quit()
            end
            
            -- Check if collides with itself
            for i = 2, #self.segments do
                if headX == self.segments[i].x and headY == self.segments[i].y then
                    -- Game over
                    love.event.quit()
                end
            end
            
            -- Update segments
            table.insert(self.segments, 1, {x = headX, y = headY})
            if headX == foodX and headY == foodY then
                -- Snake eats food
                -- Increase score or grow snake
                -- Recreate food
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
    
    return self
end

return Snake
