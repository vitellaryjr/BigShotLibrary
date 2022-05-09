local Dummy, super = Class(Encounter)

function Dummy:init()
    super:init(self)

    self:addEnemy("dummy")
    self.text = "* The testing begins!\n* ...[wait:5] Hopefully it works."
end

function Dummy:createSoul(x, y)
    return YellowSoul(x, y)
end

return Dummy