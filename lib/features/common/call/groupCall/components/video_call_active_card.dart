import 'package:flutter/material.dart';
import 'package:sonalysis/style/styles.dart';


class VideoCallActiveCard extends StatelessWidget {
  const VideoCallActiveCard({
    Key? key,
    required this.name,
    required this.image,
  }) : super(key: key);

  final String name, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: sonaBlack,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            image,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                color: sonaBlack.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}
