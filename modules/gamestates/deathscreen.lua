local FinalScreen = require("modules.finalscreen")

local DeathState = {}
DeathState.__index = DeathState

DeathState.sprites = {}
DeathState.texts = {
	title = "Game Over...",
	prompt = "Press Enter or Space to Play Again",
}

DeathState.screen = nil

function DeathState:load()
	self.screen = FinalScreen:new(self.texts.title, self.texts.prompt)
end

function DeathState:update(dt)
	self.screen:update(dt)
end

function DeathState:draw()
	self.screen:draw()
end

function DeathState:keypressed(key, scancode, isrepeat)
	self.screen:keypressed(key, scancode, isrepeat)
end

return DeathState
