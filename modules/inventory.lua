----------------------------------------
-- Entidade Player
----------------------------------------

Inventory = {}
Inventory.__index = Inventory

function Inventory.new(initialItems, initialUpgrades)
	local inv = setmetatable({}, Inventory)
	inv.items = {}
	inv.upgrades = {}
	inv.usedQueue = {}

	if initialItems then
		for _, v in pairs(initialItems) do
			table.insert(inv.items, v)
		end
	end
	if initialUpgrades then
		for _, v in pairs(initialUpgrades) do
			table.insert(inv.upgrades, v)
		end
	end

	return inv
end

function Inventory:insert(buff)
	if buff.type == BUFF_TYPE.ITEM then
		local repeated = false
		for k, v in pairs(self.items) do
			if v.id == buff.id then
				repeated = true
			end
		end
		if not repeated then
			table.insert(self.items, buff)
		end
	elseif buff.type == BUFF_TYPE.UPGRADE then
		local repeated = false
		for k, v in pairs(self.upgrades) do
			if v.id == buff.id and v.id == UPGRADE.DEFIBRILLATOR then
				repeated = true
			end
		end
		if not repeated then
			table.insert(self.upgrades, buff)
		end
	end
end

function Inventory:get(id, type)
	if type == BUFF_TYPE.ITEM then
		for _, v in pairs(self.items) do
			if v.id == id then
				return v
			end
		end
	elseif type == BUFF_TYPE.UPGRADE then
		for _, v in pairs(self.upgrades) do
			if v.id == id then
				return v
			end
		end
	end
end

function Inventory:addToUsed(buff)
	table.insert(self.usedQueue, buff)
end

function Inventory:removeUpgrade(upgradeId)
	for k, v in pairs(self.upgrades) do
		if v.id == upgradeId then
			self.upgrades[k] = nil
			break
		end
	end
end

function Inventory:discardBuff(buff)
	-- remove uma instância daquele buff do usedQueue
	for k, v in pairs(self.usedQueue) do
		if v == buff then
			self.usedQueue[k] = nil
			break
		end
	end
end
