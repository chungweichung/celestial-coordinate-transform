import 'dart:math';

import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math.dart';

double roundDecimalTenForOut(double num) {
  return double.parse(num.toStringAsFixed(3));
}

double toRadFormat(String num) {
  List<String> degree = num.split('°');
  List<String> min = degree[1].split("'");
  degree.removeAt(1);
  degree.addAll(min);
  double temp;
  if (degree[2] == '' ||
      degree[2] == 'N' ||
      degree[2] == 'n' ||
      degree[2] == 'E' ||
      degree[2] == 'e') {
    temp = radians(double.parse(degree[0]) + double.parse(degree[1]) / 60);
  } else {
    temp = radians(-1 * double.parse(degree[0]) - double.parse(degree[1]) / 60);
  }
  return temp;
}

String toDegMinFormatNS(double num) {
  num = roundDecimalTenForOut(degrees(num));
  if (num >= 0) {
    return "${num.toInt()}°${(num % 1 * 60)}'N";
  } else {
    return "${-num.toInt()}°${(num % -1 * 60)}'S";
  }
}

String toDegMinFormatWE(double num) {
  num = roundDecimalTenForOut(degrees(num));
  if (num >= 0) {
    return "${num.toInt()}°${(num % 1 * 60)}'E";
  } else {
    return "${-num.toInt()}°${(num % -1 * 60)}'W";
  }
}

String toDegMinFormat(double num) {
  num = roundDecimalTenForOut(degrees(num));
  if (num >= 0) {
    return "${num.toInt()}°${(num % 1 * 60)}'";
  } else {
    return "${(-1 * num).toInt()}°${(num % -1 * 60)}'";
  }
}

String toDegreeFormat(double num) {
  num = roundDecimalTenForOut(degrees(num));
  return '${num}°';
}

String toDegFormatNotMinEW(double num) {
  num = roundDecimalTenForOut(degrees(num));
  if (num >= 0) {
    return '${num}°E';
  } else {
    return '${num}°W';
  }
}

String toDegMinFormatT(double num) {
  num = roundDecimalTenForOut(degrees(num));
  if (num >= 0) {
    return "${num.toInt()}°${(num % 1 * 60)}'E";
  } else {
    return "${-num.toInt()}°${(num - num.toInt()).abs() * 60}'W";
  }
}

String zToZn(String num) {
  if (num[0] == 'N') {
    if (num[num.length - 1] == 'W' || num[num.length - 1] == 'w') {
      List<String> degree = num.substring(1, num.length - 1).split('°');
      List<String> min = degree[1].split("'");
      degree.removeAt(1);
      degree.addAll(min);
      double temp = double.parse(degree[0]) + double.parse(degree[1]) / 60;
      temp = 360 - temp;
      return "${temp.toInt()}°${(temp - temp.toInt()) * 60}'";
    } else {
      return num.substring(1, num.length - 1);
    }
  } else {
    if (num[num.length - 1] == 'W' || num[num.length - 1] == 'w') {
      List<String> degree = num.substring(1, num.length - 1).split('°');
      List<String> min = degree[1].split("'");
      degree.removeAt(1);
      degree.addAll(min);
      double temp = double.parse(degree[0]) + double.parse(degree[1]) / 60;
      temp += 180;
      return "${temp.toInt()}°${(temp - temp.toInt()) * 60}'";
    } else {
      List<String> degree = num.substring(1, num.length - 1).split('°');
      List<String> min = degree[1].split("'");
      degree.removeAt(1);
      degree.addAll(min);
      double temp = double.parse(degree[0]) + double.parse(degree[1]) / 60;
      temp =180-temp;
      return "${temp.toInt()}°${(temp - temp.toInt()) * 60}'";
    }
  }
}

int signNonZero(double x) {
  return 2 * (0.5 + 0.5 * sin(x)).round() - 1;
}

class NavgartionInputFormat extends TextInputFormatter {
  final String symbol1, symbol2;
  final int howMuchCharNeedSy;
  NavgartionInputFormat(
      {this.symbol1 = '°',
      this.symbol2 = "'",
      required this.howMuchCharNeedSy});
  bool shouldAddSymbol2 = false;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty &&
        newValue.text[newValue.text.length - 1] ==
            oldValue.text[oldValue.text.length - 1]) {
      // 如果最后一个字符是 symbol2，则不添加额外的 symbol2
      shouldAddSymbol2 = false;
    } else if (newValue.text.length == howMuchCharNeedSy + 5) {
      shouldAddSymbol2 = true;
    }
    if (newValue.text.length == howMuchCharNeedSy &&
        oldValue.text.length < howMuchCharNeedSy + 1) {
      return TextEditingValue(
        text: '${newValue.text}$symbol1',
        selection: TextSelection.collapsed(
          offset: '${newValue.text}$symbol1'.length, // 将光标移到symbol2后面
        ),
      );
    }
    if (shouldAddSymbol2) {
      // 如果 shouldAddSymbol2 为 true，则在当前位置添加 symbol2
      shouldAddSymbol2 = false;
      return TextEditingValue(
        text: '${newValue.text}$symbol2',
        selection: TextSelection.collapsed(
          offset: '${oldValue.text}$symbol2'.length + 1, // 将光标移到symbol2后面
        ),
      );
    }
    return newValue;
  }
}

class Position {
  double lat = 0.0;
  double long = 0.0;
  Position(this.lat, this.long);
}

class PositionString {
  String lat, long;
  PositionString(this.lat, this.long);
}
