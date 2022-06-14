import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/view/ChatModel.dart';

import '../../constrants.dart';
import '../../main.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchController1 = TextEditingController();
    var chat = context.watch<ChatModel>();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.8,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: rubconColor, width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController1,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Введите сообщение...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: kDefaultPadding,
            ),
            IconButton(
              icon: Icon(
                Icons.send_sharp,
                color: rubconColor,
                size: 40,
              ),
              onPressed: () {chat.sendMessage(_searchController1.text);

              //Navigator.pushNamed(context, '/message');
              },
            )
          ],
        ),
      ),
    );
  }
}
