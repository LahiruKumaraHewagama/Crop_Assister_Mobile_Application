import 'package:crop_damage_assessment_app/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crop_damage_assessment_app/models/user_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  UserAuth? _userFromFirebaseUser(User? user) {
    if (user != null) {
      return UserAuth(uid: user.uid, phone_no: user.phoneNumber);
    } else {
      return null;
    }
  }

  //auth change user stream
  Stream<UserAuth?> get user {
    final user = _auth.authStateChanges().map(_userFromFirebaseUser);
    return user;
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
      // return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //register with email & password
  Future sendAuthenticationLink(String email) async {
    var acs = ActionCodeSettings(
        // URL you want to redirect back to. The domain (www.example.com) for this
        // URL must be whitelisted in the Firebase Console.
        url: 'https://www.example.com/finishSignUp?cartId=1234',
        // This must be true
        handleCodeInApp: true,
        iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.example.android',
        // installIfNotAvailable
        androidInstallApp: true,
        // minimumVersion
        androidMinimumVersion: '12');

    try {
      await _auth.sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
      print('Successfully sent email verification');
      return true;
    } catch (error) {
      print('Error sending email verification: $error');
      return false;
    }
  }

  //verifyOTP
  Future verifyOTP(verificationID, optCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: optCode);
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      // await DatabaseService(uid: user!.uid).updateUserData(user.uid, 'test1', 'test2@gmail.com');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signoutUser(Key? key, BuildContext context) async {
    try {
      await _auth.signOut();

      if (_auth.currentUser == null) {
        print('User is currently signed out!');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Wrapper(key: key)));
      } else {
        print('User is signed in!');
        return;
      }

      // _auth.authStateChanges().listen((User? user) {
      //   if (user == null) {
      //     print('User is currently signed out!');
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) =>
      //         const Authenticate())
      //     );
      //   } else {
      //     print('User is signed in!');
      //     return;
      //   }
      // });
      // return;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
