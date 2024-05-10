import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  String id;
  String senderId;
  String lang;
  String complaintText;
  String audioURL;
  String audioText;
  String transText;
  Timestamp timestamp;
  String output;
  Timestamp? ots;



  ComplaintModel({
    this.id="",
    this.senderId='',
    this.lang = "1",
    this.complaintText = '',
    this.audioURL='',
    this.audioText='',
    this.transText='',
    required this.timestamp,
    this.output='',
    this.ots=null,

  });

  factory ComplaintModel.fromFirestore(DocumentSnapshot data) {
    Map<String,dynamic> mapData=data.data() as Map<String,dynamic> ;

    return ComplaintModel(
      id:data.id,
      senderId:mapData['senderId']??'mh_bhashini',
      lang: mapData['lang'] ?? "null",
      complaintText: mapData['complaintText'] ?? "",
      audioURL: mapData['audioURL']??'',
      audioText: mapData['audioText']??'',
      transText: mapData['transText']??'',
      timestamp: mapData['timestamp']??Timestamp.now(),
      output: mapData['output']??'',
      ots:mapData['ots']??null,
      );
  }

  Map<String, dynamic> getMap() {
    return {
      'id':id,
      'senderId':senderId,
      'lang': lang,
      'complaintText': complaintText,
      'audioURL':audioURL,
      'audioText':audioText,
      'transText':transText,
      'timestamp':timestamp,
      'output':output,
      'ots':ots,

    };
  }

}