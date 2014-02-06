part of stage;

class Luna extends Stage{
  
  Luna(canvas):super.custom(
      0.001,// gravitation on the Moon is 1.6 m/s^2
      0,// no air resistance
      "707060", //Moon-gray
      canvas
   );
}