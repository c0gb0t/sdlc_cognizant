import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoadingText extends StatelessWidget {
  final String loadingText;
  const LoadingText({Key? key, required this.loadingText}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      SpinKitDualRing(
      color: Colors.blue,
      size: 80.0,
    ),
        Text(loadingText)

      ],

    );
  }
}