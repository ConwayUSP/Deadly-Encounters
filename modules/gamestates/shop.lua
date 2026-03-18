----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.constructors.buffs")
local resolvePath = require("modules.engine.path")
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
	initPotion(),
}
ShopState.sprites = {}
ShopState.texts = {}
ShopState.itemsForSale = {}

-- Carrega assets da loja
function ShopState:load()
    -- TODO: carregar imagem correta
    self.bg = love.graphics.newImage(resolvePath("assets/UI", "battle_bg", ".png"))
end

function ShopState:update(dt)

end

function ShopState:keypressed(key, scancode, isrepeat)
    if key == "b" then
        SetGameCtx(CTX.BATTLE)
    end
end


function ShopState:draw()
    love.graphics.clear(0.95, 0.90, 0.80)
end

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
