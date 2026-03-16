----------------------------------------
-- Tabela de estados do jogo
----------------------------------------

GAMESTATE = {}
GAMESTATE.MENU = require("modules.gamestates.menu")
GAMESTATE.BATTLE = require("modules.gamestates.battle")
GAMESTATE.SHOP = require("modules.gamestates.shop")
GAMESTATE.DEATH_SCREEN = require("modules.gamestates.deathscreen")
GAMESTATE.VICTORY_SCREEN = require("modules.gamestates.victoryscreen")
