import 'package:flutter/material.dart';

class RotatingIconButton extends StatefulWidget {
  final IconData icon;
  final Function onPressed;
  final Color? iconColor;

  RotatingIconButton(
      {Key? key, required this.icon, required this.onPressed, this.iconColor})
      : super(key: key);

  @override
  State<RotatingIconButton> createState() => RotatingIconButtonState();
}

class RotatingIconButtonState extends State<RotatingIconButton> {
  double turns = 0.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
        turns: turns,
        duration: const Duration(seconds: 1),
        child: IconButton(
            icon: Icon(widget.icon, color: widget.iconColor),
            onPressed: doStuff));
  }

  doStuff() {
    widget.onPressed.call();
    setState(() {
      turns += 1;
    });
  }
}
