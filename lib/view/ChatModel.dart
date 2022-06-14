import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rubcon/service/Chat.dart' as api;
import 'package:rubcon/service/Notification.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../main.dart';
import '../service/Chat.dart';
import 'Notifications.dart';

class ChatModel extends ChangeNotifier {
  late final stompClient;
  List<api.Chat> _chat = [];
  int _hasNewMessages = 0;
  bool _isOpen = false;

  void setChat(List<Chat> messages) {
    this._chat = messages;
  }

  void setHasNewMessages(int i) {
    _hasNewMessages = i;
    print(_hasNewMessages.toString());
    notifyListeners();
  }

  int get hasNewMessages => _hasNewMessages;

  ChatModel() {
    fetchMessages().then((msg) => setChat(msg));
    this.stompClient = StompClient(
      config: StompConfig.SockJS(
        url: hostName + 'ws',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        //stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        //webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );
    stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/user/' + userId.toString() + '/queue/messages',
      callback: (frame) {
        var notification = Notification.fromJson(jsonDecode(frame.body));

        if (_isOpen) {
          fetchMessage(int.parse(notification.id))
              .then((value) => addMessage(value));
        } else {
          final Notifications _notifications =  Notifications();
          _notifications.initNotifications();
          _notifications.pushNotification();
          setHasNewMessages(_hasNewMessages + 1);
          fetchMessage(int.parse(notification.id))
              .then((value) => addMessage(value));
        }
      },
    );
  }

  void sendMessage(String msg) {
    stompClient.send(
      destination: '/app/chat',
      body: json.encode({
        'senderId': userId.toString(),
        'recipientId': recipientId.toString(),
        'senderName': 'Алина',
        'recipientName': 'РубКон',
        'content': msg,
      }),
    );
    addMessage(api.Chat(
        senderId: userId,
        recipientId: recipientId,
        senderName: "Алина",
        content: msg,
        timestamp: DateTime.now(),
        messageStatus: "DELEVIRED"));
  }

  void addMessage(Chat newChat) {
    _chat.insert(0, newChat);
    notifyListeners();
  }

  Future<List<api.Chat>> fetchMessages() {
    return api.fetchChat(userId);
  }

  List<Chat> get chats => _chat;

  bool get isOpen => _isOpen;

  void setIsOpen(bool isOpen) {
    _isOpen = isOpen;
  }
}
