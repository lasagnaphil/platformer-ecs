local systems = {
    load = {},
    update = {},
    draw = {},
    globals = {}
}

local System = require 'plugins.knife.system'
local anim8 = require 'plugins.anim8'
local bump = require 'plugins.bump'

systems.globals.world = bump.newWorld(32)

systems.update.movement = System(
    {'position', 'velocity', '!physicsBody'},
    function (p, v, dt)
        p.x = p.x + v.x * dt
        p.y = p.y + v.y * dt
    end)

systems.draw.sprite = System(
    {'position', 'sprite'},
    function (pos, sprite)
        love.graphics.draw(sprite.image, pos.x, pos.y)
    end
)

systems.load.sprite = System(
    {'sprite'},
    function (sprite)
        sprite.image = love.graphics.newImage(sprite.filename)
    end
)

systems.update.animSprite = System(
    {'position', 'animSprite'},
    function (pos, sprite, dt)
        sprite.animation:update(dt)
    end
)

systems.load.animSprite = System(
    {'animSprite'},
    function (sprite)
        sprite.image = love.graphics.newImage(sprite.filename)
        sprite.grid = anim8.newGrid(sprite.size.w, sprite.size.h, sprite.image:getWidth(), sprite.image:getHeight())
        sprite.animation = anim8.newAnimation(sprite.grid(unpack(sprite.curFrame)), 1/(30*sprite.speed))
    end
)

systems.draw.animSprite = System(
    {'position', 'animSprite'},
    function (pos, sprite)
        sprite.animation:draw(sprite.image, pos.x, pos.y)
    end
)

systems.update.player = System(
    {'velocity', 'player'},
    function (vel, player, dt)
        if love.keyboard.isDown('left') then
            if (vel.x - player.accel * dt) > -player.speed then
                vel.x = vel.x - player.accel * dt
            end
        elseif love.keyboard.isDown('right') then
            if (vel.x + player.accel * dt) < player.speed then
                vel.x = vel.x + player.accel * dt
            end
        else
            local brake = (vel.x < 0 and player.decel or -player.decel) * dt
            if math.abs(brake) > math.abs(vel.x) then
                vel.x = 0
            else
                vel.x = vel.x + brake
            end
        end
        if love.keyboard.isDown('up') and player.onGround then
            vel.y = -player.jumpVel
            player.inAir = true
        end
    end
)

local gravAccel = 1000
local world = systems.globals.world

systems.load.collider = System(
    {'position', 'collider', '_entity'},
    function (pos, col, entity)
        world:add(entity, pos.x, pos.y, col.w, col.h)
    end
)
systems.update.physics = System(
    {'position', 'velocity', 'physicsBody', 'collider', '_entity'},
    function (pos, vel, body, col, entity, dt)
        vel.y = vel.y + gravAccel * dt
        world:update(entity, pos.x, pos.y, col.w, col.h)
        local actualX, actualY, cols, len =
            world:move(entity, pos.x + vel.x * dt, pos.y + vel.y * dt)
        pos.x, pos.y = actualX, actualY
    end
)

return systems
