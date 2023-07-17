-- -- Fragment shader
-- local fragmentShader = [[
--     extern number blurSize; // Size of the blur
--     extern number screenWidth; // Width of the screen
--     extern number screenHeight; // Height of the screen
    
--     vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
--     {
--         vec4 sum = vec4(0.0);
        
--         // Blur in horizontal direction
--         for (int i = -4; i <= 4; i++)
--         {
--             vec2 offset = vec2(float(i) * blurSize / screenWidth, 0.0);
--             sum += Texel(texture, texture_coords + offset);
--         }
        
--         // Blur in vertical direction
--         for (int i = -4; i <= 4; i++)
--         {
--             vec2 offset = vec2(0.0, float(i) * blurSize / screenHeight);
--             sum += Texel(texture, texture_coords + offset);
--         }
        
--         // Average the samples
--         vec4 blurredColor = sum / 9.0;
        
--         return blurredColor;
--     }
-- ]]

-- function love.load()

--     Shader = love.graphics.newShader(fragmentShader)
    
--     Image = love.graphics.newImage("res/sprites/player.png")
    
-- end

-- function love.update(dt)

-- end

-- function love.keypressed(key, scancode, isrepeat)

--     if key == 'escape' then
--         love.event.quit()
--     end

-- end

-- function love.draw()
--     love.graphics.setShader()
--     love.graphics.draw(Image, 0, 0)
--     love.graphics.setShader(Shader)
--     love.graphics.draw(Canvas, 0, love.graphics:getHeight()/2)
-- end

