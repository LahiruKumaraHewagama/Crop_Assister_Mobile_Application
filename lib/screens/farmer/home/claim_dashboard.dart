import 'package:crop_damage_assessment_app/models/notification_model.dart';
import 'package:crop_damage_assessment_app/models/notification.dart'
    as fnotification;
import 'package:crop_damage_assessment_app/screens/farmer/home/filter.dart';
import 'package:crop_damage_assessment_app/screens/notification/view_notification_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crop_damage_assessment_app/models/claim.dart';
import 'package:crop_damage_assessment_app/services/auth.dart';
import 'package:crop_damage_assessment_app/services/database.dart';
import 'package:crop_damage_assessment_app/components/loading.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/add_claim.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/edit_farmer.dart';
import 'package:crop_damage_assessment_app/screens/farmer/home/view_claim_list.dart';

import '../../notification/notification.dart';

class ClaimDashboard extends StatefulWidget {
  const ClaimDashboard({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  _ClaimDashboardState createState() => _ClaimDashboardState();
}

class _ClaimDashboardState extends State<ClaimDashboard> {
  final AuthService _auth = AuthService();
  late DatabaseService db;
  bool loading = true;
  final NotificationService notificationservice = NotificationService();
  int ncount = 0;
  List<dynamic> _notifications = [];
  List<NotificationModel> notification_list = [];

  var filter = {"claim_state": "", "agrarian_division": ""};

  void initFarmer() async {
    print("initFarmer");
    db = DatabaseService(uid: widget.uid);
    db.set_select_uid = widget.uid!;
    final preference = await SharedPreferences.getInstance();
    filter["claim_state"] = preference.getString('claim_state') ?? "Pending";

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initFarmer();
    _getAllNotifications();
  }

  _getAllNotifications() async {
    String uid = widget.uid!;
    var allnotifications =
        await notificationservice.fetchAllNotificationDetails(uid);
    allnotifications.forEach((notification) {
      print(notification['to'] +"------------------------------------------------------------");
      if (notification['status'] == 'unread') {
        setState(() {
          _notifications.add(notification);
        });
      }
    });
    _notifications.sort((a, b) => b['date'].compareTo(a['date']));
    await _createList();
  }

  _createList() async {
    await Future.forEach(_notifications, (dynamic element) async {
      var notification_id = element['notificationid'];
      var claimState = element['claimState'];
      var to = element['to'];
      var datetime = DateFormat.jm()
          .add_yMd()
          .format(DateTime.parse(element['date'].toDate().toString()));
      var message = element['message'];

      var from = "";

      var model = NotificationModel(
          notification_id: notification_id,
          to: to,
          status: claimState,
          from: from,
          datetime: datetime,
          message: message);
      notification_list.add(model);
    });

    setState(() {});
  }

  // _updateNotification(int index) async {
  //   dynamic notifi = _notifications[index];
  //   final notification = fnotification.Notification(notifi['notificationid'],
  //       from: notifi['from'],
  //       to: notifi['to'],
  //       message: notifi['message'],
  //       status: "read",
  //       claimState: notifi['claimState'],
  //       date: DateTime.parse(notifi['date'].toDate().toString()));

  //   notificationservice.updateNotification(notification);
  // }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : StreamProvider<List<Claim?>>.value(
            value: db.farmerClaimList(filter["claim_state"]),
            initialData: const [],
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                  body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      title: const Text(' Crop Assister - Farmer'),
                      backgroundColor: const Color.fromARGB(255, 122, 156, 122),
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
                      ],
                      pinned: true,
                      floating: true,
                      bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(55),
                          child: Container(
                            decoration: BoxDecoration(
                              
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(width: 1, color:Color.fromARGB(255, 0, 94, 32) ),
                            ),
                            child: TabBar(
                              isScrollable: true,
                              indicatorPadding: const EdgeInsets.all(5),
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 0, 140, 47),
                              ),
                              tabs: const [
                                Tab(
                                  child: Text('Applied',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      )),
                                ),
                                Tab(
                                  child: Text('New Claim',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      )),
                                )
                              ],
                            ),
                          )
                          ),                          
                    ),
                    //  const SizedBox(height: 20.0),
                  ];
                },
                
                body: TabBarView(
                  children: <Widget>[
                    ViewClaimList(uid: widget.uid),
                    AddClaim(uid: widget.uid)
                  ],
                ),
              )),
            ));
  }
}
