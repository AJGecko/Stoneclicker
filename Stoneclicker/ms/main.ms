init = function()
  clicks = 0
  stone_production = 0
  lock = []
  
  stone = object //stone
    x = -70
    y = 5
  end
  
  upgrades = object //upgrade menu
    line1 = ["Automated_Pickaxe","Drill","Stone Golem"]
    line2 = ["(+1 per sec)","(+2 per sec)","(+5 per sec)"]
    prices = [50,200,1000]
    number = [0,0,0]
    in_use = [0,0,0]
  
    show = function(x,y,id)
      local px = x
      local py = y
      local buybutton = [px,py]
      
      //hitbox check for buttons in the upgrades menu
      //lscale = local scale
      //buy
      if mouse.x < px-18 and mouse.x > px-52 and mouse.y > py-14 and mouse.y < py-2 then
        buylscale = 1.05
        if click(2) then
          if global.clicks - upgrades.prices[id] >= 0 then 
            global.clicks -= upgrades.prices[id]
            upgrades.number[id] += 1
            upgrades.in_use[id] += 1
          end
        end
      else
        buylscale = 1
      end
      
      //minus  
      if mouse.x < px+38 and mouse.x > px+26 and mouse.y > py-14 and mouse.y < py-2 then
        minuslscale = 1.05
        if click(3) then
          if not upgrades.in_use[id] - 1  < 0 then 
            upgrades.in_use[id] -= 1
          end
        end
      else
        minuslscale = 1  
      end
      
      //plus
      if mouse.x < px+52 and mouse.x > px+40 and mouse.y > py-14 and mouse.y < py-2 then
        pluslscale = 1.05
        if click(4) then
          if upgrades.number[id] >= upgrades.in_use[id] + 1 then 
            upgrades.in_use[id] += 1
          end
        end
        print(lock)
      else
        pluslscale = 1  
      end
      
      //sprite display
      screen.drawSprite( "upgrade", px, py, 120, 40 )
      
      
      screen.drawSprite( "buy", px-35, py-8, 35*buylscale, 12*buylscale)
      screen.drawSprite( "minus", px+32, py-8, 12*minuslscale, 12*minuslscale)
      screen.drawSprite( "plus", px+48, py-8, 12*pluslscale, 12*pluslscale)
      
      
      screen.drawText("In use: " + upgrades.in_use[id] ,px+3,py-10,8,"rgb(255,255,255)")
      screen.drawText("Owned: " + upgrades.number[id] ,px+3,py-4,8,"rgb(255,255,255)")
      screen.drawText(upgrades.line2[id] + "  Price: " + upgrades.prices[id] ,px , py+3,10 ,"rgb(255,255,255)")
      screen.drawText(upgrades.line1[id] ,px , py+10,10,"rgb(255,255,255)")
    end
  end
end

update = function()
  screen.setCursorVisible(0)
  //stone hitbox check
  if click(1) and isNear(mouse.x,mouse.y,stone.x,stone.y,70) then 
    clicks += 1
    stonescale = 1.1
  end
  
  //stone production
  stone_production = upgrades.in_use[0]+upgrades.in_use[1]*2+upgrades.in_use[2]*5
  if ticks >= 60 then
    clicks+= stone_production
    ticks = 0
  end
  ticks += 1
end

draw = function()
  screen.fillRect(0,0,1000,1000,"rgb(0,0,0)")
  upgrades.show(60,0,1)
  upgrades.show(60,-45,2)
  upgrades.show(60,45,0)
  screen.drawSprite( "stone", stone.x, stone.y, 128*stonescale, 128*stonescale )
  screen.drawText("Clicks: " + clicks,stone.x,stone.y-70,20,"rgb(255,255,255)")
  screen.drawText("Stone" ,stone.x,stone.y+70,20,"rgb(255,255,255)")
  screen.drawText("Upgrades:" ,60,75,20,"rgb(255,255,255)")
  screen.drawText("Current Stone Production: " + stone_production ,60,-70,10,"rgb(255,255,255)")
  screen.drawSprite( "pickaxe2", mouse.x, mouse.y, 32, 32 )
  stonescale = 1
end

click = function(p)
  if (touch.press == 1 or mouse.left == 1) and lock[p] == 0 then
    lock[p] = 1
    return true
  end
  if touch.release == 1 or mouse.left == 0 then
    lock[p] = 0
  end
end

isNear = function(x1, y1, x2, y2, threshold)
  local dx = x2 - x1
  local dy = y2 - y1
  local distance = sqrt(dx*dx + dy*dy)
  return distance <= threshold
end