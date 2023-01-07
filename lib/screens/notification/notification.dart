import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_damage_assessment_app/models/notification.dart';

class NotificationService {
  final CollectionReference notifications =
      FirebaseFirestore.instance.collection('Notifications');

  Stream<QuerySnapshot> getStream() {
    return notifications.snapshots();
  }

  fetchAll() async {
    List<dynamic> allnotifications = [];
    await notifications.get().then((querySnapshot) => {
          querySnapshot.docs
              .forEach((doc) => {allnotifications.add(doc.data())}),
        });
    return allnotifications;
  }

  fetchAllNotificationDetails(String uid) async {
    List<dynamic> notificationDetail = [];
    await notifications.get().then((querySnapshot) => {
          querySnapshot.docs.forEach((doc) => {
                if (doc.get('to') == uid) {notificationDetail.add(doc.data())}
              }),
        });
    return notificationDetail;
  }

  fetchNotificationDetail(String notificationid) async {
    dynamic notificationdetail;
    await notifications.get().then((querySnapshot) => {
          querySnapshot.docs.forEach((doc) => {
                if (doc.get('notificationid') == notificationid)
                  {notificationdetail = doc.data()}
              }),
        });
    print("Fetch notificationDetail:");
    //print(notificationdetail);
    return notificationdetail;
  }

  Future<DocumentReference> addNotification(Notification notification) {
    print("add new notification to firestore");
    //print(notification.toJson());
    return notifications.add(notification.toJson());
  }

  Future updateNotification(Notification notification) async {
    //await crops.doc(crop.cropid).update(crop.toJson());

    var snapshot = await notifications
        .where('notificationid', isEqualTo: notification.notificationid)
        .get();
    for (var doc in snapshot.docs) {
      //print(doc.reference.id);
      await doc.reference.update(notification.toJson());
    }
    print("update claim in firestore");
  }

  Future deleteNotification(Notification notification) async {
    print("Delete notification from firestore");
    //print(notification);

    List<dynamic> notificationDetail =
        await fetchAllNotificationDetails(notification.to);
    print(notificationDetail.length);

    var snapshot = await notifications
        .where('notificationid', isEqualTo: notification.notificationid)
        .get();
    for (var doc in snapshot.docs) {
      print(doc.reference.id);
      await doc.reference.delete();
    }

    //await crops.doc(crop.cropid).delete();

    List<dynamic> notificationDetail2 =
        await fetchAllNotificationDetails(notification.to);
    print(notificationDetail2.length);
  }
}
