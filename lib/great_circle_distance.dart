import 'dart:io';

import 'package:vector_math/vector_math.dart';
import 'dart:math';

import 'navigation_format_tool.dart';

class GreatCircleDist {
  double greatCircleArc = 0.0;
  double distance = 0.0;
  double courseAngle = 0.0; //radians
  double latitude1 = 0.0;
  double longitude1 = 0.0;
  double latitude2 = 0.0;
  double longitude2 = 0.0;
  double course = 0.0;
  GreatCircleDist(
      {required this.latitude1,
      required this.longitude1,
      required this.latitude2,
      required this.longitude2,
      required this.greatCircleArc});
  double roundDecimalTen(double num) {
    return double.parse(num.toStringAsFixed(10));
  }

  double distanceOfGC() {
    distance = acos(sin(latitude1) * sin(latitude2) +
        cos(latitude1) * cos(latitude2) * cos(longitude2 - longitude1));
    if (distance < 0) distance = distance + pi;
    return degrees(distance) * 60; //可以比對radians和乘半徑的準確度
  }

  double courseAngleOfGC() {
    //改半徑
    //East-> + ;West-> -
    courseAngle = acos(roundDecimalTen(
        (sin(latitude2) - sin(latitude1) * cos(distance)) /
            (cos(latitude1) * sin(distance))));
    if ((longitude2 - longitude1 > 0 && longitude2 - longitude1 < pi) ||
        longitude2 - longitude1 < -pi) {
      return courseAngle;
    } else {
      courseAngle *= -1;
      return courseAngle;
    }
  }

  get getCourse {
    course = courseAngle % 360;
    return course;
  }

  List<Position> getWayPoint() {
    int wayPointNum;
    List<Position> positionFx = [];

    wayPointNum = distance ~/ greatCircleArc;
    int i = 0;
    for (i = 0; i <= wayPointNum; i++) {
      double latTemp = asin(sin(latitude1) * cos(greatCircleArc * (i + 1)) +
          cos(latitude1) *
              sin(greatCircleArc * (i + 1)) *
              cos(courseAngle.abs()));
      positionFx.add(Position(latTemp, 0.0));
      if (courseAngle < 0) {
        positionFx[i].long = longitude1 -
            acos((cos(greatCircleArc * (i + 1)) -
                    sin(latitude1) * sin(latTemp)) /
                (cos(latitude1) * cos(latTemp)));
      } else {
        positionFx[i].long = longitude1 +
            acos((cos(greatCircleArc * (i + 1)) -
                    sin(latitude1) * sin(latTemp)) /
                (cos(latitude1) * cos(latTemp)));
      }
    }
    return positionFx;
  }

  List<Position> getVertex() {
    List<Position> vertex = [];
    double longVertex =
        longitude1 + atan(1 / (sin(latitude1) * tan(courseAngle.abs())));
    vertex.add(Position(
        acos(sin(courseAngle.abs()) * cos(latitude1)),
        (longVertex > pi)
            ? -pi * 2 + longVertex
            : (longVertex < -pi)
                ? pi * 2 + longVertex
                : longVertex));
    vertex.add(Position(-vertex[0].lat,
        vertex[0].long < 0 ? pi + vertex[0].long : -pi + vertex[0].long));
    return vertex;
  }

  double getCrossingEqutor() {
    return longitude1 + atan(-sin(latitude1) * tan(courseAngle));
  }
}
