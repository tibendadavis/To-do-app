import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/controllers/globalVariables.dart';

class inputTextField extends StatefulWidget {
  String? value;
  bool? hide;
  String? type;
  double? size;
  final String hintText;
  Function? onSelect;
  inputTextField(
      {super.key,
      required this.hintText,
      this.value,
      this.type,
      this.hide,
      this.onSelect,
      this.size});

  @override
  State<inputTextField> createState() => _inputTextFieldState();
}

class _inputTextFieldState extends State<inputTextField> {
  TextEditingController value = TextEditingController();
  bool _isTextFieldEmpty = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value.text = "";
    if (widget.value != null) value.text = widget.value!;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: SizedBox(
        width: size.width,
        height: widget.size != null ? widget.size! : 70,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
              color: globalData.darkMode
                  ? Color.fromRGBO(64, 70, 78, 1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
              keyboardAppearance:
                  globalData.darkMode ? Brightness.light : Brightness.dark,
              keyboardType: widget.type == "number"
                  ? TextInputType.number
                  : widget.type == "phone"
                      ? TextInputType.phone
                      : widget.type == "email"
                          ? TextInputType.emailAddress
                          : widget.type == "url"
                              ? TextInputType.url
                              : widget.type == "datetime"
                                  ? TextInputType.datetime
                                  : widget.type == "address"
                                      ? TextInputType.streetAddress
                                      : widget.type == "multline"
                                          ? TextInputType.multiline
                                          : widget.type == "name"
                                              ? TextInputType.name
                                              : null,
              style: GoogleFonts.openSans(
                  fontSize: 18,
                  color: globalData.darkMode ? Colors.white : Colors.black),
              obscureText: widget.hide != null ? widget.hide! : false,
              controller: value,
              onChanged: (val) {
                setState(() {
                  widget.value = val;
                  _isTextFieldEmpty = val.isEmpty;
                });
                widget.onSelect!(value.text, _isTextFieldEmpty);
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              textAlignVertical: TextAlignVertical.center,
              maxLines:
                  widget.type == "multline" ? double.maxFinite.floor() : null,
              decoration: InputDecoration(
                errorStyle: GoogleFonts.openSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                errorText: _isTextFieldEmpty ? '*Required' : null,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: GoogleFonts.openSans(
                    fontSize: 16,
                    color: globalData.darkMode
                        ? Colors.grey.shade500
                        : Colors.grey.shade700),
              )),
        ),
      ),
    );
  }
}
