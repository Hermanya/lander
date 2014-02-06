part of stage;

class Mars extends Stage{
  
  Mars(canvas):super.custom(
      0.0013,// gravitation on the Moon is 1.6 m/s^2
      0.2,// no air resistance
      "E3701A", //Moon-gray
      canvas
   );
}