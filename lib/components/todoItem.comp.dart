import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/components/heading3.dart';
import 'package:todo/components/heading5.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/screens/home.scrn.dart';
import 'package:todo/screens/todoItemDetails.scrn.dart';

class todoItem extends StatefulWidget {
  final String? id;
  final String? title;
  final String? description;
  final String? created;
  final String? lastUpdated;
  final bool? completed;

  todoItem({
    super.key,
    this.id,
    this.title,
    this.description,
    this.completed,
    this.created,
    this.lastUpdated,
  });

  @override
  State<todoItem> createState() => _todoItemState();
}

class _todoItemState extends State<todoItem> with TickerProviderStateMixin {
  bool _expanded = false;
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration(milliseconds: 5), () {
      setState(() {
        _expanded = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
        // ignore: deprecated_member_use
        vsync: this,
        duration: Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn,
        child: _expanded
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: globalData.darkMode
                      ? Color.fromRGBO(64, 70, 78, 1)
                      : Colors.white.withOpacity(1),
                  boxShadow: [
                    BoxShadow(
                      color: globalData.darkMode
                          ? Colors.black.withOpacity(0.2)
                          : Colors.grey[600]!.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListTile(
                    minLeadingWidth: 2,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    onTap: () {
                      setState(() {
                        globalData.detailScreen = true;
                        globalData.taskTitle = widget.title!;
                      });

                      Navigator.push(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (BuildContext context) => MyHomePage(
                                page: todoItemDetails(
                              id: widget.id!,
                              title: widget.title!,
                              description: widget.description!,
                              completed: widget.completed!,
                              created: widget.created!,
                              lastUpdated: widget.lastUpdated!,
                            )),
                          ));
                    },
                    trailing: Icon(
                        widget.completed!
                            ? Icons.check_circle_outline_rounded
                            : Icons.timelapse_outlined,
                        size: 35,
                        color: widget.completed!
                            ? globalData.darkMode
                                ? Colors.green.shade300
                                : Colors.green.shade800
                            : Colors.grey.shade500),
                    title: Row(
                      children: [
                        Expanded(
                          child: Heading3(
                              textFormat: 'Capitalize',
                              color: globalData.darkMode
                                  ? Colors.white
                                  : Colors.black,
                              value: widget.title!),
                        ),
                      ],
                    ),
                    dense: true,
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Heading5(
                            fontWeight: FontWeight.w600,
                            color: globalData.darkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            value: DateFormat.EEEE()
                                    .format(DateTime.parse(widget.created!)) +
                                ", " +
                                DateFormat.d()
                                    .format(DateTime.parse(widget.created!)),
                          ),
                        ),
                      ],
                    )),
              )
            : Container());
  }
}
