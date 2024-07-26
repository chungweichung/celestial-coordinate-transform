import 'great_circle_distance.dart';
import 'navigation_format_tool.dart';
import 'package:vector_math/vector_math_64.dart';

class GreatCircleDistanceString {
  String lat1 = '', long1 = '', lat2 = '', long2 = '', greatCircleArc = '';
  String distance = '', courseAngle = '', course = '';
  List<PositionString> wayPoint = [], vertex = [];
  late double lat1Rad,
      long1Rad,
      lat2Rad,
      long2Rad,
      greatCircleArcRad,
      distRad,
      courseAngleRad,
      courseRad;
  late List<Position> wayPointRad, vertexRad;
  late GreatCircleDist greatCircle;
  GreatCircleDistanceString(
      {required this.lat1,
      required this.long1,
      required this.lat2,
      required this.long2,
      required this.greatCircleArc}) {
    lat1Rad = toRadFormat(lat1);
    long1Rad = toRadFormat(long1);
    lat2Rad = toRadFormat(lat2);
    long2Rad = toRadFormat(long2);
    greatCircleArcRad = radians(double.parse(greatCircleArc) / 60);
    greatCircle = GreatCircleDist(
        latitude1: lat1Rad,
        longitude1: long1Rad,
        latitude2: lat2Rad,
        longitude2: long2Rad,
        greatCircleArc: greatCircleArcRad);
  }

  get getDist {
    distRad = greatCircle.distanceOfGC();
    distance = (distRad).toStringAsFixed(2);
    return distance;
  }

  get getCourseAngle {
    courseAngleRad = greatCircle.courseAngleOfGC();
    courseAngle = 'N${toDegFormatNotMinEW(courseAngleRad)}';
    return courseAngle;
  }

  get getcourse {
    courseRad = greatCircle.getCourse;
    course = degrees(courseRad).toStringAsFixed(3);
    return course;
  }

  List<PositionString> getWayPoint() {
    wayPointRad = greatCircle.getWayPoint();
    for (int i = 0; i < wayPointRad.length; i++) {
      wayPoint.add(PositionString(toDegMinFormatNS(wayPointRad[i].lat),
          toDegMinFormatWE((wayPointRad[i].long))));
    }
    return wayPoint;
  }

  List<PositionString> getVertex() {
    vertexRad = greatCircle.getVertex();
    for (int i = 0; i < vertexRad.length; i++) {
      vertex.add(PositionString(toDegMinFormatNS(vertexRad[i].lat),
          toDegMinFormatWE(vertexRad[i].long)));
    }
    return vertex;
  }

  get getCrossingEquator {
    return toDegMinFormatWE(greatCircle.getCrossingEqutor());
  }
}
