----------------------------------------
-- Importações de módulos
----------------------------------------
require("modules.oponent")
require("modules.history")
require("modules.combat")
require("modules.actions")
require("modules.fs")

----------------------------------------
-- Entidade ItemsSlot
----------------------------------------

ItemSlot = {}
ItemSlot.__index = ItemSlot

function ItemSlot.new(items, scale, pos)
	local slot = setmetatable({}, ItemSlot)
	slot.items = items
	slot.scale = scale
	slot.pos = pos

	slot.socket = love.graphics.newImage("assets/UI/combat/consumables_socket.png")

	return slot
end

function ItemSlot:draw()
	love.graphics.setColor(1, 1, 1, 1)

	local socketW = self.socket:getWidth() * self.scale
	local socketH = self.socket:getHeight() * self.scale

	love.graphics.draw(self.socket, self.pos[1] - socketW / 2, self.pos[2] - socketH / 2, 0, self.scale, self.scale)

	local itemScale = 0.25
	if self.items[1] then
		local item = self.items[1]
		local itemSprite = item.sprite
		local itemW = itemSprite:getWidth() * itemScale
		local itemH = itemSprite:getHeight() * itemScale
		love.graphics.draw(
			itemSprite,
			self.pos[1] + socketW / 4 - itemW / 2 - 8,
			self.pos[2] - itemH / 2,
			0,
			itemScale,
			itemScale
		)
	end

	if self.items[2] then
		local item = self.items[2]
		local itemSprite = item.sprite
		local itemW = itemSprite:getWidth() * itemScale
		local itemH = itemSprite:getHeight() * itemScale
		love.graphics.draw(
			itemSprite,
			self.pos[1] - socketW / 4 - itemW / 2 + 4,
			self.pos[2] - itemH / 2 - socketH / 4 + 8,
			0,
			itemScale,
			itemScale
		)
	end

	if self.items[3] then
		local item = self.items[3]
		local itemSprite = item.sprite
		local itemW = itemSprite:getWidth() * itemScale
		local itemH = itemSprite:getHeight() * itemScale
		love.graphics.draw(
			itemSprite,
			self.pos[1] - socketW / 4 - itemW / 2 + 4,
			self.pos[2] - itemH / 2 + socketH / 4,
			0,
			itemScale,
			itemScale
		)
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

----------------------------------------
-- Entidade ActionSlot
----------------------------------------

ActionSlot = {}
ActionSlot.__index = ActionSlot

function ActionSlot.new(action, pos, scale)
	local slot = setmetatable({}, ActionSlot)
	slot.action = action
	slot.originalPos = pos
	slot.pos = { pos[1], pos[2] }
	slot.moving = false
	slot.active = false
	slot.scale = scale

	slot.socket = love.graphics.newImage("assets/UI/combat/action_socket.png")
	slot.actionSprite = love.graphics.newImage("assets/UI/combat/" .. action .. ".png")

	return slot
end

function ActionSlot:draw()
	love.graphics.setColor(1, 1, 1, 1)

	if self.active then
		love.graphics.setShader(brightnessShader)
	end

	local socketW = self.socket:getWidth() * self.scale
	local socketH = self.socket:getHeight() * self.scale

	local actionW = self.actionSprite:getWidth() * self.scale
	local actionH = self.actionSprite:getHeight() * self.scale

	love.graphics.draw(self.socket, self.pos[1] - socketW / 2, self.pos[2] - socketH / 2, 0, self.scale, self.scale)
	love.graphics.draw(
		self.actionSprite,
		self.pos[1] - actionW / 2,
		self.pos[2] - actionH / 2,
		0,
		self.scale,
		self.scale
	)

	if self.active then
		love.graphics.setShader()
	end
end

----------------------------------------
-- Entidade HealthBar
----------------------------------------

HealthBar = {}
HealthBar.__index = HealthBar

function HealthBar.new(creature, pos, who)
	local healthBar = setmetatable({}, HealthBar)
	healthBar.creature = creature
	healthBar.pos = pos
	healthBar.scale = 0.72

	healthBar.empty = love.graphics.newImage("assets/UI/combat/empty_healthbar.png")
	healthBar.full = love.graphics.newImage("assets/UI/combat/" .. who .. "_healthbar.png")

	return healthBar
end

function HealthBar:draw()
	love.graphics.setColor(1, 1, 1, 1)

	local emptyW = self.empty:getWidth() * self.scale

	-- background
	love.graphics.draw(self.empty, self.pos[1] - emptyW / 2, self.pos[2], 0, self.scale, self.scale)

	-- foreground (vida)
	local hpRatio = self.creature.hp / self.creature.maxHp
	local barWidth = emptyW * hpRatio
	local offset = 0

	love.graphics.setScissor(
		self.pos[1] - emptyW / 2 + offset,
		self.pos[2],
		barWidth,
		self.full:getHeight() * self.scale
	)
	love.graphics.draw(self.full, self.pos[1] - emptyW / 2, self.pos[2], 0, self.scale, self.scale)
	love.graphics.setScissor()

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

----------------------------------------
-- Entidade UpgradesOwned
----------------------------------------

UpgradesOwned = {}
UpgradesOwned.__index = UpgradesOwned

function UpgradesOwned.new(initialUpgrades, initialPos, direction)
	local upgradesOwned = setmetatable({}, UpgradesOwned)

	upgradesOwned.upgrades = initialUpgrades or {}
	upgradesOwned.pos = initialPos
	upgradesOwned.direction = direction
	upgradesOwned.scale = 0.25

	return upgradesOwned
end

function UpgradesOwned:draw()
	local x, y = self.pos[1], self.pos[2]
	local spacing = 0
	local size = self.upgrades[1] and self.upgrades[1].sprite:getWidth() * self.scale or 0
	for i, upgrade in ipairs(self.upgrades) do
		x = x + self.direction * (size + spacing) * (i - 1)
		love.graphics.draw(upgrade.sprite, x, y, 0, self.scale, self.scale)
	end
end

----------------------------------------
-- Estado do jogo no contexto de batalha
----------------------------------------

local BattleState = {}
BattleState.__index = BattleState

-- TODO: preencher o estado
BattleState.sprites = {}
BattleState.texts = {}
BattleState.sounds = {}
BattleState.upgradesOwned = {}
BattleState.healthBar = {}
BattleState.actionSlots = {}
BattleState.itemSlots = nil
BattleState.oponentPool = generateOponentPool()
BattleState.battleNum = 1
BattleState.oponent = BattleState.oponentPool[BattleState.battleNum]
BattleState.decisionTime = 3
BattleState.timer = BattleState.decisionTime * 2
BattleState.turn = 1
BattleState.hist = History.new()

-- para caso o jogo recomece
function BattleState:restartGame()
	self.oponentPool = generateOponentPool()
	self.battleNum = 1
	self.oponent = self.oponentPool[self.battleNum]
	self:reset()
	Player:reset()
end

function BattleState:reset()
	self.texts = {}
	self.decisionTime = 3
	self.timer = self.decisionTime * 2
	self.turn = 1
	self.hist = History.new()
end

-- passa para o próximo oponente e reseta uns atributos
function BattleState:nextBattle()
	self.battleNum = self.battleNum + 1
	self.oponent = self.oponentPool[self.battleNum]
	self.texts = {}
	self.timer = 0
	self.turn = 1
	self.hist = History.new()
	if self.battleNum <= 2 then
		self.decisionTime = 5
	elseif self.battleNum <= 4 then
		self.decisionTime = 4
	else
		self.decisionTime = 3
	end

	Player:resetForBattle()
end

-- simula um confronto entre o player e o oponente, atualizando o historico do combate
function BattleState:simulateBattle()
	local turnResult = simulateTurn(Player, self.oponent, self.hist)
	self.hist:addSnapshot(Player)

	if turnResult == Combat.ONGOING then
		return
	end

	if turnResult == Combat.WIN and BattleState.battleNum == 6 then
		-- ganhar a sexta batalha == vitória
		SetGameCtx(CTX.VICTORY_SCREEN)
	elseif turnResult == Combat.LOSS then
		SetGameCtx(CTX.DEATH_SCREEN)
	elseif turnResult == Combat.WIN then
		SetGameCtx(CTX.SHOP)
	end
end

function BattleState:newCounterText(txt)
	local width, height = love.graphics.getDimensions()
	return Text.new(txt, 64, { 0.15, 0.10, 0.08, 1 }, { width / 2, height * 2 / 5 }, 0, 0, 1, function(text, dt)
		text.scale = text.scale and text.scale + 3 * dt or 1
	end)
end

function BattleState:load()
	self:reset()

	local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()

	local background = love.graphics.newImage("assets/UI/combat/combat_bg.png")
	-- local background = love.graphics.newImage("assets/UI/combat/reference.jpg")
	self.sprites.bg = background

	-- coisa
	self.sprites.coisa = love.graphics.newImage("assets/UI/combat/coisa.png")
	local coisaW = self.sprites.coisa:getWidth()
	local coisaScale = 0.65

	-- textos
	local xOffset = 50
	local yOffset = 135
	self.texts.playerName = Text.new(string.upper(Player.name), 32, { 0, 0, 0, 1 }, { xOffset, yOffset })
	self.texts.oponentName = Text.new(
		string.upper(self.oponent.name),
		32,
		{ 0, 0, 0, 1 },
		{ love.graphics.getWidth() - xOffset, yOffset }
	)

	local textWidth = self.texts.oponentName:getDimensions()
	self.texts.oponentName.pos[1] = self.texts.oponentName.pos[1] - textWidth

	-- sounds
	self.sounds.counter3 = love.audio.newSource("sounds/counter_3.mp3", "static")
	self.sounds.counter2 = love.audio.newSource("sounds/counter_2.mp3", "static")
	self.sounds.counter1 = love.audio.newSource("sounds/counter_1.mp3", "static")
	self.sounds.counterShoot = love.audio.newSource("sounds/counter_shoot.mp3", "static")

	-- debug buffs
	-- Player:getBuff(initShield())
	-- Player:getBuff(initStopWatch())
	-- Player:getBuff(initEnergyDrink())
	-- Player:getBuff(initPotion())
	-- Player:getBuff(initFlashbang())
	-- self.oponent.inventory.upgrades = { initShield(), initTotem() }

	-- upgrades owned
	xOffset = 140
	local playerUpgradesOwned = UpgradesOwned.new(Player.inventory.upgrades, { xOffset, yOffset }, 1)
	local oponentUpgradesOwned = UpgradesOwned.new(
		self.oponent.inventory.upgrades,
		{ love.graphics.getWidth() - xOffset - textWidth + 20, yOffset },
		-1
	)
	self.upgradesOwned.player = playerUpgradesOwned
	self.upgradesOwned.oponent = oponentUpgradesOwned

	-- health bars
	xOffset = 40
	local centerFirstPart = (screenW - coisaW * coisaScale * 0.5) / 4
	local centerSecondPart = screenW - centerFirstPart
	local healthBarYOffset = 80
	local healthBarPlayer = HealthBar.new(Player, { centerFirstPart, healthBarYOffset }, "your")
	local healthBarOponent = HealthBar.new(self.oponent, { centerSecondPart, healthBarYOffset }, "enemy")
	self.healthBar.player = healthBarPlayer
	self.healthBar.oponent = healthBarOponent

	-- items slots
	local itemSlot = love.graphics.newImage("assets/UI/combat/consumables_socket.png")
	local itemScale = 0.7
	local itemSlotW = itemSlot:getWidth() * itemScale
	self.itemSlots = ItemSlot.new(Player.inventory.items, itemScale, { 0, screenH - 100 })

	-- action slots
	local actionSlotYOffset = 100
	local actionSlotSpacing = 15
	local socketImg = love.graphics.newImage("assets/UI/combat/action_socket.png")
	local slotScale = 0.7
	local slotWidth = socketImg:getWidth() * slotScale
	local gap = actionSlotSpacing
	local totalWidth = 5 * slotWidth + 4 * gap
	local regionWidth = screenW / 2
	local rowLeft = screenW / 4 + (regionWidth - totalWidth) / 2 - itemSlotW
	self.itemSlots.pos[1] = rowLeft + totalWidth + slotWidth + gap + 20

	for i = 1, 5 do
		local idx = i - 1
		local rightEdgeX = rowLeft + slotWidth + idx * (slotWidth + gap)
		self.actionSlots[i] = ActionSlot.new(ACTION_IDX[i], { rightEdgeX, screenH - actionSlotYOffset }, slotScale)
	end
end

function BattleState:update(dt)
	local pt = self.timer
	self.timer = pt - dt
	if self.timer <= 0 then
		self.texts.counterShoot = self:newCounterText("SHOOT!")
		self.sounds.counterShoot:play()
		self.turn = self.turn + 1

		self:simulateBattle()
		self.timer = self.decisionTime + 2
		-- self.texts = {}
	end
	if pt > 3 and self.timer < 3 then
		self.texts.counter3 = self:newCounterText("3")
		self.sounds.counter3:play()
	end
	if pt > 2 and self.timer < 2 then
		self.texts.counter2 = self:newCounterText("2")
		self.sounds.counter2:play()
	end
	if pt > 1 and self.timer < 1 then
		self.texts.counter1 = self:newCounterText("1")
		self.sounds.counter1:play()
	end

	for _, text in pairs(self.texts) do
		if text.update then
			text:update(dt)
		end
	end
	cleanUpTexts(self.texts)
end

function BattleState:draw()
	local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()

	-- background
	local bg = self.sprites.bg
	local bgW, bgH = bg:getWidth(), bg:getHeight()
	local scale = math.max(screenW / bgW, screenH / bgH)
	local drawX = (screenW - bgW * scale) / 2
	local drawY = (screenH - bgH * scale) / 2
	love.graphics.draw(bg, drawX, drawY, 0, scale, scale)

	-- coisa
	local coisa = self.sprites.coisa
	local coisaW = coisa:getWidth()
	local coisaScale = 0.65
	local coisaX = screenW / 2 - (coisaW * coisaScale) / 2
	local coisaY = 55
	love.graphics.draw(coisa, coisaX, coisaY, 0, coisaScale, coisaScale)

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)

	-- player
	local width, height = love.graphics.getDimensions()
	local playerPos = { 2.5 * width / 12, height / 2 }
	Player:draw(playerPos)

	-- oponent
	local oponentPos = { 9.5 * width / 12, height / 2 }
	self.oponent:draw(oponentPos)

	-- upgrades
	self.upgradesOwned.player:draw()
	self.upgradesOwned.oponent:draw()

	-- health bars
	self.healthBar.player:draw()
	self.healthBar.oponent:draw()

	-- action slots
	for _, slot in pairs(self.actionSlots) do
		slot:draw()
	end

	-- item slots
	self.itemSlots:draw()

	for _, text in pairs(self.texts) do
		text:draw()
	end

	love.graphics.setColor(1, 1, 1, 1)
end

-- Detecta o input do usuário
function BattleState:keypressed(key, scancode, isrepeat)
	-- TODO: remover isso
	if key == "return" or key == "space" then
		SetGameCtx(CTX.VICTORY_SCREEN)
	elseif key == "s" then
		SetGameCtx(CTX.SHOP)
	end

	local num = tonumber(key)
	if num and num > 0 and num < 6 then
		self:setAction(num)
	end
end

function BattleState:setAction(num)
	if Player.action ~= ACTION_IDX[num] then
		Player.action = ACTION_IDX[num]
	else
		Player.action = ACTION.NONE
	end

	for i, slot in pairs(self.actionSlots) do
		if i == num then
			slot.active = not slot.active
		else
			slot.active = false
		end
	end
end

return BattleState
