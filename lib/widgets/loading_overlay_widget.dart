import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sonalysis/style/styles.dart';
import 'package:sonalysis/widgets/loader_widget.dart';

class LoadingOverlayWidget extends StatelessWidget {
  final bool? loading;
  final Widget? child;

  const LoadingOverlayWidget({this.loading, this.child});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: loading!,
      color: sonaBlack,
      opacity: 0.8,
      progressIndicator: LoaderWidget(),
      child: child!,
    );
  }
}
