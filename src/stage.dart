library stage;

import 'dart:math';
import 'star.dart';
part 'luna.dart';
part 'random_stage.dart';
part 'mars.dart';

abstract class Stage{
  
  num g; //gravitational acceleration
  num r; //air resistance
  String color;
  List<Point> positiveSurfaceLine;
  List<Point> negativeSurfaceLine;
  List<List<Star>> positiveStars;
  List<List<Star>> negativeStars;
  Stage(canvas){
    g = new Random().nextInt(10)/10000+0.0005;
    r = new Random().nextInt(5);
    color = (0x444444+(new Random()).nextInt(0x333333)).round().toRadixString(16).substring(1,6);
    negativeSurfaceLine = new List();
    int pointZeroRandomY = new Random().nextInt(canvas.height~/4)+canvas.height*2~/4;
    negativeSurfaceLine.add(new Point(0,pointZeroRandomY));
    positiveSurfaceLine = new List();
    positiveSurfaceLine.add(new Point(0,pointZeroRandomY));
    positiveStars= new List();
    negativeStars = new List();
  }
  Stage.custom(this.g,this.r,this.color,canvas){
    negativeSurfaceLine = new List();
    int pointZeroRandomY = new Random().nextInt((canvas.height~/4).toInt())+canvas.height*2~/4;
    negativeSurfaceLine.add(new Point(0,pointZeroRandomY));
    positiveSurfaceLine = new List();
    positiveSurfaceLine.add(new Point(0,pointZeroRandomY));
    positiveStars= new List();
    negativeStars = new List();
  }
  
  updateSurface(actor,camera){
    /*
     * Horizontal generation of the landscape and stars
     */
    int singleWidth = 24;
    
    this.updatePositiveSurfaceLine(camera,actor,singleWidth);
    this.updateNegativeSurfaceLine(camera,actor,singleWidth);
    /* 
     * Vertical generation
     * 
     */
    
    for (List<Star> substars in positiveStars){
      updateSubstars(substars,camera,actor,singleWidth);
    }
    for (List<Star> substars in negativeStars){
      updateSubstars(substars,camera,actor,singleWidth);
    }

    
  }
  void updateNegativeSurfaceLine(camera,actor,singleWidth){
    while (negativeSurfaceLine.last.x > actor.x - camera.width / 2 / camera.zoom){
      Point previousPoint = negativeSurfaceLine.last;
      Point newPoint = new Point(previousPoint.x-singleWidth,
          previousPoint.y+(new Random().nextInt(7)-3)*8
      );
      negativeSurfaceLine.add(newPoint);
      List<Star> subStars = new List();
      subStars.add(
            new Star(newPoint.x,
                newPoint.y,
                new Random().nextInt(singleWidth)-singleWidth/2,
                new Random().nextInt(singleWidth)-singleWidth/2,
                new Random().nextInt(3)==0
            )
          );
      negativeStars.add(subStars);
    }
  }
  void updatePositiveSurfaceLine(camera,actor,singleWidth){
    while (positiveSurfaceLine.last.x < actor.x + camera.width / 2 / camera.zoom){
      Point previousPoint = positiveSurfaceLine.last;
      Point newPoint = new Point(previousPoint.x+singleWidth,
          previousPoint.y+(new Random().nextInt(7)-3)*8
      );
      positiveSurfaceLine.add(newPoint);
      List<Star> subStars = new List();
      subStars.add(
            new Star(newPoint.x,
                newPoint.y,
                new Random().nextInt(singleWidth)-singleWidth/2,
                new Random().nextInt(singleWidth)-singleWidth/2,
                new Random().nextInt(3)==0
            )
          );
      positiveStars.add(subStars);
    }
  }
  static void updateSubstars(substars,camera,actor,singleWidth){
    while(substars.last.y > actor.y - camera.height / 2 / camera.zoom){
      Star previousStar = substars.last;
      substars.add(
          new Star(previousStar.x,
              previousStar.y - singleWidth,
              new Random().nextInt(singleWidth)-singleWidth/2,
              new Random().nextInt(singleWidth)-singleWidth/2,
              new Random().nextInt(64)==0
          )
      );
    }
  }
}