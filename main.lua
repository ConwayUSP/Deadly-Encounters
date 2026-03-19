----------------------------------------
-- Importações de Módulos
----------------------------------------
math.randomseed(os.time()) -- precisa ficar aqui no topo pra randomizar os oponentes
require("modules.actions")
require("modules.gamectx")
require("modules.gamestate")
require("modules.oponent")
require("modules.finalscreen")

local Player = require("modules.player")

GameCtx = CTX.MENU

GameState = {}
GameState[CTX.MENU] = GAMESTATE[CTX.MENU]
GameState[CTX.BATTLE] = GAMESTATE[CTX.BATTLE]
GameState[CTX.SHOP] = GAMESTATE[CTX.SHOP]
GameState[CTX.DEATH_SCREEN] = GAMESTATE[CTX.DEATH_SCREEN]
GameState[CTX.VICTORY_SCREEN] = GAMESTATE[CTX.VICTORY_SCREEN]

-- Função auxiliar para trocar de contexto e carregar o novo estado
-- TODO: inserir transição
function SetGameCtx(newCtx)
	GameCtx = newCtx
	GameState[GameCtx]:load()
end

function love.load()
	love.window.setFullscreen(true)

	-- carrega o estado inicial
	SetGameCtx(GameCtx)
end

function love.update(dt)
	GameState[GameCtx]:update(dt)
end

function love.draw()
	GameState[GameCtx]:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	GameState[GameCtx]:keypressed(key, scancode, isrepeat)
end
