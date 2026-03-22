----------------------------------------
-- Enum Acoes
----------------------------------------

ACTION = {}
ACTION.NONE = "none"
ACTION.RECHARGE = "recarregar"
ACTION.ATK = "ataque"
ACTION.HEAVY_ATK = "ataque_pesado"
ACTION.DEFENSE = "defesa"
ACTION.COUNTER = "contra_ataque"
ACTION.MISS = "vacilo"
ACTION.DEAD = "morto"

ACTION_IDX = {}
ACTION_IDX[1] = ACTION.ATK
ACTION_IDX[2] = ACTION.DEFENSE
ACTION_IDX[3] = ACTION.RECHARGE
ACTION_IDX[4] = ACTION.HEAVY_ATK
ACTION_IDX[5] = ACTION.COUNTER
ACTION_IDX[6] = ACTION.MISS

-- transform action name into its pretty name
function toPrettyActionName(action)
    local prettyNames = {
        [ACTION.NONE] = "None",
        [ACTION.RECHARGE] = "Recharge",
		[ACTION.ATK] = "Attack",
		[ACTION.HEAVY_ATK] = "Heavy Attack",
		[ACTION.DEFENSE] = "Defense",
		[ACTION.COUNTER] = "Counter Attack",
		[ACTION.MISS] = "Miss",
		[ACTION.DEAD] = "Dead",
	}

	return prettyNames[action]
end

function mapToColor(action)
	local colors = {
		[ACTION.NONE] = {0.3, 0.3, 0.3}, -- gray
		[ACTION.RECHARGE] = {0.8, 0.8, 0.0}, -- yellow
		[ACTION.ATK] = {0.0, 0.0, 1.0}, --blue
		[ACTION.HEAVY_ATK] = {0.0, 0.0, 0.4}, -- darkblue
		[ACTION.DEFENSE] = {0.0, 0.4, 0.0}, -- dark green
		[ACTION.COUNTER] = {0.0, 1.0, 0.0}, -- green
		[ACTION.MISS] = {1.0, 0.0, 0.0}, -- red
		[ACTION.DEAD] = {0.0, 0.0, 0.0}, -- black
    }
	return colors[action]
end
