import 'dart:math';

class CeleEqutorToCeleHori {
  double lat = 0.0, dec = 0.0, lha = 0.0, t = 0.0;
  double h = 0.0, z = 0.0, zn = 0.0;
  CeleEqutorToCeleHori(
      {required this.lat, required this.dec, required this.lha});

  double roundDecimalTen(double num) {
    return double.parse(num.toStringAsFixed(13));
  }

  get getT {
    t = pi - (lha + pi) % (2 * pi);
    return t;
  }

  get getH {
    t = pi - (lha + pi) % (2 * pi);
    h = asin(
        roundDecimalTen(sin(lat) * sin(dec) + cos(lat) * cos(dec) * cos(t)));
    return h;
  }

  get getZ {
    if (t >= 0) {
      z = acos(roundDecimalTen(
          (sin(dec) - sin(lat) * sin(h)) / (cos(lat) * cos(h))));
    } else {
      z = -acos(roundDecimalTen(
          (sin(dec) - sin(lat) * sin(h)) / (cos(lat) * cos(h))));
    }

    return z;
  }

  get getZn {
    zn = z % (2 * pi);
    return zn;
  }
}
