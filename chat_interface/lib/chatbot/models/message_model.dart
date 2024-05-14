import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id;
  String senderId;
  String userNotificationToken;
  String rType;
  String message;
  Timestamp timestamp;
  String context;



  MessageModel({
    this.id="",
    this.senderId='',
    this.userNotificationToken = '',
    this.rType = "1",
    this.message = '',
    required this.timestamp,
    this.context='',

  });

  factory MessageModel.fromFirestore(DocumentSnapshot data) {
    Map<String,dynamic> mapData=data.data() as Map<String,dynamic> ;

    return MessageModel(
      id:data.id,
      senderId:mapData['senderId']??'QxCredit',
      userNotificationToken: mapData['userNotificationToken'] ?? '',
      rType: mapData['rType'] ?? "1",
      message: mapData['message'] ?? "I have a query regarding my purchased token",
      timestamp: mapData['timestamp']??Timestamp.now(),
      context: mapData['context']??' empty context '
      );
  }

  Map<String, dynamic> getMap() {
    return {
      'senderId':senderId,
      'userNotificationToken': userNotificationToken,
      'rType': rType,
      'message': message,
      'timestamp':timestamp,
      'context':context,

    };
  }

}