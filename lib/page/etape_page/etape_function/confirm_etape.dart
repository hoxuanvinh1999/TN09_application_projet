import 'package:flutter/material.dart';
import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/build_choice_location_etape.dart';
import 'package:tn09_app_demo/math_function/is_numeric_function.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/create_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_function/show_etape.dart';
import 'package:tn09_app_demo/page/etape_page/etape_page.dart';
import 'package:tn09_app_demo/page/home_page/home_page.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/cancel_creating_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/choice_vehicule_planning.dart';
import 'package:tn09_app_demo/page/planning_page/planning_function/open_list_etape_planning.dart';
import 'package:tn09_app_demo/widget/button_widget.dart';

class ConfirmEtape extends StatefulWidget {
  Map location;
  String reason;
  String numberofEtape;
  ConfirmEtape(
      {required this.location,
      required this.reason,
      required this.numberofEtape});
  @override
  _ConfirmEtapeState createState() => _ConfirmEtapeState();
}

class _ConfirmEtapeState extends State<ConfirmEtape> {
  final _etapeKeyForm = GlobalKey<FormState>();
  String material_Etape = 'biodechet';
  List<String> listmaterial = ['biodechet', 'papier', 'verre'];
  TextEditingController _noteEtape = TextEditingController();
  DatabaseReference referenceEtape =
      FirebaseDatabase.instance.reference().child('Etape');
  DatabaseReference referenceLocation =
      FirebaseDatabase.instance.reference().child('Location');
  DatabaseReference referenceTotalInformation =
      FirebaseDatabase.instance.reference().child('TotalInformation');

  String title = '';
  Widget setTitle() {
    if (widget.reason == 'confirmEtape') {
      return Text('Confirm Creaation Etape');
    } else {
      return Text('Creating Planning...');
    }
  }

  bool checkProgression() {
    if (widget.reason == 'confirmEtape') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> dialogDecide(BuildContext context) async {
    if (widget.reason == 'confirmEtape') {
      return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Cancel Create New Etape?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  )
                ],
              ));
    } else {
      return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Cancel Create New Planning?'),
                actions: [
                  ElevatedButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      deleteCreatingPlanningProcess();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final goback = await dialogDecide(context);
        return goback ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: setTitle(),
        ),
        body: Container(
            margin: EdgeInsets.all(15),
            height: double.infinity,
            child: Form(
              key: _etapeKeyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                          'Nom de la Location: ' +
                              widget.location['nomLocation'],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.restore_from_trash,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Material: ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 6,
                      ),
                      DropdownButton(
                          value: material_Etape,
                          items: listmaterial.map((String item) {
                            return DropdownMenuItem<String>(
                              child: Text('$item'),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              material_Etape = value.toString();
                            });
                          },
                          hint: Text("Select type of material")),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.sticky_note_2,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text('Note: ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 50,
                    child: TextFormField(
                      controller: _noteEtape,
                      decoration: const InputDecoration(
                        hintText: 'Note',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Visibility(
                      visible: checkProgression(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          child: Text(
                            'Créer Etape',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            if (_etapeKeyForm.currentState!.validate()) {
                              SaveEtape(state: widget.reason);
                            }
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      )),
                  Visibility(
                      visible: !checkProgression(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          child: Text(
                            'Continue with new Etape',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            if (_etapeKeyForm.currentState!.validate()) {
                              SaveEtape(state: 'newEtape');
                            }
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Visibility(
                      visible: !checkProgression(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          child: Text(
                            'Continue with avalable Etape',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            if (_etapeKeyForm.currentState!.validate()) {
                              SaveEtape(state: 'availableEtape');
                            }
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Visibility(
                      visible: !checkProgression(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: RaisedButton(
                          child: Text(
                            'End?',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            if (_etapeKeyForm.currentState!.validate()) {
                              SaveEtape(state: 'endPlanning');
                            }
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      ))
                ],
              ),
            )),
      ),
    );
  }

  void SaveEtape({required String state}) async {
    String nomLocationEtape = widget.location['nomLocation'];
    String addressLocationEtape = widget.location['addressLocation'];
    String location_key = widget.location['key'];
    String contact_key = widget.location['contact_key'];
    String materialEtape = material_Etape;
    String nombredebac = widget.location['nombredebac'];
    String noteEtape = _noteEtape.text;
    String beforeEtape_key = '';
    String afterEtape_key = '';
    String startEtape_key = '';
    int i = 0;
    if (state == 'confirmEtape') {
      beforeEtape_key = 'null';
      afterEtape_key = 'null';
      Map<String, String> etape = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'false',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': afterEtape_key,
        'showed': 'false',
      };
      await referenceTotalInformation.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          Map<String, String> totalInformation = {
            'nombredeEtape':
                (int.parse(values['nombredeEtape']) + 1).toString(),
          };
          referenceTotalInformation.child(key).update(totalInformation);
        });
      });
      referenceEtape.push().set(etape).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShowEtape()),
        );
      });
    } else if (widget.reason == 'createPlanning' && state != 'endPlanning') {
      if (state == 'newEtape') {
        await referenceLocation.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> check_location = snapshot.value;
          check_location.forEach((key, values) {
            if (values['showed'] == 'false') {
              i++;
            }
          });
        });
      }
      if (state == 'availableEtape') {
        await referenceEtape.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> check_etape = snapshot.value;
          check_etape.forEach((key, values) {
            if (values['showed'] == 'false') {
              i++;
            }
          });
        });
      }
      print(' i = $i');
      if (i == 1) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title:
                      Text('We used all Location or Etape available, finish?'),
                  actions: [
                    ElevatedButton(
                      child: Text('Ok'),
                      onPressed: () {
                        SaveEtape(state: 'endPlanning');
                      },
                    ),
                    ElevatedButton(
                      child: Text('Cancel planning'),
                      onPressed: () {
                        deleteCreatingPlanningProcess();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    )
                  ],
                ));
      } else {
        await referenceLocation.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> location = snapshot.value;
          location.forEach((key, values) {
            if (key == widget.location['key']) {
              Map<String, String> update_location = {
                'showed': 'true',
              };
              referenceLocation.child(key).update(update_location);
            }
          });
        });
        beforeEtape_key = 'start';
        afterEtape_key = 'wait';
        String numberofEtape = widget.numberofEtape;
        numberofEtape = (int.parse(numberofEtape) + 1).toString();
        Map<String, String> etape = {
          'nomLocationEtape': nomLocationEtape,
          'addressLocationEtape': addressLocationEtape,
          'location_key': location_key,
          'contact_key': contact_key,
          'materialEtape': materialEtape,
          'nombredebac': nombredebac,
          'checked': 'creating',
          'reason_not_checked': '',
          'noteEtape': noteEtape,
          'dateEtape': '',
          'beforeEtape_key': beforeEtape_key,
          'afterEtape_key': afterEtape_key,
          'showed': 'true',
        };

        referenceEtape.push().set(etape).then((value) {
          if (state == 'newEtape') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateEtape(
                        reason: 'continuePlanning',
                        numberofEtape: numberofEtape,
                      )),
            );
          } else if (state == 'availableEtape') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpenListEtape(
                        reason: 'continuePlanning',
                        numberofEtape: numberofEtape,
                      )),
            );
          }
        });
      }
    } else if (widget.reason == 'createPlanning' && state == 'endPlanning') {
      beforeEtape_key = 'start';
      afterEtape_key = 'null';
      Map<String, String> etape = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'false',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': afterEtape_key,
        'showed': 'true',
      };

      referenceEtape.push().set(etape);

      await referenceTotalInformation.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> information = snapshot.value;
        information.forEach((key, values) {
          Map<String, String> totalInformation = {
            'nombredeEtape': (int.parse(values['nombredeEtape']) +
                    int.parse(widget.numberofEtape) +
                    1)
                .toString(),
          };
          referenceTotalInformation.child(key).update(totalInformation);
        });
      });

      DatabaseReference referenceEndEtape =
          FirebaseDatabase.instance.reference().child('Etape');

      await referenceEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['beforeEtape_key'] == 'start') {
            print('Into If right');
            startEtape_key = key;
            Map<String, String> planning = {
              'startetape_key': startEtape_key,
              'finished_create': 'false',
              'nombredeEtape': (int.parse(widget.numberofEtape) + 1).toString(),
            };
            FirebaseDatabase.instance
                .reference()
                .child('Planning')
                .push()
                .set(planning);
            Map<String, String> endetape = {
              'beforeEtape_key': 'null',
            };
            referenceEtape.child(key).update(endetape).then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChoiceVehiculePlanning(
                          reason: 'createPlanning',
                        )),
              );
            });
          }
        });
      });
    } else if (widget.reason == 'continuePlanning' && state != 'endPlanning') {
      if (state == 'newEtape') {
        await referenceLocation.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> check_location = snapshot.value;
          check_location.forEach((key, values) {
            if (values['showed'] == 'false') {
              i++;
            }
          });
        });
      }
      if (state == 'availableEtape') {
        await referenceEtape.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> check_etape = snapshot.value;
          check_etape.forEach((key, values) {
            if (values['showed'] == 'false') {
              i++;
            }
          });
        });
      }
      print(' i = $i');
      if (i == 1) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title:
                      Text('We used all location or Etape available, finish?'),
                  actions: [
                    ElevatedButton(
                      child: Text('Ok'),
                      onPressed: () {
                        SaveEtape(state: 'endPlanning');
                      },
                    ),
                    ElevatedButton(
                      child: Text('Cancel planning'),
                      onPressed: () {
                        deleteCreatingPlanningProcess();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    )
                  ],
                ));
      } else {
        await referenceLocation.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> location = snapshot.value;
          location.forEach((key, values) {
            if (key == widget.location['key']) {
              Map<String, String> update_location = {
                'showed': 'true',
              };
              referenceLocation.child(key).update(update_location);
            }
          });
        });
        String numberofEtape = widget.numberofEtape;
        numberofEtape = (int.parse(numberofEtape) + 1).toString();
        DatabaseReference referenceContinueEtape =
            FirebaseDatabase.instance.reference().child('Etape');
        await referenceContinueEtape.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> etape = snapshot.value;
          etape.forEach((key, values) {
            if (values['afterEtape_key'] == 'wait') {
              print('Into If right');
              beforeEtape_key = key;
            }
          });
        });
        Map<String, String> newetape_1 = {
          'nomLocationEtape': nomLocationEtape,
          'addressLocationEtape': addressLocationEtape,
          'location_key': location_key,
          'contact_key': contact_key,
          'materialEtape': materialEtape,
          'nombredebac': nombredebac,
          'checked': 'creating',
          'reason_not_checked': '',
          'noteEtape': noteEtape,
          'dateEtape': '',
          'beforeEtape_key': beforeEtape_key,
          'afterEtape_key': 'waitting',
          'showed': 'true',
        };

        referenceEtape.push().set(newetape_1);

        await referenceContinueEtape.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> etape = snapshot.value;
          etape.forEach((key, values) {
            if (values['afterEtape_key'] == 'waitting') {
              print('Into If right');
              afterEtape_key = key;
            }
          });
        });
        await referenceContinueEtape.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> etape = snapshot.value;
          etape.forEach((key, values) {
            if (values['afterEtape_key'] == 'wait') {
              print('Into If right');
              Map<String, String> oldetape = {
                'afterEtape_key': afterEtape_key,
              };
              referenceEtape.child(key).update(oldetape);
            }
          });
        });
        await referenceContinueEtape.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> etape = snapshot.value;
          etape.forEach((key, values) {
            if (values['afterEtape_key'] == 'waitting') {
              print('Into If right');
              Map<String, String> newetape_2 = {
                'afterEtape_key': 'wait',
              };
              referenceEtape.child(key).update(newetape_2);
            }
          });
        });
        if (state == 'newEtape') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateEtape(
                      reason: 'continuePlanning',
                      numberofEtape: numberofEtape,
                    )),
          );
        } else if (state == 'availableEtape') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpenListEtape(
                      reason: 'continuePlanning',
                      numberofEtape: numberofEtape,
                    )),
          );
        }
      }
    } else if (state == 'endPlanning') {
      DatabaseReference referenceEndEtape =
          FirebaseDatabase.instance.reference().child('Etape');
      await referenceEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            beforeEtape_key = key;
          }
        });
      });
      Map<String, String> newetape_1 = {
        'nomLocationEtape': nomLocationEtape,
        'addressLocationEtape': addressLocationEtape,
        'location_key': location_key,
        'contact_key': contact_key,
        'materialEtape': materialEtape,
        'nombredebac': nombredebac,
        'checked': 'creating',
        'reason_not_checked': '',
        'noteEtape': noteEtape,
        'dateEtape': '',
        'beforeEtape_key': beforeEtape_key,
        'afterEtape_key': 'waitting',
        'planning_key': 'null',
        'showed': 'true',
      };

      referenceEtape.push().set(newetape_1);

      await referenceEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            afterEtape_key = key;
          }
        });
      });
      await referenceEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'wait') {
            print('Into If right');
            Map<String, String> oldetape = {
              'afterEtape_key': afterEtape_key,
            };
            referenceEtape.child(key).update(oldetape);
          }
        });
      });
      await referenceEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['afterEtape_key'] == 'waitting') {
            print('Into If right');
            Map<String, String> newetape_2 = {
              'afterEtape_key': 'null',
            };
            referenceEtape.child(key).update(newetape_2);
          }
        });
      });

      await referenceTotalInformation.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> information = snapshot.value;
        information.forEach((key, values) {
          Map<String, String> totalInformation = {
            'nombredeEtape': (int.parse(values['nombredeEtape']) +
                    int.parse(widget.numberofEtape) +
                    1)
                .toString(),
          };
          referenceTotalInformation.child(key).update(totalInformation);
        });
      });

      await referenceEndEtape.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> etape = snapshot.value;
        etape.forEach((key, values) {
          if (values['beforeEtape_key'] == 'start') {
            print('Into If right');
            startEtape_key = key;
            Map<String, String> planning = {
              'startetape_key': startEtape_key,
              'finished_create': 'false',
              'nombredeEtape': (int.parse(widget.numberofEtape) + 1).toString(),
            };
            Map<String, String> endetape = {
              'beforeEtape_key': 'null',
            };
            referenceEtape.child(key).update(endetape);
            FirebaseDatabase.instance
                .reference()
                .child('Planning')
                .push()
                .set(planning)
                .then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChoiceVehiculePlanning(reason: 'createPlanning')),
              );
            });
          }
        });
      });
    }
  }
}
