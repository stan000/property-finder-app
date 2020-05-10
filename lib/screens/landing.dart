import 'package:flutter/material.dart';
import 'package:property_finder/screens/home.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: RaisedButton(
            onPressed: () => googleSignIn.signOut(),
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }
}
