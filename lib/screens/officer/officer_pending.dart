import 'package:crop_damage_assessment_app/screens/farmer/sign_up_farmer.dart';
import 'package:crop_damage_assessment_app/screens/officer/add_officer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';

class OfficerPending extends StatefulWidget {
  const OfficerPending({Key? key, required this.uid, required this.phone_no}) : super(key: key);

  final String? uid;
  final String? phone_no;

  @override
  _OfficerPendingState createState() => _OfficerPendingState();
}

class _OfficerPendingState extends State<OfficerPending> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth_in = FirebaseAuth.instance;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            appBar: AppBar(
              title: const Text('Welcome to Crop Assister'),
              backgroundColor: const Color.fromARGB(255, 71, 143, 75),
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('logout'),
                    style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      await _auth.signoutUser(widget.key, context);
                    })
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Your request has sent to adminstration. Please wait for approval',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color.fromARGB(255, 32, 196, 100)),
                        ),
                      ),

                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        child: const Text('Back'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 71, 143, 75), // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async {
                          await _auth.signoutUser(widget.key, context);
                        }
                      ),

                  ],
              )
            ),
          );
  }

}
