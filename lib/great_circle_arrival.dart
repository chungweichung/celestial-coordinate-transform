import 'dart:math';

class GreatCircleArrivel {
  double departureLatitude;
  double departureLongitude;
  double initialCourse;
  double greatCircleDistance;

  GreatCircleArrivel(
      {required this.departureLatitude,
      required this.departureLongitude,
      required this.initialCourse,
      required this.greatCircleDistance});

  // 計算到達點經緯度的功能
  Map<String, double> calculateArrivalCoordinates() {
    double departureLatInRadians = _degreesToRadians(departureLatitude);
    double departureLonInRadians = _degreesToRadians(departureLongitude);
    double initialHeadingInRadians = _degreesToRadians(initialCourse);

    // 計算到達點經緯度
    double arrivalLatInRadians = asin(
        sin(departureLatInRadians) * cos(greatCircleDistance) +
            cos(departureLatInRadians) *
                sin(greatCircleDistance) *
                cos(initialHeadingInRadians));

    double arrivalLonInRadians = departureLonInRadians +
        atan2(sin(initialHeadingInRadians) *
            sin(greatCircleDistance) *
            cos(departureLatInRadians),
            cos(greatCircleDistance) -
                sin(departureLatInRadians) * sin(arrivalLatInRadians));

    // 轉換為度數
    double arrivalLatitude = _radiansToDegrees(arrivalLatInRadians);
    double arrivalLongitude = _radiansToDegrees(arrivalLonInRadians);

    return {'latitude': arrivalLatitude, 'longitude': arrivalLongitude};
  }

  // 將度數轉換為弧度
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  // 將弧度轉換為度數
  double _radiansToDegrees(double radians) {
    return radians * (180.0 / pi);
  }
}
