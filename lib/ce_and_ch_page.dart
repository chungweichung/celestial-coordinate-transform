import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'ce_to_ch_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ch_to_ce_string.dart';
import 'navigation_format_tool.dart';
import 'celectial_horizen_picture.dart';

class CeAndChPage extends StatefulWidget {
  const CeAndChPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CeAndChPageState();
  }
}

class _CeAndChPageState extends State<CeAndChPage> with WidgetsBindingObserver {
  TextEditingController lhaController = TextEditingController();
  TextEditingController decController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController tController = TextEditingController();
  TextEditingController zController = TextEditingController();
  TextEditingController hController = TextEditingController();
  TextEditingController znController = TextEditingController();

  FocusNode lhaFocusNode = FocusNode();
  FocusNode decFocusNode = FocusNode();
  FocusNode latFocusNode = FocusNode();
  FocusNode tFocusNode = FocusNode();
  FocusNode hFocusNode = FocusNode();
  FocusNode zFocusNode = FocusNode();
  FocusNode znFocusNode = FocusNode();

  String latErrorMessage = '';
  String decErrorMessage = '';
  String lhaErrorMessage = '';
  String tErrorMessage = '';
  String hErrorMessage = '';
  String znErrorMessage = '';
  String zErrorMessage = '';

  double lat = 0.0, dec = 0.0, lha = 0.0, t = 0.0, h = 0.0, z = 0.0, zn = 0.0;

  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateWindowSize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateWindowSize() {
    final size = WidgetsBinding.instance.window.physicalSize /
        window.devicePixelRatio.toDouble();
    setState(() {
      windowWidth = size.width;
      windowHeight = size.height;
    });
  }

  @override
  void didChangeMetrics() {
    updateWindowSize();
  }

  void calculateHorizon() {
    setState(() {
      if (tFocusNode.hasFocus == true) {
        lha = -toRadFormat(tController.text) % (pi * 2);
        lhaController.text = toDegMinFormat(lha);
      }
      CelectialEquatorToHorizen toCh = CelectialEquatorToHorizen(
          lat: latController.text,
          dec: decController.text,
          lha: lhaController.text);
      hController.text = toCh.getH;
      zController.text = toCh.getZ;
      znController.text = toCh.getZn;

      lat = toCh.latRad;
      dec = toCh.decRad;
      lha = toCh.lhaRad;
      tController.text = toCh.getT;
      t = toCh.tRad;
      h = toCh.hRad;
      z = toCh.zRad;
    });
  }

  void calculateEquator() {
    setState(() {
      if (zFocusNode.hasFocus == true) {
        znController.text = zToZn(zController.text);
      }
      CelectialHorizenToEquator toCe = CelectialHorizenToEquator(
          lat: latController.text, h: hController.text, zn: znController.text);
      zController.text = toCe.getZ;
      decController.text = toCe.getDec;
      tController.text = toCe.getT;
      lhaController.text = toCe.getLha;
      lat = toCe.latRad;
      dec = toCe.decRad;
      lha = toCe.lhaRad;
      t = toCe.tRad;
      z = toCe.zRad;
      h = toCe.hRad;
    });
  }

  Widget createTextFieldEquator(
      TextEditingController textController,
      Text text,
      FocusNode node,
      FocusNode nextNod,
      String hint,
      int degFormat,
      String errorMessage,
      void Function(String text) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
          calculateHorizon();
        },
        onChanged: onChanged,
      ),
    );
  }

  Widget createTextFieldHorizen(
      TextEditingController textController,
      Text text,
      FocusNode node,
      FocusNode nextNod,
      String hint,
      int degFormat,
      String errorMessage,
      void Function(String text) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: TextField(
        controller: textController,
        focusNode: node,
        autofocus: true,
        inputFormatters: [
          NavgartionInputFormat(howMuchCharNeedSy: degFormat),
          LengthLimitingTextInputFormatter(11)
        ],
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            label: text,
            hintText: hint,
            errorText: errorMessage.isEmpty ? null : errorMessage),
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(node);
          calculateEquator();
        },
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return width <= 540 ? mobileView() : desktopView();
  }

  Widget desktopView() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(20)),
                      //margin: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                      child: SizedBox(
                        width: 540,
                        child: createTextFieldEquator(
                            latController,
                            const Text('L:'),
                            latFocusNode,
                            decFocusNode,
                            "xx°xx.x'N",
                            2,
                            latErrorMessage, (String text) {
                          List textDegreeArray = text.split('°');
                          List textMinArray = textDegreeArray[1].split("'");
                          setState(() {
                            if (double.parse(textDegreeArray[0]) > 90) {
                              latErrorMessage = 'not more than 90';
                            } else if (double.parse(textMinArray[0]) >= 60) {
                              latErrorMessage = "Minutes unit need <60'";
                            } else {
                              latErrorMessage = '';
                            }
                          });
                        }),
                      )),
                  /*Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomPaint(
                  size: const Size(400, 400),
                  painter: CelectialMeridianBase(MediaQuery.of(context).platformBrightness,),
                ),
                CustomPaint(
                  size: const Size(400, 400),
                  painter:
                      CelectialMeridian(lat: lat, dec: dec, t: t, h: h, z: z),
                )
              ],
            ),
                    ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Expanded(child: TextField(controller: decController,)),
                      Column(
                        children: [
                          SizedBox(
                              width: 250,
                              child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(20)),
                                  //margin: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(children: [
                                      createTextFieldEquator(
                                          decController,
                                          const Text('d:'),
                                          decFocusNode,
                                          lhaFocusNode,
                                          "xx°xx.x'N",
                                          2,
                                          decErrorMessage, (String text) {
                                        List textDegreeArray = text.split('°');
                                        List textMinArray =
                                            textDegreeArray[1].split("'");
                                        setState(() {
                                          if (double.parse(textDegreeArray[0]) >
                                              90) {
                                            decErrorMessage =
                                                'not more than 90';
                                          } else if (double.parse(
                                                  textMinArray[0]) >=
                                              60) {
                                            decErrorMessage =
                                                "Minutes unit need <60'";
                                          } else {
                                            decErrorMessage = '';
                                          }
                                        });
                                      }),
                                      createTextFieldEquator(
                                          tController,
                                          const Text('t:'),
                                          tFocusNode,
                                          latFocusNode,
                                          "xxx°xx.x'E",
                                          3,
                                          tErrorMessage, (String text) {
                                        List textDegreeArray = text.split('°');
                                        List textMinArray =
                                            textDegreeArray[1].split("'");
                                        setState(() {
                                          if (double.parse(textDegreeArray[0]) >
                                              180) {
                                            tErrorMessage = 'not more than 180';
                                          } else if (double.parse(
                                                  textMinArray[0]) >=
                                              60) {
                                            tErrorMessage =
                                                "Minutes unit need <60'";
                                          } else {
                                            tErrorMessage = '';
                                          }
                                        });
                                      }),
                                      createTextFieldEquator(
                                          lhaController,
                                          const Text('LHA:'),
                                          lhaFocusNode,
                                          latFocusNode,
                                          "xxx°xx.x'",
                                          3,
                                          lhaErrorMessage, (String text) {
                                        List textDegreeArray = text.split('°');
                                        List textMinArray =
                                            textDegreeArray[1].split("'");
                                        setState(() {
                                          if (double.parse(textDegreeArray[0]) >
                                              360) {
                                            lhaErrorMessage =
                                                'not more than 360';
                                          } else if (double.parse(
                                                  textMinArray[0]) >=
                                              60) {
                                            lhaErrorMessage =
                                                "Minutes unit need <60'";
                                          } else {
                                            lhaErrorMessage = '';
                                          }
                                        });
                                      }),
                                    ]),
                                  ))),
                          const Text('Celestial Equator')
                        ],
                      ),

                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                calculateHorizon();
                              },
                              icon: Icon(Icons.arrow_right_alt_sharp)),
                          Transform.rotate(angle: pi,child: 
                          IconButton(
                              onPressed: () {
                                calculateEquator();
                              },
                              icon: Icon(Icons.arrow_right_alt_sharp)),)
                          
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                              width: 250,
                              child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(20)),
                                  //margin: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(children: [
                                      createTextFieldHorizen(
                                          hController,
                                          const Text('H:'),
                                          hFocusNode,
                                          znFocusNode,
                                          "xx°xx.x'",
                                          2,
                                          hErrorMessage, (String text) {
                                        List textDegreeArray = text.split('°');
                                        List textMinArray =
                                            textDegreeArray[1].split("'");
                                        setState(() {
                                          if (double.parse(textDegreeArray[0]) >
                                              90) {
                                            hErrorMessage = 'not more than 90';
                                          } else if (double.parse(
                                                  textMinArray[0]) >=
                                              60) {
                                            hErrorMessage =
                                                "Minutes unit need <60'";
                                          } else {
                                            hErrorMessage = '';
                                          }
                                        });
                                      }),
                                      createTextFieldHorizen(
                                          zController,
                                          const Text('Az:'),
                                          zFocusNode,
                                          latFocusNode,
                                          "Nxxx°xx.x'E",
                                          4,
                                          zErrorMessage, (String text) {
                                        List textDegreeArray = text.split('°');
                                        List textMinArray =
                                            textDegreeArray[1].split("'");
                                        setState(() {
                                          if (double.parse(textDegreeArray[0]) >
                                              180) {
                                            zErrorMessage = 'not more than 180';
                                          } else if (double.parse(
                                                  textMinArray[0]) >=
                                              60) {
                                            zErrorMessage =
                                                "Minutes unit need <60'";
                                          } else {
                                            zErrorMessage = '';
                                          }
                                        });
                                      }),
                                      createTextFieldHorizen(
                                          znController,
                                          const Text('Zn:'),
                                          znFocusNode,
                                          latFocusNode,
                                          "xxx°xx.x'",
                                          3,
                                          znErrorMessage, (String text) {
                                        List textDegreeArray = text.split('°');
                                        List textMinArray =
                                            textDegreeArray[1].split("'");
                                        setState(() {
                                          if (double.parse(textDegreeArray[0]) >
                                              360) {
                                            znErrorMessage =
                                                'not more than 360';
                                          } else if (double.parse(
                                                  textMinArray[0]) >=
                                              60) {
                                            znErrorMessage =
                                                "Minutes unit need <60'";
                                          } else {
                                            znErrorMessage = '';
                                          }
                                        });
                                      }),
                                    ]),
                                  ))),
                          const Text('Celestial Horizen')
                        ],
                      )
                    ],
                  )
                ]),
          ),
        ));
  }

  Widget mobileView() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(20)),
                        //margin: const EdgeInsets.fromLTRB(50, 50, 50, 30),
                        child: SizedBox(
                          width: 250,
                          child: createTextFieldEquator(
                              latController,
                              const Text('L:'),
                              latFocusNode,
                              decFocusNode,
                              "xx°xx.x'N",
                              2,
                              latErrorMessage, (String text) {
                            List textDegreeArray = text.split('°');
                            List textMinArray = textDegreeArray[1].split("'");
                            setState(() {
                              if (double.parse(textDegreeArray[0]) > 90) {
                                latErrorMessage = 'not more than 90';
                              } else if (double.parse(textMinArray[0]) >= 60) {
                                latErrorMessage = "Minutes unit need <60'";
                              } else {
                                latErrorMessage = '';
                              }
                            });
                          }),
                        )),
                    /*Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CustomPaint(
                    size: const Size(400, 400),
                    painter: CelectialMeridianBase(MediaQuery.of(context).platformBrightness,),
                  ),
                  CustomPaint(
                    size: const Size(400, 400),
                    painter:
                        CelectialMeridian(lat: lat, dec: dec, t: t, h: h, z: z),
                  )
                ],
              ),
                      ),*/
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Expanded(child: TextField(controller: decController,)),
                        Column(
                          children: [
                            SizedBox(
                                width: 250,
                                child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                20)),
                                    //margin: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(children: [
                                        createTextFieldEquator(
                                            decController,
                                            const Text('d:'),
                                            decFocusNode,
                                            lhaFocusNode,
                                            "xx°xx.x'N",
                                            2,
                                            decErrorMessage, (String text) {
                                          List textDegreeArray =
                                              text.split('°');
                                          List textMinArray =
                                              textDegreeArray[1].split("'");
                                          setState(() {
                                            if (double.parse(
                                                    textDegreeArray[0]) >
                                                90) {
                                              decErrorMessage =
                                                  'not more than 90';
                                            } else if (double.parse(
                                                    textMinArray[0]) >=
                                                60) {
                                              decErrorMessage =
                                                  "Minutes unit need <60'";
                                            } else {
                                              decErrorMessage = '';
                                            }
                                          });
                                        }),
                                        createTextFieldEquator(
                                            tController,
                                            const Text('t:'),
                                            tFocusNode,
                                            latFocusNode,
                                            "xxx°xx.x'E",
                                            3,
                                            tErrorMessage, (String text) {
                                          List textDegreeArray =
                                              text.split('°');
                                          List textMinArray =
                                              textDegreeArray[1].split("'");
                                          setState(() {
                                            if (double.parse(
                                                    textDegreeArray[0]) >
                                                180) {
                                              tErrorMessage =
                                                  'not more than 180';
                                            } else if (double.parse(
                                                    textMinArray[0]) >=
                                                60) {
                                              tErrorMessage =
                                                  "Minutes unit need <60'";
                                            } else {
                                              tErrorMessage = '';
                                            }
                                          });
                                        }),
                                        createTextFieldEquator(
                                            lhaController,
                                            const Text('LHA:'),
                                            lhaFocusNode,
                                            latFocusNode,
                                            "xxx°xx.x'",
                                            3,
                                            lhaErrorMessage, (String text) {
                                          List textDegreeArray =
                                              text.split('°');
                                          List textMinArray =
                                              textDegreeArray[1].split("'");
                                          setState(() {
                                            if (double.parse(
                                                    textDegreeArray[0]) >
                                                360) {
                                              lhaErrorMessage =
                                                  'not more than 360';
                                            } else if (double.parse(
                                                    textMinArray[0]) >=
                                                60) {
                                              lhaErrorMessage =
                                                  "Minutes unit need <60'";
                                            } else {
                                              lhaErrorMessage = '';
                                            }
                                          });
                                        }),
                                      ]),
                                    ))),
                            const Text('Celestial Equator')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(angle: pi/2,child: 
                          IconButton(
                              onPressed: () {
                                calculateHorizon();
                              },
                              icon: Icon(Icons.arrow_right_alt_sharp))
                          ),
                          Transform.rotate(angle: -pi/2,child: 
                          IconButton(
                              onPressed: () {
                                calculateEquator();
                              },
                              icon: Icon(Icons.arrow_right_alt_sharp)),)
                          
                        ],
                      ),
                        Column(
                          children: [
                            SizedBox(
                                width: 250,
                                child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                20)),
                                    //margin: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(children: [
                                        createTextFieldHorizen(
                                            hController,
                                            const Text('H:'),
                                            hFocusNode,
                                            znFocusNode,
                                            "xx°xx.x'",
                                            2,
                                            hErrorMessage, (String text) {
                                          List textDegreeArray =
                                              text.split('°');
                                          List textMinArray =
                                              textDegreeArray[1].split("'");
                                          setState(() {
                                            if (double.parse(
                                                    textDegreeArray[0]) >
                                                90) {
                                              hErrorMessage =
                                                  'not more than 90';
                                            } else if (double.parse(
                                                    textMinArray[0]) >=
                                                60) {
                                              hErrorMessage =
                                                  "Minutes unit need <60'";
                                            } else {
                                              hErrorMessage = '';
                                            }
                                          });
                                        }),
                                        createTextFieldHorizen(
                                            zController,
                                            const Text('Az:'),
                                            zFocusNode,
                                            latFocusNode,
                                            "Nxxx°xx.x'E",
                                            4,
                                            zErrorMessage, (String text) {
                                          List textDegreeArray =
                                              text.split('°');
                                          List textMinArray =
                                              textDegreeArray[1].split("'");
                                          setState(() {
                                            if (double.parse(
                                                    textDegreeArray[0]) >
                                                180) {
                                              zErrorMessage =
                                                  'not more than 180';
                                            } else if (double.parse(
                                                    textMinArray[0]) >=
                                                60) {
                                              zErrorMessage =
                                                  "Minutes unit need <60'";
                                            } else {
                                              zErrorMessage = '';
                                            }
                                          });
                                        }),
                                        createTextFieldHorizen(
                                            znController,
                                            const Text('Zn:'),
                                            znFocusNode,
                                            latFocusNode,
                                            "xxx°xx.x'",
                                            3,
                                            znErrorMessage, (String text) {
                                          List textDegreeArray =
                                              text.split('°');
                                          List textMinArray =
                                              textDegreeArray[1].split("'");
                                          setState(() {
                                            if (double.parse(
                                                    textDegreeArray[0]) >
                                                360) {
                                              znErrorMessage =
                                                  'not more than 360';
                                            } else if (double.parse(
                                                    textMinArray[0]) >=
                                                60) {
                                              znErrorMessage =
                                                  "Minutes unit need <60'";
                                            } else {
                                              znErrorMessage = '';
                                            }
                                          });
                                        }),
                                      ]),
                                    ))),
                            const Text('Celestial Horizen')
                          ],
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ));
  }
}
