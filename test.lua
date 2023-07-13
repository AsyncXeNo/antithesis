

function love.load()
    ParticleSystem = love.graphics.newParticleSystem(love.graphics.newImage("res/sprites/particle.png"), 50)
    ParticleSystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
    ParticleSystem:setEmissionRate(5)
    ParticleSystem:setSizeVariation(1)
    ParticleSystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
    ParticleSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency
end


function love.update(dt)
    ParticleSystem:update()
end
    
function love.draw()
    love.graphics.draw(ParticleSystem, love.window.getWidth()/2, love.window.getHeight()/2)
end