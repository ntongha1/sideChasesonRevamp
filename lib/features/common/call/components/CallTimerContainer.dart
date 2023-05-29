

import 'package:flutter/material.dart';

class CallTimerContainer extends StatelessWidget {
  CallTimerContainer({this.label, this.value});

  final String? label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value == null ? '00' : '$value',
            style: const TextStyle(
                color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
