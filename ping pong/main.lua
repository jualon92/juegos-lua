--que halla una ai que se mueve hacia el objeto.

jsaque = barraDer --barra der es la primera en sacar
largoVent = love.graphics.getWidth()
altoVent = love.graphics.getHeight()

rectLargo = 16
rectAlto = 64
distA = 20
velocidad = 400
largoPelota = 8
altoPelota = 8
maximo = altoVent - rectAlto 
pelota = {   --dimensiones y posicion de la pelota.
    
    x = largoVent / 2 - largoPelota, 
    y = altoVent / 2 - altoPelota,
    randx = 0,
    randy = 0,

}

barraDer  = {
    x = distA,
    y = 10,
    score = 0,
}

    sonidoVic = love.audio.newSource('Powerup24.wav', 'static')


sonido = {  --creo obj sonido.  hago un hashmap de key golpePaleta(nombre), love audio new source
    ['golpePaleta'] = love.audio.newSource('Blip_Select.wav', 'static'),
    ['punto'] = love.audio.newSource('Explosion6.wav', 'static'),
}



barraIzq = {
    x = largoVent - rectLargo - distA, --  pos y= max piso.  luego sube a rectLargo, y luego 10
    y = altoVent - rectAlto - distA,
    score = 0,
}
vsenial = 0  


--creo objeto de pelot con locacion x e y.

gameState = 'pentrada'


--cual es la de update

function love.load()
    math.randomseed(os.time())
    fontGrande = love.graphics.newFont(48)
    fontChica = love.graphics.newFont(24)
    reiniciarPelota()
end

function love.update(dt)
    if (gameState ~= "victoria") then  -- quiero que se cancele el mov cuando se terminaaaa
    
    

    if love.keyboard.isDown('w') then
        barraDer.y = barraDer.y -  dt * velocidad -- a y le resto(sube para arriba) la velocidad por tiempo(distancia?)
    end

    if  love.keyboard.isDown('s') then
        barraDer.y = barraDer.y + dt * velocidad -- dt * velocidad es desplazamiento
    end

    if love.keyboard.isDown('up') then 
        barraIzq.y = barraIzq.y - dt * velocidad
    end

    if love.keyboard.isDown('down') then
        barraIzq.y = barraIzq.y + dt * velocidad
    end

    barraDer.score = 0
    barraIzq.score = 0

    end

        if gameState == 'juego' then
        
          -- ubica pelota en centro, crea valor de distancia
        pelota.x = pelota.x + pelota.randx * dt * 1.02 -- se muevve dx(dezplazamiento random) por 000.1s
        pelota.y = pelota.y + pelota.randy * dt * 1.02
   --     barraDer.y = pelota.y - rectAlto/2
    --    barraIzq.y = pelota.y - rectAlto/2
    
        if barraIzq.y > maximo then
            barraIzq.y = altoVent - rectAlto
        end

        if barraDer.y < 0 then -- si toca el techo y = 0;
            barraDer.y = 0
        end
    
        if barraIzq.y < 0 then 
            barraIzq.y = 0
        end
    
        if barraDer.y > maximo then -- se le resta el rect porque dibujo comienza arriba derecha
            barraDer.y = altoVent - rectAlto -- no funciona, use largo en vez de alto
        end



        --si llega outofbound, suma score y reinicia
        if pelota.x > largoVent - largoPelota then
            sonido['punto']:play()
            barraDer.score = barraDer.score + 1
            if (barraDer.score  < 1) then
                jsaque = barraIzq --saca izquierda por punto de derecha
                reiniciarPelota()
                gameState = 'saque'
            else
                reiniciarPelota()
                gameState = 'victoria' --tiene mayor a 5 de score
                sonidoVic:play()
            end


        elseif pelota.x < 0 - largoPelota   then -- pelota.x < largoVent - largoPeota.
            sonido['punto']:play()
            barraIzq.score = barraIzq.score + 1
            
            if (barraIzq.score  < 1) then
                jsaque = barraDer 
                reiniciarPelota()
                gameState = 'saque'
                 
            else
                reiniciarPelota()
                gameState = 'victoria' --tiene mayor a 5 de score
                sonidoVic:play()
            end
        end




        if coliciona(barraDer, pelota) then
            pelota.randx = -pelota.randx --pelota.randx * dt se vuelve negativo, pelota x cambia de s
            --la colision va a ser dentro del x = 0 , y = 0, sup der
            pelota.x = barraDer.x + rectLargo -- la pelota se ubica en x de la barra 
            sonido['golpePaleta']:play()
        end
 
        
        if coliciona(barraIzq, pelota) then
            pelota.randx = -pelota.randx --  pelota.ranx * dt (unidades que se mueve x segundo) 
            pelota.x = barraIzq.x - rectLargo
            sonido['golpePaleta']:play()
        end
        --1. coliciona, triggerea funcion
        --2. pelota.x se ubica en x = 0 + largo de reectangulo, superfiice de paleta
        --3 toma direcion contrario en eje x, va para el otro lado
  
        if pelota.y < 0  then -- la pelota esta por tocar el techo  t = 0
            pelota.randy = - pelota.randy  --randy define la unidad recorrida por tiempo(velocidad), cambiarla a neg cambia su direccion
         
        end

        if pelota.y > altoVent - largoPelota  then
            pelota.randy = - pelota.randy
        end



    end


end
--si en function llamo una variable, toma el valor de variable global. si es un objeto puedo actualizar
function love.keypressed(tecla) --
    if tecla == 'escape' then
        love.event.quit() -- apaga, no reinicia como p
    end
    
    if tecla == 'return' or tecla == 'return' then --keypressed evalua solo condicion de key == x. listenea.
         if gameState == "pentrada" then --si esta en lobby
            gameState = "saque"
         elseif gameState == 'saque' then
            gameState = 'juego'
         elseif gameState == 'victoria' then
            gameState = 'pentrada'
         end
    end    
end

vauxi1 = largoVent - 161
scoreAuxi = "score: " .. barraDer.score .. ' - ' .. barraIzq.score --


function love.draw()  --dibujar las pantallas
    if gameState == 'pentrada' then 
        
       -- love.graphics.setFont(font36)
        love.graphics.printf('Pong Ping', fontGrande, 0, 60, largoVent, 'center') -- Ping Pong
        
        love.graphics.printf('Presionar enter para comenzar', fontChica, 0, altoVent - 120 , largoVent, 'center')
        -- 120? adrede, experimentando, a ojo
    end
    
    if gameState == 'saque' then
        love.graphics.printf('Presiona enter para sacar', fontChica, 0, altoVent - 120, largoVent, 'center')
      --  love.graphics.printf('Score',fontGrande, 0, 60, largoVent, 'center')
      
    end

    if gameState == 'victoria' then
        if barraDer.score > barraIzq.score then
            ganador = "barraDer"
        else 
            ganador = 'barraIzq'
        end

            love.graphics.printf('gana '.. ganador, fontGrande, 0, 60, largoVent, 'center')
            love.graphics.printf('presiona enter para reiniciar', fontChica, 0, altoVent-120, largoVent, 'center')
             
    end

  --  love.graphics.setFont(fontChica)
  --  love.graphics.printf("score: " .. barraDer.score .. ' - ' .. barraIzq.score, fontChica, 0, 10, largoVent, 'center') --xq no sirve x scoreauxi?
   -- love.graphics.print('score: ' .. barraDer.score .. ' - ', largoVent - 161, 10) --score derecho
    
   -- love.graphics.print(barraIzq.score, largoVent - 40, 10) -- score izquierdo
   love.graphics.setFont(fontChica)
    love.graphics.printf("score: " .. barraDer.score .. ' - ' .. barraIzq.score, fontChica, 0, 10, largoVent, 'center')
    love.graphics.rectangle('fill',barraDer.x, barraDer.y, rectLargo ,rectAlto) --paddle der
    love.graphics.rectangle('fill',barraIzq.x, barraIzq.y , rectLargo, rectAlto) -- paddle izq
    love.graphics.rectangle('fill', pelota.x, pelota.y, largoPelota, altoPelota)
    
end


function reiniciarPelota() -- 
    pelota.x = largoVent /2 - largoPelota
    pelota.y = altoVent / 2 - altoPelota
    pelota.randx = 60 + math.random(60)--pongo velocidad. mayor horizontal que vertical
    pelota.randy = 30 + math.random(60)
    if math.random(2) > 1 then  --asigno direccion + o - , 50/50 coin flip, 
        pelota.randx =  -pelota.randx
    end
    if math.random(2) > 1 then 
        pelota.randy = -pelota.randy
    end



end


function coliciona(p, b)
    return not (p.x > b.x + (largoPelota + altoPelota) or p.y > b.y + (largoPelota + altoPelota) or b.x > p.x + rectLargo or b.y > p.y + rectAlto)
end