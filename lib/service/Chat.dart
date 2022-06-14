import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';

List<Chat> chatFromJson(String str) => List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chat {
  Chat({
    required this.senderId,
    required this.recipientId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.messageStatus,
  });

  final int senderId;
  final int recipientId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final String messageStatus;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    senderId: json["senderId"],
    recipientId: json["recipientId"],
    senderName: json["senderName"],
    content: json["content"],
    timestamp: DateTime.parse(json["timestamp"]),
    messageStatus: json["messageStatus"],
  );

  Map<String, dynamic> toJson() => {
    "senderId": senderId,
    "recipientId": recipientId,
    "senderName": senderName,
    "content": content,
    "timestamp": timestamp.toIso8601String(),
    "messageStatus": messageStatus,
  };
}


Future<List<Chat>> fetchChat(int userId) async {
  http.Response resp = await http.get(
    Uri.parse(hostName+'messages/'+recipientId.toString()+'/'+userId.toString()),
  );


  return List<Chat>.from(json.decode(utf8.decode(resp.bodyBytes)).map((x) => Chat.fromJson(x)));
}

Future<Chat> fetchMessage(int id) async {
  http.Response resp = await http.get(
    Uri.parse(hostName+'messages/'+id.toString()),
  );

  var json = jsonDecode(utf8.decode(resp.bodyBytes));
  return  Chat.fromJson(json);
}


