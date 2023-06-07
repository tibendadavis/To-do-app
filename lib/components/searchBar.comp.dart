import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/heading4.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/theme/design.theme.dart';

class searchBar extends StatefulWidget {
  String? value;
  Function? onSelect;
  Function? onSort;

  searchBar({
    super.key,
    this.onSelect,
    this.value,
    this.onSort,
  });

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  TextEditingController value = TextEditingController();
  void initState() {
    // TODO: implement initState
    super.initState();
    value.text = "";
    if (widget.value != null) value.text = widget.value!;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Heading4(
            value: "Stay on Track!",
            color: globalData.darkMode
                ? Colors.grey.shade500
                : Colors.grey.shade600,
          ),
        ),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: globalData.darkMode
                          ? Color.fromRGBO(64, 70, 78, 1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: value,
                      onChanged: (val) {
                        setState(() {
                          widget.value = val;
                        });
                        widget.onSelect!(value.text);
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      style: GoogleFonts.openSans(
                          fontSize: 17,
                          color: globalData.darkMode
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search,
                          size: 25,
                          color: globalData.darkMode
                              ? Palette().accentColorLight
                              : Palette().accentColorDark,
                        ),
                        hintStyle: GoogleFonts.openSans(
                            color: globalData.darkMode
                                ? Colors.white
                                : Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                        hintText: "Search",
                      )),
                ),
              ),
              InkWell(
                  onTap: () {
                    widget.onSort!();
                  },
                  child: Icon(
                    Icons.sort,
                    color: globalData.darkMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade800,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
