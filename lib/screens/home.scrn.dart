import 'package:flutter/material.dart';
import 'package:todo/components/heading2.dart';
import 'package:todo/components/heading6.dart';
import 'package:todo/controllers/functions.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/controllers/mobileScaffold.scrn.dart';
import 'package:todo/screens/addTodo.scrn.dart';
import 'package:todo/screens/listTodo.scrn.dart';
import 'package:todo/screens/updateTodo.scrn.dart';
import 'package:todo/theme/design.theme.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, this.page});

  Widget? page;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var taskTitle;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Palette().appColorDark,
      body: Stack(
        children: [
          Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(globalData.darkMode
                        ? "lib/assets/img/abstractDark.jpg"
                        : "lib/assets/img/abstractLight.jpg"),
                    fit: BoxFit.fill),
              ),
              child: SingleChildScrollView(
                child: Container(
                  height: size.height - 165,
                  margin: EdgeInsets.only(top: 166),
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  decoration: BoxDecoration(
                    color: globalData.darkMode
                        ? Palette().appColorDark
                        : Palette().appColorLight,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 23, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Heading2(
                                textFormat: "Capitalize",
                                value: globalData.detailScreen
                                    ? '${globalData.taskTitle!}'
                                    : "${Funcs().getSalutation()}",
                                fontWeight: FontWeight.w700,
                                color: globalData.darkMode
                                    ? Colors.white
                                    : Colors.grey.shade800,
                              ),
                            ),
                            Row(
                              children: [
                                globalData.detailScreen
                                    ? Offstage()
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            globalData.darkMode =
                                                !globalData.darkMode;
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder: (BuildContext
                                                          context) =>
                                                      MyHomePage(
                                                          page:
                                                              listTodoItems()),
                                                ));
                                          });
                                        },
                                        icon: Icon(
                                          size: 20,
                                          globalData.darkMode
                                              ? Icons.light_mode_rounded
                                              : Icons.dark_mode_rounded,
                                          color: globalData.darkMode
                                              ? Colors.white
                                              : Colors.grey.shade800,
                                        )),
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 17,
                                  child: ClipOval(
                                      child: Image.asset(
                                          "lib/assets/img/defaultAvatar.jpg")),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: size.height - 262,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return mobileScaffold(
                                  page: widget.page!,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                          height: 25,
                          width: size.width,
                          child: Container(
                              padding: EdgeInsets.only(
                                top: 3,
                                left: 7,
                              ),
                              color: globalData.darkMode
                                  ? Palette().appColorDark
                                  : Palette().appColorLight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Heading6(
                                      color: Colors.grey.shade500,
                                      value:
                                          "Copyright © ${DateTime.now().year}, Davis Tibenda"),
                                ],
                              )))
                    ],
                  ),
                ),
              )),
          globalData.detailScreen
              ? Positioned(
                  top: 110,
                  left: 15,
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette().accentColorDark,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17))),
                      onPressed: () {
                        setState(() {
                          globalData.detailScreen = false;
                        });

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  MyHomePage(page: listTodoItems()),
                            ));
                      },
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color:
                              globalData.darkMode ? Colors.black : Colors.white,
                          size: 25),
                    ),
                  ))
              : Offstage()
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: globalData.darkMode
              ? Palette().accentColorLight
              : Palette().accentColorDark,
          onPressed: () {
            globalData.detailScreen
                ? showDialog(context: context, builder: (_) => updateTodo())
                : showDialog(context: context, builder: (_) => addTodo());
          },
          child: Icon(
            globalData.detailScreen ? Icons.edit : Icons.add,
            size: 25,
            color: Colors.white,
          )),
    );
  }
}
