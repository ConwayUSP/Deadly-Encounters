----------------------------------------
-- Importações de módulos
----------------------------------------
require("modules.oponent")
require("modules.utils")
require("modules.shaders")
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
	if self.items[3] then
		local item = self.items[3]

		if item.quantity > 0 then
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
	end

	if self.items[1] then
		local item = self.items[1]

		if item.quantity > 0 then
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
	end

	if self.items[2] then
		local item = self.items[2]

		if item.quantity > 0 then
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
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

----------------------------------------
-- Entidade ActionSlot
----------------------------------------

ActionSlot = {}
ActionSlot.__index = ActionSlot

function ActionSlot.new(action, index, scale, screenW)
	local slot = setmetatable({}, ActionSlot)
	slot.action = action
	slot.originalIndex = index
	slot.index = index
	slot.scale = scale
	slot.screen = screenW

	slot.active = false
	slot.disabled = false
	slot.isMoving = false
	slot.gap = 15

	-- sprites
	slot.socket = love.graphics.newImage("assets/UI/combat/action_socket.png")
	slot.actionSprite = love.graphics.newImage("assets/UI/combat/" .. action .. ".png")

	-- position
	local y = love.graphics.getHeight() - 100
	local slotWidth = slot.socket:getWidth() * scale
	local totalWidth = 5 * slotWidth + 4 * slot.gap
	local startX = (screenW - totalWidth) / 2
	local x = startX + (index - 1) * (slotWidth + slot.gap) + slotWidth / 2

	slot.startX = startX
	slot.originalPos = { x, y }
	slot.pos = { x, y }
	slot.targetPos = {}

	return slot
end

function ActionSlot:moveTo(newIndex)
	if newIndex < 1 or newIndex > 5 or newIndex == self.index then
		return
	end

	local slotWidth = self.socket:getWidth() * self.scale
	local newX = self.startX + (newIndex - 1) * (slotWidth + self.gap) + slotWidth / 2
	self.targetPos = { newX, self.pos[2] }
	self.isMoving = true
	self.index = newIndex
end

function ActionSlot:resetPosition()
	self.targetPos = { self.originalPos[1], self.originalPos[2] }
	self.isMoving = true
	self.index = self.originalIndex
end

function ActionSlot:getPosEnd()
	return self.pos[1] + (self.socket:getWidth() * self.scale) / 2 + self.gap
end

function ActionSlot:disable()
	self.disabled = true
end

function ActionSlot:enable()
	self.disabled = false
end

function ActionSlot:update(dt)
	if self.isMoving then
		local dx = self.targetPos[1] - self.pos[1]
		local dy = self.targetPos[2] - self.pos[2]
		if math.abs(dx) < 1 and math.abs(dy) < 1 then
			self.pos[1] = self.targetPos[1]
			self.pos[2] = self.targetPos[2]
			self.targetPos = {}
			self.isMoving = false
		else
			self.pos[1] = self.pos[1] + dx * dt * 10
			self.pos[2] = self.pos[2] + dy * dt * 10
		end
	end
end

function ActionSlot:draw()
	love.graphics.setColor(1, 1, 1, 1)

	if self.disabled then
		love.graphics.setShader(darknessShader)
	elseif self.active then
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

	if self.disabled then
		love.graphics.setShader()
	elseif self.active then
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
	healthBar.targetRatio = 1
	healthBar.currentRatio = 1

	healthBar.empty = love.graphics.newImage("assets/UI/combat/empty_healthbar.png")
	healthBar.full = love.graphics.newImage("assets/UI/combat/" .. who .. "_healthbar.png")
	healthBar.shielded = love.graphics.newImage("assets/UI/combat/shielded_healthbar.png")

	return healthBar
end

function HealthBar:update(dt)
	local hpRatio = self.creature.hp / self.creature.maxHp
	self.targetRatio = hpRatio

	local speed = 6
	self.currentRatio = self.currentRatio + (self.targetRatio - self.currentRatio) * (1 - math.exp(-speed * dt))
end

function HealthBar:draw()
	love.graphics.setColor(1, 1, 1, 1)

	local emptyW = self.empty:getWidth() * self.scale

	-- background
	love.graphics.draw(self.empty, self.pos[1] - emptyW / 2, self.pos[2], 0, self.scale, self.scale)

	if self.creature.shielded then
		-- shield
		love.graphics.draw(self.shielded, self.pos[1] - emptyW / 2, self.pos[2], 0, self.scale, self.scale)
	else
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
	end

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
-- Entidade CounterText
----------------------------------------

CounterText = {}
CounterText.__index = CounterText

function CounterText.new(pos)
	local counterText = setmetatable({}, CounterText)
	counterText.pos = pos

	counterText.counter = nil
	counterText.scale = 1
	counterText.isActive = false

	return counterText
end

function CounterText:setCounter(counter)
	self.counter = counter
	self.scale = 1
	self.isActive = true
end

function CounterText:update(dt)
	if not self.isActive then
		return
	end

	self.scale = self.scale + 2 * dt

	if self.scale > 2 then
		self.isActive = false
	end
end

function CounterText:draw()
	if not self.isActive then
		return
	end

	local width = self.counter:getWidth()
	local height = self.counter:getHeight()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(
		self.counter,
		self.pos.x - (width * self.scale) / 2,
		self.pos.y - (height * self.scale) / 2,
		0,
		self.scale,
		self.scale
	)
	love.graphics.setColor(1, 1, 1, 1)
end

----------------------------------------
-- Estado do jogo no contexto de batalha
----------------------------------------

local BattleState = {}
BattleState.__index = BattleState

BattleState.sprites = {}
BattleState.texts = {}
BattleState.sounds = {}
BattleState.upgradesOwned = {}
BattleState.healthBar = {}
BattleState.actionSlots = {}
BattleState.counter = nil
BattleState.itemSlots = nil
BattleState.oponentPool = generateOponentPool()
BattleState.battleNum = 1
BattleState.oponent = BattleState.oponentPool[BattleState.battleNum]
BattleState.decisionTime = 5
BattleState.timer = BattleState.decisionTime
BattleState.turn = 1
BattleState.hist = History.new()
BattleState.hasEnded = false
BattleState.endTimer = math.huge
BattleState.finalResult = nil
BattleState.actionsEnabled = true

-- para caso o jogo recomece
function BattleState:restartGame()
	self.oponentPool = generateOponentPool()
	self.battleNum = 1
	self.oponent = self.oponentPool[self.battleNum]
	Player:reset()
	self:reset()
end

function BattleState:reset()
	self.texts = {}
	self.decisionTime = 5
	self.timer = self.decisionTime
	self.turn = 1
	self.hist = History.new()
	self.hasEnded = false
	self.endTimer = math.huge
	self.finalResult = nil
	self.actionsEnabled = true
	self:resetUI()
end

function BattleState:resetUI()
	self.upgradesOwned = {}
	self.healthBar = {}
	self.actionSlots = {}
	self.itemSlots = nil
	self.counter = CounterText.new({ x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() * 2 / 5 })

	local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()

	-- coisa
	self.sprites.coisa = love.graphics.newImage("assets/UI/combat/coisa.png")
	local coisaW = self.sprites.coisa:getWidth()
	local coisaScale = 0.65

	-- health bars
	xOffset = 40
	local centerFirstPart = (screenW - coisaW * coisaScale * 0.5) / 4
	local centerSecondPart = screenW - centerFirstPart
	local healthBarYOffset = 80
	local healthBarPlayer = HealthBar.new(Player, { centerFirstPart, healthBarYOffset }, "your")
	local healthBarOponent = HealthBar.new(self.oponent, { centerSecondPart, healthBarYOffset }, "enemy")
	self.healthBar.player = healthBarPlayer
	self.healthBar.oponent = healthBarOponent

	-- textos
	local xOffset = centerFirstPart - self.healthBar.player.empty:getWidth() * self.healthBar.player.scale / 2
	local yOffset = 135
	self.texts.playerName = Text.new(string.upper(Player.name), 32, { 0, 0, 0, 1 }, { xOffset, yOffset })

	local textPlayerWidth = self.texts.playerName:getDimensions()
	local playerUpgradesOwned =
		UpgradesOwned.new(Player.inventory.upgrades, { xOffset + textPlayerWidth + 20, yOffset }, 1)

	xOffset = centerSecondPart + self.healthBar.oponent.empty:getWidth() * self.healthBar.oponent.scale / 2
	self.texts.oponentName = Text.new(string.upper(self.oponent.name), 32, { 0, 0, 0, 1 }, { xOffset, yOffset })

	local textOponentWidth = self.texts.oponentName:getDimensions()
	local oponentUpgradesOwned =
		UpgradesOwned.new(self.oponent.inventory.upgrades, { xOffset - textOponentWidth - 50, yOffset }, -1)
	self.texts.oponentName.pos[1] = self.texts.oponentName.pos[1] - textOponentWidth

	-- upgrades owned
	self.upgradesOwned.player = playerUpgradesOwned
	self.upgradesOwned.oponent = oponentUpgradesOwned

	-- items slots
	local itemScale = 0.7
	self.itemSlots = ItemSlot.new(Player.inventory.items, itemScale, { 0, screenH - 100 })

	local itemSlotW = self.itemSlots.socket:getWidth() * itemScale
	-- action slots
	local slotScale = 0.7
	for i = 1, 5 do
		self.actionSlots[i] = ActionSlot.new(ACTION_IDX[i], i, slotScale, screenW - itemSlotW)
	end

	self.itemSlots.pos[1] = self.actionSlots[5]:getPosEnd() + self.itemSlots.socket:getWidth() * itemScale / 2
end

-- passa para o próximo oponente e reseta uns atributos
function BattleState:nextBattle()
	self.battleNum = self.battleNum + 1
	self.oponent = self.oponentPool[self.battleNum]
	self.texts = {}
	self.timer = 0
	self.turn = 1
	self.hasEnded = false
	self.endTimer = math.huge
	self.finalResult = nil
	self.actionsEnabled = true
	self.hist = History.new()
	self.decisionTime = 5

	Player:resetForBattle()
end

-- simula um confronto entre o player e o oponente, atualizando o historico do combate
function BattleState:simulateBattle()
	local turnResult = simulateTurn(Player, self.oponent, self.hist)
	self.hist:addSnapshot(Player)

	if turnResult ~= Combat.ONGOING then
		self.finalResult = turnResult
		self.hasEnded = true
		self.endTimer = 2
		if turnResult == Combat.WIN then
			self.oponent.action = ACTION.DEAD
		else
			Player.action = ACTION.DEAD
		end
	end
end

function BattleState:endBattle()
	if self.finalResult == Combat.WIN and BattleState.battleNum == 6 then
		SetGameCtx(CTX.VICTORY_SCREEN)
	elseif self.finalResult == Combat.LOSS then
		SetGameCtx(CTX.DEATH_SCREEN)
	elseif self.finalResult == Combat.WIN then
		SetGameCtx(CTX.SHOP)
	end
end

function BattleState:newCounterText(txt)
	local width, height = love.graphics.getDimensions()
	return Text.new(txt, 64, { 0.15, 0.10, 0.08, 1 }, { width / 2, height * 2 / 5 }, 0, 0, 0.5, function(text, dt)
		text.scale = text.scale and (text.scale + 2 * dt) or 1
	end)
end

function BattleState:load()
	self:reset()

	-- sprites
	local background = love.graphics.newImage("assets/UI/combat/combat_bg.png")
	self.sprites.bg = background
	self.sprites.one = love.graphics.newImage("assets/UI/combat/1.png")
	self.sprites.two = love.graphics.newImage("assets/UI/combat/2.png")
	self.sprites.three = love.graphics.newImage("assets/UI/combat/3.png")
	self.sprites.shoot = love.graphics.newImage("assets/UI/combat/shoot.png")

	self.sprites.amount = love.graphics.newImage("assets/UI/combat/amount.png")
	-- sounds
	self.sounds.select = love.audio.newSource("sounds/select.wav", "static")
	self.sounds.counter3 = love.audio.newSource("sounds/counter_3.mp3", "static")
	self.sounds.counter2 = love.audio.newSource("sounds/counter_2.mp3", "static")
	self.sounds.counter1 = love.audio.newSource("sounds/counter_1.mp3", "static")
	self.sounds.counterShoot = love.audio.newSource("sounds/counter_shoot.mp3", "static")
end

function BattleState:resetTurn()
	-- TODO: melhorar isso aqui que horror
	Player.dmgMult = 1
	self.oponent.dmgMult = 1

	Player.defibrilated = false
	self.oponent.defibrilated = false

	Player.timedRight = false
	self.oponent.timedRight = false

	Player.blinded = false
	self.oponent.blinded = false
end

function BattleState:update(dt)
	if not self.hasEnded then
		local pt = self.timer
		self.timer = pt - dt

		-- count chegou a 0 -> shoot
		if self.timer <= 0 then
			self.counter:setCounter(self.sprites.shoot)
			self.sounds.counterShoot:play()
			self.turn = self.turn + 1
			self:simulateBattle()
			self.timer = self.decisionTime
			self:resetTurn()
			self.actionsEnabled = false
		end

		-- count chegou a 4 -> volta ao idle e limpa os textos
		if pt > 4 and self.timer < 4 and self.turn > 1 then
			self:setAction(0)
			self.oponent.action = ACTION.MISS
			self.counter.isActive = false
			self.actionsEnabled = true
		end

		-- count chegou a 2.25 -> inicia a contagem acelerada (3)
		if pt > 2.25 and self.timer < 2.25 then
			self.counter:setCounter(self.sprites.three)
			self.sounds.counter3:play()
		end
		if pt > 1.5 and self.timer < 1.5 then
			self.counter:setCounter(self.sprites.two)
			self.sounds.counter2:play()
		end
		if pt > 0.75 and self.timer < 0.75 then
			self.counter:setCounter(self.sprites.one)
			self.sounds.counter1:play()
		end

		for _, healthBar in pairs(self.healthBar) do
			healthBar:update(dt)
		end

		-- Disable buttons if player cannot perform action/Enable them if they can
		if Player.ammo == 0 then
			self.actionSlots[getIdFromValue(ACTION.ATK, ACTION_IDX)]:disable()
		else
			self.actionSlots[getIdFromValue(ACTION.ATK, ACTION_IDX)]:enable()
		end
		if Player.ammo < 2 then
			self.actionSlots[getIdFromValue(ACTION.HEAVY_ATK, ACTION_IDX)]:disable()
		else
			self.actionSlots[getIdFromValue(ACTION.HEAVY_ATK, ACTION_IDX)]:enable()
		end
		if Player.defCount >= 2 then
			self.actionSlots[getIdFromValue(ACTION.DEFENSE, ACTION_IDX)]:disable()
		else
			self.actionSlots[getIdFromValue(ACTION.DEFENSE, ACTION_IDX)]:enable()
		end
		if Player.counters == 0 then
			self.actionSlots[getIdFromValue(ACTION.COUNTER, ACTION_IDX)]:disable()
		else
			self.actionSlots[getIdFromValue(ACTION.COUNTER, ACTION_IDX)]:enable()
		end

		for _, slot in pairs(self.actionSlots) do
			slot:update(dt)
		end
	else
		self.endTimer = self.endTimer - dt
		if self.endTimer <= 0 then
			self:endBattle()
		end
	end

	-- texts
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

	-- ammo amount
	local amountX = screenW / 5 + 10
	local amountY = screenH - self.sprites.amount:getHeight() - 60
	love.graphics.draw(self.sprites.amount, amountX, amountY, 0, 1, 1)

	love.graphics.print(tostring(Player.ammo) .. "x", amountX + 60, amountY + 20)
	-- item slots
	self.itemSlots:draw()

	-- texts
	for _, text in pairs(self.texts) do
		text:draw()
	end

	-- counter
	self.counter:draw()

	love.graphics.setColor(1, 1, 1, 1)
end

-- Detecta o input do usuário
function BattleState:keypressed(key, scancode, isrepeat)
	if not self.actionsEnabled then
		return
	end

	local num = tonumber(key)
	if num and num > 0 and num < 6 then
		-- ignore if slot is disabled
		if not self.actionSlots[num].disabled then
			self:setAction(num)
		end
	end

	if num and num >= 6 and num <= 8 then
		local itemIndex = num - 5
		if Player.inventory.items[itemIndex] then
			Player:useBuff(Player.inventory.items[itemIndex])
			self.sounds.select:play()
		end
	end
end

function BattleState:setAction(num)
	-- deselecionando o slot
	for i, slot in pairs(self.actionSlots) do
		if i == num then
			slot.active = not slot.active
		else
			slot.active = false
		end
	end

	-- alterando a acao do jogador
	if Player.action == ACTION_IDX[num] or num == 0 then
		Player.action = ACTION.NONE
	else
		Player.action = ACTION_IDX[num]
	end

	if Player.action == ACTION.ATK or Player.action == ACTION.HEAVY_ATK then
		local stopwatch = Player:hasUpgrade(UPGRADE.STOPWATCH)
		if stopwatch then
			stopwatch:activate(Player, self.timer)
		end
	end

	self.sounds.select:play()
end

function BattleState:shuffleActionSlots()
	local usedIndexes = {}
	for _, slot in pairs(self.actionSlots) do
		local newIndex = math.random(1, 5)
		while usedIndexes[newIndex] do
			newIndex = math.random(1, 5)
		end

		usedIndexes[newIndex] = true
		slot:moveTo(newIndex)
	end
end

return BattleState
