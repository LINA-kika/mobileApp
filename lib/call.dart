import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/service/CallDetail.dart';
import 'package:rubcon/view/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constrants.dart';
import 'main.dart';

class CallDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserModel>();
    return Scaffold(
      body: FutureBuilder<Call>(
        future: user.fetchCall(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? CallCard(context, snapshot.data!)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Widget CallCard(BuildContext context, Call call) {
  return SafeArea(
    child: Container(
      padding: EdgeInsets.only(
        top: 18,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                      size: 27,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 36, top: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Тема',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  call.theme,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Дата вызова',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('yyyy-MM-dd H:m:s').format(call.departureCallDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Дата обработки',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: 12,
                  ),
                ),
                call.masterArrivingDate == null
                    ? Text(
                        " -",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        DateFormat('yyyy-MM-dd H:m:s')
                            .format(call.masterArrivingDate!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                SizedBox(
                  height: 30,
                ),
                call.reportPath == null
                    ? SizedBox(
                        height: 46,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            if (await canLaunch(hostName + call.reportPath!)) {
                              await launch(hostName + call.reportPath!);
                            } else {
                              throw 'Could not launch ';
                            }
                          },
                        ),
                      )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.51,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              /*Positioned(
                  bottom: 240,
                  left: 144,
                  child: Container(
                    height: 280,
                    width: 250,
                    child: Image.asset('assets/images/plant4.png'),
                  ),
                ),*/
              Container(
                padding: EdgeInsets.only(left: 20, top: 72),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Причина',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      call.reason,
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      color: call.callStatus == "DONE"
          ? callgreen
          : call.callStatus == "CANCELED"
              ? callred
              : rubconColor,
    ),
  );
}
