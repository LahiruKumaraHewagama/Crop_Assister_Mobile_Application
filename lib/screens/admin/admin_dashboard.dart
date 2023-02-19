import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:crop_damage_assessment_app/screens/admin/add_officers.dart';
import 'package:crop_damage_assessment_app/screens/admin/view_officer_list.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../officer/add_officer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _auth = AuthService();

  late DatabaseService db;

  bool loading = true;
  var filter = {"user_type": "officer"};

  void initOfficerClaimList() async {
    db = DatabaseService(uid: widget.uid);
    db.set_select_uid = widget.uid!;

    final preference = await SharedPreferences.getInstance();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initOfficerClaimList();
    print(filter);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Officer?>>.value(
        value: db.officerList,
        initialData: const [],
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                          title: const Text('Crop Assister - Admin'),
                          backgroundColor:
                              const Color.fromARGB(255, 122, 156, 122),
                          elevation: 0.0,
                          // automaticallyImplyLeading: false,
                          actions: <Widget>[
                            IconButton(
                                icon: const Icon(Icons.power_settings_new),
                                onPressed: () async {
                                  await _auth.signoutUser(widget.key, context);
                                })
                          ])
                    ];
                  },
                  body: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 50.0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 1.0),
                        Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                        const SizedBox(height: 5.0),
                        const Text('WELCOME',
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 30,
                                color: Color.fromARGB(255, 4, 92, 9))),
                        const SizedBox(height: 10.0),
                        const SizedBox(height: 25.0),
                        ElevatedButton(
                          child: const Text('Add New Officer'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(
                                255, 71, 143, 75), // background
                            onPrimary: Colors.white, // foreground
                            textStyle: const TextStyle(fontSize: 20),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 50.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddOfficer()),
                            );
                          },
                        ),
                        Expanded(
                          child: ViewOfficerList(
                            uid: widget.uid,
                            officer_type: 'officer',
                          ),
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  )),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 105, 184, 109),
                      ),
                      child: Text('Crop Assister'),
                    ),
                    ListTile(
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminDashboard(uid: widget.uid)),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Add Officers'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddOfficer()),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Logout'),
                      onTap: () async {
                        await _auth.signoutUser(widget.key, context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
