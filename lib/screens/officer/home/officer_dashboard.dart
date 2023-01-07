import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/filter.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/edit_officer.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/view_claim_list.dart';

class OfficerDashboard extends StatefulWidget {
  const OfficerDashboard({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _OfficerDashboardState createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends State<OfficerDashboard> {
  final AuthService _auth = AuthService();
  late DatabaseService db;
  bool loading = true;

  var filter = {"claim_state": "", "agrarian_division": ""};

  void initOfficerClaimList() async {
    db = DatabaseService(uid: widget.uid);
    db.set_select_uid = widget.uid!;

    final preference = await SharedPreferences.getInstance();
    filter["claim_state"] = preference.getString('claim_state') ?? "Pending";
    filter["agrarian_division"] = preference.getString('agrarian_division') ?? "galle";
    setState(() {
      loading = false;
    });
  }

  // void _showSettingsPanel(BuildContext context) {
  //   // showModalBottomSheet(
  //   //     context: context,
  //   //     isScrollControlled: true,
  //   //     builder: (context) {
  //   //       return Container(
  //   //         padding:
  //   //             const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
  //   //         child: Filter(uid: widget.uid),
  //   //       );
  //   //     });
  // }

  @override
  void initState() {
    super.initState();
    initOfficerClaimList();
    print(filter);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : StreamProvider<List<Claim?>>.value(
            value: db.officerClaimList(filter["claim_state"], filter["agrarian_division"]),
            initialData: const [],
            child: Scaffold(
              body: NestedScrollView( headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                          title: const Text('Crop Assister - Officer'),
                          backgroundColor: const Color.fromARGB(255, 201, 195, 117),
                          elevation: 0.0,
                          actions: <Widget>[
                            // IconButton(
                            //   icon: const Icon(Icons.settings),
                            //   onPressed: () => _showSettingsPanel(context),
                            // ),
                            IconButton(
                                icon: const Icon(Icons.power_settings_new),
                                onPressed: () async {
                                  await _auth.signoutUser(widget.key, context);
                                }
                            ),
                          ],
                          pinned: true,
                          floating: true),
                    ];
                  },
                  body: ViewClaimList(uid: widget.uid)),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 201, 195, 117),
                      ),
                      child: Text('Crop Assister'),
                    ),
                    ListTile(
                      title: const Text('Settings'),
                      onTap: () async {
                        final filter_result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Filter(uid: widget.uid)));

                        if (filter_result != null && filter_result) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => super.widget));
                        }
                      },
                    ),

                    ListTile(
                        title: const Text('Edit Profile'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OfficerEditData(uid: widget.uid)),
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
  }
}
