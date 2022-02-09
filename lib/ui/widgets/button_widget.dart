import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final Color buttonColor;
  final double borderRadius;
  final String buttonName;
  final Function triggerFunction;

  const ButtonWidget(
      {Key? key,
      required this.constraints,
      this.buttonColor = Colors.yellow,
      this.borderRadius = 10.0,
      this.buttonName = 'Next',
      required this.triggerFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => triggerFunction(),
      child: Container(
        margin: EdgeInsets.all(constraints.maxWidth * .012),
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.0,
              fontSize: constraints.maxWidth * .045,
            ),
          ),
        ),
      ),
    );
  }
}
