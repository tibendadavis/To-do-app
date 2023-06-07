import 'package:flutter/material.dart';
import 'package:todo/components/heading2.dart';
import 'package:todo/components/heading4.dart';
import 'package:todo/controllers/functions.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/main.dart';
import 'package:todo/model/todo.model.dart';
import 'package:todo/screens/home.scrn.dart';
import 'package:todo/theme/design.theme.dart';

class todoItemDetails extends StatefulWidget {
  final String? id;
  final String? title;
  final String? description;
  final String? created;
  final String? lastUpdated;
  bool? completed;
  todoItemDetails({
    super.key,
    this.id,
    this.title,
    this.description,
    this.completed,
    this.created,
    this.lastUpdated,
  });

  @override
  State<todoItemDetails> createState() => _todoItemDetailsState();
}

class _todoItemDetailsState extends State<todoItemDetails> {
  @override
  void initState() {
    super.initState();
    globalData.taskId = widget.id!;
    globalData.taskDescription = widget.description!;
    globalData.taskCompleted = widget.completed!;
    globalData.taskCreated = widget.created!;
    globalData.taskLastUpdated = widget.lastUpdated!;
  }

  bool? completed;
  var task;

  updateTask() async {
    final todo = Todo(
      id: globalData.taskId!,
      title: widget.title!,
      description: widget.description!,
      completed: completed != null ? completed! : widget.completed!,
      created: widget.created!,
      lastUpdated: DateTime.now().toString(),
    );
    await Funcs().updateTodo(todo);
    Funcs().showSnackBar(
        context: context,
        mainLabel: "Task updated successfully",
        actionLabel: "",
        actionFunc: () {},
        type: "success");
  }

  getSingleTask() async {
    task = await Funcs().getSingleTodo(globalData.taskId!);
  }

//function to redirect to the todo item details screen with the new updated data
  void navigateToDetailScreen(BuildContext context) async {
    await getSingleTask();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MyHomePage(
              page: todoItemDetails(
            id: task['id'],
            title: task['title'],
            description: task['description'],
            completed: task['completed'],
            created: task['created'],
            lastUpdated: task['lastUpdated'],
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Heading4(
                  value: widget.description!,
                  color: globalData.darkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Heading4(
                  value: "Created on:",
                  color: globalData.darkMode
                      ? Colors.grey.shade500
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Heading2(
                  value: Funcs()
                      .getDateTimeString(date: DateTime.parse(widget.created!)),
                  fontWeight: FontWeight.w700,
                  color:
                      globalData.darkMode ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Heading4(
                  value: "Last updated on:",
                  color: globalData.darkMode
                      ? Colors.grey.shade500
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Heading2(
                  value: Funcs().getDateTimeString(
                      date: DateTime.parse(completed == true
                          ? DateTime.now().toString()
                          : widget.lastUpdated!)),
                  fontWeight: FontWeight.w700,
                  color:
                      globalData.darkMode ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          widget.completed!
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Heading4(
                            value: "Status:",
                            color: globalData.darkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Heading2(
                                  value: "Completed",
                                  fontWeight: FontWeight.w700,
                                  color: globalData.darkMode
                                      ? Colors.green.shade300
                                      : Colors.green.shade800),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.check_circle_outline_rounded,
                                  size: 27,
                                  color: globalData.darkMode
                                      ? Colors.green.shade300
                                      : Colors.green.shade800)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette().accentColorDark,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        setState(() {
                          completed = true;
                          widget.completed = completed;
                          globalData.taskCompleted = completed;
                        });

                        updateTask();
                      },
                      child: Heading4(
                        value: "Mark As Complete",
                      )),
                ),
        ],
      ),
    );
  }
}
