local VictoryState = {}
VictoryState.__index = VictoryState

-- TODO: preencher o estado
VictoryState.sprites = {}
VictoryState.texts = {
	title = "Victory!",
	prompt = "Press Enter or Space to Play Again"
}

return VictoryState
