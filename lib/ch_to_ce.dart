import 'dart:math';

class CeleHoriToCeleEqutor {
  double lat = 0.0;
  double dec = 0.0, lha = 0.0, t = 0.0;
  double h = 0.0, z = 0.0, zn = 0.0;
  CeleHoriToCeleEqutor({required this.lat, required this.h, required this.zn});

  double roundDecimalTen(double num) {
    return double.parse(num.toStringAsFixed(13));
  }

  get getDec {
    dec =
        asin(roundDecimalTen(sin(lat) * sin(h) + cos(lat) * cos(h) * cos(zn)));
    return asin(
        roundDecimalTen(sin(lat) * sin(h) + cos(lat) * cos(h) * cos(zn)));
  }

  get getT {
    if(zn<=pi){
      t=acos(roundDecimalTen(
            (sin(h) - sin(lat) * sin(dec)) / (cos(lat) * cos(dec))));
    }else{
     t=-1*acos(roundDecimalTen(
            (sin(h) - sin(lat) * sin(dec)) / (cos(lat) * cos(dec))));
    }
    return t;
  }

  get getLha {
    lha = -t % (pi * 2);
    return lha;
  }
}
