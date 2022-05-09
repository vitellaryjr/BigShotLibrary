local ShotBullet, super = Class(Bullet)

function ShotBullet:init(x, y, texture)
    super:init(self, x, y, texture)

    self.shot_health = 1
    self.shot_tp = 1
end

function ShotBullet:onYellowShot(shot, damage)
    self.shot_health = self.shot_health - damage
    if self.shot_health <= 0 then
        self:destroy(shot)
    end
end

function ShotBullet:destroy(shot)
    Game.battle.tension_bar:giveTension(self.shot_tp)
    self:remove()
end

return ShotBullet