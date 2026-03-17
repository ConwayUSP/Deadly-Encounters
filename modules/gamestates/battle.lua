----------------------------------------
-- Importações de módulos
----------------------------------------
require("modules.oponent")

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
BattleState.timer = 0
BattleState.decisionTime = 5
BattleState.turn = 1
BattleState.hist = {}

-- para caso o jogo recomece
function BattleState:reset()
	self.texts = {}
	self.oponentPool = generateOponentPool()
	self.battleNum = 1
	self.oponent = self.oponentPool[self.battleNum]
	self.timer = 0
	self.decisionTime = 5
	self.turn = 1
	self.hist = {}
end

-- passa para o próximo oponente e reseta uns atributos
function BattleState:nextBattle()
	self.battleNum = self.battleNum + 1
	self.oponent = self.oponentPool[self.battleNum]
	self.texts = {}
	self.timer = 0
	self.turn = 1
	self.hist = {}
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
	-- TODO: adicionar ao historico player e oponente

	if resultadoTurno == Combat.ONGOING then
		return
	end

	if resultadoTurno == Combat.WIN then
		GameCtx = CTX.SHOP
	elseif resultadoTurno == Combat.LOSS then
		GameCtx = CTX.DEATH_SCREEN
	elseif resultadoTurno == Combat.DRAW then
		GameCtx = CTX.VICTORY_SCREEN
	end
end

return BattleState
