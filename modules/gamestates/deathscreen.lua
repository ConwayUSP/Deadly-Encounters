local DeathState = {}
DeathState.__index = MenuState

-- TODO: preencher o estado
DeathState.sprites = {}
DeathState.texts = {
	title = "Game Over...",
	prompt = "Press Enter or Space to Play Again"
}

return DeathState
