require('util.tcopy')

local player = {
    name = 'player',
    position = { x = 100, y = 100 },
    velocity = { x = 0, y = 0},
    player = {
        accel = 1000,
        decel = 1000,
        speed = 100,
        jumpVel = 300,
        inAir = false,
        onGround = true
    },
    physicsBody = {
    },
    collider = {
        w = 32,
        h = 32
    },
    animSprite = {
        filename = "sprites/skeleton.png",
        size = { w = 32, h = 32 },
        frames = {
            stand = {1, 1},
            runLeft = {3, 2},
            runRight = {2, 2}
        },
        curFrame = {1, 1},
        image = nil,
        grid = nil,
        animation = nil,
        speed = 1/3,
    },
}

local block = {
    name = 'block',
    position = { x = 200, y = 200 },
    collider = {
        w = 32,
        h = 32
    },
    sprite = {
        filename = "sprites/tile/BrickTiles.png",
        rect = nil,
        image = nil
    },
}

function createBlock(x, y)
    local b = clone(block)
    b.position.x = x
    b.position.y = y
    return b
end

local entities = {
    player,
    createBlock(96, 200),
    createBlock(128, 200),
    createBlock(224, 200)
}

return entities
