import 'dart:math';

import 'package:celestial_coordinate_transform_web/ce_to_ch.dart';
import 'package:celestial_coordinate_transform_web/ch_to_ce.dart';


import 'great_circle_page.dart';
import 'package:flutter/material.dart';
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
        /*theme: ThemeData(
            primarySwatch: Colors.grey,
            primaryColor: Colors.grey,
            
            scaffoldBackgroundColor:Colors.black,
            colorScheme: ColorScheme.light().copyWith(primary: Colors.grey)
            ),
        darkTheme: ThemeData(brightness: Brightness.dark),*/
        
        home:HomePage());
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
    return const CeAndChPage();/*Scaffold(
      body: currentPage,
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          ListTile(
              title: const Text('CE to CH'), onTap: () => menuTapHandler(0)),
          ListTile(onTap: () => menuTapHandler(1))
        ]),
      ),
    );*/
  }
}

