
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/messages/screen.dart';
import 'package:rubcon/view/ChatModel.dart';
import 'call.dart';
import 'callButton.dart';
import 'callsanddocs.dart';
import 'view/UserModel.dart';
import 'profile.dart';
import 'projects.dart';
import 'home.dart';

String hostName = "http://192.168.1.33:8080/";
int userId = 2;
int recipientId = 1;

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
      ChangeNotifierProvider<ChatModel>(create: (context) => ChatModel())
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rubcon',
      theme: ThemeData(),
      initialRoute: '/',
      routes: {
        "/": (context) => LoginPage(),
        "/projects": (context) => ProjectsPage(),
        "/profile": (context) => ProfilePage(),
        "/message": (context) => MessagesScreen(),
        "/createcall": (context) => CallButton(),
        "/docs": (context) => DocsCallPage(),
        "/call": (context) => CallDetailPage()
      },
    );
  }
}
