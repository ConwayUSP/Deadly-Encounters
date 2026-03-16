----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.actions")
require("modules.gamectx")
require("modules.gamestate")
require("modules.oponent")
local player = require("modules.player")

GameCtx = CTX.MENU
GameState = GAMESTATE.MENU

function love.load()
	love.window.setMode(1920, 1080)
end

function love.update(dt)
	-- !TODO: tudo
end

function love.draw()
	love.graphics.clear(0.1, 0.1, 0.15)
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
