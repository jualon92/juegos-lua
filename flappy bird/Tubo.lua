Tubo = Class{}

local TuboImg = love.graphics.newImage('pipe.png')

 
local TUBOVEL = -60


function Tubo:init() --constructor
    self.x = largoVirtual --spawnean en extremo derecho

    self.y = math.random(altoVirtual / 4, altoVirtual - 30)

    self.alto = TuboImg:getHeight()
    self.largo = TuboImg:getWidth()
end


function Tubo:update(dt)
    self.x = self.x + TUBOVEL * dt
end

function Tubo:render()
     love.graphics.draw(TuboImg, math.floor(self.x + 0.5) , math.floor(self.y))
end
