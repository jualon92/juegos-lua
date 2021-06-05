Bird = Class{} -- tabla tipo class?

local GRAVEDAD = 2
local VINICIAL = 0


function Bird:init() -- constructor
    self.imagen = love.graphics.newImage('bird.png') -- crea imagen, pasa a self.image para utilizarlo en clase
    self.imgLargo = self.imagen:getWidth() -- self.width.  lo utiliza de parametro en class
    self.imgAlto = self.imagen:getHeight()

    self.x = largoVirtual / 2  - ( self.imgLargo / 2)  -- largopantalla dividido por la mitad. x = 412.  
    --esta en x = 0.  mueve la mitad de flappy bird hacia la izquierda ( - self.image)
    self.y = altoVirtual / 2 - (self.imgAlto / 2)

    self.acu = 0
end

function Bird:update(dt)
    
   -- self.y = self.y +  (GRAVEDAD * dt)  -- en este caso el desplazamiento es constante. no me sirve
   
   --  convierto a desplazamiento en acu 
    self.acu = self.acu + (GRAVEDAD * dt) -- x pixeles por t tiempo. + espacio inicial. 
     
    if love.keyboard.waskeypressed('space') then
        self.acu = -1 -- gravedad se vuelve -5
    end

    self.y = self.y + self.acu


end


function Bird:render() -- se llama Bird:render como si fuera una clase  Bird:
    love.graphics.draw(self.imagen, self.x,self.y)
     
end


function Bird:Collides(pipe) -- retorna true si coliciona
    if (self.x + 2) + (self.imgLargo - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.imgAlto - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end