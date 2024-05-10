import 'package:flutter/material.dart';
import 'package:mhs_pred_app/chatbot/models/complaint_model.dart';
import 'package:mhs_pred_app/utils/date_time_helper.dart';

class TextFormat extends StatefulWidget {
  final ComplaintModel message;
  final bool isMe;

  const TextFormat(this.message, this.isMe, {super.key});

  @override
  _TextFormatState createState() => _TextFormatState();
}

class _TextFormatState extends State<TextFormat> {
   
  @override
  Widget build(BuildContext context) {

     Size size = MediaQuery.of(context).size;
   final sheight = size.height;
    final swidth = size.width;

    final isMe = widget.isMe;
    final message = widget.message;

    return Column(
      children: <Widget>[
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DatetimeHelper(
                      timestamp: message.timestamp
                          .toDate()
                          .toLocal()
                          .millisecondsSinceEpoch)
                  .getTime(),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: isMe ? Colors.grey : Colors.grey,
                  fontSize: 14.0),
            ),
          ),
        ),
        GestureDetector(
          // onLongPress: (){
          //  if(!value.selectedId.contains(message.time)){
          //    Provider.of<ChatWindowAppBarProvider>(context, listen: false).addNewId(message);
          //  }else{
          //    Provider.of<ChatWindowAppBarProvider>(context, listen: false).removeExistingId(message);
          //  }
          //
          // },
          child: Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(
                      right: isMe ? 10 : 0, left: isMe ? 0 : 10),
                  child: Flex(
                      mainAxisSize: MainAxisSize.min,
                      direction: Axis.vertical, children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: <Widget>[
                          // isMe
                          //     ? message.isNotSent
                          //         ? Icon(
                          //             Icons.warning,
                          //             color: Color.fromRGBO(230, 93, 95, 1),
                          //           )
                          //         : Container()
                          //     : Container(),
                          Container(
                            width: swidth*0.3,
                            margin: isMe
                                ? const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    left: 8,
                                  )
                                : const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 15.0),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color.fromRGBO(230, 93, 95, 1)
                                  : const Color.fromRGBO(42, 15, 113, 1),
                              // : Color.fromRGBO(212, 212, 212, 0.5),
                              borderRadius: isMe
                                  ? const BorderRadius.only(
                                      bottomRight: Radius.circular(15.0),
                                      topLeft: Radius.circular(15.0),
                                      bottomLeft: Radius.circular(15.0),
                                    )
                                  : const BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //SizedBox(height: 8.0),
                                Text(
                                  message.complaintText,
                                  style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          // : Color.fromRGBO(42, 15, 113, 1),
                                          : Colors.white,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          // message.isNotSent? SizedBox(
                          //    width: 10,
                          //  ):Container(),
                          //  isMe
                          //    ? message.isNotSent
                          //        ? SvgPicture.asset("assets/svgs/retry.svg",
                          //            height: 23,
                          //            color: Color.fromRGBO(42, 15, 113, 1),
                          //            semanticsLabel: 'A red up arrow')
                          //        : Container()
                          //    : Container(),
                        ],
                      ),
                    ),
                  ]))),
        ),
      ],
    );
  }
}