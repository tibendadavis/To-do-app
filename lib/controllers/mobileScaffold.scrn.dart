import 'package:flutter/material.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/theme/design.theme.dart';

class mobileScaffold extends StatefulWidget {
  final Widget page;
  const mobileScaffold({
    super.key,
    required this.page,
  });

  @override
  State<mobileScaffold> createState() => _mobileScaffoldState();
}

class _mobileScaffoldState extends State<mobileScaffold> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
            color: globalData.darkMode
                ? Palette().appColorDark
                : Palette().appColorLight),
        child: widget.page,
      ),
    );
  }
}
