----------------------------------------
-- Classe Oponente
----------------------------------------

Oponent = {}
Oponent.__index = Oponent

function Oponent.new(name, maxHP, strategyFunc)
    local oponent = setmetatable({}, Oponent)

    oponent.name = name
    oponent.hp = maxHP
    oponent.makeDecision = strategyFunc
    oponent.ammo = 0
    oponent.action = nil
end

return Oponent
