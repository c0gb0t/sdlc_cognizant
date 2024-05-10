import 'package:mhs_pred_app/chatbot/widgets/thumbnail.dart';
import 'package:flutter/material.dart';

class AppBarView extends StatelessWidget {
  const AppBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
          child: Row(
        children: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.arrow_back_ios, color: Color.fromRGBO(42, 15, 113, 1),),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ThumbnailChat(),
        ],
      ),
    );
  }
}