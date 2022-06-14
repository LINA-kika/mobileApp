
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../main.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.lastName,
    required this.firstName,
    required this.patronymic,
    required this.email,
    required this.phone,
    required this.constructions,
  });

  final String lastName;
  final String firstName;
  final String patronymic;
  final String email;
  final String phone;
  final List<Construction> constructions;

  factory User.fromJson(Map<String, dynamic> json) => User(
    lastName: json["lastName"],
    firstName: json["firstName"],
    patronymic: json["patronymic"],
    email: json["email"],
    phone: json["phone"],
    constructions: List<Construction>.from(json["constructions"].map((x) => Construction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "lastName": lastName,
    "firstName": firstName,
    "patronymic": patronymic,
    "email": email,
    "phone": phone,
    "constructions": List<dynamic>.from(constructions.map((x) => x.toJson())),
  };
}

class Construction {
  Construction({
    required this.id,
    required this.image,
    required this.constName,
  });

  final int id;
  final String image;
  final String constName;

  factory Construction.fromJson(Map<String, dynamic> json) => Construction(
    id: json["id"],
    image: json["image"],
    constName: json["constName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "constName": constName,
  };
}



Future<User> fetchUser(int userId) async {
  http.Response resp = await http.get(
    Uri.parse(hostName+'client/user/'+userId.toString())
  );
  var json = jsonDecode(utf8.decode(resp.bodyBytes));

  return User.fromJson(json);
}
