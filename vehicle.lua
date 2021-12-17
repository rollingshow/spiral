Vehicle = {}
Vehicle.__index = Vehicle

function isNaN( v ) return v ~= v end

function math.map( value, imin, imax, omin, omax )
    local scale = (omax - omin) / (imax - imin)
    return omin + (value - imin) * scale
end

function Vehicle:create( x, y )
    local vehicle = {}
    setmetatable(vehicle, Vehicle)

    vehicle.velocity = Vector:create(0, 0)
    vehicle.acceleration = Vector:create(0, 0)
    vehicle.location = Vector:create(0, 0)
    vehicle.r = 5
    vehicle.vertices = { 0, -vehicle.r * 2, -vehicle.r, vehicle.r * 2, vehicle.r, vehicle.r * 2 }
    vehicle.maxSpeed = 4
    vehicle.maxForce = 0.05
    vehicle.wtheta = 0

    return vehicle
end

function Vehicle:update()
    self.velocity:add(self.acceleration)
    self.velocity:limit(self.maxSpeed)
    self.location:add(self.velocity)
    self.acceleration:mul(0)

end

function Vehicle:applyForce( force ) self.acceleration:add(force) end

function Vehicle:borders()
    if self.location.x < -self.r then
        self.location.x = width + self.r
    end
    if self.location.y < -self.r then
        self.location.y = height + self.r
    end
    if self.location.x > width + self.r then
        self.location.x = -self.r
    end
    if self.location.y > height + self.r then
        self.location.y = -self.r
    end
end

function Vehicle:draw()
    local theta = self.velocity:heading() + math.pi / 2
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(theta)
    love.graphics.polygon("fill", self.vertices)
    love.graphics.pop()
end

function Vehicle:follow( flow )
    local desired = flow:lookup(self.location)

    if (isNaN(desired.x) or isNaN(desired.y) or isNaN(desired)) then
        desired = Vector:create(0, 0)
    end

    desired:mul(self.maxSpeed)
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    self:applyForce(steer)

end
