import 'package:flutter/material.dart';

class GlobalData {
  static final _globalData = new GlobalData._internal();
  double listPos = 0.0;
  ScrollController scrollCont = ScrollController();

  bool darkMode = false;
  bool detailScreen = false;
  String? searchQuery;
  String? taskTitle;
  String? taskId;
  String? taskDescription;
  bool? taskCompleted;
  String? taskCreated;
  String? taskLastUpdated;

  factory GlobalData() {
    return _globalData;
  }
  GlobalData._internal();
}

final globalData = GlobalData();
