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

local Transition = require("modules.engine.transition")
MainTransition = Transition.new(0.5, Transition.FADEINOUT)

-- Função auxiliar para trocar de contexto e carregar o novo estado
function SetGameCtx(newCtx)
	local sounds = GAMESTATE[GameCtx].sounds
	if sounds then
		for _, sound in pairs(sounds) do
			sound:stop()
		end
	end

	MainTransition:start(function()
		GameCtx = newCtx
		GAMESTATE[GameCtx]:load()
	end)
end

function love.load()
	love.window.setFullscreen(true)

	-- carrega o estado inicial manualmente para usar uma transição
	GAMESTATE[GameCtx]:load()
end

function love.update(dt)
	MainTransition:update(dt)
	-- do not update the scene while transition is running
	if MainTransition.isActive then
		return
	end
	GAMESTATE[GameCtx]:update(dt)
end

function love.draw()
	GAMESTATE[GameCtx]:draw()
	MainTransition:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	GAMESTATE[GameCtx]:keypressed(key, scancode, isrepeat)
end
