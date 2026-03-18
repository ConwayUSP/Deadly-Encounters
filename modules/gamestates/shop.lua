----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.constructors.buffs")
require("modules.utils")
require("modules.fs")
local Player = require("modules.player")

----------------------------------------
-- Constantes
----------------------------------------

local ITEMS_FOR_SALE = 3
local DESCRIPTION_WIDTH = 300
local DESCRIPTION_GAP = 10
local DESCRIPTIONS_TOTAL_WIDTH = DESCRIPTION_WIDTH * ITEMS_FOR_SALE + DESCRIPTION_GAP * (ITEMS_FOR_SALE - 1)
local DESCRIPTION_START_X = (love.graphics.getWidth() - DESCRIPTIONS_TOTAL_WIDTH) / 2

----------------------------------------
-- Entidade DescriptionCard
----------------------------------------

local DescriptionCard = {}
DescriptionCard.__index = DescriptionCard

function DescriptionCard.new(item, pos)
	local card = setmetatable({}, DescriptionCard)
	local x, y = pos.x, pos.y

	local function updateFunc(text, _, descCard)
		local color = text.color or { 0, 0, 0, 1 }
		color[4] = descCard.alpha
		text.color = color
	end

	card.item = item
	card.type = item.type
	card.title = Text.new(capitalize(item.id), 36, { 0, 0, 0, 1 }, { x, y }, nil, false, math.huge, updateFunc)
	card.description = Text.new(
		item.description,
		18,
		{ 0, 0, 0, 1 },
		{ x, y + 30 },
		nil,
		false,
		math.huge,
		updateFunc,
		DESCRIPTION_WIDTH
	)

	-- configura label e cores da badge como Text também
	local badgeLabel
	local badgeBgColor
	local badgeBorderColor
	if card.type == BUFF_TYPE.UPGRADE then
		badgeLabel = "Upgrade"
		badgeBgColor = { 0.80, 0.90, 1.00 }
		badgeBorderColor = { 0.30, 0.45, 0.70 }
	elseif card.type == BUFF_TYPE.ITEM then
		badgeLabel = "Item"
		badgeBgColor = { 0.85, 1.00, 0.85 }
		badgeBorderColor = { 0.30, 0.60, 0.30 }
	end
	card.badgeBgColor = badgeBgColor
	card.badgeBorderColor = badgeBorderColor
	card.badgeText = Text.new(badgeLabel, 18, { 0.10, 0.08, 0.05, 1 }, { 0, 0 }, nil, false, math.huge, updateFunc)

	card.position = pos or { x = 0, y = 0 }
	card.alpha = 0
	card.fadeDuration = 0.3
	return card
end

function DescriptionCard:update(dt, isSelected)
	if isSelected then
		if self.alpha < 1 then
			self.alpha = math.min(1, self.alpha + dt / self.fadeDuration)
		end
	else
		self.alpha = 0
	end

	self.title:update(dt, self)
	self.description:update(dt, self)
	if self.badgeText then
		self.badgeText:update(dt, self)
	end
end

function DescriptionCard:draw()
	if self.alpha <= 0 then
		return
	end
	-- fundo card
	love.graphics.setColor(0.55, 0.40, 0.25, self.alpha)
	love.graphics.rectangle("fill", self.position.x - 10, self.position.y - 10, DESCRIPTION_WIDTH + 20, 200, 12, 12, 16)

	-- borda do card
	love.graphics.setColor(0.30, 0.20, 0.10, self.alpha)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", self.position.x - 10, self.position.y - 10, DESCRIPTION_WIDTH + 20, 200, 12, 12, 16)

	-- badge para TIPO (upgrade/item)
	local badgeText = self.badgeText
	local label = badgeText.content or ""
	local bgColor = self.badgeBgColor or { 1, 1, 1 }
	local borderColor = self.badgeBorderColor or { 0, 0, 0 }
	local badgeX = self.position.x - 6
	local badgeY = self.position.y - 46
	local font = badgeText.font or love.graphics.getFont()
	local textWidth = font:getWidth(label)
	local horizontalPadding = 16
	local badgeW = textWidth + horizontalPadding
	local badgeH = 28

	-- fundo badge
	love.graphics.setColor(bgColor[1], bgColor[2], bgColor[3], self.alpha)
	love.graphics.rectangle("fill", badgeX, badgeY, badgeW, badgeH, 8, 8, 8)

	-- borda badge
	love.graphics.setColor(borderColor[1], borderColor[2], borderColor[3], self.alpha)
	love.graphics.setLineWidth(1.5)
	love.graphics.rectangle("line", badgeX, badgeY, badgeW, badgeH, 8, 8, 8)

	badgeText.pos = { badgeX + 8, badgeY + 6 }
	badgeText:draw()

	self.title:draw(self.position.x, self.position.y)
	self.description:draw(self.position.x, self.position.y)
end

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
ShopState.descriptionCards = {}
ShopState.font = nil

function ShopState:load()
	self:reset()

	self.font = returnFont(24)
end

-- reinicia a loja, limpando os itens à venda e sorteando novos
function ShopState:reset()
	self.itemsForSale = {}
	self.descriptionCards = {}
	self.selectedItemIndex = -1
	self:randomizeItems()
end

-- randomiza os itens que estarão à venda na loja
function ShopState:randomizeItems()
	local pickedIndexes = {}
	local pickedCount = 0
	while pickedCount < ITEMS_FOR_SALE do
		local index = math.random(1, #self.allItems)
		if not pickedIndexes[index] then
			pickedIndexes[index] = true
			pickedCount = pickedCount + 1

			local x = DESCRIPTION_START_X + pickedCount * (DESCRIPTION_WIDTH + DESCRIPTION_GAP)
			local y = 300

			local desc = DescriptionCard.new(self.allItems[index], { x = x, y = y })

			table.insert(self.itemsForSale, self.allItems[index])
			table.insert(self.descriptionCards, desc)
		end
	end
end

-- faz o player comprar um item, adicionando ele ao inventário e removendo da loja
function ShopState:buyItem(item)
	for i, it in ipairs(self.itemsForSale) do
		if it == item then
			Player:getBuff(it)
			table.remove(self.itemsForSale, i)
			table.remove(self.descriptionCards, i)
			break
		end
	end
end

function ShopState:update(dt)
	for i, card in ipairs(self.descriptionCards) do
		card:update(dt, i == self.selectedItemIndex)
	end
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
		end

		SetGameCtx(CTX.BATTLE)
	end
end

-- seleciona um dos itens dispoíveis para compra
function ShopState:selectItem(index)
	if index == self.selectedItemIndex then
		self.selectedItemIndex = -1
		return
	end
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

	for i, card in ipairs(self.descriptionCards) do
		if i == self.selectedItemIndex then
			card:draw()
		end
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1)
end

return ShopState
