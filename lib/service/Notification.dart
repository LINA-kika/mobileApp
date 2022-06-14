import 'dart:convert';

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    required this.id,
    required this.senderId,
    required this.senderName,
  });

  final String id;
  final String senderId;
  final String senderName;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"] as String,
    senderId: json["senderId"] as String,
    senderName: json["senderName"] as String,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "senderId": senderId,
    "senderName": senderName,
  };
}
