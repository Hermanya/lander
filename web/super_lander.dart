import 'dart:html';

import "../src/stage.dart";
import "../src/actor.dart";
import "../src/camera.dart";
import "../src/keyboard.dart";

final canvas= querySelector("#canvas");
final CanvasRenderingContext2D ctx =
( canvas as CanvasElement).context2D;
var animationFrame,stage,actor,camera,keyboard;

game(num delta){
  
  stage.updateSurface(actor, camera);
  
  if (actor.isActive){
  actor.updateStatistics();
  actor.updatePosition(keyboard,stage,camera);
  }

  camera.show(ctx,stage,actor);
  
  animationFrame = window.animationFrame.then(game);
  /*if (actor.isActive){
    
  }else{
    if (actor.isCrashed){
      print("crashed");
    }else{
      print("cool");
    }
  }*/
}
init(Event e){
  querySelector("#menu-wrap").style.display="none";
  querySelector("#statistics").style.display="block";
  actor.isActive = true;
}
void selectChangeHandler(Event e){
  var select = querySelector("#stage");
  var value = select.options[select.selectedIndex].value;
  
  switch (value){
  case "luna":
    stage = new Luna(canvas);
    break;
  case "mars":
    stage = new Mars(canvas);
    break;
  case "random":
    stage = new RandomStage(canvas);
    break;
  }
}
void main() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  
  keyboard = new Keyboard();
  actor = new Actor(0,0);
  camera = new Camera(canvas.width,canvas.height,1);
  selectChangeHandler(new Event("ds"));
  querySelector("#play").onClick.listen(init);
  querySelector("#stage").onChange.listen(selectChangeHandler);
  querySelector("#win-reload").onClick.listen(reloadHandler);
  querySelector("#fail-reload").onClick.listen(reloadHandler);
  animationFrame = window.animationFrame.then(game);
}
void reloadHandler(Event e){
  window.location.assign(window.location.href);
}