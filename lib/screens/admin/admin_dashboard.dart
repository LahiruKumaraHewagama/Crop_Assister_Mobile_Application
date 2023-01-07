import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:crop_damage_assessment_app/screens/admin/view_officer_list.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:provider/provider.dart';

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

  void initAdmin() async {
    db = DatabaseService(uid: widget.uid);
    db.set_select_uid = widget.uid!;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : StreamProvider<List<Officer?>>.value(
            value: db.officerList,
            initialData: const [],
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        title: const Text('Crop Assister - Admin'),
                        backgroundColor:
                            const Color.fromARGB(255, 115, 162, 177),
                        elevation: 0.0,
                        // automaticallyImplyLeading: false,
                        actions: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.power_settings_new),
                              onPressed: () async {
                                await _auth.signoutUser(widget.key, context);
                              })
                        ],
                        pinned: true,
                        floating: true,
                        bottom: TabBar(
                          isScrollable: true,
                          indicatorPadding: const EdgeInsets.all(10),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: const Color.fromARGB(255, 41, 93, 100),
                          ),
                          tabs: const [
                            Tab(child: Text('View Officers')),
                            Tab(child: Text('Pending Officer'))
                          ],
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: <Widget>[
                      ViewOfficerList(uid: widget.uid, officer_type: "officer"),
                      ViewOfficerList(uid: widget.uid, officer_type: "officer_pending")
                    ],
                  ),
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 115, 162, 177),
                        ),
                        child: Text('Crop Assister'),
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
            ));
  }
}
