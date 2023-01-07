import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String notificationid;
  final String from;
  final String to;
  String message;
  String status;
  String claimState;
  DateTime date;

  //A reference id to a Firestore document representing this crop
  String? referenceId;

  Notification(this.notificationid,
      {required this.from,
      required this.to,
      required this.message,
      required this.status,
      required this.claimState,
      required this.date});

  factory Notification.fromSnapshot(DocumentSnapshot snapshot) {
    final newClaim =
        Notification.fromJson(snapshot.data() as Map<String, dynamic>);
    newClaim.referenceId = snapshot.reference.id;
    return newClaim;
  }

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _notificationFromJson(json);

  Map<String, dynamic> toJson() => _notificationToJson(this);

  @override
  String toString() => 'Notification<$notificationid>';
}

Notification _notificationFromJson(Map<String, dynamic> json) {
  return Notification(
    json['notificationid'] as String,
    from: json['from'] as String,
    to: json['to'] as String,
    message: json['message'] as String,
    status: json['status'] as String,
    claimState: json['claimState'] as String,
    date: json['date'] as DateTime,
  );
}

Map<String, dynamic> _notificationToJson(Notification instance) =>
    <String, dynamic>{
      'notificationid': instance.notificationid,
      'from': instance.from,
      'to': instance.to,
      'message': instance.message,
      'status': instance.status,
      'claimState': instance.claimState,
      'date': instance.date,
    };
