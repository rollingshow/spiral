FlowMap = {}
FlowMap.__index = FlowMap

function FlowMap:create( size, margin )
    local map = {}
    setmetatable(map, FlowMap)
    map.field = {}

    if (math.fmod( size,2 ) == 0) then
        map.size = size+1
    else
        map.size = size
    end
    
    map.margin = margin
    love.math.setRandomSeed(10000)
    return map
end

function FlowMap:init()
    local cols = (width / self.size) + self.margin
    local rows = (height / self.size) + self.margin

    for i = 1, cols do
        self.field[i] = {}
        for j = 1, rows do

            local y = j - rows / 2
            local x = i - cols / 2

            local vec = Vector:create(-1 * x - 10 * y, 10 * x - 1 * y)
            self.field[i][j] = vec / vec:mag()
        end
    end
end

function FlowMap:draw()
    for i = 1, #self.field do
        for j = 1, #self.field[1] do
            drawVector(self.field[i][j], (i - self.margin / 2) * self.size, (j - self.margin / 2) * self.size, self.size - 2)
        end
    end
end

function drawVector( v, x, y, s )
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(v:heading())
    local len = v:mag() * s
    love.graphics.line(0, 0, len, 0)
    love.graphics.circle("fill", len, 0, 5)
    love.graphics.pop()
end

function FlowMap:lookup( v )
    local col = math.constrain(math.roundNew((v.x / self.size) + self.margin / 2), 1, #self.field)
    local row = math.constrain(math.roundNew((v.y / self.size) + self.margin / 2), 1, #self.field[1])

    return self.field[col][row]:copy()
end
