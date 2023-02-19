import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';

import 'officer_dashboard.dart';

class UpdatePassword extends StatefulWidget {
  @override
  const UpdatePassword({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth_in = FirebaseAuth.instance;

  final _formKey_1 = GlobalKey<FormState>();
  final _formKey_2 = GlobalKey<FormState>();
  String error = "";
  bool loading = false;

  // text field state
  String oldPassword = '';
  String newPassword = '';
  String verificationID = "";
  bool otpVisibility = false;
  String opt_code = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: const Text('Change Your Password'),
                backgroundColor: const Color.fromARGB(255, 0, 121, 107),
                elevation: 0.0),
            body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey_1,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          decoration: textInputDecoration.copyWith(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 129, 32)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 129, 32)),
                              ),
                              hintText: 'Old Password'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter your old Password' : null,
                          onChanged: (val) {
                            setState(() => oldPassword = val);
                            setState(() => error = "");
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 129, 32)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 129, 32)),
                              ),
                              hintText: 'New Password'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter the valid password' : null,
                          onChanged: (val) {
                            setState(() => newPassword = val);
                            setState(() => error = "");
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                            child: const Text('Reset'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 0, 121, 107), // background
                              onPrimary: Colors.white, // foreground
                              textStyle: const TextStyle(fontSize: 20),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 50.0),
                            ),
                            onPressed: () async {
                              bool isSuccess = false;
                              print(oldPassword);
                              print(newPassword);
                              if (_formKey_1.currentState != null &&
                                  _formKey_1.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                bool isSuccess = await _changePassword(
                                    oldPassword, newPassword);

                                if (isSuccess) {
                                  triggerSuccessAlert();
                                } else {
                                  triggerErrorAlert();
                                }
                              }
                            }),
                        const SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  )),
            ),
          );
  }

  void triggerSuccessAlert() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Password Updated successfully!',
        autoCloseDuration: const Duration(seconds: 10),
        onConfirmBtnTap: () => closeAlert());
  }

  void triggerErrorAlert() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        loopAnimation: false,
        onCancelBtnTap: () => closeAlert());
  }

  void closeAlert() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => OfficerDashboard(uid: widget.uid)));
  }

  Future<bool> _changePassword(
      String currentPassword, String newPassword) async {
    bool success = false;

    //Create an instance of the current user.
    var user = await FirebaseAuth.instance.currentUser!;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    final cred = await EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        print("password changed successfully");
        success = true;
        setState(() {
          loading = false;
        });
      }).catchError((error) {
        setState(() {
          loading = false;
          error = "Invalid old or new password!";
        });
      });
    }).catchError((err) {
      setState(() {
        loading = false;
        error = "Invalid old or new password!";
      });
    });

    return success;
  }
}
