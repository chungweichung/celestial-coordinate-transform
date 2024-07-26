import 'dart:math';

import 'package:celestial_coordinate_transform_web/ce_to_ch.dart';
import 'package:celestial_coordinate_transform_web/ch_to_ce.dart';


import 'great_circle_page.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'ce_and_ch_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            //primarySwatch: Colors.grey,
            ),
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: /*FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('error');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return HomePage();
              }
              return CircularProgressIndicator();
            }));*/
            HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
   //var width = MediaQuery.of(context).size.width;
  Widget currentPage = const CeAndChPage();
  menuTapHandler(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            currentPage = const CeAndChPage();
          }
          break;
        case 1:
          {
            currentPage = GreatCirclePage();
          }
          break;
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          ListTile(
              title: const Text('CE to CH'), onTap: () => menuTapHandler(0)),
          ListTile(onTap: () => menuTapHandler(1))
        ]),
      ),
    );
  }
}

