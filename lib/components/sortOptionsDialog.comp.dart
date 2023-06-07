import 'package:flutter/material.dart';
import 'package:todo/components/heading2.dart';
import 'package:todo/components/heading4.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/theme/design.theme.dart';

class sortOptionsDialog extends StatefulWidget {
  Function? sortByName;
  Function? sortByDate;
  Function? sortByCompletion;
  sortOptionsDialog(
      {super.key, this.sortByName, this.sortByDate, this.sortByCompletion});

  @override
  State<sortOptionsDialog> createState() => _sortOptionsDialogState();
}

class _sortOptionsDialogState extends State<sortOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          globalData.darkMode ? Palette().appColorDark : Colors.white,
      title: Heading2(
        value: "Sort Options",
        fontWeight: FontWeight.w700,
        color: globalData.darkMode ? Colors.white : Colors.grey.shade800,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Heading4(
              value: "Sort by Title",
              color: globalData.darkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade800,
            ),
            onTap: () {
              widget.sortByName!();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Heading4(
              value: "Sort by Date",
              color: globalData.darkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade800,
            ),
            onTap: () {
              widget.sortByDate!();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Heading4(
              value: "Sort by Status",
              color: globalData.darkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade800,
            ),
            onTap: () {
              widget.sortByCompletion!();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
