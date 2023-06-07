import 'package:flutter/material.dart';
import 'package:todo/components/heading2.dart';
import 'package:todo/components/heading4.dart';
import 'package:todo/components/heading5.dart';
import 'package:todo/components/inputTextField.comp.dart';
import 'package:todo/components/switch.comp.dart';
import 'package:todo/controllers/functions.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/model/todo.model.dart';
import 'package:todo/screens/home.scrn.dart';
import 'package:todo/screens/listTodo.scrn.dart';
import 'package:todo/screens/loading.scrn.dart';
import 'package:todo/screens/todoItemDetails.scrn.dart';
import 'package:todo/theme/design.theme.dart';

class updateTodo extends StatefulWidget {
  const updateTodo({super.key});

  @override
  State<updateTodo> createState() => _updateTodoState();
}

class _updateTodoState extends State<updateTodo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  String? title;
  String? description;
  bool? completed;
  bool loading = false;
  var task;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation = CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  updateTask(BuildContext context) async {
    final todo = Todo(
      id: globalData.taskId!,
      title: title != null ? title! : globalData.taskTitle!,
      description:
          description != null ? description! : globalData.taskDescription!,
      completed: completed != null ? completed! : globalData.taskCompleted!,
      created: globalData.taskCreated!,
      lastUpdated: DateTime.now().toString(),
    );
    await Funcs().updateTodo(todo);

    navigateToDetailScreen(context);
  }

  deleteTask(BuildContext context) async {
    await Funcs().deleteTodo(globalData.taskId!);
    setState(() {
      loading = false;
    });
    Funcs().showSnackBar(
        context: context,
        mainLabel: "Task deleted successfully",
        actionLabel: "",
        actionFunc: () {},
        type: "success");
    setState(() {
      globalData.detailScreen = false;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MyHomePage(page: listTodoItems()),
        ));
  }

  getSingleTask() async {
    task = await Funcs().getSingleTodo(globalData.taskId!);
    setState(() {
      globalData.taskTitle = title != null ? title! : globalData.taskTitle!;
    });
  }

//function to redirect to the todo item details screen with the new updated data
  void navigateToDetailScreen(BuildContext context) async {
    await getSingleTask();
    setState(() {
      loading = false;
    });
    Funcs().showSnackBar(
        context: context,
        mainLabel: "Task updated successfully",
        actionLabel: "",
        actionFunc: () {},
        type: "success");
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

//a pop up to confirm deletion of a todo item
  void showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          icon: Icon(
            Icons.warning_amber_rounded,
            size: 35,
            color: Colors.yellow.shade900,
          ),
          backgroundColor:
              globalData.darkMode ? Palette().appColorDark : Colors.white,
          title: Heading2(
            value: "Confirm Delete",
            fontWeight: FontWeight.w700,
            color: globalData.darkMode ? Colors.white : Colors.grey.shade800,
          ),
          content: Row(
            children: [
              Expanded(
                child: Heading4(
                  value: "Are you sure you want to delete this task?",
                  color: globalData.darkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade800,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Heading4(
                value: "Cancel",
                color: globalData.darkMode
                    ? Colors.grey.shade200
                    : Colors.grey.shade700,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Heading4(
                value: "Delete",
                color: Colors.red,
              ),
              onPressed: () {
                deleteTask(context);
                setState(() {
                  loading = true;
                });
                if (loading) {
                  showDialog(
                      context: context,
                      builder: (_) => loadingScreen(),
                      barrierDismissible: false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
            scale: scaleAnimation,
            child: SizedBox(
              width: size.width,
              child: Container(
                margin:
                    EdgeInsets.only(top: 15, bottom: 0, left: 10, right: 10),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                decoration: BoxDecoration(
                  color: globalData.darkMode
                      ? Palette().appColorDark
                      : Palette().appColorLight,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Heading2(
                                value: "Edit Task",
                                fontWeight: FontWeight.w700,
                                color: globalData.darkMode
                                    ? Colors.white
                                    : Colors.grey.shade800,
                              ),
                              InkWell(
                                onTap: () {
                                  showDeleteConfirmation(context);
                                },
                                child: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.redAccent,
                                  size: 35,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Heading5(
                            value: "You can update the details of the task",
                            color: globalData.darkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          inputTextField(
                            hintText: "Title",
                            type: "name",
                            value: globalData.taskTitle,
                            onSelect: (val, isEmpty) {
                              setState(() {
                                title = val;
                              });
                              print(title);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          inputTextField(
                            hintText: "Description",
                            type: "multline",
                            size: 170,
                            value: globalData.taskDescription,
                            onSelect: (val, isEmpty) {
                              setState(() {
                                description = val;
                              });
                              print(description);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          todoSwitch(
                              onSelect: (val) {
                                print(val);
                                setState(() {
                                  completed = val;
                                });
                              },
                              value: globalData.taskCompleted),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation:
                                            globalData.darkMode ? 5 : null,
                                        backgroundColor: globalData.darkMode
                                            ? Palette().appColorDark
                                            : Palette().appColorLight,
                                        padding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Heading4(
                                      value: "Cancel",
                                      color: globalData.darkMode
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
                                    )),
                              ),
                              SizedBox(
                                width: 120,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: globalData.darkMode
                                            ? Palette().accentColorLight
                                            : Palette().accentColorDark,
                                        padding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      updateTask(context);
                                      setState(() {
                                        loading = true;
                                      });
                                      if (loading) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => loadingScreen(),
                                            barrierDismissible: false);
                                      }
                                    },
                                    child: Heading4(
                                      value: "Save",
                                      fontWeight: globalData.darkMode
                                          ? FontWeight.bold
                                          : null,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
