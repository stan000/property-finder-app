import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:property_finder/models/user.dart';
import 'package:property_finder/screens/add.dart';
import 'package:property_finder/screens/landing.dart';
import 'package:property_finder/screens/notifications.dart';
import 'package:property_finder/screens/profile.dart';
import 'package:property_finder/screens/signin.dart';

final DateTime timestamp = DateTime.now();
final googleSignIn = GoogleSignIn();
final storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection('users');
final housesRef = Firestore.instance.collection('houses');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController = PageController();
  int pageIndex = 0;
  User currentUser;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignin(account);
    });
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignin(account);
    });
  }

  handleSignin(account) {
    if (account != null) {
      createUserInFirestore();
      // print('User id: ${currentUser.id}');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    GoogleSignInAccount googleAccount = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(googleAccount.id).get();

    if (!doc.exists) {
      usersRef.document(googleAccount.id).setData({
        'id': googleAccount.id,
        'displayName': googleAccount.displayName,
        'photoUrl': googleAccount.photoUrl,
        'email': googleAccount.email,
        'bio': '',
        'phoneNumber': null,
        'timestamp': timestamp,
      });
    doc = await usersRef.document(googleAccount.id).get();
    }
    currentUser = User.fromDocument(doc);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  changePage(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  animateToPage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Scaffold authScreen() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (pageIndex) => changePage(pageIndex),
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          LandingPage(),
          AddNew(currentUser: currentUser),
          Notifications(),
          Profile(profileId: currentUser?.id),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: Theme.of(context).primaryColor,
        currentIndex: pageIndex,
        onTap: (pageIndex) => animateToPage(pageIndex),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.add)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? authScreen() : Signin();
  }
}
