import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/model/todo.model.dart';
import 'package:todo/theme/design.theme.dart';
import 'package:http/http.dart' as http;
import 'package:todo/constants/constants.dart';
import 'package:uuid/uuid.dart';

class Funcs {
  Future getAllTodos(String page) async {
    final url = Uri.parse(apiUrl + '?fields=.&page=${page}');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
    );

    if (response.statusCode == 200) {
      final todos = jsonDecode(response.body);
      print('Todo items fetched successfully!');
      return todos['entries'];
    } else {
      print('Failed to get todo items. Error: ${response.body}');
    }
  }

  Future createTodo(Todo todo) async {
    final url = Uri.parse(apiUrl + '/${todo.id}');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 201) {
      final res = jsonDecode(response.body);
      print('Task created successfully');
      return res;
    } else {
      print('Failed to create a task. Error: ${response.body}');
    }
  }

  Future getSingleTodo(String id) async {
    final url = Uri.parse(apiUrl + '/${id}');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
    );

    if (response.statusCode == 200) {
      final todo = jsonDecode(response.body);
      print('Todo item fetched successfully! ${todo}');
      return todo;
    } else {
      print('Failed to get todo item. Error: ${response.body}');
    }
  }

  Future updateTodo(Todo todo) async {
    final url = Uri.parse(apiUrl + '/${todo.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print('Todo item updated successfully!');
      return res['message'];
    } else {
      print('Failed to update todo item. Error: ${response.body}');
    }
  }

  Future deleteTodo(String id) async {
    final url = Uri.parse(apiUrl + '/${id}');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      print('Todo item deleted successfully!');
      return res['message'];
    } else {
      print('Failed to delete todo item. Error: ${response.body}');
    }
  }

  void showSnackBar(
      {required BuildContext context,
      required String mainLabel,
      required String actionLabel,
      required VoidCallback actionFunc,
      required String type}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: type == "info"
            ? Palette().appInfo2
            : type == "success"
                ? Palette().appSucc2
                : type == "error"
                    ? Palette().appError2
                    : type == "warning"
                        ? Palette().appWarn2
                        : Colors.white,
        action: SnackBarAction(
          textColor: Palette().appColorLight,
          label: actionLabel,
          onPressed: () {
            actionFunc();
          },
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            type == "info"
                ? Icon(
                    Icons.info_outline,
                    size: 30,
                    color: Palette().appInfo,
                  )
                : type == "success"
                    ? Icon(
                        Icons.check_circle_outline,
                        size: 30,
                        color: Palette().appSucc,
                      )
                    : type == "error"
                        ? Icon(
                            Icons.theater_comedy_outlined,
                            size: 30,
                            color: Palette().appError,
                          )
                        : type == "warning"
                            ? Icon(
                                Icons.warning_amber_outlined,
                                size: 30,
                                color: Palette().appWarn,
                              )
                            : const Offstage(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                mainLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: type == "info"
                      ? Palette().appInfo
                      : type == "success"
                          ? Palette().appSucc
                          : type == "error"
                              ? Palette().appError
                              : type == "warning"
                                  ? Palette().appWarn
                                  : Palette().appColorDark,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
    );
  }

  String getRandomID() {
    var uuid = const Uuid();
    return uuid.v1();
  }

  String capitalize(String text) {
    final words = text.split(' ');
    final capitalizedWords = words.map((word) {
      final firstLetter = word[0].toUpperCase();
      final remainingLetters = word.substring(1);
      return '$firstLetter$remainingLetters';
    });
    return capitalizedWords.join(' ');
  }

  getDateString({required DateTime date}) {
    String _dateString = DateFormat("dd/MM/yyyy").format((date)).toString();
    return _dateString;
  }

  getDateTimeString({required DateTime date}) {
    String _dateTimeString = DateFormat('yyyy-MM-dd  kk:mm').format(date);
    return _dateTimeString;
  }

  String getSalutation() {
    var now = DateTime.now();
    var hour = now.hour;

    if (hour < 12) {
      return "Good👋\nMorning";
    } else if (hour < 18) {
      return "Good👋\nAfternoon";
    } else {
      return "Good👋\nEvening";
    }
  }
}
