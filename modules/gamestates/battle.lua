----------------------------------------
-- Importações de módulos
----------------------------------------
require("modules.oponent")
require("modules.history")
require("modules.combat")
require("modules.fs")

----------------------------------------
-- Estado do jogo no contexto de batalha
----------------------------------------

local BattleState = {}
BattleState.__index = BattleState

-- TODO: preencher o estado
BattleState.sprites = {}
BattleState.texts = {}
BattleState.oponentPool = generateOponentPool()
BattleState.battleNum = 1
BattleState.oponent = BattleState.oponentPool[BattleState.battleNum]
BattleState.decisionTime = 3
BattleState.timer = BattleState.decisionTime * 2
BattleState.turn = 1
BattleState.hist = History.new()

-- para caso o jogo recomece
function BattleState:reset()
	self.texts = {}
	self.oponentPool = generateOponentPool()
	self.battleNum = 1
	self.oponent = self.oponentPool[self.battleNum]
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
function BattleState:simulaConfronto()
	local resultadoTurno = simulaTurno(Player, self.oponent, self.hist)
	self.hist:addSnapshot(Player)

	if resultadoTurno == Combat.ONGOING then
		return
	end

	if resultadoTurno == Combat.WIN and BattleState.battleNum == 6 then
		-- ganhar a sexta batalha == vitória
		SetGameCtx(CTX.VICTORY_SCREEN)
	elseif resultadoTurno == Combat.LOSS then
		SetGameCtx(CTX.DEATH_SCREEN)
	elseif resultadoTurno == Combat.WIN then
		SetGameCtx(CTX.SHOP)
	end
end

function BattleState:newCounterText(txt)
	local width, height = love.graphics.getDimensions()
	return Text.new(txt, 64, { 0.15, 0.10, 0.08, 1 }, { width / 2, height / 3 }, 0, 0, 1, function(text, dt)
		text.scale = text.scale and text.scale + 3 * dt or 1
	end)
end

function BattleState:load()
	local background = love.graphics.newImage("assets/UI/battle_bg.png")
	self.sprites.bg = background
end

function BattleState:update(dt)
	local pt = self.timer
	self.timer = pt - dt
	if self.timer <= 0 then
		self:simulaConfronto()
		self.timer = self.decisionTime + 0.001
		self.texts = {}
	end
	if pt > 3 and self.timer < 3 then
		self.texts.counter3 = self:newCounterText("3")
	end
	if pt > 2 and self.timer < 2 then
		self.texts.counter2 = self:newCounterText("2")
	end
	if pt > 1 and self.timer < 1 then
		self.texts.counter1 = self:newCounterText("1")
	end

	for _, text in pairs(self.texts) do
		if text.update then
			text:update(dt)
		end
	end
	cleanUpTexts(self.texts)
end

function BattleState:draw()
	love.graphics.clear(0.95, 0.90, 0.80)

	love.graphics.draw(self.sprites.bg)

	for key, text in pairs(self.texts) do
		text:draw()
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)

	local width, height = love.graphics.getDimensions()
	local playerPos = { 2 * width / 8, height / 2 }
	Player:draw(playerPos)
	local oponentPos = { 6 * width / 8, height / 2 }
	self.oponent:draw(oponentPos)
end

-- Detecta o input do usuário
function BattleState:keypressed(key, scancode, isrepeat)
	-- TODO: remover isso
	if key == "return" or key == "space" then
		SetGameCtx(CTX.VICTORY_SCREEN)
	elseif key == "s" then
		SetGameCtx(CTX.SHOP)
	end

	-- TODO: lógica de decisão e poderes
end

return BattleState
