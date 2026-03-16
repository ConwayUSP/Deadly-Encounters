local ShopState = {}
ShopState.__index = MenuState

-- TODO: preencher o estado da loja
ShopState.items = {}
ShopState.sprites = {}
ShopState.texts = {}

function ShopState:randomizeItems()
	-- !TODO:
end

return ShopState
