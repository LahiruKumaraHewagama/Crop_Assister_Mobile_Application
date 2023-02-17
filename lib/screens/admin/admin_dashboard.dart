import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/models/officer.dart';
import 'package:crop_damage_assessment_app/screens/admin/add_officers.dart';
import 'package:crop_damage_assessment_app/screens/admin/view_officer_list.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:provider/provider.dart';

import '../officer/add_officer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AuthService _auth = AuthService();

  late DatabaseService db;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text('Crop Assister - Admin'),
                        backgroundColor:
                            const Color.fromARGB(255, 122, 156, 122),
                        elevation: 0.0,
                        // automaticallyImplyLeading: false,
                        actions:                        
                            <Widget>[                              
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

              title: Text("ALL CLAIMS",
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
                   
                   const SizedBox(height: 10.0)                                           
                 
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
                              textStyle: const TextStyle(fontSize: 20),
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
                                    AddOfficer()),
                          );
                             },),
                             Text(
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 15,
                                color: Color.fromARGB(255, 4, 92, 9)),
                            'Add New Officer', //title
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
                      const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 105, 184, 109),
                        ),
                        child: Text('Crop Assister'),
                      ),
                       ListTile(
                        title: const Text('Home'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminDashboard(uid: widget.uid)),
                          );
                        },
                      ),
                       ListTile(
                        title: const Text('Add Officers'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddOfficer()),
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
