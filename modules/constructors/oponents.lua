-- Aberration
function initAberration()
	-- Randomized powers and behaivor
	local aberrationStrategy = function(self, player, turn, hist)
		local actions = {
			ACTION.RECHARGE,
			ACTION.ATK,
			ACTION.HEAVY_ATK,
			ACTION.DEFENSE,
			ACTION.COUNTER,
			ACTION.MISS
		}

		local i = math.random(6)
		return actions[i]
	end

	return Oponent.new("Aberracao", 200, 3, nil, nil, aberrationStrategy)
end

-- Archibald
function initArchibald()
	-- Tries to attack and load a heavy one, but defends if the player has not attacked yet
	local archibaldStrategy = function(self, player, turn, hist)
		if self.ammo > 3 then
			return ACTION.HEAVY_ATK
		elseif self.ammo > 0 and math.random() < 0.5 then
			return ACTION.ATK
		else
			return ACTION.RECHARGE
		end
	end

	-- TODO: add desfibrilador
	return Oponent.new("Archibald", 200, 3, nil, nil, archibaldStrategy)
end

-- Devil
function initDjabo()
	-- is a cheater
	-- Relies on counter-attacks
	-- Has flashbangs and uno cards
	local djaboStrategy = function(self, player, turn, hist)
		if player.ammo >= 3 then
			return ACTION.COUNTER
		elseif self.ammo < 9 then
			return ACTION.RECHARGE
		else
			return ACTION.HEAVY_ATK
		end
	end

	-- TODO: add flashbangs and cards
	return Oponent.new("D'Jabo", 200, 8, nil, nil, djaboStrategy)
end

-- Emo
function initJoshua()
	-- Joshua. He's an emo
	-- Love's energy drinks
	-- Block only when it thinks there will be a heavy attack
	local joshuaStrategy = function(self, player, turn, hist)
		if self.ammo == 0 or math.random() < 0.4 then
			return ACTION.RECHARGE
		end

		if player.ammo > 5 then
			return ACTION.COUNTER
		elseif player.ammo > 3 then
			return ACTION.DEFENSE
		else
			return ACTION.ATK
		end
	end

	-- TODO: add energy drinks
	return Oponent.new("Joshua", 200, 3, nil, nil, joshuaStrategy)
end

-- Pirate
function initLarry()
	-- Larry is a pirate
	-- Relies on luck (has a totem)
	-- Tries to shoot whenever possible
	local larryStrategy = function(self, player, turn, hist)
		if self.ammo > 0 and math.random() < 0.7 then
			return ACTION.ATK
		else
			return ACTION.RECHARGE
		end
	end

	-- TODO: add totem
	return Oponent.new("Larry", 200, 3, nil, nil, larryStrategy)
end

-- Wizard
-- Its a healer and defender (has a potion and shield)
-- Uses only heavy attacks
function initOZard()
	local ozardStrategy = function(self, player, turn, hist)
		if self.ammo < 3 then
			return ACTION.RECHARGE
		elseif player.ammo > 2 then
			return ACTION.DEFENSE
		elseif player.hp < player.maxHp / 3 and self.ammo > 3 then
			return ACTION.HEAVY_ATK
		elseif self.ammo > 0 then
			return ACTION.ATK
		end
	end

	-- TODO: add shield and potions
	return Oponent.new("O'Zard", 200, 3, nil, nil, ozardStrategy)
end

-- Cowboy
function initSebastiao()
	local sebastiaoStrategy = function(self, player, turn, hist)
		if self.ammo < 1 then
			return ACTION.RECHARGE
		end

		if math.random() < 0.5 then
			return ACTION.DEFENSE
		end

		if self.ammo > 0 then
			return ACTION.ATK
		end
	end

	-- TODO: add parry
	return Oponent.new("Sebastiao", 200, 3, nil, nil, sebastiaoStrategy)
end
