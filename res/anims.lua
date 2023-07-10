local utils = require("utils")

return {
    ["player"] = {
        ["states"] = States.table({
            ["idle"] = { 
                ["spritesheet"] = "player_idle",
                ["speed"] = 3
            },
            ["left"] = {
                ["spritesheet"] = "player_left",
                ["speed"] = 3
            },
            ["right"] = {
                ["spritesheet"] = "player_right",
                ["speed"] = 3
            }
        }, "idle"),
        ["transitions"] = {
            {
                ["from"] = "idle",
                ["to"] = "left",
                ["condition"] = {
                    "velx < 0"
                }
            },
            {
                ["from"] = "idle",
                ["to"] = "right",
                ["condition"] = {
                    "velx > 0"
                }
            },
            {
                ["from"] = "left",
                ["to"] = "idle",
                ["condition"] = {
                    "velx == 0"
                }
            },
            {
                ["from"] = "right",
                ["to"] = "idle",
                ["condition"] = {
                    "velx == 0"
                }
            },
            {
                ["from"] = "left",
                ["to"] = "right",
                ["condition"] = {
                    "velx > 0"
                }
            },
            {
                ["from"] = "right",
                ["to"] = "left",
                ["condition"] = {
                    "velx < 0"
                }
            },
        },
        ["variables"] = {
            ["velx"] = {
                "Movable",
                "vel",
                "x"
            }
        }
    }
}