import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubcon/main.dart';
import 'package:rubcon/service/Chat.dart';

import '../../constrants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Chat message;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Container(
        decoration: BoxDecoration(
            color: message.senderId == recipientId ? Colors.white : rubconColor,
            borderRadius: defaultRadius,
            border: Border.all(color: subColor, width: 3)),
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
          vertical: kDefaultPadding / 2,
        ),
        child: Row(
          children: [
            if (message.senderId == recipientId) ...[
              const CircleAvatar(
                radius: 48,
                foregroundImage: AssetImage("assets/rubconImage.png"),
                //backgroundColor: Colors.transparent,
              ),
              const SizedBox(
                width: kDefaultPadding,
              ),
            ],
            Column(
              children: [
                if (message.senderId == recipientId) ...[
                  const Text(
                    "РубКон",
                    style: TextStyle(
                      color: subColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],Text(
                    message.content,
                    style: TextStyle(
                      color: message.senderId == userId ? Colors.white : subColor,
                    ),
                  ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
