import 'package:flutter/material.dart';
import 'package:sonalysis/core/utils/colors.dart';

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.centerLeft,
        radius: 1,
        colors: [AppColors.sonaG1, AppColors.sonaG2, AppColors.sonaG3],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}