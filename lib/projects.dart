import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/constrants.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rubcon/main.dart';
import 'package:rubcon/view/ChatModel.dart';
import 'package:rubcon/view/UserModel.dart';

import 'service/User.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var user = context.watch<UserModel>();
    var chat = context.watch<ChatModel>();

    return Scaffold(
      backgroundColor: rubconColor,
      appBar: AppBar(
        elevation: 0,
        leading: new Container(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(
                Icons.account_circle_rounded,
                size: 40,
              ),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: RawMaterialButton(
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.messenger,
                size: 40,
                color: rubconColor,
              ),
            ),
            onPressed: () {
              chat.setHasNewMessages(0);
              Navigator.pushNamed(context, '/message');
            },
          ),
        ),
        Positioned(
            top: 2,
            right: 2,
            child: chat.hasNewMessages !=0 ?  Container(
              height: 13,
              width: 13,
              child: CircleAvatar(
                backgroundColor: kErrorColor,
                /*child: Text(
                  chat.hasNewMessages.toString(),
                  style: TextStyle(fontSize: 10),
                ),*/
              ),
            ) :Container(),
            ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints:
              BoxConstraints.loose(Size(screenWidth * 0.9, screenHeight * 0.7)),
          child: Container(
            height: screenHeight * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
                width: 20,
              ),
              borderRadius: defaultRadius,
            ),
            child: FutureBuilder<User>(
              future: user.fetchUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ConstructionSwiper(context, snapshot.data!)
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}

Widget ConstructionSwiper(BuildContext context, User snapUser) {
  var user = context.watch<UserModel>();
  return Container(
      child: snapUser.constructions.isEmpty
          ? Center(
              child: Text(
              'Нет проектов',
              style: Theme.of(context).textTheme.headline4,
            ))
          : Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapUser.constructions[index].constName,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.network(
                        hostName + snapUser.constructions[index].image,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                );
              },
              onTap: (index) {
                user.setCurrentConstId(snapUser.constructions[index].id);
                print(user.currentConstId);
                Navigator.pushNamed(context, '/docs');
              },
              itemCount: snapUser.constructions.length,
              loop: false,
              scrollDirection: Axis.horizontal,
              index: 0,
              pagination: const SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                      color: subColor, activeColor: rubconColor)),
              control: const SwiperControl(
                iconNext: null,
                iconPrevious: null,
              ),
            ));
}
