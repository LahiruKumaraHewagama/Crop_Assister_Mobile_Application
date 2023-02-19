import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/components/decoration.dart';

class OfficerSignIn extends StatefulWidget {
  const OfficerSignIn({
    Key? key,
    required this.toggleView,
  }) : super(key: key);

  final Function toggleView;

  @override
  State<OfficerSignIn> createState() => _OfficerSignInState();
}

class _OfficerSignInState extends State<OfficerSignIn> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth_in = FirebaseAuth.instance;

  final _formKey_1 = GlobalKey<FormState>();
  final _formKey_2 = GlobalKey<FormState>();
  String error = "";
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String verificationID = "";
  bool otpVisibility = false;
  String opt_code = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            // backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            resizeToAvoidBottomInset: false,
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey_1,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30.0),
                      Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                      const SizedBox(height: 20.0),
                      const Text('OFFICER SIGN IN',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 30,
                              color: Color.fromARGB(255, 4, 92, 9))),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
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
                            hintText: 'Officel email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a Email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
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
                            hintText: 'Enter Your Password'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter the valid password' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                          setState(() => error = "");
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          child: const Text('Sign In'),
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
                          onPressed: () async {
                            print(email);
                            print(password);
                            if (_formKey_1.currentState != null &&
                                _formKey_1.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              loginWithEmail();
                            }
                          }),
                      const SizedBox(height: 12.0),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        child: Text(
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              color: Color.fromARGB(255, 4, 92, 9)),
                          'Are you a farmer ? \nClick Here', //title
                          textAlign: TextAlign.center, //aligment
                        ),
                        onPressed: () => widget.toggleView(1),
                      ),
                    ],
                  ),
                )),
          );
  }

  void loginWithEmail() async {
    try {
      await auth_in.signInWithEmailAndPassword(
          email: email, password: password);
      print("You are logged in successfully");
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
        error = "Invalid email or password!";
      });
    }
  }
}
