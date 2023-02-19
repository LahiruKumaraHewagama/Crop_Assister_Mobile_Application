import 'package:crop_damage_assessment_app/screens/farmer/sign_up_farmer.dart';
import 'package:crop_damage_assessment_app/screens/officer/add_officer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.uid, required this.phone_no})
      : super(key: key);

  final String? uid;
  final String? phone_no;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                        child: const Text('Register as Farmer'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 122, 156, 122), // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FarmerAddData(
                                      uid: widget.uid,
                                      phone_no: widget.phone_no)));
                        }),
                    ElevatedButton(
                        child: const Text('Register as Officer'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 0, 121, 107), // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OfficerAddData(
                                      uid: widget.uid,
                                      phone_no: widget.phone_no)));
                        }),
                  ],
                )),
          );
  }
}
