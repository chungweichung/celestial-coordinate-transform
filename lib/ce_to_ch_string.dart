import 'ce_to_ch.dart';
import 'navigation_format_tool.dart';

class CelectialEquatorToHorizen {
  String lat = '';
  String lha = '', t = '', dec = '';
  String h = '', zn = '', z = '';
  late CeleEqutorToCeleHori toCh;
  late double latRad, decRad, lhaRad, tRad, hRad, znRad, zRad;
  CelectialEquatorToHorizen(
      {required this.lat, required this.dec, required this.lha}) {
    latRad = toRadFormat(lat);
    decRad = toRadFormat(dec);
    lhaRad = toRadFormat(lha);
    toCh = CeleEqutorToCeleHori(lat: latRad, dec: decRad, lha: lhaRad);
  }
  get getT {
    tRad = toCh.getT;
    t = toDegMinFormatWE(tRad);
    return t;
  }

  get getH {
    hRad = toCh.getH;
    h = toDegreeFormat(hRad);
    return h;
  }

  get getZ {
    zRad = toCh.getZ;
    z = 'N${toDegMinFormatWE(zRad)}';
    return z;
  }

  get getZn {
    znRad = toCh.getZn;
    zn = toDegMinFormat(znRad);
    return zn;
  }
}