----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")

----------------------------------------
-- ENUM de Items e Upgrades
----------------------------------------
UPGRADE = {}
UPGRADE.PARRY = "parry"
UPGRADE.SHIELD = "shield"
UPGRADE.DEFIBRILLATOR = "defibrillator"
UPGRADE.REVERSE_CARD = "reverse card"
UPGRADE.LUCK_TOTEM = "luck totem"
UPGRADE.STOPWATCH = "stopwatch"

ITEM = {}
ITEM.FLASHBANG = "flashbang"
ITEM.POTION = "potion"
ITEM.ENERGY_DRINK = "energy drink"

----------------------------------------
-- Entidade Item/Upgrade
----------------------------------------

ItemUpgrade = {}
ItemUpgradem.__index = ItemUpgrade

-- cria um novo buff, o id é um dos enums acima
function ItemUpgrade.new(id, desc, effectFunc)
	local buff = setmetatable({}, ItemUpgrade)
	buff.id = id
	buff.desc = desc
	buff.activate = effectFunc
	local spritePath = pngPathFormat("assets", "buffs", id)
	buff.sprite = love.graphics.newImage(spritePath)
end
