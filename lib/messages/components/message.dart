import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubcon/main.dart';
import 'package:rubcon/messages/components/text.dart';
import 'package:rubcon/service/Chat.dart';

import '../../constrants.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Chat message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.senderId==userId ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          TextMessage(message: message)
        ],
      ),
    );
  }
}
