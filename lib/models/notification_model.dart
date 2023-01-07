class NotificationModel {
  final String notification_id;
  final String to;
  final String status;
  final String from;
  final String datetime;
  final String message;

  NotificationModel(
      { required this.notification_id,
        required this.to,
        required this.status,
      required this.from,
      required this.datetime,
      required this.message});
}