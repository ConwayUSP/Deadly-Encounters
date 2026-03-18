----------------------------------------
-- Importações de módulos
----------------------------------------
require("modules.oponent")
local resolvePath = require("modules.engine.path")
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

-- Carrega assets da Batalha
function BattleState:load()
    self.bg = love.graphics.newImage(resolvePath("assets/UI", "battle_bg", ".png"))
end

-- Atualiza o estado da batalha
function BattleState:update()

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

-- Desenha a batalha
function BattleState:draw()
    love.graphics.draw(self.bg)
end

-- para caso o jogo recomece
function BattleState:reset()
	self.texts = {}
	self.oponentPool = generateOponentPool()
	self.battleNum = 1
	self.oponent = self.oponentPool[self.battleNum]
	self.timer = 0
	self.decisionTime = 5
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

return BattleState
