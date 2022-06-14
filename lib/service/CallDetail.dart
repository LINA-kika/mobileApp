import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../main.dart';

Call callFromJson(String str) => Call.fromJson(json.decode(str));

String callToJson(Call data) => json.encode(data.toJson());

class Call {
  Call({
    required this.id,
    required this.theme,
    required this.reason,
    this.reportPath,
    required this.departureCallDate,
    this.masterArrivingDate,
    required this.callStatus,
  });

  final int id;
  final String theme;
  final String reason;
  String? reportPath;
  final DateTime departureCallDate;
  DateTime? masterArrivingDate;
  final String callStatus;

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        id: json["id"],
        theme: json["theme"],
        reason: json["reason"],
        reportPath: json["reportPath"] ?? null,
        departureCallDate: DateTime.parse(json["departureCallDate"]),
        masterArrivingDate: json["masterArrivingDate"]  == null ? null : DateTime.parse(json["masterArrivingDate"] as String),
        callStatus: json["callStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "theme": theme,
        "reason": reason,
        "reportPath": reportPath,
        "departureCallDate": departureCallDate.toIso8601String(),
        "masterArrivingDate": masterArrivingDate?.toIso8601String(),
        "callStatus": callStatus,
      };
}

Future<Call> fetchSelectedCall(int callId) async {
  http.Response resp = await http.get(
    Uri.parse(hostName + 'call/' + callId.toString()),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer_eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMSIsInJvbGVzIjpbIlJPTEVfVVNFUiJdLCJpYXQiOjE2NDkyMzE4MTEsImV4cCI6MzYwMTY0OTIzMTgxMX0.ldDnU1oGJQzjqzV4Rpw0cgYDgIGELjC5VkQBkmxhWCo'
    },
  );

  var json = jsonDecode(utf8.decode(resp.bodyBytes));
  print(json);
  return Call.fromJson(json);
}
