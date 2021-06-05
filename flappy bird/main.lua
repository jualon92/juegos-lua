
 
push = require 'push'  --carga modulo/libreria lua de manejo ventana

Class = require 'class'  -- lib p/ usar clases

require 'Bird' -- extends
require 'Tubo'
require 'pipePairs'


largoVentana = 1280
altoVentana = 720 --

largoVirtual = 512
altoVirtual = 288 -- 
 

 


local bird = Bird() -- crea objeto bird desde clase Bird
local pipePairs = {}
 
local suelo = love.graphics.newImage('ground.png')
local timerSpawn = 0
local sueloScroll = 0 --  x inicial de scrolling para suelo

local fondo = love.graphics.newImage('background.png')
local fondoScroll = 0 -- x inicial de scrolling para fondo

--velocidad de scroll
local sueloSpeed = 42
local fondoSpeed = 30
local BACKGROUND_LOOPING_POINT = 413  -- punto en x, al llegar el loop devuelve x = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

 
local scrolling = true -- vsenial

function love.load()

    love.window.setTitle('Flappy Bird')
    love.graphics.setDefaultFilter("nearest", 'nearest') --  blurry fix
    math.randomseed(os.time())

    --inicializar resolucion virtual
    push:setupScreen(largoVirtual,altoVirtual,largoVentana,altoVentana, { -- confg ventana para que se vea bien 
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.hashmap = {} -- crea tabla con Keys = key, value = boolean


end



function love.resize(w,h)
    push:resize(w,h)

end

function love.update(dt)
    if scrolling then 
        fondoScroll = (fondoScroll + (fondoSpeed * dt) ) 
        % BACKGROUND_LOOPING_POINT 
        --espacio a mover(espacio ini + unidad * tiempo(unidad recorrida)) 

        sueloScroll = (sueloScroll + (sueloSpeed * dt)) 
        % largoVirtual

        timerSpawn = timerSpawn + dt  -- acu de dt



        --pasan 2s tiempo real
        if timerSpawn > 2 then
            local y = math.max(-PIPE_HEIGHT + 10,math.min(lastY + math.random(-20,20), altoVirtual - 90 - PIPE_HEIGHT )
            lastY = y
            

            table.insert(tubos, Tubo())  --agrega un tubo random
            print("Agregado nuevo tubo") 
            timerSpawn = 0 
        end

        bird:update(dt) 
        
        for k, p in pairs(tubos) do --por cada tubo agregado a la tabla  
            p:update(dt) --  mueve el tubo

              
            if bird:Collides(p) then
                    scrolling = false;
            end
            
        


            if p.x < -p.largo then -- si tubo esta en x < 0, lo borra
                  table.remove(tubos,k)
             end
        end

        
    end

    love.keyboard.hashmap = {}

end

function love.keypressed(ptecla)
    love.keyboard.hashmap[ptecla] = true-- asigna  key ptecla, value true

    if "escape" ==  ptecla then
        love.event.quit()
    end

    
end

function love.keyboard.waskeypressed(pkey) -- 

    return love.keyboard.hashmap[pkey]  -- hashmap, true or false de esa key. return devuelve valor
    --

end

--function love.update()

--end

function love.draw()
    push:start()
    love.graphics.draw(fondo, -fondoScroll,0) -- a fondo lo imprime en x = -fondoScroll. fondoScroll va a ir shifteando a la 
    
    for i, tubo in pairs(tubos) do
        tubo:render()
    end

    bird:render()

    love.graphics.draw(suelo,-sueloScroll, altoVirtual - 16)

    push:finish()
end
