import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/create_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/delete_cle.dart';
import 'package:tn09_app_demo/page/cle_page/cle_function/view_information_cle.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/update_contact.dart';
import 'package:tn09_app_demo/page/contact_page/contact_function/view_contact.dart';
import 'package:tn09_app_demo/page/location_page/location_function/build_item_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/view_information_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/create_location.dart';
import 'package:tn09_app_demo/page/location_page/location_function/update_location.dart';
import 'package:tn09_app_demo/page/location_page/location_page.dart';

class ViewLocation extends StatefulWidget {
  String locationKey;
  ViewLocation({required this.locationKey});

  @override
  _ViewLocationState createState() => _ViewLocationState();
}

class _ViewLocationState extends State<ViewLocation> {
  Query _referenceCle = FirebaseDatabase.instance
      .reference()
      .child('Cle')
      .orderByChild('noteCle');
  Query _referenceLocation = FirebaseDatabase.instance
      .reference()
      .child('Location')
      .orderByChild('nomLocation');
  DatabaseReference _refCle =
      FirebaseDatabase.instance.reference().child('Cle');
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Information'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _referenceLocation,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            //print('inside ${widget.locationKey}');
            Map location = snapshot.value;
            location['key'] = snapshot.key;
            if (location['key'] == widget.locationKey) {
              return buildItemLocation(context: context, location: location);
            } else {
              //need to fine other way
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
