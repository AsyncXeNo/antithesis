local concord = require "libs.Concord";
local push = require "libs.push";
local log = require "libs.log";

require "modules.game.basics"
require "modules.game.graphics"
require "modules.game.physics"
require "modules.game.controller"
require "modules.game.ui"
require "modules.game.levels"

local spriteSheet = require "res.spritesheets"
local anims = require "res.anims"

GameState = {
    game = concord.world(),
    main_menu = concord.world(),
    pause_menu = concord.world(),
    game_over = concord.world()
}

CurrentGameState = "game"

function love.load()

    love.mouse.setVisible(false)
    local gameWidth, gameHeight = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(gameWidth, gameHeight)
    push:setupScreen(1024, 576, 1920, 1080, {upscale = "normal"})

    log.info("Started")
    GameState.game:addSystem(HUDSystem):addSystem(RenderSystem):addSystem(InputSystem):addSystem(MovementSystem):addSystem(CollisionSystem):addSystem(MessageBoxSystem):addSystem(TimelineSystem):addSystem(StatsSystem)

    local player = concord.entity(GameState.game)
        :give("Information", "Player")
        :give("Position", 300, 300)
        :give("ComplexSpriteRenderer", "monster", 1)
        :give("Animator", anims.player.states, anims.player.transitions, anims.player.variables)
        :give("Movable", {x=0, y=0}, {x=1200, y=1200}, {x = 0, y = 0}, {x=50000, y=50000})
        :give("Controllable", 100)
        :give("Collider", "BOX", {width=32, height=32}, {x=0, y=0})
        :give("Stats", 10, 100, 10, 1, 0, 0)
        :give("Player")

    local obj = concord.entity(GameState.game)
        :give("Position", 1024, 0)
        :give ("CircleRenderer", 10, {0,0,1,1} )
        :give ("Stats", 10, 100, 10, 1, 0, 0)
        :give("Timeline", {
            {
                type = "move",
                args = {
                    pos = {
                        x = 500,
                        y = 300
                    },
                    duration = 5,
                    func = math.easingFunctions.easeInOutQuint
                }
            },
            {
                type = "shoot",
                args = {
                    type = "burst",
                    bullet_type = "simple",
                    start_angle = 30,
                    end_angle = 60,
                    lines = 3,
                    speed = 100,
                    start_radius = 20,
                    duration = 2,
                    interval = 0.2,
                    radius = 5,
                    color = Color.fromRGB(255, 0, 0, 255),
                    mode = "fill"
                },
            },
            {
                type = "move",
                args = {
                    pos = {
                        x = 1024,
                        y = 576
                    },
                    duration = 2,
                    func = math.easingFunctions.easeInOutQuint
                }
            }
        })
        :give("Collider", "CIRCLE", {r=10})

    GameState[CurrentGameState]:emit("init", GameState[CurrentGameState])

end


function GameState.game:onEntityAdded(entity)

    if entity.ComplexSpriteRenderer and entity.Animator then
        local complexSprite = entity.ComplexSpriteRenderer
        local AnimatorCurrentState =  entity.Animator.states[entity.Animator.currentState]

        complexSprite.index = AnimatorCurrentState.spritesheet
        complexSprite.speed = AnimatorCurrentState.speed

        local sprite = spriteSheet[complexSprite.index]

        complexSprite.spritesheet = love.graphics.newImage(SPRITES_PATH .. sprite.path)
        local no_col = complexSprite.spritesheet:getWidth() / sprite.size.x
        for i=1, sprite.frames, 1 do
            complexSprite.quads[i] = love.graphics.newQuad(
                ((i-1) % no_col) * sprite.size.x + (math.max((i-2),0) % no_col) * sprite.padding.x,
                math.floor((i-1) / no_col) * sprite.size.y + math.floor(math.max((i-2),0) / no_col) * sprite.padding.y,
                sprite.size.x,
                sprite.size.y,
                complexSprite.spritesheet:getWidth(),
                complexSprite.spritesheet:getHeight()
            )
        end
    end

    if entity.Stats then
        entity.Stats.current = {
            damage = entity.Stats.base.damage,
            hp = entity.Stats.base.maxHp,
            armor = entity.Stats.base.armor,
            armor_pen = entity.Stats.base.armor_pen,
            maxShield = entity.Stats.base.maxShield,
            shield = entity.Stats.base.maxShield,
            regen = entity.Stats.base.regen
        }
    end

end


function love.update(dt)

    GameState[CurrentGameState]:emit("update", dt)

end


function love.keypressed(key, scancode, isrepeat)

    if key == 'escape' then
        love.event.quit()
    end

end


function love.draw()

    push:start()
    GameState[CurrentGameState]:emit("draw")
    push:finish()

end