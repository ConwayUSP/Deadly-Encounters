----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
local Player = require("modules.player")

----------------------------------------
-- Entidade ShopState
----------------------------------------

local ShopState = {}
ShopState.__index = ShopState

-- todos os itens disponíves à venda
ShopState.allItems = {
	initShield(),
	initDefibrillator(),
	initReverseCard(),
	initTotem(),
	initStopWatch(),
	initEnergyDrink(),
	initFlashbang(),
	initPotion()
}
ShopState.sprites = {}
ShopState.texts = {}
ShopState.itemsForSale = {}

-- reinicia a loja, limpando os itens à venda e sorteando novos
function ShopState:reset()
	self.itemsForSale = {}
	self:randomizeItems()
end

-- randomiza os itens que estarão à venda na loja
function ShopState:randomizeItems()
	local pickedIndexes = {}
	local ITEMS_FOR_SALE = 3
	while #pickedIndexes < ITEMS_FOR_SALE do
		local index = math.random(1, #self.allItems)
		if not pickedIndexes[index] then
			pickedIndexes[index] = true
			table.insert(self.itemsForSale, self.allItems[index])
		end
	end
end

-- faz o player comprar um item, adicionando ele ao inventário e removendo da loja
function ShopState:buyItem(item)
	for i, it in ipairs(self.itemsForSale) do
		if it == item then
			Player:getBuff(it)
			table.remove(self.itemsForSale, i)
			break
		end
	end
end

return ShopState
