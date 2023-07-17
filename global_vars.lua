local concord = require("libs.Concord")

GameState = {
    game = concord.world(),
    main_menu = concord.world(),
    pause_menu = concord.world(),
    game_over = concord.world()
}

CurrentGameState = "game"