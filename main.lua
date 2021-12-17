require("vector")
require("flowmap")
require("vehicle")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    flow = FlowMap:create(31, 10)
    flow:init()

    vehicle = Vehicle:create(width / 2, height / 2)
    vehicle.velocity.x = 1
    vehicle.velocity.y = 1.5
end

function love.update( dt )

    vehicle:borders()
    vehicle:follow(flow)
    vehicle:update()

end

function love.draw()
    flow:draw()
    vehicle:draw()
end
