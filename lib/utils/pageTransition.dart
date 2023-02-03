import 'package:flutter/cupertino.dart';

class BouncePage extends PageRouteBuilder {
  final Widget widget;

  BouncePage({required this.widget})
      : super(
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.linear);
              return ScaleTransition(
                scale: animation,
                alignment: Alignment.center,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
