import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/models/user_auth.dart';
import 'package:crop_damage_assessment_app/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // storageBucket:"crop-assister.appspot.com"
  await Firebase.initializeApp( options: const FirebaseOptions( apiKey: "AIzaSyDSMJVUIuOqEQklOyNsKH9_O0DbaXf7oRE", appId: "1:578822898762:android:d41e5bfed6efd8f96d92b3", messagingSenderId: "578822898762", projectId: "crop-assister"), 
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserAuth?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          title: 'Crop Assister',
          theme: ThemeData(
            primarySwatch: Colors.green,          
          ),
          home: Wrapper(key: key),
          debugShowCheckedModeBanner: false,
        ));
  }
}
