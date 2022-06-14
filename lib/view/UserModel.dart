import 'dart:collection';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:rubcon/service/DocList.dart' as doc;
import 'package:rubcon/service/User.dart' as api;
import 'package:async/async.dart';

import '../main.dart';
import '../service/CallDetail.dart';
import '../service/CallList.dart';
import '../service/User.dart';

class UserModel extends ChangeNotifier {
  final user = AsyncCache<api.User>(const Duration(seconds: 15));
  int _currentConstId = -1;
  int _selectedCallId = -1;
  bool _isUpdated = false;
  Map<int, int> allDocIndexes = new HashMap();
  Map<int, int> actIndexes = new HashMap();
  Map<int, int> drawingIndexes = new HashMap();
  Map<int, int> contractIndexes = new HashMap();
  Map<int, int> callIndexes = new HashMap();
  //Map<int, List<List<doc.DocList>>> docs = new HashMap();
  //Map<int, List<CallList>> calls = new HashMap();

  UserModel() {
    fetchUser().then((User user) {
      for (api.Construction c in user.constructions) {
        List<List<doc.DocList>> constDocs = [];
        callIndexes.putIfAbsent(c.id, () => 0);
        allDocIndexes.putIfAbsent(c.id, () => 0);
        drawingIndexes.putIfAbsent(c.id, () => 0);
        actIndexes.putIfAbsent(c.id, () => 0);
        contractIndexes.putIfAbsent(c.id, () => 0);
        /*doc.fetchFullDocList(c.id, 0).then((List<doc.DocList> docs) {
          constDocs.add(docs);
          print(docs.length);
        });
        doc
            .fetchDocListByType(c.id, 0, "ACT", '')
            .then((List<doc.DocList> docs) {
          constDocs.add(docs);
        });
        doc
            .fetchDocListByType(c.id, 0, "CONTRACT", '')
            .then((List<doc.DocList> docs) {
          constDocs.add(docs);
        });
        doc
            .fetchDocListByType(c.id, 0, "DRAWING", '')
            .then((List<doc.DocList> docs) {
          constDocs.add(docs);
        });
        docs.putIfAbsent(c.id, () => constDocs);
        fetchFullCallList(c.id, 0).then((List<CallList> call) {
          calls.putIfAbsent(c.id, () => call);
        });*/
      }
    });
  }

  int get currentConstId => _currentConstId;

  int get selectedCallId => _selectedCallId;


  bool get isUpdated => _isUpdated;

  Future<api.User> fetchUser() => user.fetch(() {
        return api.fetchUser(userId);
      });

  Future<List<CallList>> fetchFullSortedCallList(String name) {
    return fetchSortedCallList(
        name, _currentConstId, callIndexes[_currentConstId]!);
  }

  Future<List<doc.DocList>> fetchAllDocList() {
    return doc.fetchFullDocList(
        _currentConstId, allDocIndexes[_currentConstId]!);
  }
  Future<List<doc.DocList>> fetchAllDocListByName(String name) {
    return doc.fetchDocListByName(
        _currentConstId, allDocIndexes[_currentConstId]!, name);
  }

  Future<List<doc.DocList>> fetchSortedDocList(String type, String name) {
    int index = 0;
    switch (type) {
      case "ACT":
        index = actIndexes[_currentConstId]!;
        break;
      case "DRAWING":
        index = drawingIndexes[_currentConstId]!;
        break;
      case "CONTRACT":
        index = contractIndexes[_currentConstId]!;
        break;
    }
    return doc.fetchDocListByType(
        _currentConstId, index, type, name);
  }

  Future<Call> fetchCall() {
    return fetchSelectedCall(_selectedCallId);
  }

  void setCurrentConstId(int id) {
    if (_currentConstId != id) {
      _currentConstId = id;
      notifyListeners();
    }
  }

  void incCallIndex() {
    callIndexes[_currentConstId] = callIndexes[_currentConstId]! + 1;
  }

  int getIndexByType(String type) {
    int result = 0;
    switch (type) {
      case "":
        result = allDocIndexes[_currentConstId]!;
        break;
      case "ACT":
        result = actIndexes[_currentConstId]!;
        break;
      case "DRAWING":
        result = drawingIndexes[_currentConstId]!;
        break;
      case "CONTRACT":
        result = contractIndexes[_currentConstId]!;
        break;
    }
    return result;
  }

  void zeroCallIndex() {
    callIndexes[_currentConstId] = 0;
  }

  void cancelCallIndex() {
    callIndexes[_currentConstId] != -1;
  }

  void incDocIndex(String type) {
    switch (type) {
      case "":
        allDocIndexes[_currentConstId] = allDocIndexes[_currentConstId]! + 1;
        break;
      case "ACT":
        actIndexes[_currentConstId] = actIndexes[_currentConstId]! + 1;
        break;
      case "DRAWING":
        drawingIndexes[_currentConstId] = drawingIndexes[_currentConstId]! + 1;
        break;
      case "CONTRACT":
        contractIndexes[_currentConstId] =
            contractIndexes[_currentConstId]! + 1;
        break;
    }
  }

  void zeroDocIndex(String type) {
    switch (type) {
      case "":
        allDocIndexes[_currentConstId] = 0;
        break;
      case "ACT":
        actIndexes[_currentConstId] = 0;
        break;
      case "DRAWING":
        drawingIndexes[_currentConstId] = 0;
        break;
      case "CONTRACT":
        contractIndexes[_currentConstId] = 0;
        break;
    }
  }

  void cancelDocIndex(String type) {
    switch (type) {
      case "":
        allDocIndexes[_currentConstId] = -1;
        break;
      case "ACT":
        actIndexes[_currentConstId] = -1;
        break;
      case "DRAWING":
        drawingIndexes[_currentConstId] = -1;
        break;
      case "CONTRACT":
        contractIndexes[_currentConstId] = -1;
        break;
    }
  }

  void setSelectedCallId(int index) {
    if (_selectedCallId != index) {
      _selectedCallId = index;
      notifyListeners();
    }
  }
  void setIsUpdated(bool b) {
    _isUpdated = b;
  }
/*
  void callIsAdded() {
    _isUpdated = true;
    user.invalidate();
    notifyListeners();
  }*/
}
