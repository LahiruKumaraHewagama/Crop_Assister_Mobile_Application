import 'package:crop_damage_assessment_app/screens/authenticate/officer_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/screens/authenticate/sign_in.dart';
import 'package:crop_damage_assessment_app/screens/authenticate/sign_up.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  int showSignIn = 1;

  void toggleView(step) {
    setState(() => showSignIn = step);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == 1) {
      return SignIn(toggleView: toggleView);
    } else if (showSignIn == 2) {
      return SignUp(toggleView: toggleView);
    } else if (showSignIn == 3) {
      return OfficerSignIn(toggleView: toggleView);
    } else {
      return SignIn(toggleView: toggleView);
    }

    // switch (showSignIn) {
    //   case 1:
    //     return SignIn(toggleView:  toggleView);
    //   case 2:
    //     return SignUp(toggleView:  toggleView);
    //   case 3:
    //     return AddData(toggleView:  toggleView);
    //   default:
    //     return SignIn(toggleView:  toggleView);
    // }
  }
}

// 1 - sign in || 2 - sign up  || 3 - add data
