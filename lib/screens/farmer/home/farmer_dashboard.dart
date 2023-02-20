import 'package:crop_damage_assessment_app/screens/farmer/home/claim_profile.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/claim_view.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';

import '../../../models/notification_model.dart';
import '../../notification/notification.dart';
import '../../notification/view_notification_list.dart';
import '../../farmer/home/filter.dart';
import 'claim_dashboard.dart';
import 'edit_farmer.dart';

class FarmerDashboard extends StatefulWidget {


 
  const FarmerDashboard({Key? key,required this.uid}) : super(key: key);

  final uid; 

  @override
  _FarmerDashboardState createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final AuthService _auth = AuthService();

  late DatabaseService db;

  bool loading = true;
     int approve=0;
    int reject=0;
     int pending=0;
  final NotificationService notificationservice = NotificationService();
  int ncount = 0;
  List<dynamic> _notifications = [];
  List<NotificationModel> notification_list = [];

  void initFarmerDash() async {
    db = DatabaseService(uid: widget.uid);
    db.set_select_uid = widget.uid!;

    approve = await  db.farmerClaimCount('Approve');
    pending = await  db.farmerClaimCount('Pending');
    reject = await  db.farmerClaimCount('Reject');     
    loading = false;
     setState(() {
            pending = pending;
            approve=approve;
            reject=reject;          
    });   
  }

  @override
  void initState() {
    super.initState();
    initFarmerDash();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('Crop Assister - Farmer'),
                        backgroundColor:
                            const Color.fromARGB(255, 122, 156, 122),
                        elevation: 0.0,
                        // automaticallyImplyLeading: false,
                        actions: <Widget>[
                          IconButton(
                            // icon: const Icon(Icons.notifications),
                            icon: Stack(
                              children: <Widget>[
                                const Icon(Icons.notifications),
                                Visibility(
                                  child: Positioned(
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                      child: Text(
                                        notification_list.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  visible: notification_list.isNotEmpty,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              final filter_result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewNotificationList(
                                        uid: widget.uid,
                                        notifications_all_list: _notifications,
                                        notification_list: notification_list)),
                              );
                              // print("this is filter result");
                              // print(filter_result);
                              // Type type = filter_result.runtimeType;
                              // print(filter_result != null);

                              if (filter_result != null && filter_result) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            super.widget));
                              }
                            },
                          ),
                          IconButton(
                              icon: const Icon(Icons.power_settings_new),
                              onPressed: () async {
                                await _auth.signoutUser(widget.key, context);
                              })
                        ])];
        },
        body: Container(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 50.0),            
                      
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 1.0),
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                          const SizedBox(height: 5.0),
                          const Text('WELCOME',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 4, 92, 9))),
                          const SizedBox(height: 10.0),
                           const Text('“CropAssister” is mobile application to submit the compensation claims together with evidence of damage (E.g. photos/videos) which allows the crop damage compensation process to be more effective and less fraudulent.',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 13,                                  
                                  color: Color.fromARGB(255, 4, 92, 9)),
                                  textAlign:TextAlign.center),
                          const SizedBox(height: 30.0),
                          Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
              const SizedBox(height: 10.0),
            ListTile(             

              title: Text("YOUR CLAIMS",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 0, 0, 0)),
                      textAlign: TextAlign.center,),                      
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment :CrossAxisAlignment.center,
                children: <Widget>[
                   
                   const SizedBox(width: 5.0),
                   
                  Align(
                    alignment: Alignment.center,                                        
                    child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment :CrossAxisAlignment.center,
                children: <Widget>[
                   
                   const SizedBox(height: 10.0),
                   
                   
                  Align(
                    alignment: Alignment.center,                                        
                    child: const Icon(Icons.check,color:Color.fromARGB(255, 0, 153, 8),size: 40,),
                    
                  ),
                   const SizedBox(width: 40.0),
                   Text('Approve',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,  
                                  // fontWeight: FontWeight.bold,                                
                                  color: Color.fromARGB(255, 0, 0, 0)),
                                  textAlign:TextAlign.center),  
                  const SizedBox(width: 40.0),
                   Text(approve.toString(),
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,  
                                  fontWeight: FontWeight.bold,                                
                                  color: Color.fromARGB(255, 0, 0, 0)),
                                  textAlign:TextAlign.center),                              
                 
                ],
              ),            
                  ),
                  const SizedBox(width: 40.0),
                  Align(
                    alignment: Alignment.center,                                        
                    child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment :CrossAxisAlignment.center,
                children: <Widget>[
                   
                  const SizedBox(height: 10.0),
                   
                  Align(
                    alignment: Alignment.center,                                        
                    child: const Icon(Icons.close ,color:Color.fromARGB(255, 219, 0, 0),size: 40, ),                  
                    
                  ),
                   const SizedBox(width: 40.0),
                   Text('Reject',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,  
                                  // fontWeight: FontWeight.bold,                                
                                  color: Color.fromARGB(255, 0, 0, 0)),
                                  textAlign:TextAlign.center),  
                  const SizedBox(width: 40.0),
                   Text(reject.toString(),
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,  
                                  fontWeight: FontWeight.bold,                                
                                  color: Color.fromARGB(255, 0, 0, 0)),
                                  textAlign:TextAlign.center),                              
                 
                ],
              ),            
                  ),


                 const SizedBox(width: 40.0),
                  Align(
                    alignment: Alignment.center,                                        
                    child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment :CrossAxisAlignment.center,
                children: <Widget>[
                   
              const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.center,                                        
                    child: const Icon(Icons.rotate_right_sharp,color:Color.fromARGB(255, 182, 154, 0),size: 40,),
                    
                  ),
                   const SizedBox(width: 40.0),
                   Text('Pending',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,  
                                  // fontWeight: FontWeight.bold,                                
                                  color: Color.fromARGB(255, 0, 0, 0)),
                                  textAlign:TextAlign.center),  
                  const SizedBox(width: 40.0),
                   Text(pending.toString(),
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,    
                                  fontWeight: FontWeight.bold,                              
                                  color: Color.fromARGB(255, 0, 0, 0)),
                                  textAlign:TextAlign.center),                              
                 
                ],
              ),            
                  ),
                  
                ],
              ), 
                        
                           
            ),
              const SizedBox(height: 20.0) 
          ],
        ),
      ),
    ), const SizedBox(height: 25.0),
                          ElevatedButton(
                             child: const Text('GET START'),
                             style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(
                                  255, 71, 143, 75), // background
                              onPrimary: Colors.white, // foreground
                              textStyle: const TextStyle(fontSize: 15),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 50.0),
                            ), onPressed: () { 
                               Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ClaimDashboard(uid: widget.uid)),
                          );
                             },),
                             Text(
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 15,
                                color: Color.fromARGB(255, 4, 92, 9)),
                            'Apply for a new Claim', //title
                            textAlign: TextAlign.end, //aligment
                          ),
                              
                          const SizedBox(height: 12.0),
                         
                        ],
                      ),
                    )                
            
      ),
         drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 1.0),
                          Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/crop-assister.appspot.com/o/Crop%20assister%20app%20%20PNG.png?alt=media&token=e9067fd2-4eac-4df4-93be-185589e15833'),
                          const SizedBox(height: 5.0),
                              Container(
                        alignment: Alignment.centerLeft,
                          width: 300,
                          height:1 , 
                          color: Color.fromARGB(255, 45, 46, 46)  ),
                      
                       ListTile(
                        title: const Text('Home'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FarmerDashboard(uid: widget.uid)),
                          );
                        },
                      ),
                       ListTile(
                        title: const Text('Claims'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ClaimDashboard(uid: widget.uid)),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Filter Settings'),
                        onTap: () async {
                          final filter_result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Filter(uid: widget.uid)));

                          if (filter_result != null && filter_result) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget));
                          }
                        },
                      ),
                      ListTile(
                        title: const Text('Edit Profile'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FarmerEditData(uid: widget.uid)),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Logout'),
                        onTap: () async {
                          await _auth.signoutUser(widget.key, context);
                        },
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
