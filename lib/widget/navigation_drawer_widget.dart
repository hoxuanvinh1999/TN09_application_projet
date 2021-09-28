import 'package:flutter/material.dart';
import 'package:tn09_app_demo/page/cle_page/cle_page.dart';
import 'package:tn09_app_demo/page/collecteur_page/collecteur_page.dart';
import 'package:tn09_app_demo/page/contact_page/contact_page.dart';
import 'package:tn09_app_demo/page/etape_page/etape_page.dart';
import 'package:tn09_app_demo/page/location_page/location_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_page.dart';
import 'package:tn09_app_demo/page/testing_page/testing_page.dart';
import 'package:tn09_app_demo/page/testing_page/testing_search_page.dart';
import 'package:tn09_app_demo/page/vehicule_page/vehicule_page.dart';
//import 'package:http/http.dart' as http;

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(50, 75, 205, 1),
        child: ListView(
          children: <Widget>[
            Container(
              padding: padding,
              child: Column(
                children: [
                  Container(
                    height: 50.0,
                    child: DrawerHeader(
                        child: Text('Menu',
                            style:
                                TextStyle(fontSize: 25, color: Colors.white)),
                        margin: const EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.all(0.0)),
                  ),
                  buildMenuItem(
                    text: 'Collecteur',
                    //icon: Icons.people,
                    onClicked: () => selectedItem(context, 0),
                  ),

                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Planning',
                    //icon: Icons.favorite_border,
                    onClicked: () => selectedItem(context, 1),
                  ),

                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Contact',
                    //icon: Icons.workspaces_outline,
                    onClicked: () => selectedItem(context, 2),
                  ),

                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Location',
                    //icon: Icons.update,
                    onClicked: () => selectedItem(context, 3),
                  ),

                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Vehicule',
                    //icon: Icons.update,
                    onClicked: () => selectedItem(context, 4),
                  ),

                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Cle',
                    //icon: Icons.update,
                    onClicked: () => selectedItem(context, 5),
                  ),

                  const SizedBox(height: 16),
                  //Divider(color: Colors.white70),
                  buildMenuItem(
                    text: 'Etape',
                    //icon: Icons.update,
                    onClicked: () => selectedItem(context, 6),
                  ),

                  const SizedBox(height: 16),
                  //Divider(color: Colors.white70),
                  buildMenuItem(
                    text: 'Testing',
                    //icon: Icons.update,
                    onClicked: () => selectedItem(context, 7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    //required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      //leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CollecteurPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlanningPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ContactPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LocationPage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VehiculePage(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClePage(),
        ));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EtapePage(),
        ));
        break;
      case 7:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TestingSearchPage(),
        ));
        break;
    }
  }
}
