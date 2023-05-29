import 'package:flutter/material.dart';
import 'package:sonalysis/style/styles.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Align(
    //     alignment: Alignment.center,
    //     child: Lottie.asset(
    //     lottieDir + '/loading.json',
    //     width: 200,
    //     height: 200,
    //   )
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 100),
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                  )),
            ),
            Container(
              height: 50.0,
              width: 50.0,
              padding: const EdgeInsets.all(7),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(sonaPurple1),
              ),
              // Image.asset(
              //   imagesDir+"/loader.gif",
              //   height: 50.0,
              //   width: 50.0,
              // ),
            )
          ],
        ),
      ),
    );
  }
}
