local Shot, super = Class(Object)

function Shot:init(x, y, angle)
    super:init(self, x, y)
    self.layer = BATTLE_LAYERS["above_bullets"]
    self.rotation = angle
    self:setOrigin(0, 0.5)
    self:setSprite("player/shot/shot")
    self:setHitbox(1,1, 25,9)

    self.physics = {
        speed = 16,
        direction = angle,
    }

    self.damage = 1
    self.hit_bullets = {}
end

function Shot:update()
    super:update(self)
    if self.x > SCREEN_WIDTH + self.sprite.width then
        self:remove()
    end

    local bullets = Utils.filter(Game.stage:getObjects(Bullet), function(v)
        if self.hit_bullets[v] then return false end
        return v.onYellowShot
    end)
    for _,bullet in ipairs(bullets) do
        if self:collidesWith(bullet) then
            self.hit_bullets[bullet] = true
            local result, result_big = bullet:onYellowShot(self, self.damage)
            if result == nil then
                if result_big == nil then
                    result_big = false
                end
                result = "a"
            end
            if result_big == nil then
                result_big = result
            end
            local real_result
            if self.big then
                real_result = result_big
            else
                real_result = result
            end
            if real_result then
                if type(real_result) == "string" then
                    self:destroy(real_result)
                else
                    self:remove()
                end
                break
            end
        end
    end
end

function Shot:draw()
    super:draw(self)
    if DEBUG_RENDER then
        self.collider:draw(1,0,0)
    end
end

function Shot:setSprite(sprite)
    if self.sprite then
        self.sprite:remove()
    end
    self.sprite = Sprite(sprite, 0, 0)
    self:addChild(self.sprite)
    self:setSize(self.sprite:getSize())
end

function Shot:destroy(anim)
    anim = anim or "player/shot/shot_hit_a"
    if string.len(anim) == 1 then
        anim = "player/shot/shot_hit_"..anim
    end
    local sprite = Sprite(anim, self.x, self.y - self.height/2)
    sprite.layer = BATTLE_LAYERS["above_bullets"]
    sprite:play(0.1, false, function()
        sprite:remove()
    end)
    Game.battle:addChild(sprite)
    self:remove()
end

return Shot