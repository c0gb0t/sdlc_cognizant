import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mhs_pred_app/chatbot/models/user_main.dart';
import 'package:mhs_pred_app/main.dart';
import './models/content_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

var _db = FirebaseFirestore.instance;
FirebaseStorage _storage = FirebaseStorage.instance;

Future<List<String>> uploadFiles(List<PlatformFile> files) async {
  List<String> fileUrls = [];
  for (PlatformFile file in files) {
    String filePath = file.name;
    // File file;
    // if(filePath.contains('http')) {
    //   file = await DefaultCacheManager().getSingleFile(filePath);
    // }
    // else {

    //   file=File(filePath);
    // }
    //Create a reference to the location you want to upload to in firebase
    Reference reference =
        _storage.ref().child("sdlc_cognizant/${filePath.split('/').last}");

    //Upload the file to firebase
    UploadTask uploadTask = reference.putData(file.bytes as Uint8List);

    // Waits till the file is uploaded then stores the download url
    String fileUrl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    print("upoalded file url=$fileUrl");
    fileUrls.add(fileUrl);
  }
  //returns the download url
  return fileUrls;
}

Stream<List<ContentModel>> streamContents(UserModel? user) {
  var ref = _db
      .collection(coll_name)
      .doc(user?.uid)
      .collection('pContents')
      .orderBy('id', descending: true)
      .limit(1);
  // int len=await ref.snapshots().length;
  // debugPrint(len);
  return ref.snapshots().map((list) => list.docs.map((doc) {
        debugPrint("----------------------${doc.id}");
        return ContentModel.fromFirestore(
          doc,
        );
      }).toList());
//   return const Stream.empty();
}

Future<String> sendContent(UserModel user,
    {List<String> fileUrls = const [], String rType = "1"}) async {
  ContentModel content =
      ContentModel(fileUrls: fileUrls, timestamp: Timestamp.now());
  content.id = Timestamp.now().millisecondsSinceEpoch.toString();
  content.senderId =
      rType == '0' ? "backend@red" : "${user.name?.split(' ')[0]}@red";
  // content.rType = rType;
  content.timestamp = Timestamp.now();
  content.fileUrls = fileUrls;

  _db
      .collection(coll_name)
      .doc(user.uid)
      .collection('rContents')
      .doc('content')
      .set(content.getMap());
  return content.id;

  // ----------------------from python api----------------
  //
  // final queryParameters = {
  //   'input': context,
  //   'instruction': txt,
  // };
  // print("-----------generating uri--------------");
  // final uri = Uri.http('127.0.0.1:5000', '/predict', queryParameters);
  // print("-----------calling api------------------");
  // final response = await http.get(
  //   uri,
  // );
  // print("-----------api call succesfull------------------");
  //
  //
  // txt = jsonDecode(response.body)['output'];
  //
  // // txt='chatbot respone.......';
  // complaint = ContentModel(timestamp: Timestamp.now());
  // complaint.senderId = 'chatbot' + "@red";
  // complaint.rType = rType;
  // complaint.timestamp = Timestamp.now();
  // complaint.complaint = txt;
  //
  // _db
  //     .collection(coll_name)
  //     .doc(user.uid)
  //     .collection('allcomplaints')
  //     .doc(complaint.timestamp.millisecondsSinceEpoch.toString())
  //     .set(complaint.getMap());
}
