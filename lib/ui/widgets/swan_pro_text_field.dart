import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwanProTextField extends StatefulWidget {
  final BoxConstraints constraints;
  final Color textFieldColor;
  final double textFieldBorderRadius;
  final TextEditingController fieldTextEditingController;
  final Color textFieldFontColor;
  final String hintText;
  final double fontSize;
  final bool isPassword;
  final bool isObscure;

  const SwanProTextField(
      {required this.constraints,
        this.textFieldColor = const Color(0xff7AAFC5),
        this.textFieldBorderRadius = 5.0,
        required this.fieldTextEditingController,
        this.textFieldFontColor = const Color(0xff60767E),
        this.hintText = 'i.e. Name',
        this.isObscure = false,
        this.fontSize = 12.0,
        this.isPassword = false
      });

  @override
  _SwanProTextFieldState createState() => _SwanProTextFieldState();
}

class _SwanProTextFieldState extends State<SwanProTextField> {
  /// Variables ///
  late bool widgetObscure;

  @override
  void initState() {
    super.initState();
    widgetObscure = widget.isObscure;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.textFieldColor,
          borderRadius:
          BorderRadius.all(Radius.circular(widget.textFieldBorderRadius))),
      child: Stack(
        children: <Widget>[
          TextField(
            controller: widget.fieldTextEditingController,
            obscureText: widgetObscure,
            style: TextStyle(
              color: const Color(0xff60767E),
              fontSize: widget.fontSize,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
              const EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 15),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  color: widget.textFieldFontColor,
                  fontSize: widget.fontSize,
                  letterSpacing: .25),
            ),
            onEditingComplete: () async {
              if(widget.hintText == 'i.e. Jhon Doe'){

              }
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}
