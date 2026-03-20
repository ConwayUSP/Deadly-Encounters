----------------------------------------
-- Importações de Módulos
----------------------------------------
math.randomseed(os.time()) -- precisa ficar aqui no topo pra randomizar os oponentes
require("modules.actions")
require("modules.gamectx")
require("modules.gamestate")
require("modules.oponent")
require("modules.finalscreen")

Player = require("modules.player")

GameCtx = CTX.MENU

-- Função auxiliar para trocar de contexto e carregar o novo estado
-- TODO: inserir transição
function SetGameCtx(newCtx)
	GameCtx = newCtx
	GAMESTATE[GameCtx]:load()
end

function love.load()
	love.window.setFullscreen(true)

	-- carrega o estado inicial
	SetGameCtx(GameCtx)
end

function love.update(dt)
	GAMESTATE[GameCtx]:update(dt)
end

function love.draw()
	GAMESTATE[GameCtx]:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if key == "s" then
		SetGameCtx(CTX.SHOP)
	end

	GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
end
