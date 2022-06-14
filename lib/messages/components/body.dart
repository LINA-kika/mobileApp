import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constrants.dart';
import '../../service/Chat.dart';
import '../../view/ChatModel.dart';
import 'input.dart';
import 'message.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var chat = context.watch<ChatModel>();
    chat.setIsOpen(true);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: chat.chats.length,
              itemBuilder: (context, index) => Message(message: chat.chats[index]),
            ),
          ),
        ),
        ChatInputField(),
      ],
    );
  }
}

