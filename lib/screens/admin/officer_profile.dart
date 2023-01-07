import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/admin/admin_dashboard.dart';

Officer? user;

class OfficerProfile extends StatefulWidget {
  final String? uid;
  final String? officer_uid;

  const OfficerProfile({Key? key, required this.uid, required this.officer_uid})
      : super(key: key);

  @override
  _OfficerProfileState createState() => _OfficerProfileState();
}

class _OfficerProfileState extends State<OfficerProfile> {

  bool loading = true;
  final AuthService _auth = AuthService();

  void getUserProfileData() async {
    //use a Async-await function to get the data
    final select_user = await DatabaseService(uid: widget.uid).getOfficerData(widget.officer_uid);
    setState(() {
      user = select_user;
      loading = false;
    });
  }

  @override
  void initState() {

    super.initState();
    getUserProfileData();
  }

  void triggerSuccessAlert() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Updated successfully!',
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
            builder: (context) => AdminDashboard(uid: widget.uid)));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('View Officer Profile'),
              backgroundColor: const Color.fromARGB(255, 115, 162, 177),
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),

              child: Column(
                  children: <Widget>[

                    const SizedBox(height: 20.0),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.profile_url),
                      radius: 100,
                    ),

                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        user!.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 80, 79, 79)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        user!.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 80, 79, 79)),
                      ),
                    ),

                    const SizedBox(height: 20.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Officer Details",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),

                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                                              
                        "Phone No - " + 
                        user!.phone_no + 

                        "\nStatus - " + 
                        user!.type + 
                        
                        "\nAgrarian Division - " + 
                        user!.agrarian_division + 

                        "\nProvice - " + 
                        user!.province + 

                        "\nAddress - " + 
                        user!.address + 

                        "\nNIC - " + 
                        user!.nic
                        ,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 80, 79, 79)),
                      ),
                    ),

                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      child: const Text(
                              'Approve',
                              style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {

                          setState(() {
                            loading = true;
                          });

                        var officer_data = {
                              "uid": user!.uid,
                              "phone_no": user!.phone_no,
                              "name": user!.name,
                              "email": user!.email,
                              "type": "officer",
                              "agrarian_division": user!.agrarian_division,
                              "nic": user!.nic,
                              "address": user!.address,
                              "province": user!.province,
                              "profile_url": user!.profile_url
                        };

                        DatabaseService db = DatabaseService(uid: widget.uid);
                        bool isSuccess = await db.updateOfficerData(user!.uid, officer_data);
                                      
                        setState(() {
                          loading = false;
                        });

                        if (isSuccess) {
                          triggerSuccessAlert();
                        } else {
                          triggerErrorAlert();
                        }

                      }
                    ),

                  ],
                ),
          )
        );
  }
}
