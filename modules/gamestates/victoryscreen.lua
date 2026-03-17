local FinalScreen = require("modules.finalscreen")

local VictoryState = {}
VictoryState.__index = VictoryState

VictoryState.sprites = {}
VictoryState.texts = {
	title = "Victory!",
	prompt = "Press Enter or Space to Play Again"
}

VictoryState.screen = nil

function VictoryState:load()
	self.screen = FinalScreen:new(self.texts.title, self.texts.prompt)
end

function VictoryState:update(dt)
	self.screen:update(dt)
end

function VictoryState:draw()
	self.screen:draw()
end

function VictoryState:keypressed(key, scancode, isrepeat)
	self.screen:keypressed(key, scancode, isrepeat)
end

return VictoryState
