import 'package:crop_damage_assessment_app/screens/officer/home/officer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/officer/home/claim_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/decoration.dart';
import '../../../services/auth.dart';

class ViewClaimList extends StatefulWidget {
  const ViewClaimList({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _ViewClaimListState createState() => _ViewClaimListState();
}

class _ViewClaimListState extends State<ViewClaimList> {
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = "";

  final List<String> claim_states = ['Pending', 'Approve', 'Reject'];

  // form values
  String currentState = 'Pending';
  String agrarian_division = 'galle';

  final List<String> agrarian_Division_Options = ['galle', 'matara', 'kandy'];
  void initFilter() async {
    final preference = await SharedPreferences.getInstance();
    currentState = preference.getString('claim_state')!;
    agrarian_division = preference.getString('agrarian_division')!;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initFilter();
  }

  @override
  Widget build(BuildContext context) {
    var claims = Provider.of<List<Claim?>>(context);

    return loading
        ? const Loading()
        : Column(
            children: [
              SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 00.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        DropdownButtonFormField(
                          value: currentState,
                          decoration: textInputDecoration,
                          items: claim_states.map((claim_state_option) {
                            return DropdownMenuItem(
                              value: claim_state_option,
                              child: Text(claim_state_option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              currentState = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        DropdownButtonFormField(
                          value: agrarian_division,
                          decoration: textInputDecoration,
                          items: agrarian_Division_Options
                              .map((agrarian_division_option) {
                            return DropdownMenuItem(
                              value: agrarian_division_option,
                              child: Text(agrarian_division_option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              agrarian_division = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                          ElevatedButton(
                       child: const Text('Set Filtering'),
                     style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 71, 143, 75), // background
                              onPrimary: Colors.white, // foreground
                              textStyle: const TextStyle(fontSize:15),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 40.0),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                final preference =
                                    await SharedPreferences.getInstance();
                                await preference.setString(
                                    "claim_state", currentState);
                                await preference.setString(
                                    "agrarian_division", agrarian_division);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OfficerDashboard(uid: widget.uid),
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                  )),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                    child: claims.isNotEmpty
                        ? ListView.builder(
                            itemCount: claims.length,
                            itemBuilder: (context, index) {
                              return ClaimTile(
                                  uid: widget.uid, claim: claims[index]);
                            },
                          )
                        : const Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Empty",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Color.fromARGB(255, 80, 79, 79)),
                            ))),
              ),
            ],
          );
  }
}
