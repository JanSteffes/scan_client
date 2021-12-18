import 'package:flutter/widgets.dart';

class OpacityWrapper extends StatelessWidget {
  final Widget child;
  final int milliseconds;

  OpacityWrapper(this.child, {this.milliseconds = 1000});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        curve: Curves.ease,
        duration: Duration(milliseconds: milliseconds),
        builder:
            (BuildContext newContext, double opacity, Widget? childWidget) {
          return Opacity(opacity: opacity, child: child);
        });
  }
}
