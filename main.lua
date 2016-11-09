require 'strict'

local systems = require 'systems'
local entities = require 'entities'

love.graphics.setDefaultFilter('nearest', 'nearest')

local canvas = love.graphics.newCanvas(400, 300)

local SCALE = 2

function love.load()
    for _, entity in ipairs(entities) do
        for _, system in pairs(systems.load) do
            system(entity)
        end
    end
end

function love.update(dt)
    for _, entity in ipairs(entities) do
        for _, system in pairs(systems.update) do
            system(entity, dt)
        end
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setCanvas(canvas)
    love.graphics.clear(255, 255, 255, 255)
    for _, entity in ipairs(entities) do
        for _, system in pairs(systems.draw) do
            system(entity)
        end
    end
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
end
