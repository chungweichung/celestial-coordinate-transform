import 'dart:math';

import 'ch_to_ce.dart';
import 'navigation_format_tool.dart';

class CelectialHorizenToEquator {
  String lat = '';
  String lha = '', t = '', dec = '';
  String h = '', zn = '', z = '';
  late CeleHoriToCeleEqutor toCe;
  late double latRad, decRad, lhaRad, tRad, hRad, znRad, zRad;
  CelectialHorizenToEquator(
      {required this.lat, required this.h, required this.zn}) {
    latRad = toRadFormat(lat);
    znRad = toRadFormat(zn);
    hRad = toRadFormat(h);
    zRad = znRad <= pi ? znRad : znRad - 2 * pi;
    toCe = CeleHoriToCeleEqutor(lat: latRad, h: hRad, zn: znRad);
  }
  get getZ {
    z = toDegMinFormatWE(zRad);
    return 'N$z';
  }

  get getDec {
    decRad = toCe.getDec;
    dec = toDegMinFormatNS(decRad);
    return dec;
  }

  get getT {
    tRad = toCe.getT;
    t = toDegMinFormatT(tRad);
    return t;
  }

  get getLha {
    lhaRad = toCe.getLha;
    lha = toDegMinFormat(lhaRad);
    return lha;
  }
}
