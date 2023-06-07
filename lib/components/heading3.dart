import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:todo/controllers/functions.dart';

class Heading3 extends StatefulWidget {
  final String value;
  final Color? color;
  final TextAlign? align;
  final String? textFormat;
  final FontWeight? fontWeight;
  const Heading3(
      {Key? key,
      required this.value,
      this.color,
      this.align,
      this.textFormat,
      this.fontWeight})
      : super(key: key);

  @override
  State<Heading3> createState() => _Heading3State();
}

class _Heading3State extends State<Heading3> {
  @override
  Widget build(BuildContext context) {
    return Text(
      (widget.textFormat == "Capitalize"
          ? Funcs().capitalize(widget.value)
          : widget.textFormat == "Uppercase"
              ? widget.value.toUpperCase()
              : widget.textFormat == "Lowercase"
                  ? widget.value.toLowerCase()
                  : widget.value),
      textAlign: widget.align,
      style: GoogleFonts.openSans(
        fontSize: 15,
        fontWeight: widget.fontWeight ?? FontWeight.w500,
        color: widget.color,
      ),
    );
  }
}
