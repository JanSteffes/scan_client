import 'package:flutter/widgets.dart';

class OpacityWrapper extends StatelessWidget {
  final Widget child;

  OpacityWrapper(this.child);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        curve: Curves.ease,
        duration: const Duration(seconds: 1),
        builder:
            (BuildContext newContext, double opacity, Widget? childWidget) {
          return Opacity(opacity: opacity, child: child);
        });
  }
}
