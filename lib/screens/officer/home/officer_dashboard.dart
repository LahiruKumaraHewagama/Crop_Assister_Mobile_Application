import 'package:crop_damage_assessment_app/screens/officer/home/update_password.dart';
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
    filter["agrarian_division"] =
        preference.getString('agrarian_division') ?? "galle";
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
    return loading
        ? const Loading()
        : StreamProvider<List<Claim?>>.value(
            value: db.officerClaimList(
                filter["claim_state"], filter["agrarian_division"]),
            initialData: const [],
            child: Scaffold(
              body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                          title: const Text('Crop Assister - Officer'),
                          backgroundColor:
                              const Color.fromARGB(255, 105, 184, 109),
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
                                }),
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
                    const SizedBox(height: 1.0),
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                          const SizedBox(height: 5.0),
                              Container(
                        alignment: Alignment.centerLeft,
                          width: 300,
                          height:1 , 
                          color: Color.fromARGB(255, 45, 46, 46)  ),
                    ListTile(
                      title: const Text('Update Password'),
                      onTap: () async {
                        final filter_result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdatePassword(uid: widget.uid)));

                        if (filter_result != null && filter_result) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
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
