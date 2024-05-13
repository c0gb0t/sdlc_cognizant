import 'package:cloud_firestore/cloud_firestore.dart';

class ContentModel {
  String id;
  String senderId;
  List<String> fileUrls;
  Timestamp timestamp;
  String output;
  Timestamp? ots;

  ContentModel({
    this.id = "",
    this.senderId = '',
    this.fileUrls = const [],
    required this.timestamp,
    this.output = '',
    this.ots = null,
  });

  factory ContentModel.fromFirestore(DocumentSnapshot data) {
    Map<String, dynamic> mapData = data.data() as Map<String, dynamic>;

    return ContentModel(
      id: data.id,
      senderId: mapData['senderId'] ?? 'mh_bhashini',
      fileUrls: mapData['fileUrls'].cast<String>() ?? [],
      timestamp: mapData['timestamp'] ?? Timestamp.now(),
      output: mapData['output'] ?? '',
      ots: mapData['ots'] ?? null,
    );
  }

  Map<String, dynamic> getMap() {
    return {
      'id': id,
      'senderId': senderId,
      'fileUrls': fileUrls,
      'timestamp': timestamp,
      'output': output,
      'ots': ots,
    };
  }
}
