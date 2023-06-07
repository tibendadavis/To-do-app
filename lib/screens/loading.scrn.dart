import 'package:flutter/material.dart';
import 'package:todo/controllers/globalVariables.dart';

import 'package:todo/theme/design.theme.dart';

class loadingScreen extends StatefulWidget {
  const loadingScreen({super.key});

  @override
  State<loadingScreen> createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen>
    with SingleTickerProviderStateMixin {
  bool _menu = false;
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  double? loadSize = 90;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    scaleAnimation = CurvedAnimation(
        parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    Future.delayed(Duration(milliseconds: 100), () {
      myloadSize();
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          loadSize = 30;
        });
        Future.delayed(Duration(milliseconds: 290), () {
          myloadSize();
        });
      });
    });
  }

  void myloadSize() {
    setState(() {
      loadSize = 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
          scale: scaleAnimation,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
                child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
              width: loadSize,
              height: loadSize,
              child: CircularProgressIndicator(
                color: globalData.darkMode
                    ? Palette().accentColorLight
                    : Palette().accentColorDark,
              ),
            )),
          )),
    );
  }
}
