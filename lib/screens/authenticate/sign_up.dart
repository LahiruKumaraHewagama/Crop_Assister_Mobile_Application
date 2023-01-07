import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    Key? key,
    required this.toggleView,
  }) : super(key: key);

  final Function toggleView;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth_in = FirebaseAuth.instance;

  final _formKey_1 = GlobalKey<FormState>();
  final _formKey_2 = GlobalKey<FormState>();
  String error = "";
  bool loading = false;

  // text field state
  String phone_no = '';
  String verificationID = "";
  bool otpVisibility = false;
  String opt_code = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            // appBar: AppBar(
            //   title: const Text('Sign Up to Crop Assister'),
            //   backgroundColor: const Color.fromARGB(255, 71, 143, 75),
            //   elevation: 0.0,
            //   actions: <Widget>[
            //     TextButton.icon(
            //       icon: const Icon(Icons.person),
            //       label: const Text('Sign Up'),
            //       style: TextButton.styleFrom(
            //         primary: Colors.white, // foreground
            //       ),
            //       onPressed: () => widget.toggleView(1),
            //     ),
            //   ],
            // ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: !otpVisibility ? Form(
                      key: _formKey_1,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 30.0),
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                          const SizedBox(height: 20.0),
                          const Text('SIGN UP',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 4, 92, 9))),
                          const SizedBox(height: 30.0),
                           const Text('Before Sign up to the system you have to verify any of your mobile number which is going to use signup.',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 4, 92, 9))),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.phone,
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
                                hintText: 'Mobile Number'),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter a Mobile Number' : null,
                            onChanged: (val) {
                              setState(() => phone_no = val);
                              setState(() => error = "");
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                             child: const Text('Sign Up'),
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 71, 143, 75), // background
                              onPrimary: Colors.white, // foreground
                              textStyle: const TextStyle(fontSize: 20),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 50.0),
                            ),
                              onPressed: () async {
                                if (_formKey_1.currentState != null &&
                                    _formKey_1.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  loginWithPhone();
                                }
                              }),
                          const SizedBox(height: 12.0),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          ),const SizedBox(height: 20.0),
                          TextButton(
                            child: Text(
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 4, 92, 9)),
                              'Already have an account? SIGN IN', //title
                              textAlign: TextAlign.end, //aligment
                            ),
                            onPressed: () => widget.toggleView(1),
                          ),
                        ],
                      ),
                    )
                  : Form(
                      key: _formKey_2,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 40.0),
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.number,
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
                                hintText: 'OPT Code'),
                            validator: (val) => val!.length != 6
                                ? 'Enter the opt code 6 chars long'
                                : null,
                            onChanged: (val) {
                              setState(() => opt_code = val);
                              setState(() => error = "");
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              loginWithPhone();
                            },
                            child: const Text(
                              'Resend OPT code',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 4, 92, 9)),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                              child: const Text('Verify'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // background
                                onPrimary: Colors.white, // foreground
                                textStyle: const TextStyle(fontSize: 20),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 55.0),
                              ),
                              onPressed: () async {
                                if (_formKey_2.currentState != null &&
                                    _formKey_2.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result = await _auth.verifyOTP(
                                      verificationID, opt_code);
                                  print(result);
                                  if (result == null && mounted) {
                                    setState(() {
                                      error = "Invalid OPT code";
                                      loading = false;
                                    });
                                  }
                                }
                              }),
                          const SizedBox(height: 12.0),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
            ),
          );
  }

  void loginWithPhone() async {
    auth_in.verifyPhoneNumber(
      phoneNumber: phone_no,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth_in.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
        setState(() {
          loading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          loading = false;
          error = "Invalid phone number!";
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          loading = false;
          otpVisibility = true;
          verificationID = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // setState(() {
        //   loading = false;
        //   error = "Time out!";
        //   verificationID = verificationId;
        // });
      },
    );
  }
}
