import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rubcon/constrants.dart';
import 'package:rubcon/main.dart';
import 'package:intl/intl.dart';
import 'package:rubcon/service/CallList.dart';
import 'package:rubcon/service/DocList.dart';
import 'package:rubcon/view/UserModel.dart';
import 'package:rubcon/widgets/SearchWidget.dart';
import 'package:url_launcher/url_launcher.dart';

/*
class DocsCallsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel user = context.watch<UserModel>();
    return DocsCallPage(user: user);
  }
}
*/
class DocsCallPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<DocsCallPage> {
  int _pageIndex = 0;

  final _pageList = <Widget>[_CallPage(), _DocsPage()];

/*
  void fetchCallList() {
    widget.user.fetchFullSortedCallList('').then((List<CallList> list) {
      setState(() {
        call_items.addAll(list);
      });
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/projects'),
        ),
        backgroundColor: rubconColor,
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (
          child,
          animation,
          secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _pageList[_pageIndex],
      ),
      floatingActionButton: _pageIndex == 0
          ? Padding(
              padding: const EdgeInsets.only(right: 30, bottom: 30),
              child: IconButton(
                icon: Icon(Icons.add_circle_rounded,
                    size: 70, color: rubconColor),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/createcall');
                  print("upd");

                  print("upd");
                },
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (selectedIndex) {
          setState(() {
            _pageIndex = selectedIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
              label: "Заявки", icon: Icon(Icons.access_time)),
          BottomNavigationBarItem(
              label: "Документы", icon: Icon(CupertinoIcons.doc))
        ],
      ),
    );
  }
}

class _DocsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserModel>();
    return _DocList(user: user);
  }
}

class _DocList extends StatefulWidget {
  final UserModel user;

  const _DocList({required this.user}) : super();

  @override
  _DocListState createState() => _DocListState();
}

class _DocListState extends State<_DocList> {
  ScrollController _docScrollController = new ScrollController();
  bool isLoading = false;
  List<DocList> _items = [];
  String type = '';
  String name = '';
  bool isInit = false;
  bool all = true;
  late Color _allButtonColor;
  late Color _actButtonColor;
  late Color _contractButtonColor;
  late Color _drawingButtonColor;

  void _getMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      widget.user.incDocIndex(type);
      if (type == '') {
        widget.user.fetchAllDocListByName(name).then((List<DocList> list) {
          if (list.isEmpty) {
            widget.user.cancelDocIndex(type);
          }
          _items.addAll(list);

          setState(() {
            isLoading = false;
          });
        });
      } else {
        widget.user.fetchSortedDocList(type, name).then((List<DocList> list) {
          if (list.isEmpty) {
            widget.user.cancelDocIndex(type);
          }
          _items.addAll(list);

          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.user.zeroDocIndex('');
    widget.user.zeroDocIndex('ACT');
    widget.user.zeroDocIndex('CONTRACT');
    widget.user.zeroDocIndex('DRAWING');
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    widget.user.fetchAllDocListByName(name).then((List<DocList> list) {
      setState(() {
        _items.addAll(list);
        isLoading = false;
        isInit = true;
      });
    });
    print("init");

    _allButtonColor = rubconColor;
    _actButtonColor = subColor;
    _contractButtonColor = subColor;
    _drawingButtonColor = subColor;

    _docScrollController.addListener(() {
      if (_docScrollController.position.pixels ==
              _docScrollController.position.maxScrollExtent &&
          widget.user.getIndexByType(type) != -1) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _docScrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == _items.length) {
          return _buildProgressIndicator();
        } else {
          return new _DocCard(item: _items[index]);
        }
      },
      controller: _docScrollController,
    );
  }

  void sortList() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    widget.user.fetchSortedDocList(type, name).then((List<DocList> list) {
      _items.clear();
      _items.addAll(list);

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchWidget(
            text: "Поиск",
            onChanged: (text) {
              widget.user.zeroDocIndex('');
              widget.user.zeroDocIndex('ACT');
              widget.user.zeroDocIndex('DRAWING');
              widget.user.zeroDocIndex('CONTRACT');
              name = text;
              if (!isLoading) {
                setState(() {
                  isLoading = true;
                });
                if (type == '') {
                  widget.user
                      .fetchAllDocListByName(name)
                      .then((List<DocList> list) {
                    if (list.isEmpty) {
                      widget.user.cancelDocIndex(type);
                    }
                    _items.clear();
                    _items.addAll(list);

                    setState(() {
                      isLoading = false;
                    });
                  });
                } else {
                  widget.user
                      .fetchSortedDocList(type, name)
                      .then((List<DocList> list) {
                    if (list.isEmpty) {
                      widget.user.cancelDocIndex(type);
                    }
                    _items.clear();
                    _items.addAll(list);

                    setState(() {
                      isLoading = false;
                    });
                  });
                }

                setState(() {
                  isLoading = false;
                });
              }
            },
            hintText: "название документа "),
        Row(
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: _allButtonColor,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                type = '';
                _allButtonColor = rubconColor;
                _actButtonColor = subColor;
                _contractButtonColor = subColor;
                _drawingButtonColor = subColor;
                widget.user.zeroDocIndex('');
                if (!isLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                widget.user.fetchAllDocList().then((List<DocList> list) {
                  _items.clear();
                  _items.addAll(list);

                  setState(() {
                    isLoading = false;
                  });
                });
              },
              child: const Text('Все'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: _actButtonColor,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                type = 'ACT';
                _allButtonColor = subColor;
                _actButtonColor = rubconColor;
                _contractButtonColor = subColor;
                _drawingButtonColor = subColor;
                widget.user.zeroDocIndex('ACT');
                sortList();
              },
              child: const Text('Акт'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: _contractButtonColor,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                type = 'CONTRACT';
                _allButtonColor = subColor;
                _actButtonColor = subColor;
                _contractButtonColor = rubconColor;
                _drawingButtonColor = subColor;
                widget.user.zeroDocIndex('CONTRACT');
                sortList();
              },
              child: const Text('Договор'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: _drawingButtonColor,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                type = 'DRAWING';
                _allButtonColor = subColor;
                _actButtonColor = subColor;
                _contractButtonColor = subColor;
                _drawingButtonColor = rubconColor;
                widget.user.zeroDocIndex('DRAWING');

                sortList();
              },
              child: const Text('Чертёж'),
            )
          ],
        ),
        _items.isEmpty
            ? isInit == true
                ? Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Нет документов',
                          style: Theme.of(context).textTheme.headline5,
                        )))
                : _buildProgressIndicator()
            : Expanded(child: _buildList())
      ],
    );
  }
}

class _CallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserModel>();
    return _CallList(user: user);
  }
}

class _CallList extends StatefulWidget {
  final UserModel user;

  _CallList({required this.user}) : super();

  @override
  _CallListState createState() => _CallListState();
}

class _CallListState extends State<_CallList> {
  ScrollController _callScrollController = new ScrollController();
  bool isLoading = false;
  bool isInit = false;

  List<CallList> items = [];
  String theme = '';

  void _getMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      widget.user.incCallIndex();
      widget.user.fetchFullSortedCallList(theme).then((List<CallList> list) {
        if (list.isEmpty) {
          widget.user.cancelCallIndex();
        }

        setState(() {
          items.addAll(list);
          isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    widget.user.zeroCallIndex();
    super.initState();
    if (widget.user.isUpdated == true) {
      setState(() {
        isLoading = true;
      });
      widget.user.setIsUpdated(false);
      Future.delayed(const Duration(milliseconds: 1000), () {
        widget.user.fetchFullSortedCallList('').then((List<CallList> list) {
          setState(() {
            items.addAll(list);
            isLoading = false;
            isInit = true;
          });
        });
      });
    } else {
      widget.user.fetchFullSortedCallList('').then((List<CallList> list) {
        setState(() {
          items.addAll(list);
          isLoading = false;
          isInit = true;
        });
      });
    }

    _callScrollController.addListener(() {
      if (_callScrollController.position.pixels ==
              _callScrollController.position.maxScrollExtent &&
          widget.user.callIndexes[widget.user.currentConstId]! != -1) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _callScrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == items.length) {
          return _buildProgressIndicator();
        } else {
          return new _CallCard(item: items[index]);
        }
      },
      controller: _callScrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchWidget(
            text: "Поиск",
            onChanged: (text) {
              widget.user.zeroCallIndex();
              theme = text;
              if (!isLoading) {
                setState(() {
                  isLoading = true;
                });
              }
              widget.user
                  .fetchFullSortedCallList(text)
                  .then((List<CallList> list) {
                items.clear();
                items.addAll(list);

                setState(() {
                  isLoading = false;
                });
              });
            },
            hintText: "тема вызова"),
        items.isEmpty
            ? isInit == true
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Нет истории вызовов мастера',
                          style: Theme.of(context).textTheme.headline5,
                        )))
                : _buildProgressIndicator()
            : Expanded(child: _buildList())
      ],
    );
  }
}

class _DocCard extends StatelessWidget {
  final DocList item;

  _DocCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.file_copy_outlined,
          size: 40,
        ),
        title: Text(item.docName),
        subtitle: Text(item.type +
            ", " +
            DateFormat('yyyy-MM-dd H:m:s').format(item.uploadDate)),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () async {
            if (await canLaunch(hostName + item.docPath)) {
              await launch(hostName + item.docPath);
            } else {
              throw 'Could not launch ';
            }
          },
        ),
      ),
    );
  }
}

class _CallCard extends StatelessWidget {
  final CallList item;

  _CallCard({required this.item});

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserModel>();
    return Card(
      child: ListTile(
        leading: item.callStatus == "DONE"
            ? const Icon(
                Icons.done,
                color: kPrimaryColor,
                size: 40,
              )
            : (item.callStatus == "WAITING"
                ? const Icon(
                    Icons.access_time,
                    size: 40,
                    color: rubconColor,
                  )
                : const Icon(
                    Icons.cancel_outlined,
                    color: kErrorColor,
                    size: 40,
                  )),
        title: Text(item.theme),
        subtitle:
            Text(DateFormat('yyyy-MM-dd H:m:s').format(item.departureCallDate)),
        onTap: () => {
          user.setSelectedCallId(item.id),
          Navigator.pushNamed(context, '/call')
        },
      ),
    );
  }
}
