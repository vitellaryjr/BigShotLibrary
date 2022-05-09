local YellowSoul, super = Class(Soul)

function YellowSoul:init(x, y, angle)
    super:init(self, x, y)

    self.rotation = (angle and angle - math.pi/2) or -math.pi/2
    self.color = {1,1,0}

    -- customizable variables
    self.can_use_bigshot = true -- whether the soul can use bigshots
    self.teaching = Kristal.getLibConfig("yellowsoul", "teaching") and not Game:getFlag("yellowsoul.taught") -- whether the first bigshot should charge slower
    self.allow_cheat = Kristal.getLibConfig("yellowsoul", "allowcheat") -- whether the player is allowed to chain bigshots rapidly

    -- internal variables
    self.hold_timer = 0
end

function YellowSoul:update()
    super:update(self)
    if self.transitioning then
        if self.charge_sfx then
            self.charge_sfx:stop()
            self.charge_sfx = nil
        end
        return
    end
    
    if Input.pressed("confirm") and self.hold_timer == 0 then -- fire normal shot
        self:fireShot(false)
    end
    if self.can_use_bigshot then
        -- check release before checking hold, since if held is false it sets the timer to 0
        if Input.released("confirm") then -- fire big shot
            if self.hold_timer >= 10 and self.hold_timer < 40 then -- didn't hold long enough, fire normal shot
                self:fireShot(false)
            elseif self.hold_timer >= 40 then -- fire big shot
                self:fireShot(true)
            end
            if not self.allow_cheat then -- reset hold timer if cheating is disabled
                self.hold_timer = 0
            end
        end

        if Input.down("confirm") then -- charge a big shot
            -- charge the first shot of a save file slowly if teaching is enabled
            if self.teaching then
                self.hold_timer = self.hold_timer + DTMULT
            else
                self.hold_timer = self.hold_timer + DTMULT*2
            end

            if self.hold_timer >= 20 and not self.charge_sfx then -- start charging sfx
                self.charge_sfx = Assets.getSound("chargeshot_charge")
                self.charge_sfx:setLooping(true)
                self.charge_sfx:setPitch(0.1)
                self.charge_sfx:setVolume(0)
                local timer = 0
                Game.battle.timer:during(2/3, function()
                    timer = timer + DT
                    if self.charge_sfx then
                        self.charge_sfx:setVolume(Utils.clampMap(timer, 0,2/3, 0,0.3))
                    end
                end, function()
                    if self.charge_sfx then
                        self.charge_sfx:setVolume(0.3)
                    end    
                end)
                self.charge_sfx:play()
            end
            if self.hold_timer >= 20 and self.hold_timer < 40 then
                self.charge_sfx:setPitch(Utils.clampMap(self.hold_timer, 20,40, 0.1,1))
            end
        else
            self.hold_timer = 0
            if self.charge_sfx then
                self.charge_sfx:stop()
                self.charge_sfx = nil
            end
        end
    end
end

function YellowSoul:draw()
    local r,g,b,a = self:getDrawColor()
    local heart_texture = Assets.getTexture(self.sprite.texture_path)
    local heart_w, heart_h = heart_texture:getDimensions()

    local charge_timer = self.hold_timer - 35
    if charge_timer > 0 then
        local scale = math.abs(math.sin(charge_timer / 10)) + 1
        love.graphics.setColor(r,g,b,a*0.3)
        love.graphics.draw(heart_texture, -heart_w/2 * scale, -heart_h/2 * scale, 0, scale)

        scale = math.abs(math.sin(charge_timer / 14)) + 1.2
        love.graphics.setColor(r,g,b,a*0.3)
        love.graphics.draw(heart_texture, -heart_w/2 * scale, -heart_h/2 * scale, 0, scale)
    end

    local circle_timer = math.min(self.hold_timer - 15, 35)
    if circle_timer > 0 then
        local circle = Assets.getTexture("player/shot/charge")
        love.graphics.setColor(r,g,b,a*(circle_timer/5))
        for i=1,4 do
            local angle = (i*math.pi/2) - (circle_timer * math.rad(5))
            local x, y = math.cos(angle) * (35 - circle_timer), math.sin(angle) * (35 - circle_timer)
            local scale = Utils.clampMap(circle_timer, 0,35, 4,2)
            x, y = x - circle:getWidth()/2 * scale, y - circle:getHeight()/2 * scale
            love.graphics.draw(circle, x, y, 0, scale)
        end
    end

    if charge_timer > 0 then
        self.color = {1,1,1}
    end
    super:draw(self)
    self.color = {r,g,b}
end

function YellowSoul:onRemove(parent)
    if self.charge_sfx then
        self.charge_sfx:stop()
        self.charge_sfx = nil
    end
end

function YellowSoul:fireShot(big)
    if big then
        local shot = Game.battle:addChild(YellowSoulBigShot(self.x, self.y, self.rotation + math.pi/2))
        Assets.playSound("chargeshot_fire")
    else
        if #Game.stage:getObjects(YellowSoulShot) >= 3 then return end -- only allow 3 at once
        local shot = Game.battle:addChild(YellowSoulShot(self.x, self.y, self.rotation + math.pi/2))
        Assets.playSound("heartshot")
    end
end

return YellowSoul