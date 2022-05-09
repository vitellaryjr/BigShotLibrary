local Small, super = Class(YellowSoulBullet)

function Small:init(x, y, dir, speed)
    super:init(self, x, y, "bullets/smallbullet")
    self:setScale(4)
    self.color = {0, 0.5, 1}

    self.physics = {
        speed = speed,
        direction = dir,
    }
    self.remove_offscreen = false
end

function Small:onYellowShot(shot, damage)
    self.physics = {}
    self.collidable = false
    self.color = {1,1,1}
    self.graphics.grow = 0.1
    self:fadeTo(0, 0.1, function() self:destroy() end)
    return "a", false
end

return Small