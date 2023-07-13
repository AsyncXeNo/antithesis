SPRITES_PATH = "res/sprites/"
FONTS_PATH = "res/fonts/"
ENTRY_STATE = {}

DEF_WINDOW_WIDTH = 1920
DEF_WINDOW_HEIGHT = 1080

SHIELD_REGEN_TIME = 3

GAME_WIDTH = 1024
GAME_HEIGHT = 576

HUD = {

    start_box = {
        x = 0.04 * GAME_WIDTH,
        y = 0.05 * GAME_HEIGHT,
    },

    start_hp_box = {
        x = 0.06 * GAME_WIDTH,
        y = 0.065 * GAME_HEIGHT,
    },

    start_shield_box = {
        x = 0.06 * GAME_WIDTH,
        y = 0.11 * GAME_HEIGHT
    },

    stat_box = {
        x = 0.18 * GAME_WIDTH,
        y = 0.03 * GAME_HEIGHT
    },

    box_normal = {
        x = 0.21 * GAME_WIDTH,
        y = 0.20 * GAME_HEIGHT,
    },

    box_more = {
        x = 0.21 * GAME_WIDTH,
        y = 0.25 * GAME_HEIGHT,
    },

    color = {
        outer = {50, 50, 50, 255},
        hp_box = {50, 30, 30, 255},
        hp = {
            start_col = {135, 8, 8, 255},
            end_col = {240, 36, 36, 255},
            -- start_col = {255,255,255,255},
            -- end_col = {0,0,0,255}
        },
        shield = {
            start_col = {13, 115, 119, 255},
            end_col = {20, 255, 236, 255}
        },
    }

}