import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/constrants.dart';

import '../view/ChatModel.dart';
import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var chat = context.watch<ChatModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){ chat.setIsOpen(false);
              Navigator.pushNamed(context, '/projects');}
        ),
        title: Text("Чат"),
        backgroundColor: rubconColor,
        elevation: 0,
      ),
      body: Body(),
    );
  }
}
