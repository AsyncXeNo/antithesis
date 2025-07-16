local inspect = require ("libs.inspect").inspect
return {
    ["come_go_easy"] = function(entity, sprite, fps, collider_info, stats, spawn_pos, move_duration, pos_stay, stay_duration, pos_exit, projectile_info)
        print(inspect(projectile_info))
        entity
            :give("ComplexSpriteRenderer", sprite, fps, 1)
            :give("Collider", unpack(collider_info))
            :give("Stats", unpack(stats))
            :give("Position", spawn_pos.x, spawn_pos.y)
            :give("Timeline", {
                {
                    type = "move",
                    args = {
                        pos = pos_stay,
                        duration = move_duration,
                        func = math.easingFunctions.easeInOutQuint
                    }
                },
                {
                    type = "shoot",
                    args = Table.join(projectile_info, {
                        type = "burst",
                        bullet_type = "simple",
                        duration = stay_duration
                    })
                },
                {
                    type = "move",
                    args = {
                        pos = pos_exit,
                        duration = move_duration,
                        func = math.easingFunctions.easeInOutQuint
                    }
                }
            })
    end,
}