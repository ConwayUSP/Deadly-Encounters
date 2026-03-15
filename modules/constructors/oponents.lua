-- apenas um exemplo
function initAberration()
    local aberrationStategy = function(self, player, turn)
        if self.ammo == 0 then
            return ACTION.RECHARGE
        else
            return ACTION.ATK
        end
    end

    return Oponent.new("Aberracao", 200, aberrationStategy)
end
