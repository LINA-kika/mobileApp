import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/service/User.dart';
import 'package:rubcon/view/UserModel.dart';

import 'constrants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  bool edit = false;

  void logout() {}

  void openEdit() {
    setState(() {
      edit = true;
    });
  }

  void closeEdit() {
    setState(() {
      edit = false;
    });
  }

  void saveChanges() {}

  @override
  Widget build(BuildContext context) {
    //var user = context.watch<UserModel>();
    Widget nameField(String name) {
      return SizedBox(
        height: 50,
        width: 250,
        child: TextFormField(
          enabled: edit,
          decoration: InputDecoration(
              hintText: name,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none),
        ),
      );
    }

    Widget propertyField(String title) {
      return Padding(
        padding: EdgeInsets.all(15),
        child: TextFormField(
          decoration: InputDecoration(
              enabled: edit,
              hintText: title,
              enabledBorder: thickBorder,
              focusedBorder: thickBorder,
              disabledBorder: thickBorder),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
        backgroundColor: rubconColor,
        elevation: 0,
        leading: edit
            ? IconButton(
                icon: const Icon(Icons.done),
                onPressed: () => {saveChanges(), closeEdit()},
                color: green,
                iconSize: 40,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: edit
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: closeEdit,
                    color: callred,
                    iconSize: 40,
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: openEdit,
                  ),
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Icon(
                    Icons.account_circle,
                    color: subColor,
                    size: 150,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      nameField("Клишева"),
                      nameField("Алина"),
                      nameField("Дмитриевна"),
                    ],
                  ),
                )
              ],
            ),
          ),
          propertyField("Телефонный номер"),
          propertyField("Почта"),
        ],
      ),

      //Кнопка выхода из приложения
      bottomSheet: Padding(
        padding: const EdgeInsets.all(22.0),
        child: OutlinedButton(
          onPressed: () {
            logout();
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(350, 50),
            primary: Colors.white,
            backgroundColor: rubconColor,
            side: const BorderSide(
              color: green,
              width: minBorderWidth,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
          ),
          child: const Text('Выйти'),
        ),
      ),
    );
  }
}
