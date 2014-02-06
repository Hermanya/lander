library camera;

import 'dart:math';
import 'dart:core';
import 'star.dart';

class Camera{
  num x;
  num y;
  int width;
  int height;
  num zoom;
  Camera(this.width,this.height,this.zoom){
    x=0;
    y=0;
  }
  show(ctx,stage,actor){
    ctx..fillStyle = "#222"
       ..fillRect(0,0,width,height)
       ..scale(zoom,zoom);
    
    this.drawStars(ctx, stage.positiveStars, actor);
    this.drawStars(ctx, stage.negativeStars, actor);
    
    //positive surface line
    this.drawSurfaceLine(ctx,stage.positiveSurfaceLine,stage.color,actor);   
    //negative surface line
    this.drawSurfaceLine(ctx,stage.negativeSurfaceLine,stage.color,actor);
    
    this.drawActor(ctx,actor);
    
    ctx..scale(1/zoom,1/zoom);
  }
  drawStars(ctx,stars,actor){
    ctx..beginPath()
       ..fillStyle = "#fff";
    for (List<Star> substars in stars){
      for (Star star in substars){
        if (star.isVisible){
          /*
           * to do: check
           */
          ctx.fillRect(
              star.x+star.shiftX-actor.x+width/2/zoom,
              star.y+star.shiftY-actor.y+height/4/zoom,
              1.5/zoom,1.5/zoom);
        }
      }
    }
  }
  drawSurfaceLine(ctx,surfaceLine,color,actor){
    ctx..beginPath()
      ..lineWidth = 1/zoom
      ..fillStyle = color
      ..strokeStyle = color;
    
    Point previousPoint = surfaceLine[0];
    num depth, depthStep = 47;
    for (var point in surfaceLine){
      if (point.x + depthStep > actor.x - width / 2 / zoom &&
          point.x - depthStep < actor.x + width / 2 / zoom){
      
      depth = 0;
      
      while(depth-24<actor.y+height/4*3/zoom-point.y){
        bool isPositiveDiagonal = depth.toInt().isEven;
        ctx.beginPath();
        ctx.moveTo(previousPoint.x-actor.x+width/2/zoom,previousPoint.y-actor.y+height/4/zoom+depth);
        ctx.lineTo(point.x-actor.x+width/2/zoom,point.y-actor.y+height/4/zoom+depth);
        if (isPositiveDiagonal)
          ctx.lineTo(previousPoint.x-actor.x+width/2/zoom,previousPoint.y-actor.y+height/4/zoom+depth+depthStep);
        else
          ctx.lineTo(point.x-actor.x+width/2/zoom,point.y-actor.y+height/4/zoom+depth+depthStep);
        String _color =  ColorLuminance(color,(100-depth)/200);
        ctx.fillStyle = _color;
        ctx.strokeStyle = _color;
        ctx.fill();
        ctx.stroke();
        
        ctx.beginPath();
        ctx.moveTo(previousPoint.x-actor.x+width/2/zoom,previousPoint.y-actor.y+height/4/zoom+depth+depthStep);
        if (isPositiveDiagonal)
          ctx.lineTo(point.x-actor.x+width/2/zoom,point.y-actor.y+height/4/zoom+depth);
        else
          ctx.lineTo(previousPoint.x-actor.x+width/2/zoom,previousPoint.y-actor.y+height/4/zoom+depth);
        ctx.lineTo(point.x-actor.x+width/2/zoom,point.y-actor.y+height/4/zoom+depth+depthStep);
        
        _color =  ColorLuminance(color,(100-depth-depthStep/2)/200);
        ctx.fillStyle = _color;
        ctx.strokeStyle = _color;
        ctx.fill();
        ctx.stroke();
        depth+=depthStep;
      }
      previousPoint = point;
    }
    }
    ctx..stroke();
  }
  drawActor(ctx,actor){
    ctx..beginPath()
      ..save()
      ..fillStyle = "#aaa"
      ..strokeStyle = "#aaa"
      ..lineWidth=1/zoom
      ..translate(width/2/zoom,height/4/zoom)
      ..rotate(actor.rotation)
      
      //body
      ..moveTo(6,0)
      ..lineTo(4,-4)
      ..lineTo(4,4)
      ..fillStyle = "#bbb"
      ..strokeStyle = "#bbb"
      ..fill()
      ..stroke()
      
      ..beginPath()
      ..moveTo(4,4)
      ..lineTo(0,0)
      ..lineTo(4,-4)
      ..fillStyle = "#aaa"
      ..strokeStyle = "#aaa"
      ..fill()
      ..stroke()
      
      ..beginPath()
      ..moveTo(4,-4)
      ..lineTo(-4,-4)
      ..lineTo(0,0)
      ..fillStyle = "#999"
      ..strokeStyle = "#999"
      ..fill()
      ..stroke()
      
      ..beginPath()
      ..moveTo(0,0)
      ..lineTo(4,4)
      ..lineTo(-4,4)
      ..fillStyle = "#999"
      ..strokeStyle = "#999"
      ..fill()
      ..stroke()
      
      ..beginPath()
      ..moveTo(-4,4)
      ..lineTo(0,0)
      ..lineTo(-4,-4)
      ..fillStyle = "#aaa"
      ..strokeStyle = "#aaa"
      ..fill()
      ..stroke()
     
      ..lineWidth=2/zoom
      
     // left leg
      ..beginPath()
      ..moveTo(-8,-8)
      ..lineTo(-8,-4)
      ..moveTo(-8,-6)
      ..lineTo(-2,-6)
      ..moveTo(-2,-6)
      ..lineTo(-2,-4)
      ..moveTo(-4,-4)
      ..lineTo(-6,-6) 
      
      ..fillStyle = "#aaa"
      ..strokeStyle = "#aaa"
      ..fill()
      ..stroke()
     // right leg
      ..beginPath()
      ..moveTo(-8, 8)
      ..lineTo(-8, 4)
      ..moveTo(-8, 6)
      ..lineTo(-2, 6)
      ..moveTo(-2, 6)
      ..lineTo(-2, 4)
      ..moveTo(-4, 4)
      ..lineTo(-6, 6) 
      
      ..fillStyle = "#aaa"
      ..strokeStyle = "#aaa"
      ..fill()
      ..stroke()
      
     // flame
      ..beginPath()
      ..fillStyle="#eea"
      ..moveTo(-6,-3)
      ..lineTo(-actor.acceleration*24*500-6+new Random().nextInt(3),0)
      ..lineTo(-6,3)
      ..closePath()
      ..fill()
     // nozzle
      ..beginPath()
      ..moveTo(-4, -1)
      ..lineTo(-6,-3)
      ..lineTo(-6,3)
      ..lineTo(-4, 1)
     // ..lineTo(-4,-1)
      ..fillStyle = "#aaa"
      ..strokeStyle = "#aaa"
      ..fill()
      ..stroke()
       
      ..restore();
  }
  /*
   * the following function was taken from 
   * http://www.sitepoint.com/javascript-generate-lighter-darker-color/
   * and translated to dart
   */
  static String ColorLuminance(hex, lum) {

    // validate hex string
    hex = hex.toString().replaceAll(new RegExp(r'/[^0-9a-f]/gi'),'');
    if (hex.length < 6) {
      hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
    }
    
    if (lum == null){
      lum = 0;  
    }
    
    // convert to decimal and change luminosity
    var rgb = "#", c, i;
    for (i = 0; i < 3; i++) {
      c = hex.substring(i*2,i*2+2);
      c = int.parse(c, radix:16);
      c = (min(max(0, c + (c * lum)), 255)).round().toRadixString(16);
      rgb += ("00"+c).substring(c.length);
    }

    return rgb;
  }
  void adjustZoom(altitude){
    if (altitude < height/2/zoom){
      if (zoom<4)
        zoom+=0.0015;
    }else{
      if (zoom>1)
        zoom-=0.0015;
    }
  }
}
