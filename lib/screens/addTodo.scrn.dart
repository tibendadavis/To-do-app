import 'package:flutter/material.dart';
import 'package:todo/components/heading2.dart';
import 'package:todo/components/heading4.dart';
import 'package:todo/components/heading5.dart';
import 'package:todo/components/inputTextField.comp.dart';
import 'package:todo/controllers/functions.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/model/todo.model.dart';
import 'package:todo/screens/home.scrn.dart';
import 'package:todo/screens/listTodo.scrn.dart';
import 'package:todo/screens/loading.scrn.dart';
import 'package:todo/theme/design.theme.dart';

class addTodo extends StatefulWidget {
  const addTodo({super.key});

  @override
  State<addTodo> createState() => _addTodoState();
}

class _addTodoState extends State<addTodo> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  String title = "";
  String description = "";
  bool isTitleEmpty = true;
  bool isDescriptionEmpty = true;
  bool loading = false;

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

  createTask(BuildContext context) async {
    final todo = Todo(
      id: Funcs().getRandomID(),
      title: title,
      description: description,
      completed: false,
      created: DateTime.now().toString(),
      lastUpdated: DateTime.now().toString(),
    );
    await Funcs().createTodo(todo);
    setState(() {
      loading = false;
    });
    Funcs().showSnackBar(
        context: context,
        mainLabel: "Task saved successfully",
        actionLabel: "",
        actionFunc: () {},
        type: "success");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MyHomePage(page: listTodoItems()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
              scale: scaleAnimation,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  decoration: BoxDecoration(
                    color: globalData.darkMode
                        ? Palette().appColorDark
                        : Palette().appColorLight,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Heading2(
                              value: "Add Task",
                              fontWeight: FontWeight.w700,
                              color: globalData.darkMode
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Heading5(
                              value:
                                  "Fill out the details below to add a new task",
                              color: globalData.darkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Form(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              inputTextField(
                                hintText: "Title",
                                type: "name",
                                onSelect: (val, isEmpty) {
                                  setState(() {
                                    title = val;
                                    isTitleEmpty = isEmpty;
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
                                onSelect: (val, isEmpty) {
                                  setState(() {
                                    description = val;
                                    isDescriptionEmpty = isEmpty;
                                  });
                                  print(description);
                                },
                                size: 170,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 150,
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
                                    width: 150,
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
                                          if (isTitleEmpty == false &&
                                              isDescriptionEmpty == false) {
                                            createTask(context);
                                            setState(() {
                                              loading = true;
                                            });
                                            if (loading) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      loadingScreen(),
                                                  barrierDismissible: false);
                                            }
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
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
