import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:property_finder/models/user.dart';
import 'package:property_finder/screens/home.dart';
import 'package:property_finder/widgets/show_progress.dart';

class Profile extends StatefulWidget {
  final String profileId;

  const Profile({Key key, this.profileId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  contactDetailsColumn(IconData icon, String contactDetail) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).accentColor,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(contactDetail, textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }

  buildProfileCard() {
    return FutureBuilder(
      future: usersRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return showProgressIndicator(context);
        }
        // print(snapshot.data.toString());
        User user = User.fromDocument(snapshot.data);
        // print('User name: ${user.displayName}');
        return ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Center(
                    child: Container(
                      // height: 300,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                          ),
                          Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.headline,
                          ),
                          user.bio == null
                              ? SizedBox.shrink()
                              : Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0),
                                  child: Text(user.bio, textAlign: TextAlign.center,),
                                ),
                          contactDetailsColumn(Icons.mail, user.email),
                          user.phoneNumber != null
                              ? contactDetailsColumn(
                                  Icons.phone, user.phoneNumber)
                              : SizedBox.shrink(),
                          SizedBox(height: 22.0,)
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 55.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoUrl),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Houses:',
                    style: Theme.of(context).textTheme.headline,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              height: 130,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
            ),
          ),
          buildProfileCard()
        ],
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {

  // @overide
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(
        size.width / 2, size.height + 10, size.width, size.height - 70);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
