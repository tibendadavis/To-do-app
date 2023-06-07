import 'package:flutter/material.dart';
import 'package:todo/screens/home.scrn.dart';
import 'package:todo/screens/listTodo.scrn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(page: listTodoItems()),
      debugShowCheckedModeBanner: false,
    );
  }
}
