import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/constrants.dart';
import 'package:rubcon/view/UserModel.dart';

import 'main.dart';

class CallButton extends StatefulWidget {
  const CallButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _StateCallButton();
  }
}

class _StateCallButton extends State<CallButton> {
  String _reason = "";
  String _theme = "";
  final _searchController1 = TextEditingController();
  final _searchController2 = TextEditingController();
  bool apiCall = false;

  void postData(int currentConstId) async {
    try {
      Map<String, String> body = {'theme': _theme, 'reason': _reason};

      var response = await Dio().post(
        hostName + 'client/call/construction/' + currentConstId.toString(),
        data: body,
      );

      print(response);
    } catch (er) {
      print(er);
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserModel>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: rubconColor,
          title: Text("Заявка на вызов мастера"),
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            controller: _searchController1,
                            minLines: 1,
                            maxLines: 3,
                            maxLength: 25,
                            keyboardType: TextInputType.multiline,
                            cursorColor: rubconColor,
                            decoration: const InputDecoration(
                                label: Text("Тема вызова:"),
                                labelStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: TextFormField(
                            controller: _searchController2,
                            minLines: 1,
                            maxLines: 6,
                            maxLength: 100,
                            keyboardType: TextInputType.multiline,
                            cursorColor: rubconColor,
                            decoration: const InputDecoration(
                                label: Text("Причина вызова мастера:"),
                                labelStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          )),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: rubconColor,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          setState(() {
                            apiCall = true;
                            _theme = _searchController1.text;
                            _reason =
                                _searchController2.text; // Set state like this
                          });
                          if (_theme.isNotEmpty && _reason.isNotEmpty) {
                            postData(user.currentConstId);
                          }
                          user.setIsUpdated(true);
                          Navigator.pushNamed(context, '/docs');
                        },
                        child: const Text('Отправить'),
                      ),
                    ]))));
  }
}
