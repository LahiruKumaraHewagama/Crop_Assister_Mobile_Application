import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/models/farmer.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';

Farmer? user;

class ClaimProfile extends StatefulWidget {
  final String? uid;
  final String? claim_uid;

  const ClaimProfile({Key? key, required this.uid, required this.claim_uid})
      : super(key: key);

  @override
  _ClaimProfileState createState() => _ClaimProfileState();
}

class _ClaimProfileState extends State<ClaimProfile> {
  bool loading = true;

  void getUserProfileData() async {
    //use a Async-await function to get the data
    final select_user =
        await DatabaseService(uid: widget.uid).getFarmerData(widget.claim_uid);
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: SizedBox.fromSize(
    size: const Size.fromRadius(100),
    child: Image.network(
      user!.profile_url,
      fit: BoxFit.cover,
    ),
  ),
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
                               Container(
                        alignment: Alignment.centerLeft,
                          width: 300,
                          height:2 , 
                          color: Color.fromARGB(255, 98, 98, 98)  ),
                  const SizedBox(height: 10.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Personal Details",
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
                        "\nAgrarian Division - " +
                        user!.agrarian_division +
                        "\nProvice - " +
                        user!.province +
                        "\nAddress - " +
                        user!.address +
                        "\nNIC - " +
                        user!.nic,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                    
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 80, 79, 79)),
                  ),
                ),
                const SizedBox(height: 30.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bank Details",
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
                    "Bank - " +
                        user!.bank +
                        "\nBranch - " +
                        user!.branch +
                        "\nAccount Name - " +
                        user!.account_name +
                        "\nAccount No - " +
                        user!.account_no,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(                        
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 80, 79, 79)),
                  ),
                ),
              ],
            ),
          );
  }
}
