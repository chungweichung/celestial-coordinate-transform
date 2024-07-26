//import 'dart:ffi';

import 'great_circle_distance_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation_format_tool.dart';

class GreatCirclePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GreatCirclePageState();
  }
}

class _GreatCirclePageState extends State<GreatCirclePage> {
  TextEditingController lat1Controller = TextEditingController();
  TextEditingController long1Controller = TextEditingController();
  TextEditingController lat2Controller = TextEditingController();
  TextEditingController long2Controller = TextEditingController();
  TextEditingController greatCircleArcController = TextEditingController();
  TextEditingController distController = TextEditingController();
  TextEditingController courseAngleController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  FocusNode lat1Focus = FocusNode();
  FocusNode long1Focus = FocusNode();
  FocusNode lat2Focus = FocusNode();
  FocusNode long2Focus = FocusNode();
  FocusNode greatCircleArcFocus = FocusNode();
  FocusNode distFocus = FocusNode();
  FocusNode courseAngleFocus = FocusNode();
  FocusNode courseFocus = FocusNode();

  String lat1ErrorMessage = '';
  String long1ErrorMessage = '';
  String lat2ErrorMessage = '';
  String long2ErrorMessage = '';
  String greatCircleArcErrorMessage = '';
  String distErrorMessage = '';
  String courseAngleErrorMessage = '';
  String courseErrorMessage = '';

  void calculateDist() {
    setState(() {
      GreatCircleDistanceString getGCInform = GreatCircleDistanceString(
          lat1: lat1Controller.text,
          long1: long1Controller.text,
          lat2: lat2Controller.text,
          long2: long2Controller.text,
          greatCircleArc: greatCircleArcController.text);
      distController.text = getGCInform.getDist;
      courseAngleController.text = getGCInform.getCourseAngle;
      courseController.text = getGCInform.getcourse;
    });
  }

  Widget createPositionTextField(
      TextEditingController textController,
      Text text,
      FocusNode node,
      FocusNode nextNod,
      String hint,
      int degFormat,
      String errorMessage,
      void Function(String text) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextField(
        controller: textController,
        focusNode: node,
        autofocus: true,
        inputFormatters: [
          NavgartionInputFormat(howMuchCharNeedSy: degFormat),
          LengthLimitingTextInputFormatter(10)
        ],
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            label: text,
            hintText: hint,
            errorText: errorMessage.isEmpty ? null : errorMessage),
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(node);
          calculateDist();
        },
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Row(
                children: [
                  SizedBox(
                    width: 250,
                    height: 178,
                    child: Column(
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(20)),
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Column(
                              children: [
                                createPositionTextField(
                                    lat1Controller,
                                    const Text('Lat'),
                                    lat1Focus,
                                    long1Focus,
                                    "xx°xx.x'N",
                                    2,
                                    lat1ErrorMessage, (text) {
                                  List textDegreeArray = text.split('°');
                                  List textMinArray =
                                      textDegreeArray[1].split("'");
                                  setState(() {
                                    if (double.parse(textDegreeArray[0]) > 90) {
                                      lat1ErrorMessage = 'not more than 90';
                                    } else if (double.parse(textMinArray[0]) >=
                                        60) {
                                      lat1ErrorMessage =
                                          "Minutes unit need <60'";
                                    } else {
                                      lat1ErrorMessage = '';
                                    }
                                  });
                                }),
                                createPositionTextField(
                                    long1Controller,
                                    const Text('Long:'),
                                    long1Focus,
                                    lat2Focus,
                                    "xxx°xx.x'W",
                                    3,
                                    long1ErrorMessage, (text) {
                                  List textDegreeArray = text.split('°');
                                  List textMinArray =
                                      textDegreeArray[1].split("'");
                                  setState(() {
                                    if (double.parse(textDegreeArray[0]) >
                                        180) {
                                      long1ErrorMessage = 'not more than 180';
                                    } else if (double.parse(textMinArray[0]) >=
                                        60) {
                                      long1ErrorMessage =
                                          "Minutes unit need <60'";
                                    } else {
                                      long1ErrorMessage = '';
                                    }
                                  });
                                })
                              ],
                            )),
                        const Text('Departure')
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 178,
                    child: Column(
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(20)),
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Column(
                              children: [
                                createPositionTextField(
                                    lat2Controller,
                                    const Text('Lat'),
                                    lat2Focus,
                                    long2Focus,
                                    "xx°xx.x'N",
                                    2,
                                    lat2ErrorMessage, (text) {
                                  List textDegreeArray = text.split('°');
                                  List textMinArray =
                                      textDegreeArray[1].split("'");
                                  setState(() {
                                    if (double.parse(textDegreeArray[0]) > 90) {
                                      lat2ErrorMessage = 'not more than 90';
                                    } else if (double.parse(textMinArray[0]) >=
                                        60) {
                                      lat2ErrorMessage =
                                          "Minutes unit need <60'";
                                    } else {
                                      lat2ErrorMessage = '';
                                    }
                                  });
                                }),
                                createPositionTextField(
                                    long2Controller,
                                    const Text('Long:'),
                                    long2Focus,
                                    lat2Focus,
                                    "xxx°xx.x'W",
                                    3,
                                    long2ErrorMessage, (text) {
                                  List textDegreeArray = text.split('°');
                                  List textMinArray =
                                      textDegreeArray[1].split("'");
                                  setState(() {
                                    if (double.parse(textDegreeArray[0]) >
                                        180) {
                                      long2ErrorMessage = 'not more than 180';
                                    } else if (double.parse(textMinArray[0]) >=
                                        60) {
                                      long2ErrorMessage =
                                          "Minutes unit need <60'";
                                    } else {
                                      long2ErrorMessage = '';
                                    }
                                  });
                                })
                              ],
                            )),
                        const Text('Arrival')
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 223,
                width: 250,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(20)),
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: TextField(
                            controller: distController,
                            focusNode: distFocus,
                            autofocus: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: const Text('Dist:'),
                                hintText: 'NM'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: TextField(
                            controller: courseAngleController,
                            focusNode: courseAngleFocus,
                            autofocus: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: const Text('C:'),
                                hintText: 'degrees'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: TextField(
                            controller: courseController,
                            focusNode: courseFocus,
                            autofocus: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                label: const Text('Cn:'),
                                hintText: 'degrees'),
                          ),
                        )
                      ],
                    )),
              )),
          Positioned(
              bottom: 100,
              right: 0,
              child: Container(
                width: 200,
                height: 300,
                child: DraggableScrollableSheet(
                
                  maxChildSize: 0.9,
                  minChildSize: 0.1,
                  initialChildSize: 0.5,
                  builder: (context, scrollController) {
                    return NestedScrollView(
                      controller: scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          // Add any sliver app bars or headers here if needed
                        ];
                      },
                      body: ListView(
                        children: [
                          ListTile(
                            title: Text('fdfdfdf'),
                          ),
                          Text('34343'),Text('34343'),Text('34343'),Text('34343'),Text('34343'),Text('34343'),Text('34343')
                          ,Text('34343'),Text('34343')
                        ],
                      ),
                    );
                  },
                ),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
                width: 250,
                child: TextField(
                    controller: greatCircleArcController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: const Text('Waypoint:'),
                        hintText: 'distance(miles)'))),
          )
        ],
      ),
    );
  }
}
