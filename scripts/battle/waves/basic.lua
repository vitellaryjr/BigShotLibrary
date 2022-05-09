local Basic, super = Class(Wave)

function Basic:onStart()
    self.timer:every(0.2, function()
        local x = SCREEN_WIDTH + 20
        local y = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom)
        self:spawnBullet("small", x, y, math.rad(180), 8)
    end)
end

return Basic