// import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';
import 'package:property_finder/screens/home.dart';
// import 'package:property_finder/signin.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        fontFamily: 'Source Sans Pro',
        accentColor: Colors.yellow[900],
        primaryColor: Colors.blue[800],
        backgroundColor: Colors.grey[350],

        textTheme: TextTheme(
          headline: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
            fontSize: 16.0,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}