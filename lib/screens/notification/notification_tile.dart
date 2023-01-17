import 'dart:async';
import 'package:crop_damage_assessment_app/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:crop_damage_assessment_app/models/notification.dart'
    as fnotification;
import '../farmer/home/claim_dashboard.dart';
import 'notification.dart';
import 'package:intl/intl.dart';
// import 'package:crop_damage_assessment_app/models/notification.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({Key? key, required this.uid, required this.index, required this.notifications_all_list, required this.notification})
      : super(key: key);

  final String? uid;
  final int index;
  final List<dynamic> notifications_all_list;
  final NotificationModel? notification;

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  final NotificationService notificationservice = NotificationService();

  // updateNotification() async {
  //   print("notification updated!");
  //   NotificationModel notifi = widget.notification!;
  //   final notification = fnotification.Notification(notifi.notification_id,
  //       from: notifi.from,
  //       to: notifi.to,
  //       message: notifi.message,
  //       status: "read",
  //       claimState: notifi.status,
  //       date: DateTime.parse(notifi.datetime));

  //   notificationservice.updateNotification(notification);
  // }

  _updateNotification() async {
    int index = widget.index;
    dynamic notifi = widget.notifications_all_list[index];
    final notification = fnotification.Notification(notifi['notificationid'],
        from: notifi['from'],
        to: notifi['to'],
        message: notifi['message'],
        status: "read",
        claimState: notifi['claimState'],
        date: DateTime.parse(notifi['date'].toDate().toString()));
        
    await notificationservice.updateNotification(notification);
  }

  Icon getStatusIcon(String status) {
    // return const Icon(Icons.circle_notifications,
    //     color: const Color.fromARGB(255, 198, 167, 11), size: 40.0);
    switch (status) {
      case "Approved":
        return const Icon(Icons.circle_notifications,
            color: Color.fromARGB(255, 14, 129, 81), size: 40.0);

      case "Rejected":
        return const Icon(Icons.circle_notifications,
            color: Color.fromARGB(255, 193, 30, 30), size: 40.0);

      default:
        return const Icon(Icons.circle_notifications,
            color: Color.fromARGB(255, 198, 167, 11), size: 40.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("notification!.icon");
    print(widget.notification!.status);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: getStatusIcon(widget.notification!.status),

              title: Text(widget.notification!.from,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 0, 0, 0))),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.notification!.message,
                      style: const TextStyle(
                          fontSize: 15.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.notification!.datetime,
                      style: const TextStyle(
                          fontSize: 13.0,
                          color: Color.fromARGB(255, 109, 108, 108)),
                    ),
                  ),
                ],
              ),
              tileColor: const Color.fromARGB(255, 218, 249, 232),
              //trailing: ,
              onTap: () async {
                await _updateNotification();
                Navigator.pop(context, true);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => FarmerDashboard(uid: widget.uid)),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
