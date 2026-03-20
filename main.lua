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
local Transition = require("modules.engine.transition")

GameCtx = CTX.MENU

GameState = {}
GameState[CTX.MENU] = GAMESTATE[CTX.MENU]
GameState[CTX.BATTLE] = GAMESTATE[CTX.BATTLE]
GameState[CTX.SHOP] = GAMESTATE[CTX.SHOP]
GameState[CTX.DEATH_SCREEN] = GAMESTATE[CTX.DEATH_SCREEN]
GameState[CTX.VICTORY_SCREEN] = GAMESTATE[CTX.VICTORY_SCREEN]

MainTransition = Transition.new(0.5, Transition.FADEINOUT)

-- Função auxiliar para trocar de contexto e carregar o novo estado
function SetGameCtx(newCtx)
	local sounds = GameState[GameCtx].sounds
	if sounds then
		for _, sound in pairs(sounds) do
			sound:stop()
		end
	end

	MainTransition:start(function()
		GameCtx = newCtx
		GameState[GameCtx]:load()
	end)
end

function love.load()
	love.window.setFullscreen(true)

	-- carrega o estado inicial manualmente para usar uma transição
	GameState[GameCtx]:load()
end

function love.update(dt)
	MainTransition:update(dt)

	-- do not update the scene while transition is running
	if MainTransition.isActive then
		return
	end
	
	GameState[GameCtx]:update(dt)
end

function love.draw()
	GameState[GameCtx]:draw()
	MainTransition:draw()
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end

	if key == "s" then
		SetGameCtx(CTX.SHOP)
	end

	GameState[GameCtx]:keypressed(key, scancode, isrepeat)
end
