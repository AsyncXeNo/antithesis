
local inspect = require "libs.inspect";
local concord = require "libs.Concord";
local push = require "libs.push";
local log = require "libs.log";
require "basics"
require "graphics"

function love.load()

    love.mouse.setVisible(false)
    local gameWidth, gameHeight = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")
    push:setupScreen(1024, 576, 1920, 1080, {upscale = "normal"})

    log.info("Started")
    World = concord.world():addSystem(RenderSystem):addSystem(MovementSystem)

    local test = concord.entity(World)
        :give("Position", 500, 400)
        :give("ComplexSpriteRenderer", "monster", 1)
        :give("Movable", {x=0, y=-400}, {x=100000, y=100000}, {x = 0, y = 0}, {x=500, y=500})

    World:emit("init", World)

end


function love.update(dt)

    World:emit("update", dt)

end


function love.keypressed(key, scancode, isrepeat)

    if key == 'escape' then
        love.event.quit()
    end

end


function love.draw()

    push:start()
    World:emit("draw")
    push:finish()

end