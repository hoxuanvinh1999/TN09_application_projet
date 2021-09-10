import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class CreateCle extends StatefulWidget {
  String locationKey;

  CreateCle({required this.locationKey});

  @override
  _CreateCleState createState() => _CreateCleState();
}

class _CreateCleState extends State<CreateCle> {
  TextEditingController _noteCle = TextEditingController();
  String _typeSelected = '';
  String locationKeyValue = '';

  DatabaseReference _refCle =
      FirebaseDatabase.instance.reference().child('Cle');
  DatabaseReference _refLocation =
      FirebaseDatabase.instance.reference().child('Location');
  @override
  Widget _buildCleType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _typeSelected == title
              ? Colors.green
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer Clé'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _noteCle,
              decoration: InputDecoration(
                hintText: 'Note?',
                prefixIcon: Icon(
                  Icons.note,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCleType('Cle'),
                  SizedBox(width: 10),
                  _buildCleType('Badge'),
                  SizedBox(width: 10),
                  _buildCleType('Carte'),
                  SizedBox(width: 10),
                  _buildCleType('Autre'),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Text(
                  'Créer Clé',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  SaveCle();
                },
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  void SaveCle() async {
    String cleTableSecurityPass = 'check';
    DataSnapshot snapshotlocation =
        await _refLocation.child(widget.locationKey).once();
    Map location = snapshotlocation.value;
    String numberofCle = location['nombredecle'];
    numberofCle = (int.parse(numberofCle) + 1).toString();
    Map<String, String> updatelocation = {
      'nombredecle': numberofCle,
    };
    _refLocation.child(widget.locationKey).update(updatelocation);

    String noteCle = _noteCle.text;
    Map<String, String> newcle = {
      'noteCle': noteCle,
      'location_key': widget.locationKey,
      'type': _typeSelected,
    };

    _refCle.push().set(newcle).then((value) {
      Navigator.pop(context);
    });
  }
}
