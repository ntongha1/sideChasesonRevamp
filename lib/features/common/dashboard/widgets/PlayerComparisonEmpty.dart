import 'package:flutter/material.dart';

import '../../../../core/utils/images.dart';

class PlayerComparisonEmpty extends StatefulWidget {

  PlayerComparisonEmpty({Key? key}) : super(key: key);

  @override
  State<PlayerComparisonEmpty> createState() => _PlayerComparisonEmptyState();
}

class _PlayerComparisonEmptyState extends State<PlayerComparisonEmpty> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Container(
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    child: Image.asset(
    AppAssets.noComparison,
    fit: BoxFit.fitWidth,
    repeat: ImageRepeat.noRepeat,
    ),
    )
      ],
    );




  }

}
