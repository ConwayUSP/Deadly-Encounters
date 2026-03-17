----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")

----------------------------------------
-- Classe History
----------------------------------------

History = {}
History.__index = History

function History.new()
	local hist = setmetatable({}, History)
	return hist
end

function History:addSnapshot(player)
	local snapshot = self:createSnapshot(player)
	table.insert(self, snapshot)
end

function History:createSnapshot(player)
	local snapshot = {}
	snapshot.hp = player.hp
	snapshot.counters = player.counters
	snapshot.ammo = player.ammo
	snapshot.defCount = player.defCount
	snapshot.action = player.action
	snapshot.buffs = {}
	for _, item in pairs(player.inventory.items) do
		snapshot.buffs[item.id] = item.quantity
	end
	for _, upg in pairs(player.inventory.upgrades) do
		snapshot.buffs[upg.id] = upg.quantity
	end
	return snapshot
end
