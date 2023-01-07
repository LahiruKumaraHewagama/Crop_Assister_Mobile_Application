import 'package:crop_damage_assessment_app/models/notification_model.dart';
import 'package:crop_damage_assessment_app/models/user.dart';
import 'package:crop_damage_assessment_app/screens/notification/notification_tile.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/claim_tile.dart';

class ViewNotificationList extends StatefulWidget {
  const ViewNotificationList({Key? key, required this.uid, required this.notifications_all_list, required this.notification_list}) : super(key: key);

  final String? uid;
  final List<dynamic> notifications_all_list;
  final List<NotificationModel> notification_list;

  @override
  _ViewNotificationListState createState() => _ViewNotificationListState();
}

class _ViewNotificationListState extends State<ViewNotificationList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 242, 255, 243),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Notifications'),
              backgroundColor: const Color.fromARGB(255, 122, 156, 122),
              elevation: 0.0,
            ),
            body:Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: 
            
              widget.notification_list.isNotEmpty? 
                  ListView.builder(
                    itemCount: widget.notification_list.length,
                    itemBuilder: (context, index) {
                      return NotificationTile(uid: widget.uid, index: index, notifications_all_list: widget.notifications_all_list, notification: widget.notification_list[index]);
                    },
                  )
                : 
                const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "No Notifications",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 80, 79, 79)),
                    )
                )
        ));
  }
}
