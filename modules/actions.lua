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

-- map action to a color for the UI
function mapToColor(action)
	local colors = {
		[ACTION.NONE] = {0.35, 0.35, 0.38}, -- gray 
		[ACTION.RECHARGE] = {0.95, 0.75, 0.2},  -- yellow
		[ACTION.ATK] = {0.25, 0.55, 0.95}, -- blue
		[ACTION.HEAVY_ATK] = {0.15, 0.25, 0.6}, -- deep blue
		[ACTION.DEFENSE] = {0.2, 0.6, 0.35}, -- green 
		[ACTION.COUNTER] = {0.4, 0.9, 0.5}, -- bright green
		[ACTION.MISS] = {0.9, 0.25, 0.25}, -- red
		[ACTION.DEAD] = {0.08, 0.08, 0.1}, -- near black
	}

	return colors[action]
end
