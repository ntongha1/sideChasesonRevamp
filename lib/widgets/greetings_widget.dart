import 'package:flutter/material.dart';
import 'package:sonalysis/helpers/helpers.dart';

class GreetingsWidget extends StatelessWidget {
  final String? name;
  final String? teamAndRole;

  const GreetingsWidget({Key? key, required this.name, this.teamAndRole}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            )),
        const SizedBox(height: 2),
        Text(teamAndRole!,
            style: TextStyle(
                color: getColorHexFromStr("A0A0A0"),
                fontSize: 14,
                fontWeight: FontWeight.w400
            )),
      ],
    );
  }
}