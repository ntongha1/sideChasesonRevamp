import 'package:flutter/material.dart';
import 'package:sonalysis/lang/strings.dart';

class RoleTile extends StatelessWidget {
  final String? image;
  const RoleTile({Key? key, this.image}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Image.asset(
          imagesDir + image!,
          fit: BoxFit.contain,
          repeat: ImageRepeat.noRepeat,
        ),
      ),
    );
  }
}