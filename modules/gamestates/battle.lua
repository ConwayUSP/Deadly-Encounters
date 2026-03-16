local BattleState = {}
BattleState.__index = MenuState

-- TODO: preencher o estado do menu
BattleState.sprites = {}
BattleState.texts = {}
BattleState.oponent = nil -- botar construtor do primeiro oponente
BattleState.battleNum = 1
BattleState.timer = 0
BattleState.decisionTime = 5
BattleState.turn = 1
BattleState.hist = {}

-- para caso o jogo recomece
function BattleState:reset()
	-- !TODO:
end

-- passa para o próximo oponente e reseta uns atributos
function BattleState:nextBattle()
	-- !TODO:
end

return BattleState
