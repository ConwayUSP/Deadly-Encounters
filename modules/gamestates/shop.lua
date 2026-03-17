----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.constructors.buffs")
require("modules.utils")
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
	initPotion(),
}
ShopState.sprites = {}
ShopState.texts = {}
ShopState.itemsForSale = {}
ShopState.selectedItemIndex = 1
ShopState.font = nil

function ShopState:load()
	self:reset()

	self.font = returnFont(24)
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
	local pickedCount = 0
	while pickedCount < ITEMS_FOR_SALE do
		local index = math.random(1, #self.allItems)
		if not pickedIndexes[index] then
			pickedIndexes[index] = true
			pickedCount = pickedCount + 1
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

function ShopState:update(dt)
	-- TODO: botar coisa aqui
end

function ShopState:keypressed(key, scancode, isrepeat)
	if key == "1" then
		self:selectItem(1)
	elseif key == "2" then
		self:selectItem(2)
	elseif key == "3" then
		self:selectItem(3)
	end

	-- apenas para debug
	if key == "r" then
		self:reset()
	end

	if key == "return" or key == "space" then
		local selectedItem = self.itemsForSale[self.selectedItemIndex]
		if selectedItem then
			self:buyItem(selectedItem)
			SetGameCtx(CTX.BATTLE)
		end
	end
end

-- seleciona um dos itens dispoíveis para compra
function ShopState:selectItem(index)
	if index >= 1 and index <= #self.itemsForSale then
		self.selectedItemIndex = index
		print("Selected item: " .. self.itemsForSale[index].id)
	end
end

function ShopState:draw()
	-- fundo em tom bege suave
	love.graphics.clear(0.95, 0.90, 0.80)

	love.graphics.setFont(self.font)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Mercadinho", 50, 50)

	for i, item in ipairs(self.itemsForSale) do
		local y = 150 + (i - 1) * 100
		local prefix = (i == self.selectedItemIndex) and "> " or "  "
		love.graphics.print(prefix .. item.id .. " - " .. item.description, 50, y)
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1)
end

return ShopState
