import 'home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import 'package:crop_damage_assessment_app/models/user_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth?>(context);
    // print('user ${user}');

    //retunr either Home/Authenticate widget
    if (user == null) {
      return Authenticate(key: key);
    } else {
      return Home(key: key);
    }
  }
}
