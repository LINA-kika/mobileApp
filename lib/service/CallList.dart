// To parse this JSON data, do
//
//     final callList = callListFromJson(jsonString);

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../main.dart';

List<CallList> callListFromJson(String str) => List<CallList>.from(json.decode(str).map((x) => CallList.fromJson(x)));

String callListToJson(List<CallList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CallList {
  CallList({
    required this.id,
    required this.theme,
    required this.departureCallDate,
    this.masterArrivingDate,
    required this.callStatus,
  });

  final int id;
  final String theme;
  final DateTime departureCallDate;
  final DateTime? masterArrivingDate;
  final String callStatus;

  factory CallList.fromJson(Map<String, dynamic> json) => CallList(
    id: json["id"],
    theme: json["theme"],
    departureCallDate: DateTime.parse(json["departureCallDate"]),
    masterArrivingDate: json["masterArrivingDate"]==null? null:DateTime.parse(json["masterArrivingDate"]),
    callStatus: json["callStatus"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "theme": theme,
    "departureCallDate": departureCallDate.toIso8601String(),
    "masterArrivingDate": masterArrivingDate?.toIso8601String(),
    "callStatus": callStatus,
  };
}
Future<List<CallList>> fetchFullCallList(int constId, int page) async {
  print(hostName+'call/construction/'+constId.toString()+'?page='+page.toString());
  http.Response resp = await http.get(

      Uri.parse(hostName+'call/construction/'+constId.toString()+'?page='+page.toString())
  );

  return List<CallList>.from(json.decode(utf8.decode(resp.bodyBytes)).map((x) => CallList.fromJson(x)));
}

Future<List<CallList>> fetchSortedCallList(String name, int constId, int page) async {
  print(hostName+'call/findByName/construction/'+constId.toString()+'?page='+page.toString()+'&callName='+name);
  http.Response resp = await http.get(
      Uri.parse(hostName+'call/findByName/construction/'+constId.toString()+'?page='+page.toString()+'&callName='+name)
  );print(json.decode(utf8.decode(resp.bodyBytes)));

  return List<CallList>.from(json.decode(utf8.decode(resp.bodyBytes)).map((x) => CallList.fromJson(x)));
}