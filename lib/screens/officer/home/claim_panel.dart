import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/claim_profile.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/claim_view.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/view_similar_list.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/models/user.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';

class ClaimPanel extends StatefulWidget {
  const ClaimPanel({Key? key, required this.uid, required this.claim})
      : super(key: key);

  final Claim? claim;
  final String? uid;

  @override
  _ClaimPanelState createState() => _ClaimPanelState();
}

class _ClaimPanelState extends State<ClaimPanel> {
  final AuthService _auth = AuthService();
  List<Claim?> similer_claims = [];
  bool loading = true;

  void getSimilerClaims() async {
    DatabaseService db = DatabaseService(uid: widget.uid);
    List<Claim?> similer_claims_list = await db.similerClaimList(
        widget.claim!.claim_id,
        widget.claim!.claim_location.latitude,
        widget.claim!.claim_location.longitude);
    setState(() {
      similer_claims = similer_claims_list;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSimilerClaims();

    // print("similer_claims.length");
    // print(similer_claims.length);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : DefaultTabController(
            length: 3,
            child: Scaffold(
                body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: const Text('View Claim'),
                    backgroundColor: const Color.fromARGB(255, 0, 121, 107),
                    elevation: 0.0,
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
                        color: const Color.fromARGB(255, 143, 142, 61),
                      ),
                      tabs: const [
                        Tab(child: Text('Claim')),
                        Tab(child: Text('Personal')),
                        Tab(child: Text('Similar'))
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  ClaimView(uid: widget.uid, claim: widget.claim),
                  ClaimProfile(
                      uid: widget.claim!.uid, claim_uid: widget.claim!.uid),
                  ViewSimilarList(
                      uid: widget.uid, similer_claims: similer_claims)
                ],
              ),
            )),
          );
  }
}
