import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TextEditingController quickDesciptionController = TextEditingController();
  TextEditingController desciptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  String houseId = Uuid().v4();
  Position position;
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    super.initState();
  }

  upload() {
    print('Upload');
    // print('$position, $houseId');
  }

  clearImage() {
    print('Cleared');
  }

  getLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String houseLocation =
        '${placemark.subLocality}, ${placemark.locality}, ${placemark.country}';
    locationController.text = houseLocation;
  }

  getMapLocation() {
    print('Enable Google maps you idiot');
  }

  createHouseInFirestore({
    String quickDescription,
    String houseDescription,
    String address,
    String location,
    List<String> media,
  }) {
    // housesRef
    //     .document(widget.currentUser.id)
    //     .collection('houseListings')
    //     .document(houseId)
    //     .setData({
    //   'houseId': houseId,
    //   'ownerId': widget.currentUser.id,
    //   'quickDescription': quickDescription,
    //   'houseDescription': houseDescription,
    //   'address': address,
    //   'location': location,
    //   'timeStamp': timestamp,
    //   // 'geolocation': geolocation,
    //   'mediaUrl': [media],
    // });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#570e43",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => clearImage(),
          ),
          title: Text('Add House'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () => upload(),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
             // Quick description
            Container(
              padding: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Quick Decription',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Form(
                    autovalidate: true,
                    child: TextFormField(
                      validator: (val) {
                        if (val.trim().length > 25) {
                          return 'Description too long';
                        } else {
                          return null;
                        }
                      },
                      controller: quickDesciptionController,
                      decoration: InputDecoration(
                        hintText: 'Quick Decription',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            // Main description
            Container(
              padding: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'House Decription',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Form(
                    autovalidate: true,
                    child: TextFormField(
                      validator: (val) {
                        if (val.trim().length > 150) {
                          return 'Description too long';
                        } else {
                          return null;
                        }
                      },
                      controller: desciptionController,
                      decoration: InputDecoration(
                        hintText: 'House Decription',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            // physical address
            Container(
              padding: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Address',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Form(
                    autovalidate: true,
                    child: TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Physical Address',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            // location (for easy search functionality)
            // edit later for google maps intergration
            Container(
              padding: EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Location',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Form(
                    autovalidate: true,
                    child: TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Location of House',
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: getLocation,
                        child: Text(
                          'Use Current location',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                      RaisedButton(
                        onPressed: getMapLocation,
                        child: Text(
                          'Select location on map',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            // add photo button
            RaisedButton.icon(
              onPressed: loadAssets,
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              label: Text(
                'Add Photo',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
            ),
            Expanded(child: buildGridView()),
          ],
        ),
      ),
    );
  }
}
