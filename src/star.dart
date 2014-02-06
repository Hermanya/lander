library star;

import 'dart:math';

class Star extends Point{
  num shiftX;
  num shiftY;
  bool isVisible;
  Star(x,y,shiftX,shiftY,isVisible):super(x,y){
    this.shiftX = shiftX;
    this.shiftY = shiftY;
    this.isVisible = isVisible;
  }
}