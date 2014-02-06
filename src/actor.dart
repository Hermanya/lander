library actor;

import 'dart:html';
import 'dart:math';

class Actor{
  num x;
  num y;
  num deltaX; // horizontal velocity
  num deltaY; // vertical velocity
  num deltaVx; // horizontal acceleration
  num deltaVy; // vertical acceleration
  num acceleration;
  num rotation;
  num fuel;
  double time;
  bool isActive;
  bool isCrashed;
  Actor(this.x,this.y){
    deltaX = 0.5;
    deltaY = 0;
    fuel = 100;
    time = 0.1;
    acceleration = 0;
    rotation = 0;
    isActive = false;
    isCrashed = false;
  }
  
  void updateStatistics(){
    querySelector("#fuel").text= fuel.toInt().toString();
  }
  void updateAltitude(num altitude){
    querySelector("#altitude").text = altitude.toInt().toString();
  }
  void updatePosition(keyboard,stage,camera){
    // appying forces
     this.applyInput(keyboard);
     this.applyForces(stage);
     
    //updating position
     x+=deltaX;
     if (camera.x - x > camera.width/3/camera.zoom || x - camera.x > camera.width/camera.zoom)
       camera.x+=deltaX;
     y+=deltaY;
     if (camera.y - y > camera.height/3/camera.zoom || y - camera.y > camera.height/3/camera.zoom)
       camera.y+=deltaY;
     
     num altitude,_deltaY1,_deltaY0,_deltaX0,_deltaX1=24;
     Point surfacePoint1,surfacePoint2;
     if (x>0){
       surfacePoint1 = stage.positiveSurfaceLine[x~/_deltaX1];
       surfacePoint2 = stage.positiveSurfaceLine[x~/_deltaX1+1];
       _deltaY1 = surfacePoint1.y-surfacePoint2.y;
       _deltaX0 = x - surfacePoint1.x;
       _deltaY0 = _deltaX0 * _deltaY1 / _deltaX1;
       altitude = surfacePoint1.y - _deltaY0 -y -8;
     }else{
       surfacePoint1 = stage.negativeSurfaceLine[-x~/_deltaX1];
       surfacePoint2 = stage.negativeSurfaceLine[-x~/_deltaX1+1];
       _deltaY1 = surfacePoint2.y-surfacePoint1.y;
       _deltaX0 = x - surfacePoint1.x;
       _deltaY0 = _deltaX0 * _deltaY1 / _deltaX1;
       altitude = surfacePoint1.y + _deltaY0 -y -8;
     }
     ifGameOver(altitude);
     
     camera.adjustZoom(altitude);
     
     updateAltitude(altitude);
  }
  void applyInput(keyboard){
    if (keyboard.isPressed(KeyCode.A))
      rotation -= PI/72; 
    if (keyboard.isPressed(KeyCode.D))
      rotation += PI/72;
    
    if (keyboard.isPressed(KeyCode.W)){
     if (acceleration<0.002)
        acceleration += 0.0001;
     else
       acceleration = 0.002;
    
     }
  //  else
    //  acceleration = 0;
    if (keyboard.isPressed(KeyCode.S)){
      if (acceleration>0.0003)
        acceleration -= 0.0001;  
      else
        acceleration = 0;
        
    }
  }
  void applyForces(stage){
    deltaX += cos(rotation)*acceleration;
    deltaY += sin(rotation)*acceleration;
    fuel-=acceleration*10;
    deltaY += stage.g;
  }
  void ifGameOver(altitude){
    if (altitude<1){
      if(deltaX < 0.2 && deltaX > -0.2 &&
          deltaY < 0.2 && deltaX > -0.2){
        querySelector("#congratulation").style.display="block";
      }else{
        querySelector("#commiseration").style.display="block";
      }
      isActive = false;
      acceleration = 0;
    }
  }
}