local concord = require "libs.Concord";
local push = require "libs.push";
local log = require "libs.log";

require "basics"
require "graphics"
require "physics"
require "controller"
require "text"

local spriteSheet = require "res.spritesheets"


World = concord.world()

function love.load()

    love.mouse.setVisible(false)
    local gameWidth, gameHeight = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(gameWidth, gameHeight)
    push:setupScreen(1024, 576, 1920, 1080, {upscale = "normal"})

    log.info("Started")
    World:addSystem(RenderSystem):addSystem(InputSystem):addSystem(MovementSystem):addSystem(CollisionSystem):addSystem(MessageBoxSystem)

    local test = concord.entity(World)
        :give("Position", 300, 300)
        :give("ComplexSpriteRenderer", "monster", 1)
        :give("Movable", {x=0, y=0}, {x=1200, y=1200}, {x = 0, y = 0}, {x=50000, y=50000})
        :give("Controllable", 100)
        :give("Collider", "BOX", {width=32, height=32}, {x=0, y=0})

    local obj = concord.entity(World)
        :give("Position", 600, 300)
        :give ("CircleRenderer", 10, {0,0,1,1} )
        :give("Collider", "CIRCLE", {r=10}, {x=0, y=0},
            function(self, entity)
                self:remove("Collider")
                concord.entity(World)
                    :give("Position", 300, 300)
                    :give("MessageBox", {{1, 0.12, 0.44, 1}, "Hello World"})
                concord.entity(World)
                    :give("Position", 200, 300)
                    :give("ComplexSpriteRenderer", "player", 0)
                    :give("Animator", States.table({
                        ["idle"] = {
                            ["spritesheet"] = "monster",
                            ["speed"] = 1,
                        }
                    }, "idle"), {}, {})
            end
        )

    World:emit("init", World)

end


function World:onEntityAdded(entity)

    if entity.ComplexSpriteRenderer and entity.Animator then
        local complexSprite = entity.ComplexSpriteRenderer
        local AnimatorCurrentState =  entity.Animator.states[entity.Animator.currentState]

        complexSprite.index = AnimatorCurrentState.spritesheet
        complexSprite.speed = AnimatorCurrentState.speed
        
        log.info("New entity")
    end

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