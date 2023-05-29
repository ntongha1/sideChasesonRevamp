import 'package:flutter/material.dart';
import 'package:sonalysis/style/styles.dart';

import '../../components/audio_user_pic.dart';
import '../../size_config.dart';


class AudioCallActiveCard extends StatelessWidget {
  const AudioCallActiveCard({
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AudioUserPic(
                size: 150,
                image: image,
              ),
              const VerticalSpacing(of: 10),
              Text(
                name,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const VerticalSpacing(of: 5),
              const Text(
                "Active",
                style: TextStyle(color: Colors.white60),
              )
            ],
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
