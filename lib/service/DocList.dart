// To parse this JSON data, do
//
//     final docList = docListFromJson(jsonString);

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../main.dart';

List<DocList> docListFromJson(String str) =>
    List<DocList>.from(json.decode(str).map((x) => DocList.fromJson(x)));

String docListToJson(List<DocList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DocList {
  DocList({
    required this.id,
    required this.uploadDate,
    required this.docPath,
    required this.type,
    required this.docName,
    required this.lastUpdateDate,
  });

  final int id;
  final DateTime uploadDate;
  final String docPath;
  final String type;
  final String docName;
  final DateTime lastUpdateDate;

  factory DocList.fromJson(Map<String, dynamic> json) => DocList(
        id: json["id"],
        uploadDate: DateTime.parse(json["uploadDate"]),
        docPath: json["docPath"],
        type: json["type"],
        docName: json["docName"],
        lastUpdateDate: DateTime.parse(json["lastUpdateDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uploadDate": uploadDate.toIso8601String(),
        "docPath": docPath,
        "type": type,
        "docName": docName,
        "lastUpdateDate": lastUpdateDate.toIso8601String(),
      };
}

Future<List<DocList>> fetchFullDocList(int constId, int page) async {
  print(hostName +
      'doc/construction/' +
      constId.toString() +
      '?page=' +
      page.toString());
  http.Response resp = await http.get(Uri.parse(hostName +
      'doc/construction/' +
      constId.toString() +
      '?page=' +
      page.toString()));

  return List<DocList>.from(
      json.decode(utf8.decode(resp.bodyBytes)).map((x) => DocList.fromJson(x)));
}

Future<List<DocList>> fetchDocListByName(
    int constId, int page, String docName) async {
  print(hostName +
      'doc/findByName/construction/' +
      constId.toString() +
      '?page=' +
      page.toString() +
      '&docName=' +
      docName);
  http.Response resp = await http.get(Uri.parse(hostName +
      'doc/findByName/construction/' +
      constId.toString() +
      '?page=' +
      page.toString() +
      '&docName=' +
      docName));
  return List<DocList>.from(
      json.decode(utf8.decode(resp.bodyBytes)).map((x) => DocList.fromJson(x)));
}

Future<List<DocList>> fetchDocListByType(
    int constId, int page, String type, String name) async {
  print(hostName +
      'doc/findByNameAndType/construction/' +
      constId.toString() +
      '?page=' +
      page.toString() +
      '&type=' +
      type +
      '&docName=' +
      name);
  http.Response resp = await http.get(Uri.parse(hostName +
      'doc/findByNameAndType/construction/' +
      constId.toString() +
      '?page=' +
      page.toString() +
      '&type=' +
      type +
      '&docName=' +
      name));
  return List<DocList>.from(
      json.decode(utf8.decode(resp.bodyBytes)).map((x) => DocList.fromJson(x)));
}
