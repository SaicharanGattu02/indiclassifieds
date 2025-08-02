import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String? bgImagePath;
  final Color? bgColor;

  const Background({
    super.key,
    required this.child,
    this.bgImagePath,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgImagePath ?? "assets/images/bc.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
