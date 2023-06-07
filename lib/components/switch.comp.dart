import 'package:flutter/material.dart';
import 'package:todo/components/heading_text.dart';
import 'package:todo/controllers/globalVariables.dart';

class todoSwitch extends StatefulWidget {
  bool? value;
  Function? onSelect;
  todoSwitch({super.key, this.onSelect, this.value});

  @override
  State<todoSwitch> createState() => _todoSwitchState();
}

class _todoSwitchState extends State<todoSwitch> {
  bool switchValue = false;

  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.value != null) switchValue = widget.value!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeadingText(
              size: 16,
              value: "Completion Status",
              color: globalData.darkMode ? Colors.white : Colors.grey.shade800),
          GestureDetector(
            onTap: () {
              setState(() {
                switchValue = !switchValue;
                widget.onSelect!(switchValue);
              });
            },
            child: Container(
              width: 51,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: switchValue
                      ? Colors.green
                      : globalData.darkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade400),
              child: Stack(
                children: [
                  Positioned(
                      left: switchValue ? 17 : 0,
                      top: 2,
                      child: Container(
                        width: 35,
                        height: 26,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
